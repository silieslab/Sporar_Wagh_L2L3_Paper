#!/usr/bin/env python2
# -*- coding: utf-8 -*-
'''
@Author: neelwagh'''


"""This code generates the figure comparing avg calcium traces for the full field flashes stimuli for the chosen experimental conditions.
Plots the peak responses; Peak retention: the percentage of the peak response retained at the end plateau (final 500 ms of the OFF epoch) of the response trace; 
Exponent: the exponential exponent obtained by fitting the response from 1.2 to 3.2 seconds after the OFF step
 """
from operator import index, truediv
import pandas as pd
import numpy as np
import warnings
import matplotlib
import matplotlib.pyplot as plt
from sklearn import preprocessing
import pickle
import os
import random
from scipy.stats import linregress
from scipy.stats.stats import pearsonr
import seaborn as sns
import sys
from scipy.optimize import curve_fit
from sklearn.metrics import r2_score
from sklearn.metrics import mean_absolute_error
from sklearn.metrics import mean_squared_error
from statistical_tests import statistical_test




# Setting path and genotypes

dataFolder = r'W:\PAPER FIGURES\data\Python' # It must be change for the path where the data is stored in the PC

stats_path = os.path.join(dataFolder, 'Stats_tests')
if not os.path.exists(stats_path):
    os.mkdir(stats_path)

experiment_label = [ 'Figure S3\\L2split', 'Figure S3\\L2split Shab']   # gentoype folder names, First genotype must be the control
genotype = ['L2split', 'L2split Shab']
condition = "ON_OFF_5sec" # stimulus 
color = [ '#007495', '#a7bde2']
markers = ['v','o', 's', '*', '<', 'v', '*', '<','>','p']

## Choose type of analysis 

plot_3sec_ON = True # Plots previous 3 sec in addtion
plot_OFF_list = [True, "Kinetics"] # "True" -> plot OFF step responses and Peak retention or "Kinetics" -> plot fit and plot decay exponents


##FFF response plots and statistics

stim = np.array([1., 1., 1., 1., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0.,
       0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0.,
       0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0.,
       0., 0., 0., 1., 1., 1., 1., 1., 1., 1., 1., 1., 1., 1., 1., 1., 1.,
       1., 1., 1., 1., 1., 1., 1., 1., 1., 1., 1., 1., 1., 1., 1., 1., 1.,
       1., 1., 1., 1., 1., 1., 1., 1., 1., 1., 1., 1., 1.])


stim = stim +1
stim_len = len(stim)
if plot_3sec_ON == True:
    stim = np.concatenate([stim[68:], stim])

fig = plt.figure(figsize=(16, 12))
grid = plt.GridSpec(1,3, wspace=0.3, hspace=0.5)
ax1=plt.subplot(grid[0,0])
ax2=plt.subplot(grid[0,1])
ax3=plt.subplot(grid[0,2])

# Initialize variables
control = genotype[0].rpartition('\\')[-1]
OFF_step_dict= {}
OFF_plat_dict = {}
OFF_pop_dict = {}

pvalues_off = {}
pvalues_off_plat = {}
pvalues_off_pop = {}

