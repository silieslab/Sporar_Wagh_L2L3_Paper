#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Thu Mar 19 15:23:13 2020

@author: neelwagh
"""


"""This code generates figure panels"""
import pandas as pd
import numpy as np
import matplotlib
import matplotlib.pyplot as plt
from pandas.core.reshape import merge
from sklearn import preprocessing
import seaborn as sns
from os import path
import os

dataFolder = r'W:\PAPER FIGURES\data\\RNA seq\\RNA_seq_transcript data' # Set the datafolder 
path =os.path.join(dataFolder, 'analyzed') # Setting path

df_ion = pd.read_csv('%s\\DEGs voltage-gated monoatomic ion channel activity across all 3 datasets.csv'% (path), header = 0)  
df_recep = pd.read_csv('%s\\DEGs neurotransmitter receptor activity across all 3 datasets.csv' % (path), header = 0)
not_present = df_ion[~df_ion['symbol'].isin(df_recep['symbol'])]
df_L2L3 = pd.concat([df_recep, not_present], axis=0)

df_L2L3.index = df_L2L3['symbol']
df_L2L3.pop('symbol')
# Define thresholds
log2fc_threshold_up = 3
log2fc_threshold_down = -3
pvalue_adj_threshold = 0.05
df_L2L3["significance"] = np.where((df_L2L3['log2FC.L2_Vs_L3.'] > log2fc_threshold_up) & (df_L2L3['padj.L2_Vs_L3.'] < pvalue_adj_threshold), 'Upregulated',
                               np.where((df_L2L3['log2FC.L2_Vs_L3.'] < log2fc_threshold_down) & (df_L2L3['padj.L2_Vs_L3.'] < pvalue_adj_threshold), 'Downregulated', 'Not significant'))
df_L2L3 = df_L2L3[df_L2L3["significance"] != "Not significant"]
genes = df_L2L3.index.values

plt.close('all')
plt.figure(figsize=(10, 8))
for gene in genes:
    gene_data = df_L2L3.loc[gene]
    plt.scatter(gene_data['log2FC.L2_Vs_L3.'], -np.log10(gene_data['padj.L2_Vs_L3.']), color = 'grey')
    plt.text(gene_data['log2FC.L2_Vs_L3.'], -np.log10(gene_data['padj.L2_Vs_L3.']), gene)
    plt.rc('font', size=12)   

colors = {'Upregulated': '#00a14a', 'Downregulated': '#30a7de'}
plt.scatter(df_L2L3['log2FC.L2_Vs_L3.'], -np.log10(df_L2L3['padj.L2_Vs_L3.']), c=df_L2L3['significance'].apply(lambda x: colors[x]), alpha=0.7)
plt.axhline(y=-np.log10(pvalue_adj_threshold), color='black', linestyle='--')
plt.axvline(x=log2fc_threshold_up, color='black', linestyle='--')
plt.axvline(x=log2fc_threshold_down, color='black', linestyle='--')
plt.xlabel('Log2 Fold Change')
plt.ylabel('-Log10 Adjusted P-value')
plt.title('Volcano Plot')
from matplotlib.lines import Line2D
legend_elements = [Line2D([0], [0], marker='o', color='w', markerfacecolor='#30a7de', markersize=10, label='Higher in L2'),
Line2D([0], [0], marker='o', color='w', markerfacecolor='#00a14a', markersize=10, label='Higher in L3')]

plt.legend(handles=legend_elements)

plt.xlabel('Log2 Fold Change')
plt.ylabel('-Log10 Adjusted P-value')
plt.title('Volcano Plot L3 vs L2 DEGs')
plt.savefig('%s\Volcano Plot L3 vs L2 DEGs.pdf' % (dataFolder), bbox_inches='tight')
df_L2L3.to_csv('%s\L3 vs L2 ion channels and receptors.csv' %dataFolder)

idx = np.where((df_L2L3['log2FC.L3_ctrl_Vs_L3_dfezfLOF.']> 0) | (df_L2L3['log2FC.L3_ctrl_Vs_L3_dfezfLOF.']<0))
highlight_genes_erm = df_L2L3.index.values[idx]

plt.close('all')
for gene in genes:
    gene_data = df_L2L3.loc[gene]
    plt.scatter(gene_data['log2FC.L2_Vs_L3.'], -np.log10(gene_data['padj.L2_Vs_L3.']), color = 'grey')
    plt.text(gene_data['log2FC.L2_Vs_L3.'], -np.log10(gene_data['padj.L2_Vs_L3.']), gene)
    plt.rc('font', size=12)   
for gene in highlight_genes_erm:
    try:
        gene_data = df_L2L3.loc[gene]
        plt.scatter(gene_data['log2FC.L2_Vs_L3.'], -np.log10(gene_data['padj.L2_Vs_L3.']), color='#f9bfcb')
        plt.text(gene_data['log2FC.L2_Vs_L3.'], -np.log10(gene_data['padj.L2_Vs_L3.']), gene)
        plt.rc('font', size=12)   
    except:
        None

plt.axhline(y=-np.log10(pvalue_adj_threshold), color='black', linestyle='--')
plt.axvline(x=log2fc_threshold_up, color='black', linestyle='--')
plt.axvline(x=log2fc_threshold_down, color='black', linestyle='--')
plt.xlabel('Log2 Fold Change')
plt.ylabel('-Log10 Adjusted P-value')
plt.title('Volcano Plot')
from matplotlib.lines import Line2D
legend_elements = [Line2D([0], [0], marker='o', color='w', markerfacecolor='#f9bfcb', markersize=10, label='dFezf regulated')]
plt.legend(handles=legend_elements)

plt.savefig('%s\Volcano Plot L3 vs L2 DEGs dfezf regulated.pdf' % (dataFolder), bbox_inches='tight')