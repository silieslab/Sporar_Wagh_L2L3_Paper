#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Thu Mar 19 15:23:13 2020

@author: burakgur
@modified: neelwagh
"""


"""This code generates the calcium traces for the varying luminance stimuli for the chosen experimental condition.
Quantifies the plateau responses for each luminance. Performs exponentially curve fits to plateau responses post OFF step with respect to luminance as well as
calculates mutual information, which is averaged over ROIs for each fly
If an error check line 364 or 417"""



from pandas.core.frame import DataFrame

import pickle
import cPickle
import pandas as pd
import numpy as np
import warnings
import matplotlib.pyplot as plt
import os
from scipy.stats import linregress
from sklearn import preprocessing
import seaborn as sns
from model_fitting import model_fitting
import ROI_mod
import post_analysis_core as pac


# Setting path and genotypes


dataFolder = r'W:\PAPER FIGURES\data\Python' # It must be change for the path where the data is stored in the PC


# Chose the experiment

#Figure S3
experiment_label = ["Figure S3\\L2split", "Figure S3\\L3", "Figure S3\\L2split Ih RNAi" ]


# Setting path for loading the data
for geno_label in experiment_label:
    geno_data = os.path.join(dataFolder, geno_label)
    experiment = 'Varying_luminance' 
    initialDirectory = os.path.join(geno_data, experiment)
    data_dir = os.path.join(initialDirectory, 'pickle_data')

    save_path = os.path.join(initialDirectory, 'Data_analysis')
    if not os.path.exists(save_path):
            os.mkdir(save_path) 

    neuron_save_dir = os.path.join(save_path, 'raw_trace')
    if not os.path.exists(neuron_save_dir):
        os.mkdir(neuron_save_dir)
        

    # Initialize variables
    datasets_to_load = os.listdir(data_dir)
    MI_baseline = True # mutual information for baseline plateua respone wrt luminance
    properties = ['Reliab','category','slope']
    combined_df = pd.DataFrame(columns=properties)
    all_rois = []
    all_traces=[]
    baseline_tunings = []
    baseline_tunings_peak = []
    genotypes = []
    flyIDs = []


    for idataset, dataset in enumerate(datasets_to_load):
        if not(dataset.split('.')[-1] =='pickle'):
            warnings.warn('Skipping non pickle file: {f}\n'.format(f=dataset))
            continue
        load_path = os.path.join(data_dir, dataset)
        load_path = open(load_path, 'rb')
        workspace = cPickle.load(load_path)
        curr_rois = workspace['final_rois']
        if (not('11' in curr_rois[0].stim_name)):
            continue
        
        for roi in curr_rois:
            flyIDs.append(roi.experiment_info['FlyID'])
            genotypes.append(roi.experiment_info['Genotype'])
        
        # Luminance slopes
        luminances= curr_rois[0].luminances
        curr_rois = ROI_mod.analyze_luminance_steps(curr_rois)
        curr_rois = ROI_mod.calculate_correlation(curr_rois, stim_type='11LuminanceSteps')
        
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

        if (geno == "L1_") or (geno =='L2_') or (geno =='L3_'):
            rel_t = 0.4   #0.5 usually
        else:
            rel_t=0.1
        curr_rois = ROI_mod.threshold_ROIs(curr_rois, {'correlation':corr_t,
                                                    'reliability' : rel_t,
                                                    'lum_resp_max' : 0.1})
        base_resps = np.squeeze\
                    (list(map(lambda roi: \
                                np.mean(roi.lum_resp_traces_interpolated[:,60:65], 
                                        axis=1),curr_rois)))
        
        base_resps_peak = np.squeeze\
                    (list(map(lambda roi: \
                                np.mean(roi.lum_resp_traces_interpolated[:,3:8], 
                                        axis=1),curr_rois)))
        save = save_path

        try:
            raw_stim = curr_rois[0].stim_info['output_data']
        except KeyError:
            warnings.warn('Raw stim not found skipping: {data}'.format(data=dataset))
            continue
        stim_frames = raw_stim[:,7]  # Frame information
        stim_vals = raw_stim[:,3] # Stimulus value
        uniq_frame_id = np.unique(stim_frames,return_index=True)[1]
        stim_vals = stim_vals[uniq_frame_id]

        for idx, roi in enumerate(curr_rois):
            
            roi.slope = linregress(roi.luminances,base_resps[idx])[0]
            fps = roi.imaging_info['frame_rate']
            filtered = ROI_mod.low_pass(roi.df_trace.copy(), fps, crit_freq=1,plot=False)
            y = filtered.copy()
            if not len(stim_vals) == len(y):
                diff = len(y) - len(stim_vals)
                y = y[diff:] # Seb: taking care of the 5 sec pause at the beginning without stimulation
                print(diff)

            x = stim_vals[:len(y)]
            ## We keep the bin size same == 0.25 and calculate n_bins based on it
            bin_step = 0.15

            if MI_baseline ==True:
                def MI_func(response, cols):
                    """Calculate the Mutual information based on the baseline response for each luminance

                    Parameters
                    ==========
                    x: array
                        roi.lum_resp_traces_interpolated 
                    cols: array
                        list of time points of the baseline
                    
                    Returns
                    =======
                    
                    stim_list: array
                        list of luminances for the baseline response
                    resp_list: array    
                        baseline response for each luminance"""

                    df = pd.DataFrame(response)
                    df['stim'] = luminances
                    df['stim_list'] = df.stim.apply(lambda x: [x,x,x,x,x])
                    df['new'] = df[cols].values.tolist()
                    resp_list = []
                    stim_list = []
                    for i in (df.index):
                        resp_list = resp_list + df.new[i]
                        stim_list = stim_list + df.stim_list[i]
                    return stim_list, resp_list



                cols = [60,61,62,63,64]
                response = roi.lum_resp_traces_interpolated
                stim_list, resp_list = MI_func(response, cols)

                n_bins = (np.max(resp_list)- np.min(resp_list))/bin_step
                n_bins = n_bins.round()
                if n_bins == 0:
                    n_bins = 1
                mi = pac.calc_MI(stim_list, resp_list, bins = [10, n_bins])

            roi.MI = mi

        baseline_tunings.append(base_resps)
        baseline_tunings_peak.append(base_resps_peak)

        all_rois.append(curr_rois)
        data_to_extract = ['SNR','reliability','slope','MI','category','NL_idx']
        roi_data = ROI_mod.data_to_list(curr_rois, data_to_extract)
        
        df_c = {}
        df_c['MI'] = roi_data['MI']
        df_c['NL_idx'] = roi_data['NL_idx']
        df_c['slope'] = roi_data['slope']
        df_c['category'] = roi_data['category']
        df_c['Reliab'] = roi_data['reliability']
        df_c['flyID'] = np.tile(curr_rois[0].experiment_info['FlyID'],len(curr_rois))
        df_c['Geno'] = np.tile(geno,len(curr_rois))
        df_c['uniq_id'] = np.array(map(lambda roi : roi.uniq_id, curr_rois)) 
        df_c["ROI"] =np.array(map(lambda roi : roi, curr_rois)) 
        
        if "RF_map_norm" in curr_rois[0].__dict__.keys():
            df_c['RF_map_center'] = list(map(lambda roi : (roi.RF_map_norm>0.95).astype(int)
                                                , curr_rois))
            df_c['RF_map_bool'] = np.tile(True,len(curr_rois))
            screen = np.zeros(np.shape(curr_rois[0].RF_map))
            screen[np.isnan(curr_rois[0].RF_map)] = -0.1
            print('RFs found')
        else:
            df_c['RF_map_center'] = np.tile(None,len(curr_rois))
            df_c['RF_map_bool'] = np.tile(False,len(curr_rois))
            
        df = pd.DataFrame.from_dict(df_c) 
        rois_df = pd.DataFrame.from_dict(df)
        combined_df = combined_df.append(rois_df, ignore_index=True, sort=False)
        print('{ds} successfully loaded\n'.format(ds=dataset))
    baseline_tunings = np.concatenate((baseline_tunings[:]))
    baseline_tunings_peak = np.concatenate((baseline_tunings_peak[:]))
    all_rois = np.concatenate(all_rois)

    le = preprocessing.LabelEncoder()
    le.fit(combined_df['flyID'])
    combined_df['flyIDNum'] = le.transform(combined_df['flyID'])
    genotypes = np.array(genotypes)  

    df = pd.DataFrame(combined_df['MI'])
    df['FlyID'] = combined_df['flyID']
    df['ROI'] = combined_df['ROI']
    df.index = df.FlyID
    df.pop('FlyID')
    df.to_csv('%s\MI.csv'%save)


    ## Luminance encoding ##
    plt.close('all')

    df_end = pd.DataFrame(baseline_tunings, columns=luminances)
    flyIDs = np.array(combined_df['flyID']).astype(str)
    df_end['FlyID'] = flyIDs

    df_end.index = df_end.FlyID
    df_end.pop('FlyID')
    df_peak = pd.DataFrame(baseline_tunings_peak, columns = luminances)
    df_peak['FlyID'] = flyIDs 
    df_peak.index = df_peak.FlyID
    df_peak.pop('FlyID')   

    if experiment_label == "Figure 4\\L2 HisCl1 RNAi":
        df_end['ROI'] = combined_df['ROI'].values

    df_end.to_csv('%s\ROIs.csv'%save)


    df_para = pd.DataFrame()
    df_end = df_end.sub(df_end[1.0], axis =0)
    for i in  range(df_end.shape[0]):
        y = df_end.iloc[i,:11].values    
        x = luminances
        plt.plot(x,y)
        para  = model_fitting(x,y)
        df_para = pd.concat([df_para, pd.DataFrame.from_dict(para, orient = 'index' ).transpose()])

    plt.xlabel('Time (s)', fontsize=18)
    plt.ylabel('$\Delta F/F$', fontsize=18)  
    plt.title('luminance encoding per ROI ', fontsize=18)
    plt.yticks(fontsize=20) 
    plt.xticks(fontsize=20) 
    plt.legend()
    # plt.ylim(0,2)
    plt.savefig('%s\\luminance_encoding_per_roi.pdf' % save, bbox_inches='tight',dpi=300)

    # Convert arrays to strings
    cols = ['linear_para', 'expo_para', 'd_expo_para1', 'd_expo_para2']
    for col in cols:
        df_para[col] = df_para[col].apply(np.array2string)

    df_para['ROI'] = all_rois
    df_para['FlyID'] = flyIDs
    df_para.index = df_para.FlyID
    df_para.pop('FlyID')
    df_para.to_csv('%s\model_fitting_per_roi.csv'%save)

    plt.close('all')

    def expo_func(x, a, c, d):
        return a*np.exp(c*x)+ d


    ## Per Fly
    df_para = pd.DataFrame()
    df_end_fly = df_end.groupby('FlyID', sort =False).mean()
    df_end_fly = df_end_fly.sub(df_end_fly[1.0], axis =0)
    for i in  range(df_end_fly.shape[0]):
        y = df_end_fly.iloc[i,:11].values     
        x = luminances
        plt.scatter(x,y, label = np.unique(flyIDs)[i])
        para  = model_fitting(x,y)
        fitted = expo_func(x,*para['expo_para'] )
        plt.plot(x,fitted, '--', color = 'gray' )
        df_para = pd.concat([df_para, pd.DataFrame.from_dict(para, orient = 'index' ).transpose()])

    plt.xlabel('Time (s)', fontsize=18)
    plt.ylabel('$\Delta F/F$', fontsize=18)  
    plt.title('luminance encoding per Fly ', fontsize=18)
    plt.yticks(fontsize=20) 
    plt.xticks(fontsize=20) 
    plt.legend()
    # plt.ylim(0,2)
    plt.savefig('%s\\luminance_encoding_per_fly.pdf' % save, bbox_inches='tight',dpi=300)
    # Convert arrays to strings
    cols = ['linear_para', 'expo_para', 'd_expo_para1', 'd_expo_para2']
    for col in cols:
        df_para[col] = df_para[col].apply(np.array2string)

    df_para['FlyID'] = np.unique(flyIDs)
    df_para.index = df_para.FlyID
    df_para.pop('FlyID')
    df_para.to_csv('%s\model_fitting_per_fly.csv'%save)


    sample_size = {}
    sample_size["n"] = '%.0f(%.0f)' %(len(np.unique(flyIDs)), len(all_rois))
    # Save the dictionary to a binary file

    with open("%s\sample_size.pkl" %(save_path), "wb") as file:  # 'wb' means write-binary
        pickle.dump(sample_size, file)



    # Plotting the respresentative raw trace
    if geno_label == "Figure 1\\L2":
        flyID = "28072021_neel_fly2"
        roi_id = 623212936
    elif geno_label == "Figure 1\\L3":
        flyID = "15092025_neel_fly1"
        roi_id = 501181256.0
    elif geno_label == "Figure S3\\L2split Ih RNAi":
        flyID = ["06082026_neel_fly2"]
        roi_id = [498585096.0]
    elif geno_label == "Figure S3\\L2split":
        flyID = ["27032024_neel_fly5" ]
        roi_id = [630099720.0]
    elif geno_label == "Figure S3\\L3":
        flyID = ["12012023_neel_fly1" ]
        roi_id = [534222024.0]

    
    fly_mask = combined_df['flyID'].values == flyID
    fly_save_dir = os.path.join(neuron_save_dir,flyID[0]) # or os.path.join(neuron_save_dir,flyID) if an error 
    if not os.path.exists(fly_save_dir):
        os.mkdir(fly_save_dir)
    fly_df = combined_df[fly_mask]
    if geno =='L3_':
        curr_color = 'green'
    elif geno == 'L2_':
        curr_color = 'blue'

        
    fig = plt.figure(figsize=(10, 6))
    grid = plt.GridSpec(1, 3, wspace=0.3, hspace=0.5)
    ax1=plt.subplot(grid[0,:])

    curr_roi_props = fly_df[fly_df['uniq_id'].values==roi_id]
    roi = curr_roi_props['ROI'].values[0]

    raw_stim = roi.stim_info['output_data']
    stim_frames = raw_stim[:,7]  # Frame information
    stim_vals = raw_stim[:,3] # Stimulus value
    uniq_frame_id = np.unique(stim_frames,return_index=True)[1]
    stim_vals = stim_vals[uniq_frame_id]
    for stim_val in np.unique(stim_vals):
        stim_vals[stim_vals==stim_val] = luminances[int(stim_val)]
    stim_plot = \
        stim_vals[:len(roi.df_trace)] +np.around(roi.df_trace.max(),1)

    time = \
        np.linspace(0,len(roi.df_trace[50:])/roi.imaging_info['frame_rate'],
                    len(roi.df_trace[50:]))
        
    ax1.plot(time,roi.df_trace[50:],color=curr_color,
                label=geno)
    try:
        ax1.plot(time,stim_plot[:len(time)],'k', # Seb before: stim_plot[50:]
                label='stimulus')
    except:
        ax1.plot(time[:len(stim_plot)],stim_plot,'k', # Seb before: stim_plot[50:]
                label='stimulus')
                

    ax1.set_ylabel('$\Delta F/F$')
    ax1.set_xlabel('Time(s)')
    ax1.set_ylim([-1, 3])
    ax1.plot([0 ,time.max()],[roi.df_trace[50:370].mean() ,roi.df_trace[50:370].mean()],'--r',lw=1, label = "Baseline") # Mean over whole trace
    ax1.legend()
    idx_max = np.where(stim_vals ==1.0)
    selected_idx = idx_max[0][59:70]
    # ax1.plot([0 ,time.max()],[roi.df_trace[50:][selected_idx].mean() ,roi.df_trace[50:][selected_idx].mean()],'--r',lw=1) # If last 1 sec of max luminance set as baseline
    # ax2


        # Saving figure
    save_name = 'ROI_{idd}'.format(idd=int(roi_id))   # or 'ROI_{idd}'.format(idd=int(roi_id[0])) if an error 
    os.chdir(fly_save_dir)
    fig_label = geno_label.rpartition("\\")[0]
    label = geno_label.rpartition("\\")[-1]
    plt.savefig('%s.jpg' % save_name, bbox_inches='tight')
    plt.savefig('%s\%s\%s.pdf' % (dataFolder,fig_label,label), bbox_inches='tight',dpi=300)
    plt.savefig('%s.pdf' % save_name, bbox_inches='tight')