kinetics_traces = {}
OFF_kinetics_pvalues = {}
OFF_step_kinetics = pd.DataFrame()
for plot_OFF in plot_OFF_list:
    for idx, geno_label in enumerate(experiment_label):
            geno = genotype[idx]
            path = dataFolder   # Change path
            path_geno = os.path.join(path, geno_label)
            path_new = os.path.join(path_geno, condition)
            path_analysis = os.path.join(path_new, 'Data_analysis')
            df_trace = pd.read_csv('%s\\fly_trace.csv'%path_analysis, header=0, index_col='FlyID')
            df_trace_new = df_trace.sub( df_trace.iloc[:, 90:95].mean(axis=1), axis =0)  # plot shifting to start from 0

            df_para = pd.read_csv('%s\model_fitting_per_fly.csv'%path_analysis, header=0, index_col='FlyID') # loading curve fit parameters for OFF step responses 
            df_para.expo_para = df_para.expo_para.apply(lambda x: np.fromstring(x.strip('[]'), sep=' ')) # Getting exponents of the exponential fits

            file_path = ("%s\sample_size.pkl"%path_analysis)
            with open(file_path, "rb") as file:  # Loading sample size file
                sample_size = pickle.load(file)

            expo = df_para.expo_para.apply(lambda x:x[1]).values
            if idx == 0:
                control_expo = expo
            dict_temp = {}
            dict_temp[geno] = expo
            OFF_step_kinetics = pd.concat([OFF_step_kinetics, pd.DataFrame.from_dict(dict_temp, orient = 'index' ).transpose()],  axis =1, sort=False)
            test_used, p = statistical_test(control_expo, expo, labels=['control', 'exp'], save_path=stats_path, plot = False)
            OFF_kinetics_pvalues[geno] = [test_used, p ]

            trace = df_trace_new.mean(axis=0).values
            sem = df_trace_new.sem(axis=0).values
            x = np.linspace(1,len(trace), len(trace))/10
            if plot_3sec_ON == True:
                trace = np.concatenate([trace[68:], trace]) # ploting previous 3 sec in addtion
                sem = np.concatenate([sem[68:], sem]) # ploting previous 3 sec in addtion
                x = np.linspace((stim_len), (stim_len) - 1 * (len(trace) - 1), len(trace))/10  # ploting previous 3 sec in addtion
                x = np.sort(x)
                

            ub = trace + sem 
            lb = trace - sem 
            
            
            ax1.plot(x,trace, color = color[idx], label = '%s %s'%(geno, sample_size))
            ax1.fill_between(x, ub, lb, color = color[idx], alpha = .4)
            off_step = (df_trace_new.iloc[:, :20].max(axis=1) - df_trace_new.iloc[:, 90:95].mean(axis=1)).values # Quantifying OFF step peak response
            off_plat = (df_trace_new.iloc[:, 45:50].mean(axis=1) - df_trace_new.iloc[:, 90:95].mean(axis=1)).values # Quantifying OFF step plateau response
            off_pop = (off_plat/off_step)*100 # Quantifying percent peak retention 
            OFF_step_dict[geno] = off_step 
            OFF_plat_dict[geno] = off_plat
            OFF_pop_dict[geno] = off_pop
            if plot_OFF == 'Kinetics':   #Plotting OFF step response for kinetics
                kinetics_traces[geno] = trace[42:62] 
                kinetics_traces['x'] = np.linspace(1,len(trace[42:62]), len(trace[42:62]))/10
            if geno ==  control:
                control_off = off_step
                control_plat = off_plat
                control_pop = off_pop
        
        # Performing statistical analysis
            test_used, p = statistical_test(control_off,off_step, ['control', 'exp'], save_path=stats_path, plot = False)
            pvalues_off[geno] = [test_used, p]
            test_used, p = statistical_test(control_pop,off_pop, ['control', 'exp'], save_path=stats_path, plot = False)
            pvalues_off_pop[geno] = [test_used, p]
            test_used, p = statistical_test(control_plat,off_plat, ['control', 'exp'], save_path=stats_path, plot = False)
            pvalues_off_plat[geno] = [test_used, p]


    # Making dataframes of the quantified metrics for all genotypes

    df_off = pd.DataFrame.from_dict(OFF_step_dict, orient='index')
    OFF_step = df_off.T
    

    df_off_plat = pd.DataFrame.from_dict(OFF_plat_dict, orient='index')
    OFF_plat = df_off_plat.T
      

    df_off_pop = pd.DataFrame.from_dict(OFF_pop_dict, orient='index')
    OFF_pop = df_off_pop.T
    
    fig_label = geno_label.rpartition("\\")[0]

    ax1.plot(x,stim)
    ax1.set_title('FFF response', fontsize =18)
    ax1.set_xlabel('Time (seconds)', fontsize = 18)
    ax1.set_ylabel('$\Delta F/F$', fontsize = 18)
    ax1.xaxis.set_tick_params(labelsize=18)
    ax1.yaxis.set_tick_params(labelsize=18)


    def expo_func(x, a, d):
        c = np.median(expo)  # Fix the exponential decay rate as mean of all decay rates
        print(c)
        return a*np.exp(c*x)+ d

