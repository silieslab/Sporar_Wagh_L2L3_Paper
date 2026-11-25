import cPickle
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




def model_fitting(x,y):
    """fits linear. exponential and double exponential models to the trace
    and returns parameters and estimates for goodness of fits
    
    Parameters
    ==========
    x: array
        time trace
    y: array
        response trace
    
    Returns
    =======
    
    A dictionary with all model parameters and goodness of fits"""
    parameters_dict = {}


    try:
        x = np.array(x)
        y = np.array(y)
    except:
        print('something went wrong')

    def linear_func(x, slope, intercept):
        return slope*x + intercept
    
    def expo_func(x, a, c, d):
        return a*np.exp(c*x)+ d



    ## Linear fitting ##    
    
    popt, pcov = curve_fit(linear_func, x, y, p0=(1, -1),  maxfev= 15000)
    fitted = linear_func(x, *popt)
    r2 = r2_score(y, fitted)
    mae = mean_absolute_error(y, fitted)
    mse = mean_squared_error(y, fitted)
    rmse = np.sqrt(mse)

    parameters_dict['linear_para'] = popt
    parameters_dict['linear_r2'] = r2
    parameters_dict['linear_mae'] = mae
    parameters_dict['linear_mse']= mse
    parameters_dict['linear_rmse']= rmse

    ## Exponential fitting ##

    popt, pcov = curve_fit(expo_func, x, y, p0 = (1,0,-1), maxfev= 15000 )
    fitted = expo_func(x, *popt)
    r2 = r2_score(y, fitted)
    mae = mean_absolute_error(y, fitted)
    mse = mean_squared_error(y, fitted)
    rmse = np.sqrt(mse)

    parameters_dict['expo_para'] = popt
    parameters_dict['expo_r2'] = r2
    parameters_dict['expo_mae'] = mae
    parameters_dict['expo_mse']= mse
    parameters_dict['expo_rmse']= rmse

    ## Double exponential fitting ##

    # fitting first half of the trace
    popt, pcov = curve_fit(expo_func, x[:(len(x)/2)], y[:(len(x)/2)], p0 = (1,0,-1), maxfev= 20000 )
    fitted = expo_func(x, *popt)
    r2 = r2_score(y, fitted)
    mae = mean_absolute_error(y, fitted)
    mse = mean_squared_error(y, fitted)
    rmse = np.sqrt(mse)

    parameters_dict['d_expo_para1'] = popt
    parameters_dict['d_expo_1_r2'] = r2
    parameters_dict['d_expo_1_mae'] = mae
    parameters_dict['d_expo_1_mse']= mse
    parameters_dict['d_expo_1_rmse']= rmse

    #fitting second half of the trace
    popt, pcov = curve_fit(expo_func, x[(len(x)/2):], y[(len(x)/2):], p0 = (-1,0,1), maxfev= 200000 )
    fitted = expo_func(x, *popt)
    r2 = r2_score(y, fitted)
    mae = mean_absolute_error(y, fitted)
    mse = mean_squared_error(y, fitted)
    rmse = np.sqrt(mse)

    parameters_dict['d_expo_para2'] = popt
    parameters_dict['d_expo_2_r2'] = r2
    parameters_dict['d_expo_2_mae'] = mae
    parameters_dict['d_expo_2_mse']= mse
    parameters_dict['d_expo_2_rmse']= rmse
    parameters_dict['d_expo_tau_diff'] = parameters_dict['d_expo_para1'][1] - parameters_dict['d_expo_para2'][1]

    return parameters_dict




    
    
    
    
    
