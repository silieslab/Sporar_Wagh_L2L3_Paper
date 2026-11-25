%%% Analyse by different regions of the neuron

clc;
clear all;
close all;

% CONSTANTS
ANALYZE_BY_REGION = true;% weather ROIs should be selected based on their layer in the lobula complex. 
REGION = 'AT';  % which group or layer of ROIs will be included in this plot
% AT=axon terminals; AX=axons; CB=cell bodies; DE=dendrites
% this region info is stored as a string in the variable 'layer'in the MASTER excel spreadsheet

if(ANALYZE_BY_REGION)
    GENOTYPE_STRING = ['L3 >> GCaMP6f, region: ' REGION];
    if(strcmp(REGION,'AT'))
        COLOR_OF_PLOT = [0 .5 0];% GREEN
        COLOR_CLOUD =[.5 .7 .5];% GREEN
    elseif(strcmp(REGION,'AX'))
        COLOR_OF_PLOT = [1 0 0]; %RED
        COLOR_CLOUD = [1 .5 .5]; %RED cloud
    elseif(strcmp(REGION,'CB'))
        COLOR_OF_PLOT = [.7 .7 0];% YELLOW
        COLOR_CLOUD = [.9 .9 .5];%YELLOW cloud
    elseif(strcmp(REGION,'CH'))
        COLOR_OF_PLOT = [0 0 1]; %BLUE; 
        COLOR_CLOUD = [.5 .5 1]; %blue cloud
    end
else
    GENOTYPE_STRING = 'L3 >> GCaMP6f, all regions';
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


% L3
% f_fff_Tm9LexA  = find(i_LocalCircle_5min_control_for_the_ramp.*i_UASGCaMP6f_L3MH56Gal4_cross_to_w.*~i_moving.*((flyID==2071)|(flyID==2072)|(flyID==2073)|(flyID==2074)|(flyID==2076)|(flyID==2077)|(flyID==2078)));

%L2
% f_fff_Tm9LexA = find(i_LocalCircle_5min_control_for_the_ramp.*i_UASGCaMP6F_L221DhhGal4_cross_to_w.*~i_moving);
f_fff_Tm9LexA  = find(i_LocalCircle_5min_control_for_the_ramp.*i_UASGCaMP6F_L221DhhGal4_cross_to_w.*~i_moving.*((flyID==2079)|(flyID==2080)|(flyID==2081)|(flyID==2082)|(flyID==2083)|(flyID==2084)|(flyID==2085)|(flyID==2086)|(flyID==2087)|(flyID==2088)));


% create structures by neuron
fTm9LexA = create_neuron_structure_all_ks(f_fff_Tm9LexA);

if (ANALYZE_BY_REGION)
    xTm9LexA = load_neuron_data10Hz_byRegion(fTm9LexA,pdatapath, REGION);
else
    % interpolates at 10 Hz now...
    xTm9LexA = load_neuron_data10Hz_ks(fTm9LexA,pdatapath);
end

mTm9LexA = aggregate_fff60sonly_means10Hz_triggeronON_control_ramp(xTm9LexA);


%% A new script %ks
iRATE = 10; %rate at which data are interpolated
dur = size(mTm9LexA.rats,2);
DURS = 300;

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

cur_t = [1:size(cur_mat,2)]/iRATE;


Q = corr(mean(mTm9LexA.stims)',cur_mat');
inds = find(Q>0.2); %finds the cells whose response correlates well with
% the stimulus 
cur_mat_pos = cur_mat(inds,:);
cur_IDs_pos = cur_IDs(inds);

%calculating means across flies
[x_pos,m_pos,e_pos] = mean_cat_full(cur_mat_pos,1,cur_IDs_pos);
%calculating the max for each trace
max_pos = max(x_pos,[],2)-1;




%negative correlation with stimulus

Q = corr(mean(mTm9LexA.stims)',cur_mat');
inds = find(Q<-0.2);
size(inds)
cur_mat_neg = cur_mat(inds,:);
cur_IDs_neg = cur_IDs(inds);

%calculating means across flies
[x_neg,m_neg,e_neg] = mean_cat_full(cur_mat_neg,1,cur_IDs_neg);
max_neg = max(x_neg,[],2)-1;



