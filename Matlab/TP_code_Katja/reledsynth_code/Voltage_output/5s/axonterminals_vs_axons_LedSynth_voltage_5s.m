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
%     GENOTYPE_STRING = ['RNAi btsz L3MH56Gal4 UASGCaMP6f >> GCaMP6f, region: ' REGION];
%     GENOTYPE_STRING = ['RNAi btsz L221DhhGal4 UASGCaMP6f >> GCaMP6f, region: ' REGION];
    GENOTYPE_STRING = ['MARCM clones, region: ' REGION];


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
    GENOTYPE_STRING = 'MARCM clones, all regions';
    COLOR_OF_PLOT = [0 0 1]; %BLUE; [.7 .7 0]% YELLOW %[1 0 0]; %RED% [0 .5 0]% GREEN %[0 0 1]; %BLUE;
    %COLOR_OF_PLOT = [1 0 0]; %RED; %[0 0 1] %BLUE;
    COLOR_CLOUD = [.5 .5 1];
end
gen_str = GENOTYPE_STRING;


MAX_LAG = 20; % the max that the alignement can shift the traces

%%

% % % % % 
pdatapath='/Users/ksporar/Documents/MATLAB/Katja_pData';
% pdatapath='W:\#Common\forFabiola\LedSynth_analysis\pData';
addpath(pdatapath);
cd(pdatapath);

% For scripts
addpath('/Users/ksporar/Documents/MATLAB/TP_code_Katja/reledsynth_code');


% FB: For the code
% addpath('W:\f.buschendorf\TP_code_Katja');
% addpath('W:\#Common\forFabiola\LedSynth_analysis\reledsynth_code');

database_select_samples_ks;

%L3 - no data yet (July 2017)
% f_fff_Tm9LexA = find(i_voltage_output_blue08_2s_fff.*i_UASGCaMP6f_L3MH56Gal4_cross_to_w.*~i_moving);


%L2 - no data yet (July 2017)
% f_fff_Tm9LexA = find(i_voltage_output_blue08_2s_fff.*i_UASGCaMP6F_L221DhhGal4_cross_to_w.*~i_moving);


%Matthew Pecot
f_fff_Tm9LexA = find(i_voltage_output_blue08_5s_fff.*i_L3_ermMARCM_LOF.*~i_moving);
% f_fff_Tm9LexA = find(i_voltage_output_blue08_5s_fff.*i_L3_MARCM_LOF_control.*~i_moving);



% create structures by neuron
fTm9LexA = create_neuron_structure_all_ks(f_fff_Tm9LexA);

if (ANALYZE_BY_REGION)
    xTm9LexA = load_neuron_data10Hz_byRegion_LedSynth(fTm9LexA,pdatapath, REGION);
else
    % interpolates at 10 Hz now...
    xTm9LexA = load_neuron_data10Hz_ks(fTm9LexA,pdatapath);
end



%%
mTm9LexA = aggregate_fffall_means10Hz_LedSynth_voltage_blue08_5s(xTm9LexA); %when you wanna look into the aggregate function: in = xTm9LexA


%% Plotting
iRATE = 10; %rate at which data are interpolated
dur = size(mTm9LexA.rats,2);
DURS = 13;

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
% inds = find(Q>0.5); %finds the cells whose response correlates well with the stimulus 
inds = find(Q>0.1); %ONLY for ort!!!!!
cur_mat_pos = cur_mat(inds,:);
cur_IDs_pos = cur_IDs(inds);

%calculating means across flies
[x_pos,m_pos,e_pos] = mean_cat_full(cur_mat_pos,1,cur_IDs_pos);
%calculating the max for each trace
max_pos = max(x_pos,[],2)-1;




%negative correlation with stimulus

Q = corr(mean(mTm9LexA.stims)',cur_mat');
inds = find(Q<-0.1);
% inds = find(Q<0) %ONLY for the L2 ort control!!!!!
size(inds)
cur_mat_neg = cur_mat(inds,:);
cur_IDs_neg = cur_IDs(inds);

