%%% Analyse by different regions of the neuron

clc;
clearvars -EXCEPT slob* contr*;
close all;

% CONSTANTS

ANALYZE_BY_REGION = true;% weather ROIs should be selected based on their layer in the lobula complex. 
REGION = 'AT';  % which group or layer of ROIs will be included in this plot
% AT=axon terminals; AX=axons; CB=cell bodies; DE=dendrites
% this region info is stored as a string in the variable 'layer'in the MASTER excel spreadsheet

if(ANALYZE_BY_REGION)
%     GENOTYPE_STRING = ['UASort UASGCaMP6f L221DhhGal4 ort1 DfBSC809, region: ' REGION];
%     GENOTYPE_STRING = ['L3 >> GCaMP6f, region: ' REGION];
%     GENOTYPE_STRING = ['L3 ort rescue R7 R8 >> ort GCaMP6f, region: ' REGION];
%     GENOTYPE_STRING = ['lexAopGCaMP6fp10attp5 16HO3lexA lexAopmyrtdTOM, region: ' REGION];
%     GENOTYPE_STRING = ['UASGCaMP6f UASort 0595Gal4,ort1, region: ' REGION];
%     GENOTYPE_STRING = ['UASort UASGCaMP6f 0595Gal4,ort1 ort1, region: ' REGION];
%     GENOTYPE_STRING = ['UASGCaMP6f plus 0595Gal4,ort1 ort1, region: ' REGION];
%     GENOTYPE_STRING = ['UASGCaMP6f plus 0595Gal4,ort1 ort1, region: ' REGION];

%     GENOTYPE_STRING = ['lexAopGCaMP6fp10attp5 16HO3lexA,lexAopmyrtdTom 11-164Gal4 ermHA, region: ' REGION];
%     GENOTYPE_STRING = ['lexAopGCaMP6fp10attp5 16HO3lexA,lexAopmyrtdTom 11-164Gal4, region: ' REGION];

%     GENOTYPE_STRING = ['UASort UASGCaMP6f L30595Gal4,ort1 DfBSC809, region: ' REGION];

%     GENOTYPE_STRING = ['RNAi btsz L3MH56Gal4 UASGCaMP6f >> GCaMP6f, region: ' REGION];
%     GENOTYPE_STRING = ['RNAi btsz L221DhhGal4 UASGCaMP6f >> GCaMP6f, region: ' REGION];
    GENOTYPE_STRING = ['L2 ort rescue, region: ' REGION];


    if(strcmp(REGION,'AT'))
        COLOR_OF_PLOT = [0 .5 0];% GREEN
        COLOR_CLOUD =[.5 .7 .5];% GREEN
    elseif(strcmp(REGION,'AX'))
        COLOR_OF_PLOT = [1 0 0]; %RED
        COLOR_CLOUD = [1 .5 .5]; %RED cloud
    elseif(strcmp(REGION,'CB')) 
        COLOR_OF_PLOT = [.7 .7 0]; % YELLOW
        COLOR_CLOUD = [.9 .9 .5]; %YELLOW cloud
    elseif(strcmp(REGION,'DE')) 
        COLOR_OF_PLOT = [0 0 1]; %BLUE; 
        COLOR_CLOUD = [.5 .5 1]; %blue cloud
    end
else
    GENOTYPE_STRING = 'L2 >> GCaMP6f, all regions';
    COLOR_OF_PLOT = [0 0 1]; %BLUE; [.7 .7 0]% YELLOW %[1 0 0]; %RED% [0 .5 0]% GREEN %[0 0 1]; %BLUE;
    %COLOR_OF_PLOT = [1 0 0]; %RED; %[0 0 1] %BLUE;
    COLOR_CLOUD = [.5 .5 1];
end
gen_str = GENOTYPE_STRING;





% % % % % 
pdatapath='/Users/ksporar/Documents/MATLAB/Katja_pData';
addpath(pdatapath);
cd(pdatapath);

database_select_samples_ks;

