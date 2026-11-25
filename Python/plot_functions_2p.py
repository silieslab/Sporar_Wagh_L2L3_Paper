# -*- coding: utf-8 -*-
"""
Created on Fri Sep 11 16:28:03 2020

@author: smolina

This script is to plot BOT data stored from a Bruker microscope (Prairie View Program) in a cvs file

"""
import pandas as pd
import matplotlib.pyplot as plt 
import numpy as np
from scipy import signal, stats
import math
import seaborn as sns  

def smooth(x,window_len=10,window='hanning'):
    """smooth the data using a window with requested size.
    
    This method is based on the convolution of a scaled window with the signal.
    The signal is prepared by introducing reflected copies of the signal 
    (with the window size) in both ends so that transient parts are minimized
    in the begining and end part of the output signal.
    
    input:
        x: the input signal 
        window_len: the dimension of the smoothing window; should be an odd integer
        window: the type of window from 'flat', 'hanning', 'hamming', 'bartlett', 'blackman'
            flat window will produce a moving average smoothing.

    output:
        the smoothed signal
        
    example:

    t=linspace(-2,2,0.1)
    x=sin(t)+randn(len(t))*0.1
    y=smooth(x)
    
    see also: 
    
    numpy.hanning, numpy.hamming, numpy.bartlett, numpy.blackman, numpy.convolve
    scipy.signal.lfilter
 
    TODO: the window parameter could be the window itself if an array instead of a string
    NOTE: length(output) != length(input), to correct this: return y[(window_len/2-1):-(window_len/2)] instead of just y.
    """

    if x.ndim != 1:
        raise ValueError, "smooth only accepts 1 dimension arrays."

    if x.size < window_len:
        raise ValueError, "Input vector needs to be bigger than window size."


    if window_len<3:
        return x


    if not window in ['flat', 'hanning', 'hamming', 'bartlett', 'blackman']:
        raise ValueError, "Window is on of 'flat', 'hanning', 'hamming', 'bartlett', 'blackman'"


    s=np.r_[x[window_len-1:0:-1],x,x[-2:-window_len-1:-1]]
    #print(len(s))
    if window == 'flat': #moving average
        w=np.ones(window_len,'d')
    else:
        w=eval('np.'+window+'(window_len)')

    y=np.convolve(w/w.sum(),s,mode='valid')
    y = y[window_len/2:-(window_len/2)+1] # Correcting for the lenght of the array
    return y

def make_label_ls(label, repetitions):
    return [label] * repetitions



def plot_BOT(csv_filename,save_dir,scan_rate):
    
    #Initialization
    fps = scan_rate
    stim_dur = 2 # Hard coded 2sec. Replace once you loas the stimulus file
    df = pd.read_csv(csv_filename)
    
    
    #Sorting variable 2
    
    df2 = df.iloc[:,1:-1]
    last_column = df2.columns[-1]
    df2.rename(columns = {last_column:'Background'}, inplace = True)
    last_column_min_val = np.min(df2[df2.columns[-1]]) # Min value: frame when screen was most likely OFF
    df2[df2.columns[-1]] = df2[df2.columns[-1]]-last_column_min_val # Substructing min value (to see where the screen was OFF)
    df_screenON = df2.loc[(df2[df2.columns[-1]] > 10)] # Localazing epochs
    df_screenOFF = df2.loc[(df2[df2.columns[-1]] < 10)]# Localazing epochs
#    df_screenON = df_screenON.iloc[:,0:-1] # getting ride of background ROI
#    df_screenOFF = df_screenOFF.iloc[:,0:-1] # getting ride of background ROI

#    ls_screenON = make_label_ls('ON',len(df_screenON)) #Creating list for new column in dataframe
#    ls_screenOFF = make_label_ls('OFF',len(df_screenOFF))
#    df_screenON['Screen'] = ls_screenON #Adding the new column
#    df_screenOFF['Screen'] = ls_screenOFF 

    if len(df_screenON) > len(df_screenOFF): # Making the dataframes' sizes match
        df_screenON = df_screenON.iloc[0:len(df_screenOFF),:]
    else:
        df_screenOFF = df_screenOFF.iloc[0:len(df_screenON),:]
        
        
   #Scatterplot
    fig = plt.figure() 
    axs = fig.subplots()
   
    x = df_screenOFF.mean()
    y = df_screenON.mean()
    
    #polynomial fit with degree = 3
    model = np.poly1d(np.polyfit(x, y, 2))

    #Plotting fitted polynomial line in scatterplot
    polyline = np.linspace(min(x), max(x), 50)
    axs.scatter(x,y)
