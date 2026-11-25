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

dataFolder = r'W:\\PAPER FIGURES\data\\RNA seq' # It must be change for the path where the data is stored in the PC

gene = 'HisCl1'   #Heatmap gene
df = pd.read_csv('%s\GSE116969_dataTable1.transcripts_x_samples_TPM.all_genes.txt.gz'%dataFolder, sep='\t', compression='gzip')
# csv_file='%s\Davis1.csv' %dataFolder

# df = pd.read_csv(csv_file, delimiter = ';')

new_cols = [
    col.split("_d")[0] if "_d" in str(col) else col
    for col in df.columns
]
df.columns = new_cols

#Mapping gene names with gene_id
unique_genes_df = df[["gene_name", "gene_id"]].drop_duplicates().reset_index(drop=True)
unique_genes_df = unique_genes_df.dropna()
gene_map = unique_genes_df.set_index("gene_name")["gene_id"]

neuron_select=['R1-6','R7','R7_Rh3','R8_Rh5','R8_Rh6','L1','L2','L3','L4','L5','Lai','Lat','Lawf1','Lawf2', 'C2','C3', 'T1'] 
df_new = df[neuron_select]
df_new.index = df['gene_name']
df_new = df_new.iloc[:34860,:]

df_avg = df_new.groupby(level=0, axis=1).mean()

df_gene_avg = df_avg.groupby(df_avg.index).mean()
df_gene_avg["gene_id"] = df_gene_avg.index.map(gene_map)
threshold = 1

df_gene_avg = df_gene_avg.loc[~(df_gene_avg < threshold).all(axis=1)]

Heatmap_df =  pd.DataFrame(df_gene_avg.loc[gene])
Heatmap_df = Heatmap_df.loc[neuron_select]
Heatmap_df = Heatmap_df.apply(pd.to_numeric, errors='coerce')
plt.figure(figsize=(12, 20))
sns.heatmap(Heatmap_df.T, annot=True, yticklabels=True, cmap = 'icefire')
plt.yticks(fontsize=12, rotation = 0)
plt.savefig('%s\HisCl1_Davis_Heatmap.pdf' % (dataFolder), bbox_inches='tight')