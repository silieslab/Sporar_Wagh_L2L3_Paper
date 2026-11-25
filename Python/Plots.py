##For Plotting

from cProfile import label
from turtle import width
import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit
import openpyxl
import pandas as pd 
import scipy.stats as stats
from pingouin import ancova
import post_analysis_core as pac
import math
import matplotlib.colors as mcolor

# df_MI = pd.read_excel('D:\HisCl1 GOF L3\eleven_steps_Luminance\L3 UAS HisCl1\Data_analysis\MI for Plateau.xlsx')  ##for Mutual information
# L3_Gal4_Control = df_MI['L3 Gal4 Control'][0:7]  ##change columns
# L3_HisCl1_GOF = df_MI['L3 HisCl1 GOF'][0:8]  #change columns
# columns = [L3_Gal4_Control, L3_HisCl1_GOF]
x_con1 = [0,1,2,3,4,5,6,7,8,9,10]
x_con2 = [0,1,2,3,4,5,6,7,8,9,10]
x_exp =[0,1,2,3,4,5,6,7,8,9,10]

y_exp = [0.65499225
,0.575898471
,0.54990622
,0.428132
,0.424644959
,0.347125777
,0.303331834
,0.194905529
,0.157165563
,0.088381175
,0
]
yerr_exp =[0.057830475
,0.025311909
,0.042618988
,0.04773781
,0.0466984
,0.025139161
,0.020490293
,0.01758931
,0.017759848
,0.022856065
,0
]
y_con1 = [0.707642427
,0.478033853
,0.508498794
,0.379810903
,0.217369458
,0.11413988
,0.178002661
,0.03780618
,0.176567445
,0.078970647
,0
]
yerr_con1 =[0.146353628
,0.036937668
,0.0654777
,0.118974006
,0.065723249
,0.045597377
,0.051149571
,0.034431028
,0.064000681
,0.051510099
,0
]

y_con2 =[0.416134369,
0.3848471
,0.303351507
,0.318047947
,0.236353262
,0.174811646
,0.133932393
,0.142132885
,0.05031627
,0.078738699
,0
]
yerr_con2 =[0.020241494
,0.029057744
,0.035814399
,0.025356527
,0.021384674
,0.024640463
,0.023546542
,0.046028148
,0.033936823
,0.020586856
,0
]
# N_exp = 7
# sqrt_N_exp =math.sqrt(N_exp)
# N_con =6
# sqrt_N_con = math.sqrt(N_con)
# ystd_exp =[]
# for j in range(len(yerr_exp)):
#     ystd_exp.append(yerr_exp[j]*sqrt_N_exp)
#     j += 1
# ystd_exp = np.array(ystd_exp)

# ystd_con= []
# for k in range(len(yerr_con)):
#     ystd_con.append(yerr_con[k]*sqrt_N_con)
#     k += 1

# ystd_con = np.array(ystd_con)

x_con1 =np.array(x_con1)
x_con2 = np.array(x_con2)
x_exp = np.array(x_exp)

y_exp = np.array(y_exp)
yerr_exp = np.array(yerr_exp)
y_con1 = np.array(y_con1)
yerr_con1 = np.array(yerr_con1)
y_con2 = np.array(y_con2)
yerr_con2 = np.array(yerr_con2)

# # ttest 
# pvals= []

# for i in range (len(y_exp)):
#     t, p = stats.ttest_ind_from_stats(mean1=y_exp[i], std1=yerr_exp[i], nobs1=N_exp, mean2=y_con[i], std2=yerr_con[i], nobs2=N_con)
#     pvals.append(p)
#     i += 1

# print('ttest_pvalue',pvals)

# # line regress stats
# slope, intercept, r_value_exp, p_value_exp, std_err = stats.linregress(x_exp,y_exp)
# print("r-squared exp:", r_value_exp**2)
# print('pvalue exp:', p_value_exp)

# slope, intercept, r_value_con, p_value_con, std_err = stats.linregress(x_con,y_con)
# print("r-squared con:", r_value_con**2)
# print('pvalue con:', p_value_con)


grid = plt.GridSpec(1, 2, wspace=0.3, hspace=0.5)


