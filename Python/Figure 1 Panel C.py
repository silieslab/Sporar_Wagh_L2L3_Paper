#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Thu Mar 19 15:23:13 2020

@author: neelwagh
"""


"""This code generates figure panels"""

from operator import index
from matplotlib.figure import Figure
import pandas as pd
import numpy as np
import warnings
import matplotlib
import matplotlib.pyplot as plt
from sklearn import preprocessing

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
plt.rcParams['svg.fonttype'] = 'none'

# Setting path and genotypes


dataFolder = r'W:\PAPER FIGURES\data\Python' # It must be change for the path where the data is stored in the PC


experiment_label = ['Figure 1\\L2','Figure 1\\L3'] 
genotype = ['L2', 'L3']
fig_label = experiment_label[0].rpartition("\\")[0]
    
color = ['#3ba7de',  '#00a14a']
markers = ['o', 's',]

data_lum_encod = pd.DataFrame()
lum_encod_pvalues = {}

fig = plt.figure(figsize=(12, 9))
grid = plt.GridSpec(2,2, wspace=0.3, hspace=0.5)
ax1=plt.subplot(grid[0,:])
ax2=plt.subplot(grid[1,0])
ax3=plt.subplot(grid[1,1])
save = os.path.join(dataFolder, fig_label)
if not os.path.exists(save):
    os.mkdir(save)
save_path = os.path.join(save, 'Stats_tests')
if not os.path.exists(save_path):
    os.mkdir(save_path) 
for idx, geno_label in enumerate(experiment_label):
    geno = genotype[idx]
    path_geno = os.path.join(dataFolder, geno_label)
    path_new = os.path.join(path_geno, 'Varying_luminance')
    path_analysis = os.path.join(path_new, 'Data_analysis')
    df_trace = pd.read_csv('%s\\ROIs.csv'%path_analysis, header=0, index_col='FlyID')
    df_para = pd.read_csv('%s\model_fitting_per_roi.csv'%path_analysis, header=0, index_col='FlyID')
    df_para.expo_para = df_para.expo_para.apply(lambda x: np.fromstring(x.strip('[]'), sep=' '))
    expo_temp= df_para.expo_para.apply(lambda x:x[1]).values
    df_para['expo'] = expo_temp
    expo = df_para['expo'].groupby('FlyID').median().values
    if idx == 0:
        control_expo = expo
    dict_temp = {}
    dict_temp[geno] = expo
    data_lum_encod = pd.concat([data_lum_encod, pd.DataFrame.from_dict(dict_temp, orient = 'index' ).transpose()],  axis =1, sort=False)
    test_used, p = statistical_test(control_expo, expo, labels=['control', 'exp'], save_path=save_path, plot = False)
    lum_encod_pvalues[geno] = [test_used, p ]
    def expo_func(x, a, c, d):
        return a*np.exp(c*x)+ d
    #plot the trace 


    df_trace = df_trace.sub(df_trace['1.0'], axis =0)
    trace = df_trace.groupby('FlyID').mean().mean(axis=0).values
    sem = df_trace.groupby('FlyID').mean().sem(axis=0).values
    # trace = (trace - trace.min())/(trace.max()-trace.min())
    y = trace
    x = np.linspace(1,len(y), len(y))/10
    popt, pcov = curve_fit(expo_func, x, y, p0 = (1,0,-1), maxfev= 5000 )
    fitted = expo_func(x , *popt)
    ax1.scatter(x,y ,color =color[idx], marker = markers[idx], label = geno)
    ax1.errorbar(x,y, yerr = sem ,color =color[idx], marker = markers[idx], fmt= 'none')
    ax1.plot(x,fitted, '--', color =color[idx] )



# Plotting the graphs
sns.boxplot(data = data_lum_encod,palette = color, ax=ax2, showfliers = False)
sns.swarmplot(data = data_lum_encod, color='0.25', ax=ax2 ,size = 8)
ax2.set_xticklabels(data_lum_encod.columns, rotation=45)

ax1.set_title('Luminance encoding', fontsize =18)
ax1.set_xlabel('Luminance', fontsize = 18)
ax1.set_ylabel('$\Delta F/F$', fontsize = 18)
ax1.xaxis.set_tick_params(labelsize=18)
ax1.yaxis.set_tick_params(labelsize=18)
ax1.legend()

ax2.set_title('Encoding metric', fontsize =18)
ax2.set_ylabel('Decay_rate', fontsize = 18)
# ax2.set_xlabel('Genotype', fontsize = 18)
ax2.xaxis.set_tick_params(labelsize=12)
ax2.yaxis.set_tick_params(labelsize=18)


f = open('%s\statistics_dict_luminance_encoding.txt' %(save),"w")
f.write(str(lum_encod_pvalues))
f.close()



plt.savefig('%s\luminance_encoding.pdf' % (save), bbox_inches='tight')