%calculating means across flies
[x_neg,m_neg,e_neg] = mean_cat_full(cur_mat_neg,1,cur_IDs_neg);
max_neg = max(x_neg,[],2)-1;

%%
% plot positively correlated cells, mean across flies
figure; hold on
subplot(2,1,1); 
cm=colormap('lines');
% h2 = plot_err_patch_v2(cur_t,m_pos,e_pos,[0.75 0 0.75],[0.75 0.5 0.75]);
h2 = plot_err_patch_v2(cur_t,m_pos,e_pos,[0 0.5 0],[0 0.80 0]); %green
% h2 = plot_err_patch_v2(cur_t,m_pos,e_pos,[1 0.4 0],[1 0.7 0]); %orange
% h2 = plot_err_patch_v2(cur_t,m_pos,e_pos,[0.5 0.4 1],[0.5 0.7 1]); %blue
title([gen_str ', pos corr, mean by fly']);
legend([h2],sprintf([gen_str ', N = %d ( %d )'],size(x_pos,1),size(cur_mat_pos,1)),...
    'location','northeast');
plot(cur_t, -(round(mean(mTm9LexA.stims))*0.1)+0.6)
ylim([-0.8 2.0]); %for L2
% ylim([-0.8 1.0]); %for L3
% ylim([-0.5 0.5]); %DE
% ylim([-0.5 0.4]); %ort rescue
% line([0 10],[0 0],'color',[0 0 0]); %for 5 s
line([0 4],[0 0],'color',[0 0 0]); %for 2 s

subplot(2,1,2);
plot(cur_t,x_pos)
title('individual fly means');
ylim([-0.8 2.0]); %for L2
% ylim([-0.8 1.0]); %for L3
% ylim([-0.5 0.5]); %DE
% ylim([-0.5 0.4]); %ort rescue
line([DURS DURS],[-0.6 0.6],'color',[0 0 0],'linestyle','--');
line([0 DURS],[0 0],'color',[0 0 0]);
set(gcf,'Color','w');
niceaxes;




%plot positively correlated cells, mean across ROIs
mROI_pos = mean(cur_mat_pos);
eROI_pos = std(cur_mat_pos,[],1)/sqrt(size(cur_mat_pos,1)); %S.E.M

figure; hold on
subplot(2,1,1);
cm=colormap('lines');
% h2 = plot_err_patch_v2(cur_t,mROI_neg,eROI_neg,[0 0.5 0],[0 0.80 0]);
h2 = plot_err_patch_v2(cur_t,mROI_pos,eROI_pos,[0.75 0 0.75],[0.75 0.5 0.75]);
title([gen_str ', pos corr, mean by ROI']);
legend([h2],sprintf([gen_str ', N = %d ( %d )'],size(x_pos,1),size(cur_mat_pos,1)),...
    'location','northeast');
plot(cur_t, (round(mean(mTm9LexA.stims))*0.1)+0.6)
ylim([-0.8 2.0]); %for L2
% ylim([-0.8 1.0]); %for L3
% ylim([-0.5 0.5]); %DE
% ylim([-0.5 0.4]); %ort rescue
% line([0 10],[0 0],'color',[0 0 0]); %for 5 s
line([0 4],[0 0],'color',[0 0 0]); %for 2 s

subplot(2,1,2);
plot(cur_t,cur_mat_pos)
title('individual fly means');
ylim([-0.8 2.0]); %for L2
% ylim([-0.8 1.0]); %for L3
% ylim([-0.5 0.5]); %DE
% ylim([-0.5 0.4]); %ort rescue
line([DURS DURS],[-0.6 0.6],'color',[0 0 0],'linestyle','--');
line([0 DURS],[0 0],'color',[0 0 0]);
set(gcf,'Color','w');
niceaxes;



