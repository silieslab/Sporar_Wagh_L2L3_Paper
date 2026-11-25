#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Thu Mar 19 15:23:13 2020

@author: neelwagh
"""


"""This code generates figure panels for the luminance-contrast discrimination stimulus quantification along with the statistical analysis"""

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

experiment_label = ['Figure 4\L2','Figure 4\L2 HisCl1 RNAi', 'Figure 4\L3'] 
genotype = ['L2', 'L2 HisCl1 RNAi', 'L3']


color = ['#3ba7de', '#2e368f', '#00a14a']
markers = ['o', '*', 's']

fig_label = experiment_label[0].rpartition("\\")[0]

control1 = genotype[0]
control2 = genotype[len(genotype)-1]
data_step = pd.DataFrame()
data_baseline = pd.DataFrame()
step_pvalues = {}
baseline_pvalues = {}
step_pvalues2 = {}
baseline_pvalues2 = {}
fig = plt.figure(figsize=(16, 12))
grid = plt.GridSpec(2,2, wspace=0.3, hspace=0.5)
ax1=plt.subplot(grid[0,0])
ax2=plt.subplot(grid[0,1])
ax3=plt.subplot(grid[1,0])
ax4=plt.subplot(grid[1,1])
save = os.path.join(dataFolder, fig_label)
if not os.path.exists(save):
    os.mkdir(save)
save_path = os.path.join(save, 'Stats_tests')
if not os.path.exists(save_path):
    os.mkdir(save_path) 

for idx, geno_label in enumerate(experiment_label):
    geno = genotype[idx]
    path_geno = os.path.join(dataFolder, geno_label)
    path_new = os.path.join(path_geno, 'A_B_steps')
    path_analysis = os.path.join(path_new, 'Data_analysis')

    step_fly = pd.read_csv('%s\Step_fly.csv'%path_analysis, header= 0)
    baseline_fly = pd.read_csv('%s\Baseline_fly.csv'%path_analysis, header= 0)
    df_slope = pd.read_csv('%s\Slope and Intercept Fly.csv'%path_analysis, header=0, index_col='FlyID')
    dict_temp_step = {}
    dict_temp_step[geno] = df_slope.b_step_slope.values
    data_step = pd.concat([data_step, pd.DataFrame.from_dict(dict_temp_step, orient = 'index' ).transpose()], axis =1, sort=False)

    dict_temp_baseline = {}
    dict_temp_baseline[geno] = df_slope.b_end_slope.values
    data_baseline = pd.concat([data_baseline, pd.DataFrame.from_dict(dict_temp_baseline, orient = 'index' ).transpose()], axis =1, sort=False)

    #Plot B_step Peak response
    color_choice = color[idx]
    marker_choice = markers[idx]
    slope, intercept, rvalue, pvalue, stderr = linregress(step_fly.b_lums.values, step_fly.b_step_mean.values)
    fitted = slope*step_fly.b_lums.values + intercept
    if geno==control1:
        ax1.plot(step_fly.b_lums.values, fitted, '--', color =color_choice)
    else:
        ax1.plot(step_fly.b_lums.values, fitted, color =color_choice )
    ax1.errorbar(step_fly.b_lums.values, step_fly.b_step_mean.values, yerr= step_fly.b_step_sem.values, color =color_choice, fmt = marker_choice, label = geno)
    #Plot B_step baseline response
    slope, intercept, rvalue, pvalue, stderr = linregress(baseline_fly.b_lums.values, baseline_fly.b_end_mean.values)
    fitted = slope*baseline_fly.b_lums.values + intercept
    if geno==control1:
        ax3.plot(baseline_fly.b_lums.values, fitted, '--', color =color_choice)
    else:
        ax3.plot(baseline_fly.b_lums.values, fitted, color =color_choice)
    ax3.errorbar(baseline_fly.b_lums.values, baseline_fly.b_end_mean.values, yerr= baseline_fly.b_end_sem.values, color =color_choice, fmt = marker_choice, label = geno)

# Statistically tests
for idx, geno in enumerate(genotype):
    # With respect to control1
    control_step = data_step[control1].dropna().values
    test_used, p = statistical_test(control_step, data_step[geno].dropna().values, ['control', 'exp'], save_path=save_path, plot = False)
    step_pvalues[geno] = [test_used, p]

    control_baseline = data_baseline[control1].dropna().values
    test_used, p = statistical_test(control_baseline, data_baseline[geno].dropna().values, ['control', 'exp'], save_path=save_path, plot = False)
    baseline_pvalues[geno] = [test_used, p]

    # With respect to control2
    control_step2 = data_step[control2].dropna().values
    test_used, p = statistical_test(control_step2, data_step[geno].dropna().values, ['control', 'exp'], save_path=save_path, plot = False)
    step_pvalues2[geno] = [test_used, p]

    control_baseline2 = data_baseline[control2].dropna().values
    test_used, p = statistical_test(control_baseline2, data_baseline[geno].dropna().values, ['control', 'exp'], save_path=save_path, plot = False)
    baseline_pvalues2[geno] = [test_used, p]

sns.boxplot(data = data_step, palette = color, ax=ax2)
sns.swarmplot(data = data_step, color='0.25', ax=ax2 ,size = 8)
ax2.set_xticklabels(data_step.columns, rotation=45)
sns.boxplot(data = data_baseline, palette = color, ax=ax4)
sns.swarmplot(data = data_baseline, color='0.25', ax=ax4 ,size = 8)
ax4.set_xticklabels(data_baseline.columns, rotation=45)

ax1.set_title('B_step Response', fontsize =18)
ax1.set_xlabel('Luminance', fontsize = 18)
ax1.set_ylabel('$\Delta F/F$', fontsize = 18)
ax1.xaxis.set_tick_params(labelsize=18)
ax1.yaxis.set_tick_params(labelsize=18)
ax1.set_ylim(0,2)
ax1.legend()

ax3.set_title('B_step End', fontsize =18)
ax3.set_xlabel('Luminance', fontsize = 18)
ax3.set_ylabel('$\Delta F/F$', fontsize = 18)
ax3.xaxis.set_tick_params(labelsize=18)
ax3.yaxis.set_tick_params(labelsize=18)
ax3.set_ylim(0,1.5)
ax3.legend()

ax2.set_title('B_step Response Slopes', fontsize =18)
ax2.set_ylabel('Slope', fontsize = 18)
# ax2.set_xlabel('Genotype', fontsize = 18)
ax2.xaxis.set_tick_params(labelsize=12)
ax2.yaxis.set_tick_params(labelsize=18)
ax2.set_ylim(-6,2)

ax4.set_title('B_step End Slopes', fontsize =18)
ax4.set_ylabel('Slope', fontsize = 18)
# ax4.set_xlabel('Genotype', fontsize = 18)
ax4.xaxis.set_tick_params(labelsize=12)
ax4.yaxis.set_tick_params(labelsize=18)
ax4.set_ylim(-4,1)

f = open('%s\statistics_dict_step_wrt_control1.txt' %(save),"w")
f.write(str(step_pvalues))
f.close()
f = open('%s\statistics_dict_baseline_wrt_control1.txt' %(save),"w")
f.write(str(baseline_pvalues))
f.close()

f = open('%s\statistics_dict_step_wrt_control2.txt' %(save),"w")
f.write(str(step_pvalues2))
f.close()
f = open('%s\statistics_dict_baseline_wrt_control2.txt' %(save),"w")
f.write(str(baseline_pvalues2))
f.close()

plt.savefig('%s\A_B_steps_analysis.pdf' % (save), bbox_inches='tight')
print('Hello')


plt.close('all')

