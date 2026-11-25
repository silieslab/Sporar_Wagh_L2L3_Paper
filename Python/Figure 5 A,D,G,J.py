#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Mon Mar 30 14:16:04 2020

@author: burakgur
@modified: neelwagh
"""

"""This code generates the avg calcium traces for the A_B steps stimuli for the chosen experimental condition.
Quantifies the peak and plateau responses to the A and B OFF steps. Performs linear regression for peak/platuea responses with respect to luminance and 
quantifies slopes, which is averaged over ROIs for each fly"""

from numpy.core.defchararray import index
from pandas.core.frame import DataFrame
import cPickle
import pandas as pd
import numpy as np
import warnings
import matplotlib
import matplotlib.pyplot as plt
from sklearn import preprocessing
# from model_fitting import model_fitting
import os
import random
from scipy.stats import linregress
from scipy.stats.stats import ModeResult, pearsonr
import seaborn as sns
import sys
import ast
import ROI_mod
import post_analysis_core as pac
from scipy.optimize import curve_fit


code_path = r'U:\Codes\Burak\2panalysis' # It must be change for the path where the code is in the PC
code_path = r'U:\Codes\Burak\2panalysis' # It must be change for the path where the code is in the PC
sys.path.insert(0, code_path) 
os.chdir(code_path)



#%%
# Setting path and genotypes
dataFolder = r'W:\PAPER FIGURES\data\Python' # It must be change for the path where the data is stored in the PC



experiment_label = ['Figure 5\L2','Figure 5\L2split Irk2 RNAi','Figure 5\L2 Irk3 RNAi', 'Figure 5\L2 Irk2AAA', 'Figure 5\L3', 'Figure 5\L3 Irk2', 'Figure 5\L3 Irk3', 'Figure 5\Untreated L2','Figure 5\\5uM PTX Treated L2']


# Setting path for loading the data
for geno_label in experiment_label:
    geno_data = os.path.join(dataFolder, geno_label)
    experiment = 'A_B_steps' 
    initialDirectory = os.path.join(geno_data, experiment)
    data_dir = os.path.join(initialDirectory, 'pickle_data')

    save_path = os.path.join(initialDirectory, 'Data_analysis')
    if not os.path.exists(save_path):
            os.mkdir(save_path) 

    # %% Load datasets and desired variables

    datasets_to_load = os.listdir(data_dir)

    avg_type = 'fly' # Quantification is performed by averaging at the fly level

    # Initialize variables

    properties = ['Reliab','category']
    combined_df = pd.DataFrame(columns=properties)
    all_rois = []
    all_traces=[]
    a_step_responses = []
    b_step_responses = []
    a_step_baseline_responses = []
    b_step_baseline_responses = []
    a_to_b_step_responses = []
    a_step_base_sub = []
    b_step_base_sub = []
    # Initialize variables


    for idataset, dataset in enumerate(datasets_to_load):
        if not(dataset.split('.')[-1] =='pickle'):
            warnings.warn('Skipping non pickle file: {f}\n'.format(f=dataset))
            continue
        load_path = os.path.join(data_dir, dataset)
        load_path = open(load_path, 'rb')
        workspace = cPickle.load(load_path)
        curr_rois = workspace['final_rois']

        
        if (not('A_B_step' in curr_rois[0].stim_name) or \
            (not('30sBG' in curr_rois[0].stim_name)) or \
            (('ON' in curr_rois[0].stim_name))):
            continue
        
        
        curr_rois=ROI_mod.sep_trial_compute_df(curr_rois,df_method='Baseline_epoch',
                                            df_base_dur=5,filtering=True)
        curr_rois = ROI_mod.analyze_A_B_step(curr_rois,int_rate=10)
        
        
        # Luminance slopes
        curr_rois = ROI_mod.calculate_correlation(curr_rois, stim_type='AB_steps')
        
        geno = curr_rois[0].experiment_info['Genotype'][:3]
        if 'ExpLine' in curr_rois[0].experiment_info['Genotype']:
            geno = geno + '_ExpLine'
        elif 'PosCnt' in curr_rois[0].experiment_info['Genotype']:
            geno = geno + '_PosCnt'


        # L1-L3 responses are negatively correlated with the stimulus

        if (geno =='L3_') or (geno =='L1_') or (geno =='Tm9')or (geno =='L2_'):
            corr_t = ('s',0) # for negatively correlated ROIs or #corr_t = ('b',0)  #for postively correlated ROIs
        else:
            raise TypeError('Correlation threshold can not be determined for this genotype.')

        # Thresholding might be needed for good ROIs
        print(curr_rois[0].experiment_info['Genotype'])
        print(curr_rois[0].stim_name)

        curr_rois = ROI_mod.threshold_ROIs(curr_rois, {'correlation':corr_t,
                                                    'reliability' : 0.4,  #0.5 
                                                    'AB_resp_max' : 0.1}) #0.2
        if len(curr_rois) <= 1:
            warnings.warn('{d} contains 1 or no ROIs, skipping'.format(d=dataset))
            continue
        
        print('%s thresholded_ROIs %s total_ROIs'%((len(curr_rois)), len(workspace['final_rois'])))
        all_rois.append(curr_rois)
        
        
        curr_all_traces = \
            np.array(map(lambda roi : roi.resp_traces_interpolated[:,200:460],
                            curr_rois)) # For 30s

        all_traces.append(curr_all_traces)
        
        a_step_responses.append(np.array(map(lambda roi : roi.a_step_responses[1:],
                            curr_rois)))
        b_step_responses.append(np.array(map(lambda roi : roi.b_step_responses[1:],
                            curr_rois)))
        a_step_baseline_responses.append(np.array(map(lambda roi : roi.a_step_baseline_responses[1:],
                            curr_rois)))
        b_step_baseline_responses.append(np.array(map(lambda roi : roi.b_step_baseline_responses[1:],
                            curr_rois)))
        
        a_to_b_step_responses.append(np.array(map(lambda roi : roi.a_to_b_step_responses[1:],
                            curr_rois)))
        
        a_step_base_sub.append(np.array(map(lambda roi : roi.a_step_responses[1:],
                                            curr_rois)) - \
                            np.array(map(lambda roi : roi.a_step_baseline_responses[1:],
                                            curr_rois)))
        
        b_step_base_sub.append(np.array(map(lambda roi : roi.b_step_responses[1:],
                                            curr_rois)) - \
                            np.array(map(lambda roi : roi.b_step_baseline_responses[1:],
                                            curr_rois)))
            
        data_to_extract = ['SNR','reliability','category']
        roi_data = ROI_mod.data_to_list(curr_rois, data_to_extract)
        
        df_c = {}
        df_c['SNR'] = roi_data['SNR']
        df_c['category'] = roi_data['category']
        df_c['reliability'] = roi_data['reliability']
        df_c['flyID'] = np.tile(curr_rois[0].experiment_info['FlyID'],len(curr_rois))
        df_c['Geno'] = np.tile(geno,len(curr_rois))
        df_c['uniq_id'] = np.array(map(lambda roi : roi.uniq_id, curr_rois)) 
        df = pd.DataFrame.from_dict(df_c) 
        rois_df = pd.DataFrame.from_dict(df)
        combined_df = combined_df.append(rois_df, ignore_index=True, sort=False)
        print('{ds} successfully loaded\n'.format(ds=dataset))
        
    le = preprocessing.LabelEncoder()
    le.fit(combined_df['flyID'])
    combined_df['flyIDNum'] = le.transform(combined_df['flyID'])

    a_step_responses = np.concatenate((a_step_responses[:]))
    b_step_responses = np.concatenate((b_step_responses[:]))
    a_step_baseline_responses = np.concatenate((a_step_baseline_responses[:]))
    b_step_baseline_responses = np.concatenate((b_step_baseline_responses[:]))
    a_to_b_step_responses = np.concatenate((a_to_b_step_responses[:]))
    a_step_base_sub = np.concatenate((a_step_base_sub[:]))
    b_step_base_sub = np.concatenate((b_step_base_sub[:]))

    all_rois = np.concatenate(all_rois)
    traces_fly = all_traces
    all_traces = np.concatenate(all_traces)

    #%%

    ##Plotting the avg calcium traces
    _, colorss = pac.run_matplotlib_params()
    colors = [colorss['magenta'],colorss['orange'],colorss['purple'],
            colorss['red'],colorss['yellow'],colorss['green1']]


    for idx, geno in enumerate(np.unique(combined_df['Geno'])):

        curr_neuron_mask = (combined_df['Geno']==geno)
        
        flyIDs = np.array(combined_df[curr_neuron_mask]['flyID']).astype(str)

        

        for  _variable in ['Step' ,  'Baseline']:

            plt.close('all')
            fig = plt.figure(figsize=(7, 7))
            grid = plt.GridSpec(1, 1, wspace=0.3, hspace=0.5)
            
            ax1=plt.subplot(grid[0,0])
        
            
            a_lums = all_rois[curr_neuron_mask][0].epoch_luminance_A_steps[1:]
            b_lums = all_rois[curr_neuron_mask][0].epoch_luminance_B_steps[1:]
            a_cont = all_rois[curr_neuron_mask][0].epoch_contrast_A_steps[1:]
            b_cont = all_rois[curr_neuron_mask][0].epoch_contrast_B_steps[1:]
            b_cont_BG_weber = all_rois[curr_neuron_mask][0].epoch_contrast_B_steps_BGweber[1:]
            
            diff_luminances = all_rois[curr_neuron_mask][0].epoch_luminance_B_steps[1:]
            cmap = matplotlib.cm.get_cmap('viridis') # or winter , viridis
            norm = matplotlib.colors.Normalize(vmin=np.min(diff_luminances), 
                                            vmax=np.max(diff_luminances))
            plot_max = 0
            cmap_colors = []
            for idx_lum, luminance in enumerate(diff_luminances):
                cmap_colors.append(cmap(norm(luminance)))
                
                curr_traces = all_traces[curr_neuron_mask,idx_lum,:]
                
                a=pac.compute_over_samples_groups(data = curr_traces, 
                                        group_ids= np.array(combined_df[curr_neuron_mask]['flyIDNum']), 
                                        error ='SEM',
                                        experiment_ids = np.array(combined_df[curr_neuron_mask]['Geno']))

                label = '{g} n: {f}({ROI})'.format(g=geno,
                                                f=len(a['experiment_ids'][geno]['over_samples_means']),
                                                ROI=len(a['experiment_ids'][geno]['all_samples']))
                
                
                mean_r = a['experiment_ids'][geno]['over_groups_mean']
                err = a['experiment_ids'][geno]['over_groups_error']
        
                if plot_max < (mean_r).max():
                    plot_max = (mean_r).max()
                    
                ub = mean_r + err
                lb = mean_r - err
                x = np.linspace(0,len(mean_r),len(mean_r))/10
                ax1.plot(x,mean_r,'-',lw=2,color=cmap(norm(luminance)),alpha=.7,
                        label=luminance)
        
            ax1.set_ylim(-0.50,1.5)
            ax1.set_xlabel('Time (seconds)')
            ax1.set_ylabel('$\Delta F/F$')
            
            a_step = a_step_responses[curr_neuron_mask,:]
            b_step = b_step_responses[curr_neuron_mask,:]
            a_base = a_step_baseline_responses[curr_neuron_mask,:]
            b_base = b_step_baseline_responses[curr_neuron_mask,:]
            a_to_b =  a_to_b_step_responses[curr_neuron_mask,:]
            a_step_base_subtracted =  a_step_base_sub[curr_neuron_mask,:]
            b_step_base_subtracted =  b_step_base_sub[curr_neuron_mask,:]


        ### Calculating luminance dependence for each roi ##
            df_slope = pd.DataFrame()
            conditions = [a_step, a_base, b_step, b_base]
            for k in range(len(conditions)):
                condition = conditions[k]
                slope = []
                intercept = []
                if k == 0 or k == 1:
                    lums_ = a_lums
                else:
                    lums_ = b_lums
                for i in range(len(condition)):
                    slope_, intercept_, rvalue, pvalue, stderr = linregress(lums_, condition[i])
                    slope.append(slope_)
                    intercept.append(intercept_)
                
                df_slope_temp = pd.DataFrame()
                df_slope_temp['slope'] = np.array(slope)
                df_slope_temp['intercept'] = np.array(intercept)

                df_slope = pd.concat([df_slope, df_slope_temp], axis = 1)

            df_slope.columns = ['a_step_slope', 'a_step_intercept', 'a_end_slope', 'a_end_intercept', 'b_step_slope', 'b_step_intercept', 'b_end_slope', 'b_end_intercept']
            df_slope['FlyID'] =flyIDs
            df_slope.index = df_slope.FlyID
            df_slope.pop('FlyID')
            df_slope['ROI'] = all_rois
            df_slope.to_csv('%s\Slope and Intercept ROI.csv'% save_path)
            a_step_roi = pd.DataFrame(a_step)
            a_end_roi = pd.DataFrame(a_base)
            b_step_roi = pd.DataFrame(b_step)
            b_end_roi = pd.DataFrame(b_base)
            a_step_roi['ROI'] = a_end_roi['ROI'] =b_step_roi['ROI'] = b_end_roi['ROI']= all_rois
            a_step_roi.index = a_end_roi.index =b_step_roi.index = b_end_roi.index= df_slope.index
            a_step_roi.to_csv('%s\A_step ROI.csv'% save_path)
            a_end_roi.to_csv('%s\A_end ROI.csv'% save_path)
            b_step_roi.to_csv('%s\B_step ROI.csv'% save_path)
            b_end_roi.to_csv('%s\B_end ROI.csv'% save_path)




        ## calculating luminance dependence for each fly ##
            df_slope = pd.DataFrame()
            for k in range(len(conditions)):
                condition = conditions[k]
                slope = []
                intercept = []
                if k == 0 or k == 1:
                    lums_ = a_lums
                else:
                    lums_ = b_lums
                df_temp = pd.DataFrame(condition)
                df_temp.index = flyIDs
                df_temp = df_temp.groupby(level=0, sort=False).mean()  # groupby fly by mean

                for fly_name in df_temp.index:
                    slope_, intercept_, rvalue, pvalue, stderr = linregress(lums_, df_temp.loc[fly_name])
                    slope.append(slope_)
                    intercept.append(intercept_)
                
                df_slope_temp = pd.DataFrame()
                df_slope_temp['slope'] = np.array(slope)
                df_slope_temp['intercept'] = np.array(intercept)

                df_slope = pd.concat([df_slope, df_slope_temp], axis = 1)
            df_slope.columns = ['a_step_slope', 'a_step_intercept', 'a_end_slope', 'a_end_intercept', 'b_step_slope', 'b_step_intercept', 'b_end_slope', 'b_end_intercept']
            df_slope['FlyID'] =  df_temp.index
            df_slope.index = df_slope.FlyID
            df_slope.pop('FlyID')
            df_slope.to_csv('%s\Slope and Intercept Fly.csv'% save_path)


            
            df_peak_plateau = pd.DataFrame()
            df_peak_plateau['a_lums'] = a_lums
            df_peak_plateau['b_lums'] = b_lums

            # plt.close()
            if _variable == 'Step':
                a_data = a_step
                b_data = b_step
                a_variable = 'A step'   
                b_variable = 'B step'

            elif _variable == 'Peak':
                a_data = a_step_base_subtracted 
                b_data = b_step_base_subtracted
                a_variable = 'A peak'   
                b_variable = 'B peak'

            elif _variable == 'Baseline':
                a_data = a_base
                b_data = b_base
                #b_data = a_to_b
                a_variable = 'A end'   
                b_variable = 'B end'
                #b_variable = 'A to B'

            elif _variable == 'A to B':
                a_data = a_step
                b_data = a_to_b
                a_variable = 'A step'   
                b_variable = 'A to B' 

            astep=pac.compute_over_samples_groups(data = a_data, 
                                        group_ids= np.array(combined_df[curr_neuron_mask]['flyIDNum']), 
                                        error ='SEM',
                                        experiment_ids = np.array(combined_df[curr_neuron_mask]['Geno']))
            
            bstep=pac.compute_over_samples_groups(data = b_data, 
                                        group_ids= np.array(combined_df[curr_neuron_mask]['flyIDNum']), 
                                        error ='SEM',
                                        experiment_ids = np.array(combined_df[curr_neuron_mask]['Geno']))
            
            astep_mean = astep['experiment_ids'][geno]['over_groups_mean']
            astep_err = astep['experiment_ids'][geno]['over_groups_error']
            
            bstep_mean = bstep['experiment_ids'][geno]['over_groups_mean']
            bstep_err = bstep['experiment_ids'][geno]['over_groups_error']
            
            if _variable == 'Step':
                df_peak_plateau['a_step_mean']  = astep_mean
                df_peak_plateau['a_step_sem'] = astep_err
                df_peak_plateau['b_step_mean'] =bstep_mean
                df_peak_plateau['b_step_sem'] = bstep_err

            elif _variable == 'Baseline':
                df_peak_plateau['a_end_mean']  = astep_mean
                df_peak_plateau['a_end_sem'] = astep_err
                df_peak_plateau['b_end_mean'] =bstep_mean
                df_peak_plateau['b_end_sem'] = bstep_err
    

            title = ' {g} n: {f}({ROI}) over {avg_type}'.format(g=geno,avg_type=avg_type,
                                            f=len(a['experiment_ids'][geno]['over_samples_means']),
                                            ROI=len(a['experiment_ids'][geno]['all_samples']))
            
            fig.suptitle(title)
            dataFolder
            label = geno_label.rpartition("\\")[-1]
            fig_label = geno_label.rpartition("\\")[0]
            plt.savefig('%s\%s_Avg_responses.pdf' % (save_path,label), bbox_inches='tight',dpi=300)
            plt.savefig('%s\%s\%s_Avg_responses.pdf' % (dataFolder,fig_label,label), bbox_inches='tight',dpi=300)
            df_peak_plateau.to_csv('%s\%s_Fly.csv'%(save_path, _variable), index =False)

# %%