#    plt.axis('equal')
#    plt.gca().set_aspect('equal', adjustable='box')

    axs.get_ylim()[1]
    line_x = [0,axs.get_ylim()[1]]
    line_y = [0,axs.get_ylim()[1]]
    axs.plot(line_x,line_y, 'r')
    axs.set_title('Abs intensity ON vs OFF')
    axs.set_ylabel('ON')
    axs.set_xlabel('OFF')
    axs.plot(polyline, model(polyline))
    fig.show() 
    fig.savefig('{}/ON_vs_OFF_all.pdf'.format(save_dir), format='pdf')
    plt.close()

#    df_diff = df_screenON.subtract(df_screenOFF) # I need to figure our how to reindex the dataframes properly to avoid NaNs
    
    
    #Plotting
    #ON
    fig = plt.figure() 
    axs = fig.subplots(2, 1)
    df_screenON.boxplot(rot=45, fontsize=8,ax=axs[0])
    axs[0].set_title('Median intensity during ON')
    axs[0].set_ylabel('Abs Intensity')
    #OFF
    df_screenOFF.boxplot(rot=45, fontsize=8,ax=axs[1])
    axs[1].set_title('Median intensity during OFF')
    axs[1].set_ylabel('Abs Intensity')
    #Difference
     
    fig.tight_layout()
    fig.show() 
    fig.savefig('{}/ON_OFF_all.pdf'.format(save_dir), format='pdf')
    plt.close()
    
    
