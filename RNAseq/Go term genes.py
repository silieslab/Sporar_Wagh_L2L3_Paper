import pandas as pd
import numpy as np
import matplotlib
import matplotlib.pyplot as plt
from pandas.core.reshape import merge
from sklearn import preprocessing
import seaborn as sns
import random
from os import path
import os
"""
@author:  neelwagh
"""
GO_term_number = 'GO:0099106'  # Select Go term (GO:0005244, voltage-gated monoatomic ion channel activity) (GO:0030594, neurotransmitter receptor activity)(GO:0099106, ion channel regulator activity)
dataFolder = r'W:\PAPER FIGURES\data\\RNA seq\\RNA_seq_transcript data' # Set the datafolder 
path =os.path.join(dataFolder, 'analyzed') # Setting path

df_L2L3 = pd.read_csv('%s\\L2_Vs_L3_res_GO.csv' %dataFolder, header = 0, index_col = 0)  

df_L3dfezfLOF = pd.read_csv('%s\\L3_L3dfezF_LOF_res_GO.csv' %dataFolder, header = 0, index_col = 0) 

df_L2_dfezfGOF =pd.read_csv('%s\\L2_L2dfezF_GOF_GO.csv' %dataFolder, header = 0, index_col = 0)


L2L3_BP = pd.read_csv('%s\\L2_Vs_L3_GO_results_MF.csv'%dataFolder, header = 0, index_col=0) 
L3dfezfLOF_BP = pd.read_csv('%s\\L3_L3dfezF_LOF_GO_results_MF.csv'%dataFolder, header = 0,index_col=0) 
L2dfezfGOF_BP = pd.read_csv('%s\\L2_L2dfezF_GOF_GO_results_MF.csv'%dataFolder, header = 0, index_col=0) 

cols = ['symbol', 'log2FoldChange',  'padj']
try:
    print(L2L3_BP.loc[GO_term_number]['Description'])
    L2L3_genes = L2L3_BP.loc[GO_term_number]['geneID'].split('/')

except:
    print('GO_term not found')
    L2L3_genes = []
    df_L2L3_new = pd.DataFrame(columns=['symbol', 'log2FC.L2_Vs_L3.',  'padj.L2_Vs_L3.'])


try:
    print(L3dfezfLOF_BP.loc[GO_term_number]['Description'])
    L3dfezfLOF_genes = L3dfezfLOF_BP.loc[GO_term_number]['geneID'].split('/')

except:
    print('GO_term not found')
    L3dfezfLOF_genes =[]
    df_L3dfezfLOF_new = pd.DataFrame(columns=['symbol', 'log2FC.L3_ctrl_Vs_L3_dfezfLOF.',  'padj.L3_ctrl_Vs_L3_dfezfLOF.'])

try:
    print(L2dfezfGOF_BP.loc[GO_term_number]['Description'])
    L2dfezfOGF_genes = L2dfezfGOF_BP.loc[GO_term_number]['geneID'].split('/')

except:
    print('GO_term not found')
    L2dfezfOGF_genes = []
    df_L2_dfezfGOF_new = pd.DataFrame(columns=['symbol', 'log2FC.L2_ctrl_Vs_L2_dfezfGOF.',  'padj.L2_ctrl_Vs_L2_dfezfGOF.'])

genes = L2L3_genes + L3dfezfLOF_genes + L2dfezfOGF_genes

if GO_term_number == 'GO:0030594':
    genes =  genes + ['FBgn0003011', 'FBgn0037950']

df_L2L3_new = df_L2L3.loc[genes][cols]
df_L2L3_new.columns = ['symbol', 'log2FC.L2_Vs_L3.',  'padj.L2_Vs_L3.']
df_L3dfezfLOF_new = df_L3dfezfLOF.loc[genes][cols]
df_L3dfezfLOF_new.columns = ['symbol', 'log2FC.L3_ctrl_Vs_L3_dfezfLOF.',  'padj.L3_ctrl_Vs_L3_dfezfLOF.']
df_L2_dfezfGOF_new = df_L2_dfezfGOF.loc[genes][cols]
df_L2_dfezfGOF_new.columns = ['symbol', 'log2FC.L2_ctrl_Vs_L2_dfezfGOF.',  'padj.L2_ctrl_Vs_L2_dfezfGOF.']

