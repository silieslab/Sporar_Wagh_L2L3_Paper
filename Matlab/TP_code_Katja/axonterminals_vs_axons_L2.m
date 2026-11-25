%%% Analyse by different regions of the neuron

clc;
clearvars -EXCEPT slob* contr*;
close all;

% CONSTANTS

ANALYZE_BY_REGION = true;% weather ROIs should be selected based on their layer in the lobula complex. 
REGION = 'AT';  % which group or layer of ROIs will be included in this plot
% REGION = 'DE';
% REGION = 'AX';

% REGION = 'Lthree';
% REGION = 'Ltwo';

% AT=axon terminals; AX=axons; CB=cell bodies; DE=dendrites
% this region info is stored as a string in the variable 'layer'in the MASTER excel spreadsheet

if(ANALYZE_BY_REGION)
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
    GENOTYPE_STRING = 'L2 >> GCaMP6f, all regions';
    COLOR_OF_PLOT = [0 0 1];
    COLOR_CLOUD = [.5 .5 1];
end
gen_str = GENOTYPE_STRING;



% % % % % 
pdatapath='T:\Katja Sporar\MATLAB\Katja_pData';
% pdatapath='/Users/ksporar/Documents/MATLAB/Katja_pData';
% pdatapath='/Users/ksporar/manuscript_code_figures/Figure1/pData/Figure1B';
addpath(pdatapath);
cd(pdatapath);

database_select_samples_ks;


f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6F_L221DhhGal4_cross_to_w.*~i_moving);


% create structures by neuron
fTm9LexA = create_neuron_structure_all_ks(f_fff_Tm9LexA);

if (ANALYZE_BY_REGION)
    xTm9LexA = load_neuron_data10Hz_byRegion(fTm9LexA,pdatapath, REGION);
else
    % interpolates at 10 Hz now...
    xTm9LexA = load_neuron_data10Hz_ks(fTm9LexA,pdatapath);
end

% mTm9LexA = aggregate_fffall_means10Hz_BleedThruFix_v2_manuscript(xTm9LexA);
mTm9LexA = aggregate_fffall_means10Hz_BleedThruFix_v2(xTm9LexA);


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

cur_t = [1:size(cur_mat,2)]/iRATE;


%positive correlation with stimulus
Q = corr(nanmean(mTm9LexA.stims)',cur_mat');
% Q = corr(mean(mTm9LexA.stims)',cur_mat');
inds = find(Q>0.5); %finds the cells whose response correlates well with the stimulus 
cur_mat_pos = cur_mat(inds,:);
cur_IDs_pos = cur_IDs(inds);

%calculating means across flies
[x_pos,m_pos,e_pos] = mean_cat_full(cur_mat_pos,1,cur_IDs_pos);
%calculating the max for each trace
max_pos = max(x_pos,[],2)-1;


%negative correlation with stimulus
Q = corr(nanmean(mTm9LexA.stims)',cur_mat');
inds = find(Q<-0.5);
size(inds)
cur_mat_neg = cur_mat(inds,:);
cur_IDs_neg = cur_IDs(inds);

%calculating means across flies
[x_neg,m_neg,e_neg] = mean_cat_full(cur_mat_neg,1,cur_IDs_neg);
max_neg = max(x_neg,[],2)-1;


% plot negatively correlated cells, mean across flies
figure; hold on
subplot(2,1,1); 
cm=colormap('lines');
h2 = plot_err_patch_v2(cur_t,m_neg,e_neg,[0 0.5 0],[0 0.80 0]); %green
title([gen_str ', neg corr, mean by fly']);
legend([h2],sprintf([gen_str ', N = %d ( %d )'],size(x_neg,1),size(cur_mat_neg,1)),...
    'location','northeast');
plot(cur_t, (round(mean(mTm9LexA.stims))*0.1)+0.6)
ylim([-1.0 2.5]);
line([0 4],[0 0],'color',[0 0 0]); %for 2 s


% plot negatively correlated cells, individual flies
subplot(2,1,2);
plot(t,x_neg)
title('individual fly means');
ylim([-1.0 2.5]);
line([DURS DURS],[-0.6 0.6],'color',[0 0 0],'linestyle','--');
line([0 DURS],[0 0],'color',[0 0 0]);
set(gcf,'Color','w');
niceaxes;