%L3
f_fff_Tm9LexA  = find(i_grey_3min_ND06_12min.*i_UASGCaMP6f_L3MH56Gal4_cross_to_w.*~i_moving); 
% f_fff_Tm9LexA  = find(i_ONO_100FF_3min_ND06_12min.*i_UASGCaMP6f_L3MH56Gal4_cross_to_w.*~i_moving); 
% f_fff_Tm9LexA  = find(i_ONO_80FF_3min_ND06_12min.*i_UASGCaMP6f_L3MH56Gal4_cross_to_w.*~i_moving); 




% create structures by neuron
fTm9LexA = create_neuron_structure_all_ks(f_fff_Tm9LexA);

if (ANALYZE_BY_REGION)
    xTm9LexA = load_neuron_data10Hz_byRegion(fTm9LexA,pdatapath, REGION);
else
    % interpolates at 10 Hz now...
    xTm9LexA = load_neuron_data10Hz_ks(fTm9LexA,pdatapath);
end

% mTm9LexA = aggregate_fffall_means10Hz_BleedThruFix(xTm9LexA);
mTm9LexA = aggregate_fffall_means10Hz_BleedThruFix_v2_grey3min_ND06(xTm9LexA); %when you wanna look into the aggregate function: in = xTm9LexA


%%
% correlate with stimulus to select normal and inverted ROIs
iRATE = 10; %rate at which data are interpolated
dur = size(mTm9LexA.rats,2);
DURS = 2;


% start with all the data, keep the ones that are positively correlated
% with stimulus (by value Q)
cur_mat = mTm9LexA.rats;
cur_IDs = mTm9LexA.flyID;
%clean up by zeros-only datasets and NaN dataset
inds = find(sum(cur_mat,2)~=0);
cur_mat = cur_mat(inds,:);
cur_IDs = cur_IDs(inds);
inds = ~isnan(sum(cur_mat,2));%ms: added these two lines, because there were NaN in dataset
cur_mat = cur_mat(inds,:);
cur_IDs = cur_IDs(inds);
% mean_res = mean(cur_mat,1); %was correlating with the mean beforee
% Q = corr(mean_res',cur_mat');

cur_t = [1:size(cur_mat,2)]/iRATE;


%positive correlation with stimulus


Q = corr(mean(mTm9LexA.stims)',cur_mat');
% Q = corr(mean(mTm9LexA.stims)',cur_mat');
inds = find(Q>0); %finds the cells whose response correlates well with the stimulus 
% inds = find(Q>0.1); %ONLY for ort!!!!!
cur_mat_pos = cur_mat(inds,:);
cur_IDs_pos = cur_IDs(inds);

%calculating means across flies
[x_pos,m_pos,e_pos] = mean_cat_full(cur_mat_pos,1,cur_IDs_pos);
%calculating the max for each trace
max_pos = max(x_pos,[],2)-1;




%negative correlation with stimulus

Q = corr(mean(mTm9LexA.stims)',cur_mat');
% inds = find(Q<-0.5);
inds = find(Q<-0.1) %ONLY for the L2 ort control!!!!!
size(inds)
cur_mat_neg = cur_mat(inds,:);
cur_IDs_neg = cur_IDs(inds);

%calculating means across flies
[x_neg,m_neg,e_neg] = mean_cat_full(cur_mat_neg,1,cur_IDs_neg);
max_neg = max(x_neg,[],2)-1;




%plot both normal and inverted (by correlation with stimulus) in one plot
figure; hold on
t = [1:dur]/10;
% subplot(2,2,1); hold on;
cm=colormap('lines');
h1 = plot_err_patch_v2(cur_t,m_pos,e_pos,[0 0 1],[0.5 0.5 1]);
h2 = plot_err_patch_v2(cur_t,m_neg,e_neg,[0.75 0 0.75],[0.75 0.5 0.75]);
% plot([0 5],0.3*[1 1],'k-','linewidth',3);
% plot([10 15],0.3*[1 1],'k-','linewidth',3);
title([gen_str ', all "normal" and "inverted" cells']);
legend([h1, h2],sprintf([gen_str ', "fff pos corr", N = %d ( %d )'],size(x_pos,1),size(cur_mat_pos,1)),...
    sprintf([gen_str ', "fff neg corr", N = %d ( %d )'],size(x_neg,1),size(cur_mat_neg,1)),...
    'location','northeast');
