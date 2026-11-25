% set up to make all fff figures...
clearvars -except geno*;
% close all;
% clc;

% pdatapath='/Users/ksporar/Fiala_2p/Katja_pData';
pdatapath='/Users/ksporar/Documents/MATLAB/Katja_pData';
addpath(pdatapath);
cd(pdatapath);

database_select_samples_ks;

%%%%%%%%%%%%%%%%
% shits silencing and controls
%%%%%%%%%%%%%%%%

%*******************
%paper genotypes
% f_fff_Tm9LexA = find(i_fff2s.*i_Tm9LexAGCaMP6F.*~i_moving);
% f_fff_Tm9LexA = find(i_fff2s.*i_Tm9LexAGCaMP6F.*~i_moving.*(flyID==75));

% f_fff_Tm9LexA = find(i_fff2s.*i_Tm9LexAGCaMP6F_shits_37C.*~i_moving); %ks: breaking
% f_fff_Tm9LexA = find(i_fff2s.*i_Tm9LexAGCaMP6F_shits_37C.*~i_moving.*(flyID~=46));

% f_fff_Tm9LexA = find(i_fff2s.*i_Tm9LexAGCaMP6F_L1shits_37C.*~i_moving.*(locnum<=35));
% f_fff_Tm9LexA = find(i_fff2s.*i_Tm9LexAGCaMP6F_L2shits_37C.*~i_moving);
% f_fff_Tm9LexA = find(i_fff2s.*i_Tm9LexAGCaMP6F_L3shits_37C.*~(flyID==21).*~(flyID==11).*~i_moving.*(locnum<=35));
% f_fff_Tm9LexA = find(i_fff2s.*i_Tm9LexAGCaMP6F_L1L3shits_37C.*~i_moving.*(flyID~=57).*(locnum<=35));
% f_fff_Tm9LexA = find(i_fff2s.*i_Tm9LexAGCaMP6F_L2L3shits_37C.*~i_moving.*(locnum<=35));
% f_fff_Tm9LexA = find(i_fff2s.*i_Tm9LexAGCaMP6F_L2L3shits_37C.*~i_moving.*(flyID==83));



%paper genotypes
% f_fff_Tm9LexA = find(i_fff5s.*i_Tm9LexAGCaMP6F.*~i_moving);
% f_fff_Tm9LexA = find(i_fff5s.*i_Tm9LexAGCaMP6F_shits_37C.*~i_moving);
% f_fff_Tm9LexA = find(i_fff5s.*i_Tm9LexAGCaMP6F_L1shits_37C.*~i_moving.*(locnum<=35));
% f_fff_Tm9LexA = find(i_fff5s.*i_Tm9LexAGCaMP6F_L2shits_37C.*~i_moving);
% f_fff_Tm9LexA = find(i_fff5s.*i_Tm9LexAGCaMP6F_L3shits_37C.*~(flyID==21).*~(flyID==11).*~i_moving.*(locnum<=35));
% f_fff_Tm9LexA = find(i_fff5s.*i_Tm9LexAGCaMP6F_L1L3shits_37C.*~i_moving.*(flyID~=57).*(locnum<=35));
% f_fff_Tm9LexA = find(i_fff5s.*i_Tm9LexAGCaMP6F_L2L3shits_37C.*~i_moving.*(locnum<=35));



% f_fff_Tm9LexA = find(i_fff2s.*i_UASGCaMP6F_L221DhhGal4.*~i_moving);
% f_fff_Tm9LexA = find(i_fff2s.*i_UASGCaMP6F_L30595Gal4.*~i_moving);

% f_fff_Tm9LexA = find(i_fff5s.*i_UASGCaMP6F_L221DhhGal4.*~i_moving.*(flyID<=114));
f_fff_Tm9LexA = find(i_fff5s.*i_UASGCaMP6F_L221DhhGal4.*~i_moving.*(flyID<=112));
% f_fff_Tm9LexA = find(i_fff5s.*i_UASGCaMP6F_L30595Gal4.*~i_moving);


