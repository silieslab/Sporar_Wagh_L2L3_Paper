
import scipy.stats as stats
import numpy as np
import matplotlib.pyplot as plt
import pylab
import seaborn as sns
import os


def statistical_test(data1, data2, labels, save_path, plot):
    """This function calculates the statistical significance between means of the two given arrays.
    Each data set is checked for normal distribution using:
    Graphical method - Histogram and Q-Q plot
    Statistical method - Kolmogorov-Smirnov Test, Shapiro-Wilk Test and, Anderson-Darling Test.
    If the data is normally distributed and indenpendent, we use Student T-test
    and if the data is not normal, we use Mann-Whitney-U test.

    Parameters
    ==========
        data1 : array
            array of data points
        data2 : array
            array of data points
        labels :
            labels for the datasets
        save_path :
            path for saving the data
        plot : Boolean
            plot the histogram and qqplots
    Returns
    =======
        test_used : str
            statistical test used ttest or mannwhitneyu
        p_value : float
            p_value 

    """
    save = os.path.join(save_path, 'stats' ) 
    if not os.path.exists(save):
        os.mkdir(save)

    data = [data1, data2]
    data_norm = {}
    

    for i in range(len(data)):
        # Plot Q-Q plot
        if plot == True:
            plt.close('all')
            stats.probplot(data[i], dist='norm', plot=plt)
            plt.savefig('%s\%s_qq_plot.pdf' % (save, labels[i]), bbox_inches='tight',dpi=300)
            plt.close('all')
            # PLot Histogram
            ax = sns.distplot(data[i])
            plt.savefig('%s\%s_histogram.pdf' % (save,labels[i]), bbox_inches='tight',dpi=300)
            plt.close('all')
        dict_temp = {}
        # Statistical test - Shapiro-Wilk
        stat,p = stats.shapiro(data[i])
        p_shapiro = p
        key_shapiro = labels[i]+'_shapiro'
        dict_temp[key_shapiro] = p_shapiro
        # Statistical test - Kolmogorov-Smirnov test
        # for kstest loc = 0 and scale  = 1, so we fit norm distribution to the data, and get the loc and scale
        loc, scale = stats.norm.fit(data[i])
        n = stats.norm(loc=loc, scale=scale)
        stat,p = stats.kstest(data[i],n.cdf)
        p_kstest = p
        key_kstest = labels[i]+ '_kstest'
        dict_temp[key_kstest] = p_kstest
        if p_shapiro >0.05 and p_kstest >0.05:
            data_norm[labels[i]] = 1
        else:
            data_norm[labels[i]] = 0

        f = open('%s\%s_statistics_dict.txt' %(save, labels[i]),"w")
        f.write(str(dict_temp))
        f.close()

    if sum(data_norm.values()) == 2:
        # We use t-test as the datasets are normally distributed
        test_used = 'Ttest'
        t,p = stats.ttest_ind(data1, data2)
    elif sum(data_norm.values()) < 2:
        # We use Mann whitney U test as the datasets are not normally distributed
        test_used = 'Mannwhitneyu'
        stat,p = stats.mannwhitneyu(data1, data2)

    return test_used, p


# Example
# data1 = np.random.normal(loc=20, scale=5, size=100)
# data2 = np.random.random(size=120)
# data3 = np.random.normal(loc=5, scale=10, size= 120)
# save_path = 'D:'
# labels = ['d1','d2']
# test_used, p = statistical_test(data1,data2, labels, save_path)

# print(test_used, p)
# test_used, p = statistical_test(data1,data3, labels, save_path)

# print(test_used, p)

# phluorin = [0.155300677,
# 0.094194043,
# 0.088710081,
# 0.138907859,
# 0.035900429,
# 0.106138066,
# 0.078526411,
# 0.084457995,
# ]

# GCaMP6f = [0.054446624,
# 0.086294118,
# 0.05013481,
# 0.021289934,
# 0.082195211,
# 0.071864173,
# 0.104316665,
# 0.07541909,
# 0.127886524,
# 0.100151069,
# 0.098454102,
# ]

# cas_IS4A = [0.10400211,
# 0.142410719,
# 0.07923726,
# 0.116196004,
# 0.124702194,
# 0.124740204,
# 0.115995636,
# 0.064316406,
# 0.146882303,
# 0.094987448,
# ]
# labels = ['phluorin', 'GCaMP6f']
# test_used, p = statistical_test(phluorin,GCaMP6f, labels, save_path = 'D:')
# print(test_used, p)

# labels = ['phluorin', 'cas_IS4A']
# test_used, p = statistical_test(phluorin,cas_IS4A, labels, save_path = 'D:')
# print(test_used, p)

# labels = ['cas_IS4A', 'GCaMP6f']
# test_used, p = statistical_test(cas_IS4A,GCaMP6f, labels, save_path = 'D:')
# print(test_used, p)