% plot negatively correlated cells, mean across flies
figure; hold on
t = [1:dur]/10;
subplot(2,1,1);
cm=colormap('lines');
h2 = plot_err_patch_v2(cur_t,m_neg-1,e_neg,[0 0.5 0],[0 0.80 0]); %m_neg-1 is there to put the calcium trace down to zero
title([gen_str ', neg corr, mean by ROI']);
legend([h2],sprintf([gen_str ', N = %d ( %d )'],size(x_neg,1),size(cur_mat_neg,1)),...
    'location','northeast');
plot(cur_t, (round(mean(mTm9LexA.stims))*0.1)+0.6)
ylim([-0.7 1.5]);
xlim([0 600])
line([0 4],[0 0],'color',[0 0 0]); %for 2 s


subplot(2,1,2);
plot(t,x_neg)
title('individual fly means');
ylim([-0.8 3.0]); %for L2
line([DURS DURS],[-0.6 0.6],'color',[0 0 0],'linestyle','--');
line([0 DURS],[0 0],'color',[0 0 0]);
set(gcf,'Color','w');
niceaxes;

%% plot negatively correlated cells, mean across ROIs
mROI_neg = mean(cur_mat_neg);
eROI_neg = std(cur_mat_neg,[],1)/sqrt(size(cur_mat_neg,1)); %S.E.M

figure; hold on
subplot(2,1,1);
cm=colormap('lines');
% h2 = plot_err_patch_v2(cur_t,mROI_neg,eROI_neg,[0 0.5 0],[0 0.80 0]);
h2 = plot_err_patch_v2(cur_t,mROI_neg-1,eROI_neg,[0.75 0 0.75],[0.75 0.5 0.75]);
title([gen_str ', neg corr, mean by ROI']);
legend([h2],sprintf([gen_str ', N = %d ( %d )'],size(x_neg,1),size(cur_mat_neg,1)),...
    'location','northeast');
plot(cur_t, (round(mean(mTm9LexA.stims))*0.1)+0.6)
ylim([-0.8 1.5]); %for L2
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


%% positive correlation with stimulus

Q = corr(mean(mTm9LexA.stims)',cur_mat');
inds = find(Q<-0.5);
size(inds)
cur_mat_neg = cur_mat(inds,:);
cur_IDs_neg = cur_IDs(inds);

%calculating means across flies
[x_neg,m_neg,e_neg] = mean_cat_full(cur_mat_neg,1,cur_IDs_neg);
max_neg = max(x_neg,[],2)-1;



% plot positively correlated cells, mean across flies
figure; hold on
t = [1:dur]/10;
subplot(2,1,1);
cm=colormap('lines');
h2 = plot_err_patch_v2(cur_t,m_pos-1,e_pos,[0 0.5 0],[0 0.80 0]); %m_neg-1 is there to put the calcium trace down to zero
title([gen_str ', neg corr, mean by ROI']);
legend([h2],sprintf([gen_str ', N = %d ( %d )'],size(x_pos,1),size(cur_mat_pos,1)),...
    'location','northeast');
plot(cur_t, (round(mean(mTm9LexA.stims))*0.1)+0.6)
% ylim([-0.7 2.2]);
ylim([-0.7 1.5]);
% xlim([0 140])
xlim([1 600]) 
% line([0 10],[0 0],'color',[0 0 0]); %for 5 s
line([0 4],[0 0],'color',[0 0 0]); %for 2 s


subplot(2,1,2);
plot(t,x_pos)
title('individual fly means');
ylim([-0.8 3.0]); %for L2
% ylim([-0.8 1.0]); %for L3
% ylim([-0.5 0.5]); %DE
% ylim([-0.5 0.4]); %ort rescue
line([DURS DURS],[-0.6 0.6],'color',[0 0 0],'linestyle','--');
line([0 DURS],[0 0],'color',[0 0 0]);
set(gcf,'Color','w');
niceaxes;



%% use this plot only for L2 and L2 ort!!!
iRATE = 10; %rate at which data are interpolated
dur = size(mTm9LexA.rats,2);
DURS = 300;

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
mean_res = mean(cur_mat,1); %was correlating with the mean beforee
Q = corr(mean_res',cur_mat');

cur_t = [1:size(cur_mat,2)]/iRATE;


% Q = corr(mean(mTm9LexA.stims)',cur_mat');
inds = find(Q>0.2); %finds the cells whose response correlates well with
% the stimulus 
cur_mat_pos = cur_mat(inds,:);
cur_IDs_pos = cur_IDs(inds);