%*******************



%others, mostly from before I had the bleedthrough fix for the aggregate
%fct
% % % f_fff_Tm9LexA = find(i_fff2s.*i_Tm9LexAGCaMP6F_shits_37C.*(flyID~=96).*(flyID~=45).*(flyID~=44).*~i_moving) %stim bleedthrough cleaned up , still incl. fly42
% f_fff_Tm9LexA = find(i_fff2s.*i_Tm9LexAGCaMP6F_shits_37C_TM6B.*~i_moving);
% f_fff_Tm9LexA = find(i_fff2s.*i_Tm9LexAGCaMP6F_sensGal4shits_37C.*~i_moving);
% f_fff_Tm9LexA = find(i_fff2s.*i_Tm9LexAGCaMP6F_sensGal4shits.*~i_moving);
%doubles
% f_fff_Tm9LexA = find(i_fff2s.*i_Tm9LexAGCaMP6F_L1L3shits_37C.*(flyID~=56).*(flyID~=57).*(flyID~=89).*(flyID~=93).*~i_moving.*(locnum<=35)); %stim bleedthrough cleaned up
% f_fff_Tm9LexA = find(i_fff2s.*i_Tm9LexAGCaMP6F_L2L3shits_37C.*(flyID~=74).*~i_moving); %stim bleedthrough cleaned up



% "recovering L1 + L3 flies were flyID 85, 90, 92. Plot fff before just for
% these: 
% f_fff_Tm9LexA = find( i_fff2s.*i_Tm9LexAGCaMP6F_L1L3shits_37C.*((flyID==85)|(flyID==90)|(flyID==92)).*~i_moving); %stim bleedthrough cleaned up




%checking out fff data (excluding the ones with bleadthrough), not preinc
% f_fff_Tm9LexA = find(i_fff2s.*i_Tm9LexAGCaMP6F_shits_TM6B.*(flyID==31).*~i_moving);
% f_fff_Tm9LexA = find(i_fff2s.*i_Tm9LexAGCaMP6F_shits_TM6B.*(flyID~=30).*(flyID~=37).*(flyID~=38).*(flyID~=31).*~i_moving);
% f_fff_Tm9LexA = find(i_fff2s.*i_Tm9LexAGCaMP6F_shits_TM6B.*(flyID~=30).*(flyID~=37).*(flyID~=38).*(flyID~=31).*(flyID~=35).*(flyID~=36).*(flyID~=40).*~i_moving);
% f_fff_Tm9LexA = find(i_fff2s.*i_Tm9LexAGCaMP6F_shits_TM6B.*(flyID==31).*~i_moving);

% Kir2.1 
%f_fff_Tm9LexA = find(i_fff2s.*i_Tm9LexAGCaMP6F_Kir2_1.*~i_moving);
%f_fff_Tm9LexA = find(i_fff2s.*i_Tm9LexAGCaMP6F_Kir2_1);
% f_fff_Tm9LexA = find(i_fff2s.*i_Tm9LexAGCaMP6F_L1_Kir2_1.*~i_moving);


% create structures by neuron
fTm9LexA = create_neuron_structure_all_ks(f_fff_Tm9LexA);

% load all the data!
xTm9LexA = load_neuron_data10Hz_ks(fTm9LexA,pdatapath);

% mTm9LexA = aggregate_fff_means10Hz_G6(xTm9LexA);
% mTm9LexA = aggregate_fffall_means10Hz(xTm9LexA);
% mTm9LexA = aggregate_fffall_means10Hz_BleedThruFix(xTm9LexA);
mTm9LexA = aggregate_fffall_means10Hz_BleedThruFix_v2(xTm9LexA);


% correlate with stimulus 

dur = size(mTm9LexA.rats,2);
%ms: taking code from fffvar_figures_scr to use cross correlations to
%select responding cels (normal and inverted)
durs = 2; 