plot(t, (round(mean(mTm9LexA.stims))*0.1)+0.8)
% ylim([-0.3 0.5]);
line([0 5.5],[0 0],'color',[0 0 0]);


% plot negatively correlated cells, mean across flies
figure; hold on
subplot(2,1,1); 
cm=colormap('lines');
% h2 = plot_err_patch_v2(cur_t,m_neg,e_neg,[0.75 0 0.75],[0.75 0.5 0.75]);
h2 = plot_err_patch_v2(cur_t,m_neg,e_neg,[0 0.5 0],[0 0.80 0]); %green
% h2 = plot_err_patch_v2(cur_t,m_neg,e_neg,[1 0.4 0],[1 0.7 0]); %orange
% h2 = plot_err_patch_v2(cur_t,m_neg,e_neg,[0.5 0.4 1],[0.5 0.7 1]); %blue
title([gen_str ', neg corr, mean by fly']);
legend([h2],sprintf([gen_str ', N = %d ( %d )'],size(x_neg,1),size(cur_mat_neg,1)),...
    'location','northeast');
plot(cur_t, (round(mean(mTm9LexA.stims))*0.1)+0.6)
ylim([-0.8 2.0]); %for L2
% ylim([-0.8 1.0]); %for L3
% ylim([-0.5 0.5]); %DE
% ylim([-0.5 0.4]); %ort rescue
% line([0 10],[0 0],'color',[0 0 0]); %for 5 s
line([0 4],[0 0],'color',[0 0 0]); %for 2 s

subplot(2,1,2);
plot(t,x_neg)
title('individual fly means');
ylim([-0.8 2.0]); %for L2
% ylim([-0.8 1.0]); %for L3
% ylim([-0.5 0.5]); %DE
% ylim([-0.5 0.4]); %ort rescue
line([DURS DURS],[-0.6 0.6],'color',[0 0 0],'linestyle','--');
line([0 DURS],[0 0],'color',[0 0 0]);
set(gcf,'Color','w');
niceaxes;




%plot negatively correlated cells, mean across ROIs
mROI_neg = mean(cur_mat_neg);
eROI_neg = std(cur_mat_neg,[],1)/sqrt(size(cur_mat_neg,1)); %S.E.M

figure; hold on
subplot(2,1,1);
cm=colormap('lines');
% h2 = plot_err_patch_v2(cur_t,mROI_neg,eROI_neg,[0 0.5 0],[0 0.80 0]);
h2 = plot_err_patch_v2(cur_t,mROI_neg,eROI_neg,[0.75 0 0.75],[0.75 0.5 0.75]);
title([gen_str ', neg corr, mean by ROI']);
legend([h2],sprintf([gen_str ', N = %d ( %d )'],size(x_neg,1),size(cur_mat_neg,1)),...
    'location','northeast');
plot(cur_t, (round(mean(mTm9LexA.stims))*0.1)+0.6)
ylim([-0.8 2.0]); %for L2
% ylim([-0.8 1.0]); %for L3
% ylim([-0.5 0.5]); %DE
% ylim([-0.5 0.4]); %ort rescue
% line([0 10],[0 0],'color',[0 0 0]); %for 5 s
line([0 4],[0 0],'color',[0 0 0]); %for 2 s

subplot(2,1,2);
plot(t,cur_mat_neg)
title('individual fly means');
ylim([-0.8 3.0]); %for L2
% ylim([-0.8 1.0]); %for L3
% ylim([-0.5 0.5]); %DE
% ylim([-0.5 0.4]); %ort rescue
line([DURS DURS],[-0.6 0.6],'color',[0 0 0],'linestyle','--');
line([0 DURS],[0 0],'color',[0 0 0]);
set(gcf,'Color','w');
niceaxes;