%calculating means across flies
[x_pos,m_pos,e_pos] = mean_cat_full(cur_mat_pos,1,cur_IDs_pos);
%calculating the max for each trace
max_pos = max(x_pos,[],2)-1;



Q = corr(mean(mTm9LexA.stims)',cur_mat');
inds = find(Q<-0.2);
size(inds)
cur_mat_neg = cur_mat(inds,:);
cur_IDs_neg = cur_IDs(inds);

%calculating means across flies
[x_neg,m_neg,e_neg] = mean_cat_full(cur_mat_neg,1,cur_IDs_neg);
max_neg = max(x_neg,[],2)-1;



% plot positively correlated cells, mean across flies
figure; hold on
t = [1:dur]/10;
subplot(2,1,1);
cm=colormap('lines');
h2 = plot_err_patch_v2(cur_t,m_pos-1,e_pos,[0 0.5 0],[0 0.80 0]); %m_neg-1 is there to put the calcium trace down to zero
title([gen_str ', neg corr, mean by ROI']);
legend([h2],sprintf([gen_str ', N = %d ( %d )'],size(x_pos,1),size(cur_mat_pos,1)),...
    'location','northeast');
plot(cur_t, (round(mean(mTm9LexA.stims))*0.1)+0.6)
% ylim([-0.7 2.2]);
ylim([-0.8 2.5]);
% xlim([0 140])
xlim([1 600]) %just for the dendrites!!!
% line([0 10],[0 0],'color',[0 0 0]); %for 5 s
line([0 4],[0 0],'color',[0 0 0]); %for 2 s


subplot(2,1,2);
plot(t,x_pos)
title('individual fly means');
ylim([-0.8 3.0]); %for L2
% ylim([-0.8 1.0]); %for L3
% ylim([-0.5 0.5]); %DE
% ylim([-0.5 0.4]); %ort rescue
line([DURS DURS],[-0.6 0.6],'color',[0 0 0],'linestyle','--');
line([0 DURS],[0 0],'color',[0 0 0]);
set(gcf,'Color','w');
niceaxes;



%% Step size - plotting and statistics - MAX response

THRESHOLD = 0;
fprintf('THRESHOLD for Signal sum: %d \n',THRESHOLD );

% Mean over flies
cur_mat = mTm9LexA.rats;
cur_IDs = mTm9LexA.flyID;

%calculating means across flies
[x_neg,m_neg,e_neg] = mean_cat_full(cur_mat_neg,1,cur_IDs_neg);

% take a mean of all assigned values, ignore 0
crossing_rats = mTm9LexA.rats;
crossing_rats(crossing_rats==0) = NaN;

% Mean over all ROI's
mean_val = squeeze(mean(crossing_rats,1,'omitnan'));

num_steps = size(mean_val,1);
numROIs = size(crossing_rats,1);

mean_calcium = zeros(1,num_steps);
err_calcium = zeros(1,num_steps);

off_step = [1];
off_step = logical(off_step);




for kk =1:num_steps
  
        
    traces = squeeze(mTm9LexA.rats(:,:)); %because mean_cat_full works only with 2 dimensions %taking all ROIs, the epoch we are on, full lenth (200)
    [x,m,e] = mean_cat_full(traces,1,mTm9LexA.flyID); %m=mean; e=std
    
    
    %ks: defining the time where we look for the baseline
    baseline = x(:,round(0.1*end):round(0.4*end)); %60s till 240s
    %ks: defining the time where we look for the response
    search_peak = x(:,round(0.2*end)+1:round(0.9*end));
    calcium = squeeze(nanmean(search_peak,1));
    

    if off_step(kk)
        baseline = baseline;
        peak = max(calcium);
    end



    not_NaN_flies = size(x,1); % Fabi: would crash otherwise, we have only 8 flies (not 12) evaluated here !
    
    calciumStep = zeros(not_NaN_flies,1);

    
    calciumStep = zeros(not_NaN_flies,1);