###scatter plots

# ax1=plt.subplot(grid[0,0])
# ax1.set_xlabel('Luminance')
# ax1.set_ylabel('$\Delta F/F$')
# ax2 = plt.subplot(grid[0,1])
# ax1.set_ylim([0, 1.2])
# ax2.set_ylim([0, 2])
# ax2.boxplot(columns)
# ax2.set_xlabel('Mutual Information')
# plt.xticks([1,2], ['L3 Gal4 Control', 'L3 HisCl1 GOF'])
# ax1.scatter(x,y_exp,marker = 's', color= 'g')
# ax1.scatter(x, y_con,marker = 'o', color = 'g')
# ax1.errorbar(x, y_exp, yerr=yerr_exp, label = 'L3 HisCl1 GOF')
# ax1.errorbar(x, y_con, yerr=yerr_con, label = 'L3 Gal4 Control')
# m_exp, b_exp = np.polyfit(x, y_exp, 1)
# m_con, b_con = np.polyfit(x, y_con, 1)
# ax1.plot(x, m_exp*x + b_exp, '--')
# print(f'exp slope = {m_exp}, exp intercept ={b_exp}')
# ax1.plot(x, m_con*x + b_con, '--')
# print(f'con slope = {m_con}, con intercept ={b_con}')
# ax1.set_title("Peak Response B_step")
# ax1.legend()


ax1=plt.subplot(grid[0,0])
ax1.set_xlabel('Luminance')
ax1.set_ylabel('$\Delta F/F$')
ax1.scatter(x_con1, y_con1, marker = 'o', color = 'blue', label = "L3 ort1")
ax1.errorbar(x_con1, y_con1, yerr= yerr_con1)
ax1.scatter(x_exp, y_exp, marker = 's', color = 'green', label = "L3>HisCl1 ort1 ortdf")
ax1.errorbar(x_exp, y_exp, yerr= yerr_exp)
ax1.scatter(x_con2, y_con2,marker = 'v', color = 'grey', label = 'L3 ort1 ortdf')
ax1.errorbar(x_con2, y_con2, yerr_con2)
ax1.set_title("Plateau")
ax1.legend()

ax1.set_ylim([0, 1])
def exponential(x_con, a, k, b):
    return a*np.exp(x_con*k) + b
opt, pcov = curve_fit(exponential, x_con1, y_con1, p0=[1,-0.5, 1], maxfev=10000)
    #fig, ax = plt.subplots()
fitted=exponential(x_con1,opt[0],opt[1],opt[2])
ax1.plot(x_con1,fitted, color='blue', label='Fit. func: $f(x) = %.3f e^{%.3f x} %+.3f$'%(opt[0],opt[1],opt[2]))
# ax1.plot(x_con1,fitted, linestyle =':', color='b', label='Fit. func: $f(x) = %.3f e^{%.3f x} %+.3f$'%(opt[0],opt[1],opt[2]))

def exponential(x_exp, a, k, b):
    return a*np.exp(x_exp*k) + b
opt, pcov = curve_fit(exponential, x_exp, y_exp, p0=[1,-0.5, 1], maxfev=10000)
    #fig, ax = plt.subplots()
fitted=exponential(x_exp,opt[0],opt[1],opt[2])
ax1.plot(x_exp,fitted, color='green', label='Fit. func: $f(x) = %.3f e^{%.3f x} %+.3f$'%(opt[0],opt[1],opt[2]))
# ax1.plot(x_exp,fitted, linestyle =':', color='g', label='Fit. func: $f(x) = %.3f e^{%.3f x} %+.3f$'%(opt[0],opt[1],opt[2]))

def exponential(x_con2, a, k, b):
    return a*np.exp(x_con2*k) + b
opt, pcov = curve_fit(exponential, x_con2, y_con2, p0=[1,-0.5, 1], maxfev=10000)
    #fig, ax = plt.subplots()
fitted=exponential(x_con2,opt[0],opt[1],opt[2])
ax1.plot(x_con2,fitted, color='gray', label='Fit. func: $f(x) = %.3f e^{%.3f x} %+.3f$'%(opt[0],opt[1],opt[2]))

plt.show()