%% dt 10% and 90% of the initial response
TIMEWINDOW = 1:15; %the window of the time trace in which we're looking for the max response
[peak_max idx_max] = max(m_neg(TIMEWINDOW));
ten_percent_max = 1*peak_max/10; %10% of the max response
ninety_percent_max = 9*peak_max/10; %90% of the max response

%finding the true datapoint that is closest to 10 and 90% max
diff_10_percent = abs(ten_percent_max - m_neg(1:idx_max));  %where peak_max lies
diff_90_percent = abs(ninety_percent_max - m_neg(1:idx_max));
[~,idx_10] = min(diff_10_percent)
[~,idx_90] = min(diff_90_percent)
% still find better way to find the (interpolated) time of 10/90% max
closest_value_10 = m_neg(idx_10);
closest_time_10 = cur_t(idx_10);
closest_value_90 = m_neg(idx_90);
closest_time_90 = cur_t(idx_90);

%finding the interpolated time of 10/90% max response

t = cur_t
p = m_neg
x = t(1):0.01:t(52) %smaller time windows
interpol_m_neg = interp1(t,p,x)


%calculating time between 10% and 90% response
time_10to90 = closest_time_90 - closest_time_10;


figure; hold on
cm=colormap('lines');
% h2 = plot_err_patch_v2(cur_t,mROI_neg,eROI_neg,[0 0.5 0],[0 0.80 0]);
h2 = plot_err_patch_v2(cur_t,mROI_neg,eROI_neg,[0.75 0 0.75],[0.75 0.5 0.75]);
title([gen_str ', neg corr, mean by ROI']);
legend([h2],sprintf([gen_str ', N = %d ( %d )'],size(x_neg,1),size(cur_mat_neg,1)),...
    'location','northeast');
plot(cur_t, (round(mean(mTm9LexA.stims))*0.1)+0.6)
ylim([-0.8 2.0]); %for L2
% ylim([-0.8 1.0]); %for L3
% ylim([-0.5 0.5]); %DE
% line([0 10],[0 0],'color',[0 0 0]); %for 5 s
line([0 4],[0 0],'color',[0 0 0]); %for 2 s
p1 = [closest_time_10, ten_percent_max] %should be:  closest (interpolated) time, ten_percent_max
plot(p1(1),p1(2),'Marker','.','Color',[0 0 0],'MarkerSize',20)

p2 = [closest_time_90, ninety_percent_max]
plot(p2(1),p2(2),'Marker','.','Color',[0 0 0],'MarkerSize',20)

line([p1(1),p2(1)], [p1(2),p2(2)])

znj1 = [ten_percent_max closest_time_10]
znj2 = [ninety_percent_max closest_time_90]
str = {'10% to 90% response rise time:', time_10to90};
text(0.3, 1.3, str)



%% dt between 10% and 90% of the initial response

%INTERPOLATION_TIME
t = cur_t
p = m_neg
x = t(1):0.001:t(52) %smaller time windows
interpol_m_neg = interp1(t,p,x, 'linear')

TIMEWINDOW = 1:1401; %the window of the time trace in which we're looking for the max response
[peak_max idx_max] = max(interpol_m_neg(TIMEWINDOW));
ten_percent_max = 10*peak_max/100 %10% of the max response
ninety_percent_max = 90*peak_max/100 %90% of the max response

%finding the true datapoint that is closest to 10 and 90% max
% diff_10_percent = abs(ten_percent_max - interpol_m_neg(1:idx_max));  %where peak_max lies
diff_10_percent = abs(ten_percent_max - interpol_m_neg(1:idx_max))
diff_90_percent = abs(ninety_percent_max - interpol_m_neg(1:idx_max))
[~,idx_10] = min(diff_10_percent)
[~,idx_90] = min(diff_90_percent)
% still find better way to find the (interpolated) time of 10/90% max
closest_value_10 = interpol_m_neg(idx_10);
closest_time_10 = x(idx_10);
closest_value_90 = interpol_m_neg(idx_90);
closest_time_90 = x(idx_90);


%calculating time between 10% and 90% response
time_10to90 = closest_time_90 - closest_time_10;