# OFF peak responses and peak retention

    if plot_OFF == True:
        sns.boxplot(data = OFF_pop, palette = color, ax=ax3)
        sns.swarmplot(data = OFF_pop, color='0.25', ax=ax3 ,size = 8)
        ax3.set_xticklabels(OFF_pop.columns, rotation=45, fontsize = 18)
        ax3.set_ylim(-20,120)
        ax3.set_title('Peak retention', fontsize =18)
        ax3.set_ylabel('Percent of Peak', fontsize = 18)

        sns.boxplot(data = OFF_step, palette = color, ax=ax2)
        sns.swarmplot(data = OFF_step, color='0.25', ax=ax2 ,size = 8)
        ax2.set_xticklabels(OFF_step.columns, rotation=45, fontsize = 18)
        ax2.set_ylim(0.0,2)
        ax2.set_title('OFF response', fontsize =18)
        ax2.set_ylabel('$\Delta F/F$', fontsize = 18)
        # ax2.set_xlabel('Time (seconds)', fontsize = 18)
        ax2.xaxis.set_tick_params(labelsize=18)
        ax2.yaxis.set_tick_params(labelsize=18)
        ax1.legend()
        ax2.legend()
        ax3.legend()
        plt.savefig('%s\%s\FFF_plot_pop.pdf' % (path, fig_label), bbox_inches='tight')
    # Plotting exponentially curve fits to the OFF response and exponent quantification
    elif plot_OFF == "Kinetics":
        plt.close('all')
        fig = plt.figure(figsize=(7, 7))
        grid = plt.GridSpec(1, 3, wspace=0.3, hspace=0.5)
        ax1=plt.subplot(grid[0,0])
        ax2=plt.subplot(grid[0,1])
        ax3=plt.subplot(grid[0,2])
        OFF_step_kinetics = OFF_step_kinetics.loc[:, ~OFF_step_kinetics.columns.duplicated()].copy()
        sns.boxplot(data = OFF_step_kinetics, palette = color, ax=ax3)
        sns.swarmplot(data = OFF_step_kinetics, color='0.25', ax=ax3 ,size = 8)
        ax3.set_xticklabels(OFF_step_kinetics.columns, rotation=45, fontsize = 18)
        ax3.set_ylim(-1.5,0.1)
        ax3.set_title('OFF step kinetics', fontsize =18)
        ax3.set_ylabel('Decay rates', fontsize = 18)

        for geno in genotype:
            ax2.scatter(kinetics_traces['x'],kinetics_traces[geno], color = color[genotype.index(geno)], marker = markers[genotype.index(geno)], label = '%s'%(geno))
            def expo_func(x, a, d):
                c = OFF_step_kinetics.median()[geno]  # Fix the exponential decay rate as mean of all decay rates
                # print(c)
                return a*np.exp(c*x)+ d
                
            popt, pcov = curve_fit(expo_func, kinetics_traces['x'],kinetics_traces[geno], p0 = (1,-1), maxfev= 5000 )
            fitted = expo_func(kinetics_traces['x'] , *popt)
            ax2.plot(kinetics_traces['x'],fitted, '--', color = color[genotype.index(geno)] )

        ax2.set_title('OFF step response', fontsize =18)
        ax2.set_xlabel('Time (seconds)', fontsize = 18)
        ax2.set_ylabel('$\Delta F/F$', fontsize = 18)

        ax1.legend()
        ax2.legend()
        ax3.legend()
        plt.savefig('%s\%s\FFF_plot_kinetics.pdf' % (path, fig_label), bbox_inches='tight')
    # Saving the statistical analysis and plots
    f = open('%s\%s\statistics_off.txt' %(path,fig_label),"w")
    f.write(str(pvalues_off))
    f.close()

    f = open('%s\%s\statistics_off_plateau.txt' %(path,fig_label),"w")
    f.write(str(pvalues_off_plat))
    f.close()

    f = open('%s\%s\statistics_percent_of_peak.txt' %(path,fig_label),"w")
    f.write(str(pvalues_off_pop))
    f.close() 
    f = open('%s\%s\statistics_off_kinetics.txt' %(path,fig_label),"w")
    f.write(str(OFF_kinetics_pvalues))
    f.close()


    f.close()