# try:
#     print(L2L3_BP.loc[GO_term_number]['Description'])
#     L2L3_genes = L2L3_BP.loc[GO_term_number]['geneID'].split('/')
#     df_L2L3_new = df_L2L3.loc[L2L3_genes][cols]
#     df_L2L3_new.columns = ['symbol', 'log2FC.L2_Vs_L3.',  'padj.L2_Vs_L3.']
# except:
#     print('GO_term not found')
#     df_L2L3_new = pd.DataFrame(columns=['symbol', 'log2FC.L2_Vs_L3.',  'padj.L2_Vs_L3.'])


# try:
#     print(L3dfezfLOF_BP.loc[GO_term_number]['Description'])
#     L3dfezfLOF_genes = L3dfezfLOF_BP.loc[GO_term_number]['geneID'].split('/')
#     df_L3dfezfLOF_new = df_L3dfezfLOF.loc[L3dfezfLOF_genes][cols]
#     df_L3dfezfLOF_new.columns = ['symbol', 'log2FC.L3_ctrl_Vs_L3_dfezfLOF.',  'padj.L3_ctrl_Vs_L3_dfezfLOF.']
# except:
#     print('GO_term not found')
#     df_L3dfezfLOF_new = pd.DataFrame(columns=['symbol', 'log2FC.L3_ctrl_Vs_L3_dfezfLOF.',  'padj.L3_ctrl_Vs_L3_dfezfLOF.'])

# try:
#     print(L2dfezfGOF_BP.loc[GO_term_number]['Description'])
#     L2dfezfOGF_genes = L2dfezfGOF_BP.loc[GO_term_number]['geneID'].split('/')
#     df_L2_dfezfGOF_new = df_L2_dfezfGOF.loc[L2dfezfOGF_genes][cols]
#     df_L2_dfezfGOF_new.columns = ['symbol', 'log2FC.L2_ctrl_Vs_L2_dfezfGOF.',  'padj.L2_ctrl_Vs_L2_dfezfGOF.']
# except:
#     print('GO_term not found')
#     df_L2_dfezfGOF_new = pd.DataFrame(columns=['symbol', 'log2FC.L2_ctrl_Vs_L2_dfezfGOF.',  'padj.L2_ctrl_Vs_L2_dfezfGOF.'])


df_L2L3_new = df_L2L3_new[(df_L2L3_new["padj.L2_Vs_L3."] < 0.05) &
    ((df_L2L3_new["log2FC.L2_Vs_L3."] > 0.6) | (df_L2L3_new["log2FC.L2_Vs_L3."] < -0.6))]

df_L3dfezfLOF_new = df_L3dfezfLOF_new[(df_L3dfezfLOF_new["padj.L3_ctrl_Vs_L3_dfezfLOF."] < 0.05) &
    ((df_L3dfezfLOF_new["log2FC.L3_ctrl_Vs_L3_dfezfLOF."] > 0.6) | (df_L3dfezfLOF_new["log2FC.L3_ctrl_Vs_L3_dfezfLOF."] < -0.6))]

df_L2_dfezfGOF_new = df_L2_dfezfGOF_new[(df_L2_dfezfGOF_new["padj.L2_ctrl_Vs_L2_dfezfGOF."] < 0.05) &
    ((df_L2_dfezfGOF_new["log2FC.L2_ctrl_Vs_L2_dfezfGOF."] > 0.6) | (df_L2_dfezfGOF_new["log2FC.L2_ctrl_Vs_L2_dfezfGOF."] < -0.6))]

##All genes across either of the 3 datasets
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
df_sorted = final_df.sort_values(by="log2FC.L2_Vs_L3.", ascending=True)
df_sorted.index = df_sorted['symbol']
df_sorted.pop('symbol')
df_sorted.to_csv('%s\DEGs %s across all 3 datasets.csv' % (dataFolder, L2L3_BP.loc[GO_term_number]['Description']))