figure; hold on
cm=colormap('lines');
% h2 = plot_err_patch_v2(cur_t,mROI_neg,eROI_neg,[0 0.5 0],[0 0.80 0]);
h2 = plot_err_patch_v2(cur_t,mROI_neg,eROI_neg,[0.75 0 0.75],[0.75 0.5 0.75]);
title([gen_str ', neg corr, mean by ROI']);
legend([h2],sprintf([gen_str ', N = %d ( %d )'],size(x_neg,1),size(cur_mat_neg,1)),...
    'location','northeast');
plot(cur_t, (round(mean(mTm9LexA.stims))*0.1)+0.6)
ylim([-0.8 2.0]); %for L2
% ylim([-0.8 1.0]); %for L3
% ylim([-0.5 0.5]); %DE
% line([0 10],[0 0],'color',[0 0 0]); %for 5 s
line([0 4],[0 0],'color',[0 0 0]); %for 2 s
p1 = [closest_time_10, ten_percent_max] %should be:  closest (interpolated) time, ten_percent_max
plot(p1(1),p1(2),'Marker','.','Color',[0 0 0],'MarkerSize',20)

p2 = [closest_time_90, ninety_percent_max]
plot(p2(1),p2(2),'Marker','.','Color',[0 0 0],'MarkerSize',20)

line([p1(1),p2(1)], [p1(2),p2(2)])

znj1 = [ten_percent_max closest_time_10]
znj2 = [ninety_percent_max closest_time_90]
str = {'10% to 90% response rise time:', time_10to90};
text(0.3, 1.3, str)


%% dt between 10% and 90% of the initial response - calculating over ROI


delta_ROI = zeros(1,size(cur_mat_neg,1));
for ii = 1:size(cur_mat_neg,1)
    t = cur_t;
    p = cur_mat_neg(ii,:);
    x = t(1):0.001:t(130); %smaller time windows
    interpol_cur_mat_neg = interp1(t,p,x);
    
    
TIMEWINDOW = 1:1401; %the window of the time trace in which we're looking for the max response
[peak_max , idx_max] = max(interpol_cur_mat_neg(TIMEWINDOW));
ten_percent_max = 10*peak_max/100; %10% of the max response
ninety_percent_max = 90*peak_max/100; %90% of the max response

%finding the true datapoint that is closest to 10 and 90% max
% diff_10_percent = abs(ten_percent_max - interpol_m_neg(1:idx_max));  %where peak_max lies
diff_10_percent = abs(ten_percent_max - interpol_cur_mat_neg(1:idx_max));
diff_90_percent = abs(ninety_percent_max - interpol_cur_mat_neg(1:idx_max));
[~,idx_10] = min(diff_10_percent);
[~,idx_90] = min(diff_90_percent);
% still find better way to find the (interpolated) time of 10/90% max
closest_value_10 = interpol_cur_mat_neg(idx_10);
closest_time_10 = x(idx_10);
closest_value_90 = interpol_cur_mat_neg(idx_90);
closest_time_90 = x(idx_90);


%calculating time between 10% and 90% response
time_10to90 = closest_time_90 - closest_time_10;
delta_ROI(ii) = time_10to90;
end


mean_time_10to90 = mean(delta_ROI);
error_time_10to90 = std(delta_ROI)/sqrt(size(delta_ROI,1)); %S.E.M

%%
slobRNAi_mean = mean_time_10to90;
slobRNAi_error = error_time_10to90;
slobRNAi_deltaROI = delta_ROI;
% controlRNAi_mean = mean_time_10to90;
% controlRNAi_error = error_time_10to90;
% control_deltaROI = delta_ROI;

figure; hold on
bar([1:2],[controlRNAi_mean, slobRNAi_mean])
errorbar([1:2],[controlRNAi_mean, slobRNAi_mean], [controlRNAi_error, slobRNAi_error])
[H,P] = ttest2(control_deltaROI, slobRNAi_deltaROI)
xlim([0 3])


%% dt between 10% and 90% of the initial response - calculating over fly


