
from os import path
import os
import pandas as pd
import numpy as np
import matplotlib
import matplotlib.pyplot as plt
from pandas.core.reshape import merge
from sklearn import preprocessing
import seaborn as sns
import random

dataFolder = r'W:\PAPER FIGURES\data\\RNA seq\\RNA_seq_transcript data' # Set the datafolder 
path =os.path.join(dataFolder, 'analyzed') # Setting path


df_L2L3 = pd.read_csv('%s\\L2_Vs_L3_res_GO.csv' %path, header = 0, index_col = 0)  

df_L3dfezfLOF = pd.read_csv('%s\\L3_L3dfezF_LOF_res_GO.csv' %path, header = 0, index_col = 0) 

df_L2_dfezfGOF =pd.read_csv('%s\\L2_L2dfezF_GOF_GO.csv' %path, header = 0, index_col = 0)

tested_genes = ['Irk3','HisCl1','Irk2','Grd','ort','Slob','Ih','Ace','Shawl','SKIP','Shab','Nmdar1']
cols = ['symbol', 'log2FoldChange',  'padj']
df_L2L3_new = df_L2L3[cols]
df_L2L3_new.columns = ['symbol', 'log2FC.L2_Vs_L3.',  'padj.L2_Vs_L3.']
df_L3dfezfLOF_new = df_L3dfezfLOF[cols]
df_L3dfezfLOF_new.columns = ['symbol', 'log2FC.L3_ctrl_Vs_L3_dfezfLOF.',  'padj.L3_ctrl_Vs_L3_dfezfLOF.']
df_L2_dfezfGOF_new = df_L2_dfezfGOF[cols]
df_L2_dfezfGOF_new.columns = ['symbol', 'log2FC.L2_ctrl_Vs_L2_dfezfGOF.',  'padj.L2_ctrl_Vs_L2_dfezfGOF.']

merged_df = pd.merge(
    df_L2L3_new,
    df_L3dfezfLOF_new,
    on="symbol",
    how="outer" )  # change to "outer" if you want all symbols)

final_df = pd.merge(
    merged_df,
    df_L2_dfezfGOF_new,
    on="symbol",
    how="outer" ) 
final_df = final_df.drop_duplicates(subset='symbol')
final_df.fillna(0, inplace=True)
df_filtered = final_df[final_df["symbol"].isin(tested_genes)]
df_filtered = df_filtered.sort_values(by="log2FC.L2_Vs_L3.", ascending=True)
df_filtered.index =df_filtered['symbol']
# Plotting the Heatmap

cols = [ 'log2FC.L2_Vs_L3.', 
       'log2FC.L3_ctrl_Vs_L3_dfezfLOF.', 
       'log2FC.L2_ctrl_Vs_L2_dfezfGOF.']
plt.close('all')
plt.figure(figsize=(12, 20))
sns.heatmap(df_filtered[cols], annot=False, yticklabels=True)
plt.ylabel('Gene', rotation = 90)

plt.savefig('%s\Heatmap L3 vs L2 tested genes.pdf' % (dataFolder), bbox_inches='tight')


df_ion = pd.read_csv('%s\\DEGs voltage-gated monoatomic ion channel activity across all 3 datasets.csv'% (path), header = 0)  
df_recep = pd.read_csv('%s\\DEGs neurotransmitter receptor activity across all 3 datasets.csv' % (path), header = 0)
df_ion_reg = pd.read_csv('%s\\DEGs ion channel regulator activity across all 3 datasets.csv' %path, header=0)
not_present = df_ion[~df_ion['symbol'].isin(df_recep['symbol'])]
df_combine = pd.concat([df_recep, not_present], axis=0)
not_present_2 = df_combine[~df_combine['symbol'].isin(df_ion_reg['symbol'])]

df_combined = pd.concat([df_ion_reg, not_present_2], axis=0)
df_combined_sorted = df_combined.sort_values(by='log2FC.L2_Vs_L3.')
df_combined_sorted.reset_index(drop=True, inplace=True)
cols = [u'symbol', u'log2FC.L2_Vs_L3.', u'padj.L2_Vs_L3.',
       u'log2FC.L3_ctrl_Vs_L3_dfezfLOF.', u'padj.L3_ctrl_Vs_L3_dfezfLOF.',
       u'log2FC.L2_ctrl_Vs_L2_dfezfGOF.', u'padj.L2_ctrl_Vs_L2_dfezfGOF.']

df_temp = df_combined_sorted[cols].dropna(subset = cols[1:6])


cols = [ 'log2FC.L2_Vs_L3.', 
       'log2FC.L3_ctrl_Vs_L3_dfezfLOF.', 
       'log2FC.L2_ctrl_Vs_L2_dfezfGOF.']

idx = np.where((df_temp['log2FC.L2_Vs_L3.']> 0) | (df_temp['log2FC.L2_Vs_L3.']<0))
df_new = df_temp.loc[idx]
idx = np.where((df_temp['log2FC.L3_ctrl_Vs_L3_dfezfLOF.']> 0) | (df_temp['log2FC.L3_ctrl_Vs_L3_dfezfLOF.']<0))
df_heatmap = df_new.loc[idx]
df_heatmap = df_heatmap.dropna(axis =0)
df_heatmap.index = df_heatmap['symbol']
plt.close('all')
plt.figure(figsize=(12, 20))
sns.heatmap(df_heatmap[cols], annot=False, yticklabels=True)
plt.ylabel('Gene', rotation = 45)

plt.savefig('%s\Heatmap L3 vs L2 DEGs extended dfezf regulated.pdf' % (dataFolder), bbox_inches='tight')