%%% Analyse by different regions of the neuron

clc;
clearvars -EXCEPT slob* contr*;
close all;

% CONSTANTS

ANALYZE_BY_REGION = true;% wether ROIs should be selected based on their layer in the lobula complex. 
REGION = 'DE';  % which group or layer of ROIs will be included in this plot

% AT=axon terminals; AX=axons; DE=dendrites
% this region info is stored as a string in the variable 'layer'in the MASTER excel spreadsheet

if(ANALYZE_BY_REGION)
%     GENOTYPE_STRING = ['L3 >> GCaMP6f, region: ' REGION];
    GENOTYPE_STRING = ['L2 >> GCaMP6f, region: ' REGION];

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
    GENOTYPE_STRING = ['L3 DE, region: ' REGION];
    COLOR_OF_PLOT = [0 0 1]; %BLUE; [.7 .7 0]% YELLOW %[1 0 0]; %RED% [0 .5 0]% GREEN %[0 0 1]; %BLUE;
    %COLOR_OF_PLOT = [1 0 0]; %RED; %[0 0 1] %BLUE;
    COLOR_CLOUD = [.5 .5 1];
end
gen_str = GENOTYPE_STRING;
% % % % % 
pdatapath='W:\Katja\Katja_pData';   % Choose the path where the pData is stored

addpath(pdatapath);
cd(pdatapath);

database_select_samples_ks;

% Figure 1

% For L2 neurons dendrites
f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6F_L221DhhGal4_cross_to_w.*~i_moving); %paper


% create structures by neuron
fTm9LexA = create_neuron_structure_all_ks(f_fff_Tm9LexA);

if (ANALYZE_BY_REGION)
    xTm9LexA = load_neuron_data10Hz_byRegion(fTm9LexA,pdatapath, REGION);
else
    % interpolates at 10 Hz now...
    xTm9LexA = load_neuron_data10Hz_ks(fTm9LexA,pdatapath);
end

% mTm9LexA = aggregate_fffall_means10Hz_BleedThruFix(xTm9LexA);
mTm9LexA = aggregate_fffall_means10Hz_BleedThruFix_v2(xTm9LexA); %when you wanna look into the aggregate function: in = xTm9LexA


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


Q = corr(nanmean(mTm9LexA.stims)',cur_mat');
% Q = corr(mean(mTm9LexA.stims)',cur_mat');
% inds = find(Q>0.5); %finds the cells whose response correlates well with the stimulus 
inds = find(Q>0.1); %ONLY for ort!!!!!    
cur_mat_pos = cur_mat(inds,:);
cur_IDs_pos = cur_IDs(inds);

%calculating means across flies
[x_pos,m_pos,e_pos] = mean_cat_full(cur_mat_pos,1,cur_IDs_pos);
%calculating the max for each trace
max_pos = max(x_pos,[],2)-1;




%negative correlation with stimulus

Q = corr(nanmean(mTm9LexA.stims)',cur_mat');
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
h1 = plot_err_patch_v2(cur_t,m_pos,e_pos,[0 0 1],[0.5 0.5 1],'-', 1);
h2 = plot_err_patch_v2(cur_t,m_neg,e_neg,[0.75 0 0.75],[0.75 0.5 0.75], '-', 1);
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
h2 = plot_err_patch_v2(cur_t,m_neg,e_neg,[0 0.5 0],[0 0.80 0], '-', 1); %green
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
h2 = plot_err_patch_v2(cur_t,mROI_neg,eROI_neg,[0.75 0 0.75],[0.75 0.5 0.75], '-', 1);
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




%% znj

numFlies = length(unique(mTm9LexA.flyID));

numROIs = size(cur_mat,1);
baseline = cur_mat(:,round(0.61*end):round(0.7*end)); %7.9 - 9.1 s of the 13s trace
response = cur_mat(:,round(0.01*end):round(0.25*end)); %0.13 - 3.25 s of the 13s trace
plateau = cur_mat(:,round(0.31*end):round(0.38*end)); %4 s - 4.9 s of the 13s trace

flyIDs = cur_IDs;   
uniqueFlies = unique(flyIDs);
numFlies = length(uniqueFlies);

calciumStep_fly = nan(numFlies,1);
calciumStep_Baseline_fly = nan(numFlies,1);
calciumStep_POP_fly = nan(numFlies,1);
% TIMEWINDOW = 2:50;
% [peak_max idx_max] = max(cur_mat(TIMEWINDOW));
% peak_max = peak_max;

    for ii = 1:numROIs
        maxresponse(ii) = max(response(ii,:));
        meanbaseline(ii) = mean(baseline(ii,:));
        meanplateau(ii) = mean(plateau(ii,:));
        calciumStep(ii) = max(response(ii,:)) - mean(baseline(ii,:));  %baseline have negative values - I need to make absolute
        calciumStep_Baseline(ii) = max(plateau(ii,:)) - mean(baseline(ii,:));
        percent_of_peak(ii) = 100*(calciumStep_Baseline(ii)/calciumStep(ii))
    end
   
    