cur_mat = mTm9LexA.rats;
cur_IDs = mTm9LexA.flyID;
%clean up by zeros-only datasets and NaN dataset
inds = find(sum(cur_mat,2)~=0);
cur_mat = cur_mat(inds,:);
cur_IDs = cur_IDs(inds);
inds = ~isnan(sum(cur_mat,2));%ms: added these two lines, because there were NaN in dataset
cur_mat = cur_mat(inds,:);
cur_IDs = cur_IDs(inds);
%correlation with stimulus
% mean_res = mean(cur_mat,1);
% Q = corr(mean_res',cur_mat');
Q = corr(mean(mTm9LexA.stims)',cur_mat');

mean(mTm9LexA.stims)
% inds = find(Q>0.5); %finds the cells whose response correlates well with the stimulus
inds = find(Q>0.5); %finds the cells whose response correlates well with the stimulus
cur_mat_pos = cur_mat(inds,:);
cur_IDs_pos = cur_IDs(inds);


[x_pos,m_pos,e_pos] = mean_cat_full(cur_mat_pos,1,cur_IDs_pos);
cur_t = [1:size(cur_mat_pos,2)]/10;
%calculating the max for each trace
max_pos = max(x_pos,[],2)-1;
min_pos = max(x_pos,[],2)-1;


cur_mat = mTm9LexA.rats;
cur_IDs = mTm9LexA.flyID;
inds = find(sum(cur_mat,2)~=0);
cur_mat = cur_mat(inds,:);
inds = ~isnan(sum(cur_mat,2));
cur_mat = cur_mat(inds,:);
cur_IDs = cur_IDs(inds);
% mean_res = mean(cur_mat,1);
% Q = corr(mean_res',cur_mat');
% Q = corr(mean(mTm9LexA.stims)',cur_mat');
% inds = find(Q<-0.5);
inds = find(Q<-0.87);
cur_mat_neg = cur_mat(inds,:);
cur_IDs_neg = cur_IDs(inds);


%plot mean and single flies
[x_neg,m_neg,e_neg] = mean_cat_full(cur_mat_neg,1,cur_IDs_neg);
cur_t = [1:size(cur_mat_neg,2)]/10;
max_neg = max(x_neg,[],2)-1
min_neg = min(x_neg,[],2)-1
maxmin = max_neg-min_neg

%plot both normal and inverted (by correlation with stimulus) in one plot
figure; hold on
t = [1:dur]/10;
% subplot(2,2,1); hold on;
cm=colormap('lines');
h1 = plot_err_patch_v2(cur_t,m_pos-1,e_pos,[0 0 1],[0.5 0.5 1]);
h2 = plot_err_patch_v2(cur_t,m_neg-1,e_neg,[0.75 0 0.75],[0.75 0.5 0.75]);
% plot([0 5],0.3*[1 1],'k-','linewidth',3);
% plot([10 15],0.3*[1 1],'k-','linewidth',3);
title('Tm9LexA, all "normal" and "inverted" cells');
legend([h1, h2],sprintf('Tm9LexA>>GCaMP6F, "fff pos corr", N = %d ( %d )',size(x_pos,1),size(cur_mat_pos,1)),...
    sprintf('Tm9LexA>>GCaMP6F, "fff neg corr", N = %d ( %d )',size(x_neg,1),size(cur_mat_neg,1)),...
    'location','northeast');
plot(t, (round(mean(mTm9LexA.stims))*0.1)+0.8)
ylim([-2.0 1])
line([0 5.5],[0 0],'color',[0 0 0]);



% plotting single traces
figure; hold on;
plot(cur_t,x_neg-1)
ylim([-0.6 0.6]);
line([durs durs],[-0.6 0.6],'color',[0 0 0],'linestyle','--');
line([0 durs+2],[0 0],'color',[0 0 0]);
set(gcf,'Color','w');
niceaxes;