#    df3 = pd.concat([df_screenON,df_screenOFF]) # Merging dataframe for sns plotting
#    ax = sns.boxplot(x= df3, hue="Screen",data=df3, palette="Set3")
    

    
    
    # Sorting variables
    temp_time_stamp = df.Timestamp
    start_time = temp_time_stamp[0]
    time_stamp = temp_time_stamp - start_time
    arr_time_stamp = np.asarray(time_stamp) # Time variable for x-axis (seconds)
    arr_background = df[df.columns[-1]] # It assums that the bg selection is the last region selected in the BOT window
    df = df.iloc[:,0:-2] # discarding the background ROIs from the analysis
    
    
    # Analysis by regions (BOT of ROIs)
    ls_f0 = []
    ls_ROIs = []
    ls_ROIs_df_f = []
    ls_ROIs_df_f_detrended = []
    ls_ROIs_df_f_smooth = []
    ls_peaks = []
    ls_peak_resp = []
    ls_mean_peak_resp = []
    
    for idx,column in enumerate(df): # Selecting column contents by column 
        print('Column Name: '+ column)
        if column == 'Timestamp':
            pass
        else:
            
            
            temp_ROI= np.asarray(df[column]-arr_background) # Column selection and Background substraction
            temp_ROI = temp_ROI + 0 # Shifting all valur by "+ x" to avoid baseline values below "x" that mess up with df/f calculation
            ls_ROIs.append(temp_ROI) # List containing ROIs responses for y-axis (absolute intensity values)
        
            #Df/f calculation per each ROI
            f0= np.mean(temp_ROI) # Taking as the baseline as the mean of the whole trace
            ls_f0.append(f0)
            temp_ROI_df_f = (temp_ROI-f0)/f0
            temp_ROI_df_f_detrended = signal.detrend(temp_ROI_df_f)
            ls_ROIs_df_f.append(temp_ROI_df_f) # List containing ROIs responses for y-axis (df/f values)
            
            #Signal correction: detrending and smoothing
            ls_ROIs_df_f_detrended.append(temp_ROI_df_f_detrended) # List containing ROIs responses for y-axis (df/f values)
            ls_ROIs_df_f_smooth.append(smooth(temp_ROI_df_f_detrended)) # List containing smoothed ROIs responses for y-axis (df/f values)
            
            #Data quantification: peak responses
            frame_dist = stim_dur * np.around(fps)
            temp_peaks, _ = signal.find_peaks(smooth(temp_ROI_df_f_detrended),height=0,distance=frame_dist)
            ls_peaks.append(temp_peaks)
            ls_peak_resp.append(smooth(temp_ROI_df_f_detrended)[temp_peaks])
            ls_mean_peak_resp.append(np.mean(np.array(smooth(temp_ROI_df_f_detrended)[temp_peaks])))
            
            # Plotting
            fig = plt.figure() 
            axs = fig.subplots(2, 1) 
            
            #Select a subsete for the trace if wished (just for visualization)
            stop = 800
            axs[0].plot(arr_time_stamp[0:stop], ls_ROIs_df_f_detrended[idx-1][0:stop],color= '#6600cc',linewidth=1) 
            axs[0].plot(arr_time_stamp[0:stop], ls_ROIs_df_f_smooth[idx-1][0:stop],color= '#808080',linewidth=2)
            axs[0].set_title('F0: {}'.format(f0))
            axs[0].set_ylabel('df/f')
            axs[0].set_xlabel('time(s)')
            if stop == len(arr_time_stamp): #if plotting the whole trace, it plots all the peaks for quantification
                axs[0].plot(arr_time_stamp[ls_peaks[idx-1]], ls_ROIs_df_f_smooth[idx-1][ls_peaks[idx-1]], "x")
            
            #Plotting all data points
            axs[1].boxplot(ls_peak_resp[idx-1])
            axs[1].set_title('Peak response')
            axs[1].set_ylabel('df/f')
            # idx-1 because the list has one item less than the number of iterations in the loop (the column 'Timestamp' in not ni the list)
            fig.tight_layout() # method that automatically maintains correct spacing among subplot
            fig.show() 
            fig.savefig('{}/BOT_{}.pdf'.format(save_dir, column), format='pdf')
            plt.close()
            
  
    message= ">>>> BOT data plotted and saved"
    print(message)
    df_peak_resp = pd.Series(ls_peak_resp).apply(lambda x : pd.Series(x))   #transforming the list of arrays to a pandas dataframe
    df_peak_resp = df_peak_resp.T # ROIs now in columns
    df_peak_resp = df_peak_resp.dropna() #Dropping rows NaNs values
    
    #assing original column names
    column_names = df.columns[1:] # Avoids the "Timesstamp" column   
    df_peak_resp.columns = column_names
    
    #Plotting all BOT data together
         
    fig = plt.figure() 
    axs = fig.subplots(2, 1)
    df_peak_resp.boxplot(rot=45, fontsize=8)
    axs[1].set_title('Peak response')
    axs[1].set_ylabel('df/f')

    
    #Relationship between absolut mean intensity and peak df/f
    x = ls_f0
    y = ls_mean_peak_resp
    
    #polynomial fit with degree = 3
    model = np.poly1d(np.polyfit(x, y, 2))

    #Plotting fitted polynomial line in scatterplot
    polyline = np.linspace(min(x), max(x), 50)
    axs[0].scatter(x,y)
    axs[0].plot(polyline, model(polyline))
    axs[0].set_title('Mean intensity vs peak response')
    axs[0].set_ylabel('df/f')
    axs[0].set_xlabel('Mean intensity')
    axs[0].invert_xaxis()
    fig.tight_layout()
    fig.show() 
    fig.savefig('{}/BOT_all.pdf'.format(save_dir), format='pdf')
    plt.close()
                 
    #Stats
    #Normality test. Null hypothesis: sample comes from a normal distribution
    alpha = 0.05
    if stats.normaltest(df_peak_resp)[1].all > alpha:
        print('All data is normally distributed')
        # One-way Anova with Scipy
        F,p = stats.f_oneway(*ls_peak_resp)
        # Paired ttest of independent samples
        p_values =  []
        compared_groups = []
        if p < alpha:
            for j in range(len(column_names)):
                for i in range(len(column_names)):
                  _, temp_p =  stats.ttest_ind(ls_peak_resp[j],ls_peak_resp[i])
                  p_values.append(temp_p)
                  compared_groups.append('{} vs {}'.format(column_names[j], column_names[i]))
                  
        

        # Missing: Bonferroni Correction here!!!
        #.......................................
        
        #Temporary, I will be super strict and take an alpha divided by number of comparisons for all p-values

        
        compared_groups = np.array(compared_groups)
        p_values = np.array(p_values)
        idx_significant_p_values = list(np.where(p_values < alpha/len(compared_groups))) # In this line I am being super strict
        significant_p_values = p_values[idx_significant_p_values]
        comparisons = compared_groups[idx_significant_p_values]
        
        for c in range(len(significant_p_values)):
            print('Significance between: {}, with p={}'.format(comparisons[c],significant_p_values[c]))
            
        
    return