mean_calciumStep = nanmean(calciumStep);
err_calciumStep = nanstd(calciumStep)/sqrt(length(calciumStep));

mean_maxresponse = nanmean(maxresponse);
err_maxresponse = nanstd(maxresponse)/sqrt(length(maxresponse));    

mean_meanbaseline = nanmean(meanbaseline);
err_meanbaseline = nanstd(meanbaseline)/sqrt(length(meanbaseline));    

mean_plateau = nanmean(meanplateau);
err_plateau = nanstd(meanplateau)/sqrt(length(meanplateau));   

mean_calciumStep_Baseline = nanmean(calciumStep_Baseline);
err_calciumStep_Baseline = nanstd(calciumStep_Baseline)/sqrt(length(calciumStep_Baseline));   

mean_percent_of_peak = nanmean(percent_of_peak);
err_percent_of_peak = nanstd(percent_of_peak)/sqrt(length(percent_of_peak));   



for f = 1:numFlies
    inds = flyIDs == uniqueFlies(f);   % ROIs belonging to this fly
    
    % average across ROIs of this fly
    calciumStep_Baseline_fly(f) = nanmedian(calciumStep_Baseline(inds));
    calciumStep_fly(f) = nanmedian(calciumStep(inds));
    calciumStep_POP_fly(f) = nanmedian(percent_of_peak(inds));
end



bar_all = figure;
grid on;

% Plot the data for the STEP
y1 = mean_calciumStep; %ks
x1 = 1;
e1 = err_calciumStep;

hold on;
bar(x1,y1,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.0);
errorbar(x1,y1,e1,'rx');



% Plot the data only for the MAX
y2 = mean_maxresponse; %ks
x2 = 3;
e2 = err_maxresponse;

hold on;
bar(x2,y2,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.0);
errorbar(x2,y2,e2,'rx');





% Plot the data only for the BASELINE
y3 = mean_meanbaseline; %ks
x3 = 5;
e3 = err_meanbaseline;

hold on;
bar(x3,y3,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.0);
errorbar(x3,y3,e3,'rx');





% Plot the data only for the PLATEAU
y4 = mean_plateau; %ks
x4 = 7;
e4 = err_plateau;

hold on;
bar(x4,y4,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.0);
errorbar(x4,y4,e4,'rx');





% Plot the data only for the PLATEAU
y5 = mean_calciumStep_Baseline; %ks
x5 = 9;
e5 = err_calciumStep_Baseline;

hold on;
bar(x5,y5,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.0);
errorbar(x5,y5,e5,'rx');


% Plot the data only for the PERCENT OF PEAK
figure; hold on
y6 = nanmean(calciumStep_POP_fly); %ks
x6 = 1;
e6 = nanstd(calciumStep_POP_fly) / sqrt(numFlies);
title('Percent of Peak');

bar(x6,y6,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.0);
errorbar(x6,y6,e6,'rx');
ylim([0 120])




% Plot the data for the STEP
figure; hold on
y1 = nanmean(calciumStep_fly); %ks
x1 = 1;
e1 = nanstd(calciumStep_fly) / sqrt(numFlies);

hold on;
bar(x1,y1,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.0);
errorbar(x1,y1,e1,'rx');
ylim([0 1.20])
title('OFF step Peak');


% Plot the data only for the PLATEAU
y5 = nanmean(calciumStep_Baseline_fly); %ks
x5 = 1;
e5 = nanstd(calciumStep_Baseline_fly) / sqrt(numFlies);

figure; hold on;
bar(x5,y5,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.0);
errorbar(x5,y5,e5,'rx');
ylim([0 1.20])
title('OFF step Plateau');


% At Which percent of the max response do we end at?
% y2: max response
% y4: plateau
plateau_percent = (y4*100) / y2

%taking into on account the calcium signal from before (so the calcium change)
% y1: mean_calciumStep
% y5: mean_calciumStep_Baseline
plateau_percent_from_baseline = (y5*100) / y1


%Plateau for the L3 is at 73.5%
%Plateau for the L2 is at 4.7%

bar_all = figure;
grid on;

% Plot the data for the STEP
y1 = nanmean(calciumStep_fly); %ks
x1 = 1;
e1 = nanstd(calciumStep_fly) / sqrt(numFlies);

hold on;
bar(x1,y1,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.0);
errorbar(x1,y1,e1,'rx');
ylim([0 1.20])


% Plot the data only for the Plateau
y2 = nanmean(calciumStep_Baseline_fly); %ks
x2 = 3;
e2 = nanstd(calciumStep_Baseline_fly) / sqrt(numFlies);
ylim([0 1.20])
hold on;
bar(x2,y2,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.0);
errorbar(x2,y2,e2,'rx');







% Plot the data only for the Percent of Peak
y3 = nanmean(calciumStep_POP_fly/100); %ks
x3 = 5;
e3 = nanstd(calciumStep_POP_fly/100) / sqrt(numFlies);

hold on;
bar(x3,y3,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.0);
errorbar(x3,y3,e3,'rx');
ylim([0 1.20])
set(gca,'XTickLabel',{'','Peak','','Plateau','','percent of peak/100'});
niceaxes;