% % negatively and positively correlated in one 8s  plot, ms
% 
% dur = size(mTm9LexA.rats,2);
% % durs = 2;
% 
% % ms: positive correlation with input
% cur_mat = mTm9LexA.rats; % loading data
% cur_IDs = mTm9LexA.flyID; % flyIDs
% %cleaning up the data (not all zeros, not nan)
% inds = find(sum(cur_mat,2)~=0); 
% cur_mat = cur_mat(inds,:);
% inds = ~isnan(sum(cur_mat,2));%ms: added these two lines, because there were NaN in dataset
% 
% cur_mat = cur_mat(inds,:);
% cur_IDs = cur_IDs(inds);
% mean_res = mean(cur_mat,1);%mean >> replace this with the stimulus
% Q = corr(mean_res',cur_mat');
% 
% pos_inds = find(Q>0.3); 
% cur_mat_pos = cur_mat(pos_inds,:);
% cur_IDs_pos = cur_IDs(pos_inds);
% 
% neg_inds = find(Q<-0.3);
% cur_mat_neg = cur_mat(neg_inds,:);
% cur_IDs_neg = cur_IDs(neg_inds);
% 
% 
% 
% %Plotting Tm9LexA, 'Q > 0.5 - mean by fly' and 'Q < -0.5 - mean by fly'
% [x_pos,m_pos,e_pos] = mean_cat_full(cur_mat_pos,1,cur_IDs_pos); %x = mean per fly, m = mean across flies, e = sem for mean across flies
% [x_neg,m_neg,e_neg] = mean_cat_full(cur_mat_neg,1,cur_IDs_neg);
% 
% t = [1:dur]/10;
% 
% figure; hold on;
% cm=colormap('lines');
% h1 = plot_err_patch_v2(t,m_pos-1,...
%     e_pos,[0 0 1],[0.5 0.5 1]);
% h2 = plot_err_patch_v2(t,m_neg-1,...
%     e_neg,[0.75 0 0.75],[0.75 0.5 0.75]);
% 
% plot([2 4],0.4*[1 1],'k-','linewidth',3);
% plot([6 8],0.4*[1 1],'k-','linewidth',3);
% title('Tm9LexA, pos and neg corr with mean');
% legend([h1 h2],sprintf('Tm9LexA>>GCaMP6F, Q >0.5 - mean by fly, N = %d ( %d )',size(x_pos,1),size(cur_mat_pos,1)),...
%     sprintf('Tm9LexA>>GCaMP6F, Q <0.5 - mean by fly, N = %d ( %d )',size(x_neg,1),size(cur_mat_neg,1)),...
%     'location','northeast');
% xlabel('time (sec)');ylabel('response (dR/R)');
% ylim([-0.6 0.8]);
% line([0 dur/10],[0 0],'color',[0 0 0]);
% set(gca,'xTick',0:1:8);
% set(gcf,'Color','w');
% niceaxes;
% 
% %single fly traces for positively correlated
% figure;
% hold on
% plot(t ,x_pos-1);title('Q > 0.5 - all fly means');
% ylim([-0.6 0.8]);
% % line([durs durs],[-0.6 0.6],'color',[0 0 0],'linestyle','--');
% line([0 dur/10],[0 0],'color',[0 0 0]);
% plot([2 4],0.6*[1 1],'k-','linewidth',3);
% % plot([6 8],0.6*[1 1],'k-','linewidth',3);
% set(gcf,'Color','w');
% niceaxes;
% 
% 
% %single fly traces for negatively correlated
% figure;
% hold on
% plot(t,x_neg-1);title('Q < -0.5 - all fly means');
% ylim([-0.6 0.8]);
% % line([durs durs],[-0.6 0.6],'color',[0 0 0],'linestyle','--');
% line([0 dur/10],[0 0],'color',[0 0 0]);
% plot([2 4],0.6*[1 1],'k-','linewidth',3);
% % plot([6 8],0.6*[1 1],'k-','linewidth',3);
% set(gcf,'Color','w');
% niceaxes;
% 
%%  use correlation with the stimulus trace to find normal and inverted
% I THINK THIS IS OLD AND I CAN JUST DELETE THAT
dur = size(mTm9LexA.rats,2);