%     for ii = 1:not_NaN_flies
%         if on_step(kk)
%             calciumStep(ii) = max(search_peakONtogrey(ii,:)) - max(baselineONtogrey(ii,:));
%         else
%             calciumStep(ii) = max(search_peak(ii,:)) - max(baseline(ii,:));
%         end
% 
%     end

    for ii = 1:not_NaN_flies
        if off_step(kk)
            calciumStep(ii) = max(search_peak(ii,:)) - min(baseline(ii,:));
        end

    end
        
    
    all_steps_all_means_flies(:,kk) = calciumStep; %use this for statistics!
    
    mean_calcium(kk) = mean(calciumStep);

    err_calcium(kk) = std(calciumStep,'omitnan')/sqrt(length(calciumStep));

    
  end  





% Plot ALL steps-------------------------------------------------
bar_all = figure;
grid on;

% Plot the data only for OFF steps
y1 = mean_calcium(off_step);
x1 = find(off_step);
e1 = err_calcium(off_step);

hold on;
% bar(x1,y1,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.0);
bar(x1,y1,'FaceColor',[0 1 1]);
errorbar(x1,y1,e1,'rx');

title('max response');

% Add titles
ax = gca;
ax.XTick = 1:length(off_step);
ax.XTickLabels = {'100% ON --> 100% OFF'};
ax.XTickLabelRotation = 45;
ylabel('max (OFF) peak') ;

hold off;



%% Step size - plotting and statistics - baseline response

THRESHOLD = 0;
fprintf('THRESHOLD for Signal sum: %d \n',THRESHOLD );

% Mean over flies
cur_mat = mTm9LexA.rats;
cur_IDs = mTm9LexA.flyID;

%calculating means across flies
[x_neg,m_neg,e_neg] = mean_cat_full(cur_mat_neg,1,cur_IDs_neg);

% take a mean of all assigned values, ignore 0
crossing_rats = mTm9LexA.rats;
crossing_rats(crossing_rats==0) = NaN;

% Mean over all ROI's
mean_val = squeeze(mean(crossing_rats,1,'omitnan'));

num_steps = size(mean_val,1);
numROIs = size(crossing_rats,1);

mean_calcium = zeros(1,num_steps);
err_calcium = zeros(1,num_steps);

off_step = [1];
off_step = logical(off_step);




for kk =1:num_steps
  
        
    traces = squeeze(mTm9LexA.rats(:,:)); %because mean_cat_full works only with 2 dimensions %taking all ROIs, the epoch we are on, full lenth (200)
    [x,m,e] = mean_cat_full(traces,1,mTm9LexA.flyID); %m=mean; e=std
    
    
    %ks: defining the time where we look for the baseline
    baseline = x(:,round(0.1*end):round(0.4*end)); %60s till 240s
    %ks: defining the time where we look for the response
    search_peak = x(:,round(0.5*end)+1:round(0.9*end));
    calcium = squeeze(nanmean(search_peak,1));
    

    if off_step(kk)
        baseline = baseline;
        peak = max(calcium);
    end



    not_NaN_flies = size(x,1); % Fabi: would crash otherwise, we have only 8 flies (not 12) evaluated here !
    
    calciumStep = zeros(not_NaN_flies,1);

    
    calciumStep = zeros(not_NaN_flies,1);
%     for ii = 1:not_NaN_flies
%         if on_step(kk)
%             calciumStep(ii) = max(search_peakONtogrey(ii,:)) - max(baselineONtogrey(ii,:));
%         else
%             calciumStep(ii) = max(search_peak(ii,:)) - max(baseline(ii,:));
%         end
% 
%     end

    for ii = 1:not_NaN_flies
        if off_step(kk)
            calciumStep(ii) = mean(search_peak(ii,:)) - mean(baseline(ii,:));
        end

    end
        
    
    all_steps_all_means_flies(:,kk) = calciumStep; %use this for statistics!
    
    mean_calcium(kk) = mean(calciumStep);

    err_calcium(kk) = std(calciumStep,'omitnan')/sqrt(length(calciumStep));

    
  end  





% Plot ALL steps-------------------------------------------------
bar_all = figure;
grid on;

% Plot the data only for OFF steps
y1 = mean_calcium(off_step);
x1 = find(off_step);
e1 = err_calcium(off_step);

hold on;
% bar(x1,y1,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.0);
bar(x1,y1,'FaceColor',[0 1 1]);
errorbar(x1,y1,e1,'rx');

title('max response');

% Add titles
ax = gca;
ax.XTick = 1:length(off_step);
ax.XTickLabels = {'100% ON --> 100% OFF'};
ax.XTickLabelRotation = 45;
ylabel('max (OFF) peak') ;

hold off;





