% set up to make all fff figures...
clear all;
close all;
clc;

pdatapath='/Users/ksporar/Documents/MATLAB/Katja_pData';
addpath(pdatapath);
cd(pdatapath);

database_select_samples_ks;

% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6F_L221DhhGal4.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6F_L3MH56Gal4.*~i_moving)
f_fff_Tm9LexA  = find(i_fff2s.*i_UASGCaMP6F_L3MH56Gal4.*~i_moving);



% create structures by neuron
fTm9LexA = create_neuron_structure_all_ks(f_fff_Tm9LexA);

% load all the data!
xTm9LexA = load_neuron_data10Hz_ks(fTm9LexA,pdatapath);

% mTm9LexA = aggregate_fff_means10Hz_5s_G6_v2(xTm9LexA);
% mTm9LexA = aggregate_fffall_means10Hz(xTm9LexA);
mTm9LexA = aggregate_fffall_means10Hz_BleedThruFix(xTm9LexA);


dur = size(mTm9LexA.rats,2);
durs=5;




%%
% correlate with stimulus to select normal and inverted ROIs
iRATE = 10; %rate at which data are interpolated
dur = size(mTm9LexA.rats,2);


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
% mean_res = mean(cur_mat,1); %was correlating with the mean before
% Q = corr(mean_res',cur_mat');

cur_t = [1:size(cur_mat,2)]/iRATE;

%positive correlation with stimulus
Q = corr(mean(mTm9LexA.stims)',cur_mat');
inds = find(Q>0.5); %finds the cells whose response correlates well with
% the stimulus 
cur_mat_pos = cur_mat(inds,:);
cur_IDs_pos = cur_IDs(inds);

%calculating means across flies
[x_pos,m_pos,e_pos] = mean_cat_full(cur_mat_pos,1,cur_IDs_pos);
%calculating the max for each trace
max_pos = max(x_pos,[],2)-1;


%negative correlation with stimulus
Q = corr(mean(mTm9LexA.stims)',cur_mat');
inds = find(Q<-0.5);
size(inds)
cur_mat_neg = cur_mat(inds,:);
cur_IDs_neg = cur_IDs(inds);

%calculating means across flies
[x_neg,m_neg,e_neg] = mean_cat_full(cur_mat_neg,1,cur_IDs_neg);
max_neg = max(x_neg,[],2)-1;

%plot negatively correlated cells, mean across ROIs
% mROI_neg = mean(cur_mat_neg);
mROI_neg = mean(cur_mat_neg)
eROI_neg = std(cur_mat_neg,[],1)/sqrt(size(cur_mat_neg,1)); %S.E.M

%normalization step %Katja
normROI_neg = mROI_neg - min(mROI_neg)
normROI_neg = normROI_neg ./ max(normROI_neg)


figure; hold on
% subplot(2,2,1); hold on;
cm=colormap('lines');
h2 = plot_err_patch_v2(cur_t,normROI_neg,eROI_neg,[0 0.5 0],[0 0.80 0]);
title('L3 UASGCaMP6f');
legend([h2],sprintf('L3>>GCaMP6F, N = %d ( %d )',size(x_neg,1),size(cur_mat_neg,1)),...
    'location','northeast');
plot(cur_t, (round(mean(mTm9LexA.stims))*0.1)+0.6)
ylim([-0.1 1.1]);
% line([0 10],[0 0],'color',[0 0 0]); %for 5 s
line([0 4],[0 0],'color',[0 0 0]); %for 2 s


%%



%Plotting "normal" and "inverted" cells
t = [1:dur]/10;
figure; hold on;
subplot(2,2,1);
cm=colormap('lines');
h1 = plot_err_patch_v2(t,[mTm9LexA.allm_norm-1 ],...
    [mTm9LexA.alle_norm ],[0 0 1],[0.5 0.5 1]);
h2 = plot_err_patch_v2(t ,[mTm9LexA.allm_inv-1 ],...
   [mTm9LexA.alle_inv],[0.75 0 0.75],[0.75 0.5 0.75]);
% plot([0 5],0.3*[1 1],'k-','linewidth',3);
% plot([10 15],0.3*[1 1],'k-','linewidth',3);
title('L3, all "normal" and "inverted" cells');
legend([h1, h2],sprintf('L3>>GCaMP6F, "normal", N = %d ( %d )',size(mTm9LexA.meanbyfly_norm,1),size(mTm9LexA.norm_rats,1)),...
    sprintf('L3>>GCaMP6F, "inverted", N = %d ( %d )',size(mTm9LexA.meanbyfly_inv,1),size(mTm9LexA.inv_rats,1)),...
    'location','northeast');
plot(t, (round(mean(mTm9LexA.stims))*0.1)+0.8)





% % % % % % % 
% % % % % % % %negative correlation with stimulus
% % % % % % % 
% % % % % % % % Q = corr(mean(mTm9LexA.stims)',cur_mat');
% % % % % % % % inds = find(Q<-0.5);
% % % % % % % % size(inds)
% % % % % % % % cur_mat_neg = cur_mat(inds,:);
% % % % % % % % cur_IDs_neg = cur_IDs(inds);
% % % % % % % % 
% % % % % % % % %calculating means across flies
% % % % % % % % [x_neg,m_neg,e_neg] = mean_cat_full(cur_mat_neg,1,cur_IDs_neg);
% % % % % % % % max_neg = max(x_neg,[],2)-1;


