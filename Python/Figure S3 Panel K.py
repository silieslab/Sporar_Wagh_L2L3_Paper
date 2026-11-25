#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Wed Jan  8 15:33:56 2020

@author:  neelwagh
"""
"""This code generates the avg calcium traces for the full field flashes stimuli for the chosen experimental condition.
Quantifies the peak and plateau responses to the OFF steps. Performs exponentially curve fits to responses post OFF step with respect to time,
 which is averaged over ROIs for each fly"""


import pickle
import cPickle
import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import warnings
import post_analysis_core as pac
import ROI_mod
from model_fitting import model_fitting
import ast
from scipy.optimize import curve_fit
from operator import index, truediv
from sklearn import preprocessing
import random
from scipy.stats import linregress
from scipy.stats.stats import pearsonr
import seaborn as sns
import sys
from sklearn.metrics import r2_score
from sklearn.metrics import mean_absolute_error
from sklearn.metrics import mean_squared_error
from statistical_tests import statistical_test

# Setting path and genotypes


dataFolder = r'W:\PAPER FIGURES\data\Python' # It must be change for the path where the data is stored in the PC


# Chose the experiment
experiment_label = ["Figure S3\\L2split","Figure S3\\L2split Shab"]



# Setting path for loading the data
for geno_label in experiment_label:
    geno_data = os.path.join(dataFolder, geno_label)
    experiment = 'ON_OFF_5sec' 
    initialDirectory = os.path.join(geno_data, experiment)
    data_dir = os.path.join(initialDirectory, 'pickle_data')

    save_path = os.path.join(initialDirectory, 'Data_analysis')
    if not os.path.exists(save_path):
            os.mkdir(save_path) 

    # Initialize variables for OFF
    datasets_to_load = os.listdir(data_dir)
    final_rois_all = []
    flyIDs = []
    flash_resps = []
    OFF_steps = []
    OFF_plateau = []
    OFF_int = []
    flash_corr = []
    genotypes = []

    for idataset, dataset in enumerate(datasets_to_load):
        if not(dataset.split('.')[-1] =='pickle'):
            warnings.warn('Skipping non pickle file: {f}\n'.format(f=dataset))
            continue
        load_path = os.path.join(data_dir, dataset)
        load_path = open(load_path, 'rb')
        workspace = cPickle.load(load_path)
        curr_rois = workspace['final_rois']

        # Thresholding might be needed for good ROIs
        geno = curr_rois[0].experiment_info['Genotype'][:3]

        if (not('_5secON_5sec_OFF_120deg_10sec' in curr_rois[0].stim_name)):
            continue

        # L1-L3 responses are negatively correlated with the stimulus

        if (geno =='L3_') or (geno =='L1_') or (geno =='Tm9')or (geno =='L2_'):
            corr_t = ('s',0) # for negatively correlated ROIs or #corr_t = ('b',0)  #for postively correlated ROIs
        else:
            raise TypeError('Correlation threshold can not be determined for this genotype.')

        curr_rois = ROI_mod.threshold_ROIs(curr_rois, {'corr_fff':corr_t,
                                                    'reliability' : 0.4,      #.5 usually
                                                    'max_response' : 0.0})   #0.2
        if len(curr_rois) <= 1: 
            warnings.warn('{d} contains 1 or no ROIs, skipping'.format(d=dataset))
            continue


        print(curr_rois[0].experiment_info['Genotype'])
        print(curr_rois[0].stim_name)
        print('%s thresholded_ROIs %s total_ROIs'%((len(curr_rois)), len(workspace['final_rois'])))
        final_rois_all.append(curr_rois)
        
        stim_t = curr_rois[0].int_stim_trace[:94]
        fff_stim_trace = \
            np.around(np.concatenate((stim_t[90:],stim_t[0:100]),axis=0))

        for roi in curr_rois:
            
            flyIDs.append(roi.experiment_info['FlyID'])
            genotypes.append(roi.experiment_info['Genotype'])
            trace = roi.int_con_trace[:94]
            
            
            flash_t = np.concatenate((trace[90:],trace[0:100]),axis=0)
            # Compute flash properties
            flash_resps.append(flash_t)
            off_step = trace[:10].max()-trace[90:95].mean()
            OFF_steps.append(off_step)
            off_plat = trace[45:50].mean()-trace[90:95].mean()
            OFF_plateau.append(off_plat)
            off_int = trace[10:30].sum()
            OFF_int.append(off_int)
            flash_corr.append(roi.corr_fff)
            
        
            
        print('{ds} successfully loaded\n'.format(ds=dataset))


    # Quantiifcation over flies and experiments
    fff_dict = pac.compute_over_samples_groups(data = flash_resps,
                                            group_ids= flyIDs, error ='SEM',
                                            experiment_ids = genotypes)


    ## Model fitting for OFF  step ##
    plt.close('all')

    final_rois = np.concatenate(final_rois_all)

    df_para = pd.DataFrame()
    for roi in final_rois:
        trace = roi.conc_trace

        y = trace[12:32]  # start threshold at 1.5 second after the step + 2 sec afterward
        x = np.linspace(1,len(y), len(y))/10
        plt.plot(x,y)
        para  = model_fitting(x,y)
        df_para = pd.concat([df_para, pd.DataFrame.from_dict(para, orient = 'index' ).transpose()])

    plt.xlabel('Time (s)', fontsize=14)
    plt.ylabel('$\Delta F/F$', fontsize=14)  
    plt.title('FFF OFF responses per ROI ', fontsize=18)
    plt.yticks(fontsize=14) 
    plt.xticks(fontsize=14) 
    plt.legend()
    # plt.ylim(0,2)
    plt.savefig('%s\\FFF_response_per_roi.pdf' % save_path, bbox_inches='tight',dpi=300)
    # Convert arrays to strings
    cols = ['linear_para', 'expo_para', 'd_expo_para1', 'd_expo_para2']
    for col in cols:
        df_para[col] = df_para[col].apply(np.array2string)


    df_para['ROI'] = final_rois
    df_para['FlyID'] = flyIDs
    df_para.index = df_para.FlyID
    df_para.pop('FlyID')
    df_para.to_csv('%s\model_fitting_per_roi.csv'%save_path)

    plt.close('all')

    def expo_func(x, a, c, d):
        return a*np.exp(c*x)+ d


    ## Per Fly

    genotype = fff_dict['experiment_ids'].keys()[0]
    df_para = pd.DataFrame()
    for i in range(len(fff_dict['experiment_ids'][genotype]['over_samples_means'])):
        trace = fff_dict['experiment_ids'][genotype]['over_samples_means'][i]

        y = trace[12:32] # start threshold at 1.5 second after the step + 2 sec afterwards
        x = np.linspace(1,len(y), len(y))/10
        plt.plot(x,y, label = fff_dict['experiment_ids'][genotype]['uniq_group_ids'][i])
        para  = model_fitting(x,y)
        fitted = expo_func(x,*para['expo_para'] )
        plt.plot(x,fitted, '--', color = 'gray' )
        df_para = pd.concat([df_para, pd.DataFrame.from_dict(para, orient = 'index' ).transpose()])


    plt.xlabel('Time (s)', fontsize=14)
    plt.ylabel('$\Delta F/F$', fontsize=14)
    plt.yticks(fontsize=14) 
    plt.xticks(fontsize=14) 
    plt.title('FFF OFF responses responses per Fly ', fontsize=18)
    plt.legend()
    # plt.ylim(0,2)
    plt.savefig('%s\\FFF_response_per_fly.pdf' % save_path, bbox_inches='tight',dpi=300)
    # Convert arrays to strings
    cols = ['linear_para', 'expo_para', 'd_expo_para1', 'd_expo_para2']
    for col in cols:
        df_para[col] = df_para[col].apply(np.array2string)


    df_para['FlyID'] = np.unique(flyIDs)
    df_para.index = df_para.FlyID
    df_para.pop('FlyID')
    df_para.to_csv('%s\model_fitting_per_fly.csv'%save_path)

    df_trace = pd.DataFrame(fff_dict['experiment_ids'][genotype]['over_samples_means'])
    df_trace['FlyID'] = np.unique(flyIDs)
    df_trace.index = df_trace.FlyID
    df_trace.pop('FlyID')
    df_trace.to_csv('%s\\fly_trace.csv'%save_path)


    sample_size = {}
    sample_size["n"] = '%.0f(%.0f)' %(len(np.unique(flyIDs)), len(final_rois))
    # Save the dictionary to a binary file

    with open("%s\sample_size.pkl" %(save_path), "wb") as file:  # 'wb' means write-binary
        pickle.dump(sample_size, file)