% ms: positive correlation with input
cur_mat = mTm9LexA.rats; % loading data
cur_IDs = mTm9LexA.flyID; % flyIDs
%cleaning up the data (not all zeros, not nan)
inds = find(sum(cur_mat,2)~=0); 
cur_mat = cur_mat(inds,:);
cur_IDs = cur_IDs(inds);
inds = ~isnan(sum(cur_mat,2));
cur_mat = cur_mat(inds,:);
cur_IDs = cur_IDs(inds);

% mean_res = mean(cur_mat,1);%mean >> replace this with the stimulus
mean_stim = round(mean(mTm9LexA.stims));
%..
Q = corr(mean_stim',cur_mat');

pos_inds = find(Q>0.3); 
cur_mat_pos = cur_mat(pos_inds,:);
cur_IDs_pos = cur_IDs(pos_inds);

neg_inds = find(Q<0.3);
cur_mat_neg = cur_mat(neg_inds,:);
cur_IDs_neg = cur_IDs(neg_inds);



%Plotting Tm9LexA, 'Q > 0.5 - mean by fly' and 'Q < -0.5 - mean by fly'
[x_pos,m_pos,e_pos] = mean_cat_full(cur_mat_pos,1,cur_IDs_pos); %x = mean per fly, m = mean across flies, e = sem for mean across flies
[x_neg,m_neg,e_neg] = mean_cat_full(cur_mat_neg,1,cur_IDs_neg);

t = [1:dur]/10;

figure; hold on;
cm=colormap('lines');
h1 = plot_err_patch_v2(t,m_pos-1,...
    e_pos,[0 0 1],[0.5 0.5 1]);
h2 = plot_err_patch_v2(t,m_neg-1,...
    e_neg,[0.75 0 0.75],[0.75 0.5 0.75]);

plot([2 4],0.4*[1 1],'k-','linewidth',3);
plot([6 8],0.4*[1 1],'k-','linewidth',3);
title('Tm9LexA, pos and neg corr with mean');
legend([h1 h2],sprintf('Tm9LexA>>GCaMP6F, Q >0.5 - mean by fly, N = %d ( %d )',size(x_pos,1),size(cur_mat_pos,1)),...
    sprintf('Tm9LexA>>GCaMP6F, Q <0.5 - mean by fly, N = %d ( %d )',size(x_neg,1),size(cur_mat_neg,1)),...
    'location','northeast');
xlabel('time (sec)');ylabel('response (dR/R)');
ylim([-0.6 0.8]);
line([0 dur/10],[0 0],'color',[0 0 0]);
set(gca,'xTick',0:1:8);
set(gcf,'Color','w');
niceaxes;

%single fly traces for positively correlated
figure;
hold on
plot(t ,x_pos-1);title('Q > 0.5 - all fly means');
ylim([-0.6 0.8]);
% line([durs durs],[-0.6 0.6],'color',[0 0 0],'linestyle','--');
line([0 dur/10],[0 0],'color',[0 0 0]);
plot([2 4],0.6*[1 1],'k-','linewidth',3);
% plot([6 8],0.6*[1 1],'k-','linewidth',3);
set(gcf,'Color','w');
niceaxes;


%single fly traces for negatively correlated
figure;
hold on
plot(t,x_neg-1);title('Q < -0.5 - all fly means');
ylim([-0.6 0.8]);
% line([durs durs],[-0.6 0.6],'color',[0 0 0],'linestyle','--');
line([0 dur/10],[0 0],'color',[0 0 0]);
plot([2 4],0.6*[1 1],'k-','linewidth',3);
% plot([6 8],0.6*[1 1],'k-','linewidth',3);
set(gcf,'Color','w');
niceaxes;