delta_fly = zeros(1,size(m_neg,1));
for ii = 1:size(m_neg,1)
    t = cur_t;
    p = m_neg(ii,:);
    x = t(1):0.001:t(130); %smaller time windows
    interpol_m_neg = interp1(t,p,x);
    
    
TIMEWINDOW = 1:1401; %the window of the time trace in which we're looking for the max response
[peak_max , idx_max] = max(interpol_m_neg(TIMEWINDOW));
ten_percent_max = 10*peak_max/100; %10% of the max response
ninety_percent_max = 90*peak_max/100; %90% of the max response

%finding the true datapoint that is closest to 10 and 90% max
% diff_10_percent = abs(ten_percent_max - interpol_m_neg(1:idx_max));  %where peak_max lies
diff_10_percent = abs(ten_percent_max - interpol_m_neg(1:idx_max));
diff_90_percent = abs(ninety_percent_max - interpol_m_neg(1:idx_max));
[~,idx_10] = min(diff_10_percent);
[~,idx_90] = min(diff_90_percent);
% still find better way to find the (interpolated) time of 10/90% max
closest_value_10 = interpol_m_neg(idx_10);
closest_time_10 = x(idx_10);
closest_value_90 = interpol_m_neg(idx_90);
closest_time_90 = x(idx_90);


%calculating time between 10% and 90% response
time_10to90 = closest_time_90 - closest_time_10;
delta_fly(ii) = time_10to90;
end


mean_time_10to90 = mean(delta_fly);
error_time_10to90 = std(delta_fly)/sqrt(size(delta_fly,1)); %S.E.M

%%
slobRNAi_mean = mean_time_10to90;
slobRNAi_error = error_time_10to90;
slobRNAi_deltafly = delta_fly;
% controlRNAi_mean = mean_time_10to90;
% controlRNAi_error = error_time_10to90;
% control_deltafly = delta_fly;

figure; hold on
bar([1:2],[controlRNAi_mean, slobRNAi_mean])
errorbar([1:2],[controlRNAi_mean, slobRNAi_mean], [controlRNAi_error, slobRNAi_error])
[H,P] = ttest2(control_deltafly, slobRNAi_deltafly)
xlim([0 3])

%%
%***********
% fits
%***********

%for 5s stimulus
%calculating exponential fit
% define the start point for fitting as the maximum of the mean trace
% fitStart = find(m_neg(1:40) == max(m_neg(1:40))); %is 9 and 12 for 2s and
% 5s traces for L2, but meaningless for sustained L3 responses. Hardcode to
% be 10
% FITSTART = 10; fitstart = FITSTART;


tau = zeros(1,size(cur_mat_neg,1));
for ii = 1:size(cur_mat_neg,1)
    fitstart = find(cur_mat_neg(ii,5:20) == max(cur_mat_neg(ii,5:20)))
    fitend = fitstart + 2*iRATE;
    [fitresult, gof] = createFit_ks(cur_t(fitstart:fitend), cur_mat_neg(ii,fitstart:fitend));
    temp = fitresult.b;
    tau(ii) = 1./temp;
    close
end
ATtau_ROImean = tau

%compare to the same fit for the mean of all flies trace
fitstart = find(m_neg(5:20) == max(m_neg(5:20))); %find max of trace between frames 5 and 20 
fitend = fitstart + 2*iRATE; %plus 2s
[fitresult, gof] = createFit_ks(cur_t(fitstart:fitend), m_neg(fitstart:fitend));
temp = fitresult.b;
tau = 1./temp;
close
ATtau_ROIFLYmean = tau

%compare to the same fit for the mean of all flies trace
tau = zeros(1,size(x_neg,1));
for ii = 1:size(x_neg,1)
    [fitresult, gof] = createFit_ks(cur_t(fitstart:fitend), x_neg(ii,fitstart:fitend));
    temp = fitresult.b;
    tau(ii) = 1./temp;
%     close
end
ATtau_FLYmean = tau


%saving as a variable
AXtau = tau
% ATtau=tau
% DEtau=tau


