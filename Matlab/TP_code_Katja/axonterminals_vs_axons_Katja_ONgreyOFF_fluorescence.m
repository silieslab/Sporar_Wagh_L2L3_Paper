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
    GENOTYPE_STRING = ['L2 >> GCaMP6f, region: ' REGION];
    if(strcmp(REGION,'AT'))
        COLOR_OF_PLOT = [0 .5 0];% GREEN
        COLOR_CLOUD =[.5 .7 .5];% GREEN
    elseif(strcmp(REGION,'AX'))
        COLOR_OF_PLOT = [1 0 0]; %RED
        COLOR_CLOUD = [1 .5 .5]; %RED cloud
    elseif(strcmp(REGION,'CB'))
        COLOR_OF_PLOT = [.7 .7 0];% YELLOW
        COLOR_CLOUD = [.9 .9 .5];%YELLOW cloud
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

% ONgrayOFFgray L3
% f_fff_Tm9LexA  = find(i_fff2sONgrayOFF.*i_UASGCaMP6F_L3MH56Gal4.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff5sONgrayOFF.*i_UASGCaMP6F_L3MH56Gal4.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff25msecONgrayOFF.*i_UASGCaMP6F_L3MH56Gal4.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff_steps_2sONgrayOFF.*i_UASGCaMP6F_L3MH56Gal4);

% ONgrayOFFgray L2
% f_fff_Tm9LexA  = find(i_fff2sONgrayOFF.*i_UASGCaMP6F_L221DhhGal4.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff5sONgrayOFF.*i_UASGCaMP6F_L221DhhGal4.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff25msecONgrayOFF.*i_UASGCaMP6F_L221DhhGal4.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff_steps_2sONgrayOFF.*i_UASGCaMP6F_L221DhhGal4.*(flyID==198));
% f_fff_Tm9LexA  = find(i_fff_steps_2sONgrayOFF.*i_UASGCaMP6F_L221DhhGal4);



% ONgrayOFFgray L3
% f_fff_Tm9LexA  = find(i_fff2sONgrayOFF4sBG.*i_UASGCaMP6F_L3MH56Gal4.*~i_moving.*(flyID==167));
% f_fff_Tm9LexA  = find(i_fff_01steps_2sONgrayOFF.*i_UASGCaMP6F_L3MH56Gal4.*(flyID==226));
% f_fff_Tm9LexA  = find(i_fff_01steps_2sONgrayOFF.*i_UASGCaMP6F_L3MH56Gal4.*(flyID>=224));
% f_fff_Tm9LexA  = find(i_fff_01steps_2sONgrayOFF.*i_UASGCaMP6F_L3MH56Gal4.*(flyID>=216)); % it breaks at flyID 216
f_fff_Tm9LexA  = find(i_fff_01steps_2sONgrayOFF.*i_UASGCaMP6F_L3MH56Gal4.*(flyID~=216));



% ONgrayOFFgray L2
% f_fff_Tm9LexA  = find(i_fff2sONgrayOFF4sBG.*i_UASGCaMP6F_L3MH56Gal4.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff_01steps_2sONgrayOFF.*i_UASGCaMP6F_L221DhhGal4.*~i_moving);


%Cbp53E
% f_fff_Tm9LexA  = find(i_fff_01steps_2sONgrayOFF.*i_Cbp53E_L221DhhGal4.*~i_moving.*((flyID==244)|(flyID==245)));


% PTX experiment L3
% f_fff_Tm9LexA  = find(i_fff2s.*i_UASGCaMP6F_L3MH56Gal4.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6F_L3MH56Gal4.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6F_L3MH56Gal4.*~i_moving.*(flyID>=157));
% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6F_L3MH56Gal4_PTX.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff2s.*i_UASGCaMP6F_L3MH56Gal4.*~i_moving.*(flyID>=157));
% f_fff_Tm9LexA  = find(i_fff2s.*i_UASGCaMP6F_L3MH56Gal4_PTX.*~i_moving);

% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6F_L3MH56Gal4.*~i_moving.*((flyID==167)|(flyID==168)));
% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6F_L3MH56Gal4_PTX.*~i_moving.*((flyID==167)|(flyID==168)));
% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6F_L3MH56Gal4_PTX.*~i_moving.*(flyID==167));

% PTX experiment L2
% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6F_L221DhhGal4.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff2s.*i_UASGCaMP6F_L221DhhGal4.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff60s.*i_UASGCaMP6F_L221DhhGal4.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6F_L221DhhGal4.*~i_moving.*(flyID>=157));
% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6F_L221DhhGal4_PTX.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff2s.*i_UASGCaMP6F_L221DhhGal4.*~i_moving.*(flyID>=157));
% f_fff_Tm9LexA  = find(i_fff2s.*i_UASGCaMP6F_L221DhhGal4_PTX.*~i_moving);

% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6F_L221DhhGal4.*~i_moving.*(flyID==165));
% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6F_L221DhhGal4_PTX.*~i_moving.*(flyID==165));
% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6F_L221DhhGal4.*~i_moving.*((flyID==165)|(flyID==166)));
% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6F_L221DhhGal4_PTX.*~i_moving.*((flyID==165)|(flyID==166)));
% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6F_L221DhhGal4.*~i_moving.*(flyID==166));
% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6F_L221DhhGal4_PTX.*~i_moving.*(flyID==166));
% % % % % % % % 
% % % % % % % % 
% create structures by neuron
fTm9LexA = create_neuron_structure_all_ks(f_fff_Tm9LexA);

if (ANALYZE_BY_REGION)
    xTm9LexA = load_neuron_data10Hz_byRegion(fTm9LexA,pdatapath, REGION);
else
    % interpolates at 10 Hz now...
    xTm9LexA = load_neuron_data10Hz_ks(fTm9LexA,pdatapath);
end

% mTm9LexA = aggregate_fffall_means10Hz_BleedThruFix(xTm9LexA);
% mTm9LexA = aggregate_fffall_means10Hz_BleedThruFix_ONgreyOFF_old(xTm9LexA);
mTm9LexA = aggregate_standingStripe_fluorescence(xTm9LexA);


% % % % % % % %ONLY for 25msec:
% % % % % % % fTm9LexA = create_neuron_structure_all_ks(f_fff_Tm9LexA);
% % % % % % % xTm9LexA = load_neuron_data40Hz_ks(fTm9LexA,pdatapath);
% % % % % % % mTm9LexA = aggregate_fff300ms_means10Hz_BleedThruFix(xTm9LexA);
% % % % % % % dur = size(mTm9LexA.rats,2);
% % % % % % % durs=1.75;



%%
% correlate with stimulus to select normal and inverted ROIs
iRATE = 10; %rate at which data are interpolated
dur = size(mTm9LexA.rats,3);


% start with all the data, keep the ones that are positively correlated
% with stimulus (by value Q)
cur_mat = mTm9LexA.rats;
cur_IDs = mTm9LexA.flyID;
% mean_res = mean(cur_mat,1); %was correlating with the mean before
% Q = corr(mean_res',cur_mat');

cur_t = [1:size(cur_mat,3)]/iRATE;

counter = 0; % starting counter value!
%try quick plot for each epoch
% for ii = 1:11
for ii = [2 3 4 5 6 1 7 8 9 10 11] %In steps from OFFgrey to ONgrey
    epochRats = squeeze(cur_mat(:,ii,:));
    [x,m,e] = mean_cat_full(epochRats,1,cur_IDs); %m=mean; e=std
    
    counter = counter + 1;
    
    if (ii == 1) % 0% grey
    stimulus = zeros(dur,1);
    stimulus(1:dur/3) = 0 
    stimulus(dur/3+1: end) = 0
    elseif (ii == 2) % -100% OFFgrey
    stimulus = zeros(dur,1);
    stimulus(1:dur/3) = -1
    stimulus(dur/3+1: end) = 0
    elseif (ii == 3) % -80% OFFgrey
    stimulus = zeros(dur,1);
    stimulus(1:dur/3) = -1
    stimulus(dur/3+1: end) = 0
    elseif (ii == 4) % -60% ONgrey
    stimulus = zeros(dur,1);
    stimulus(1:dur/3) = -1
    stimulus(dur/3+1: end) = 0
    elseif (ii == 5) % -40% OFFgrey
    stimulus = zeros(dur,1);
    stimulus(1:dur/3) = -1
    stimulus(dur/3+1: end) = 0
    elseif (ii == 6) % -20% OFFgrey
    stimulus = zeros(dur,1);
    stimulus(1:dur/3) = -1
    stimulus(dur/3+1: end) = 0
    elseif (ii == 7) % 20% ONgrey
    stimulus = zeros(dur,1);
    stimulus(1:dur/3) = 1
    stimulus(dur/3+1: end) = 0
    elseif (ii == 8) % 40% ONgrey
    stimulus = zeros(dur,1);
    stimulus(1:dur/3) = 1
    stimulus(dur/3+1: end) = 0
    elseif (ii == 9) % 60% ONgrey
    stimulus = zeros(dur,1);
    stimulus(1:dur/3) = 1
    stimulus(dur/3+1: end) = 0       
    elseif (ii == 10) % 80% ONgrey
    stimulus = zeros(dur,1);
    stimulus(1:dur/3) = 1
    stimulus(dur/3+1: end) = 0
    elseif (ii == 11) % 100% ONgrey
    stimulus = zeros(dur,1);
    stimulus(1:dur/3) = 1
    stimulus(dur/3+1: end) = 0
    end
    
    %positive correlation with stimulus    
    Q = corr(stimulus,epochRats')
    inds = find(Q>0.1);
    cur_mat_pos = epochRats(inds,:)
    cur_IDs_pos = cur_IDs(inds)
    %calculating means across flies
    [x_pos,m_pos,e_pos] = mean_cat_full(cur_mat_pos,1,cur_IDs_pos);
    %calculating the max for each trace
    max_pos = max(x_pos,[],2)-1;


    %negative correlation with stimulus
    Q = corr(stimulus,epochRats')
    inds = find(Q<-0.1);
    size(inds)
    cur_mat_neg = epochRats(inds,:)
    cur_IDs_neg = cur_IDs(inds)
    %calculating means across flies
    [x_neg,m_neg,e_neg] = mean_cat_full(cur_mat_neg,1,cur_IDs_neg);
    max_neg = max(x_neg,[],2)-1;

    
    figure(ii); hold on
    cm=colormap('lines');
    h1 = plot_err_patch_v2(cur_t,m,e,[0 0 1],[0.5 0.5 1]);
% % %     title('some genotype, all cells');
    if (ii==1)
        title('0% grey')
%         max(mean_cat_full(cur_mat_neg,1,cur_IDs_neg))
    elseif (ii==2)
        title('-100% OFFgrey')
    elseif (ii==3)
        title('-80% OFFgrey')
    elseif(ii==4)
        title('-60% OFFgrey')
    elseif(ii==5)
        title('-40% OFFgrey')
    elseif(ii==6)
        title('-20% OFFgrey') 
    elseif(ii==7)
        title('20% ONgrey')
    elseif(ii==8)
        title('40% ONgrey')
    elseif(ii==9)
        title('60% ONgrey')
    elseif(ii==10)
        title('80% ONgrey')
    elseif(ii==11)
        title('100% ONgrey') 
    end
    
    if (ii==1)
    peak_max(counter) = max(m(20:30));
    elseif (ii==2)
    peak_max(counter) = max(m(1:20));
    elseif (ii==3)
    peak_max(counter) = max(m(1:20));
    elseif (ii==4)
    peak_max(counter) = max(m(1:20));
    elseif (ii==5)
    peak_max(counter) = max(m(1:20));
    elseif (ii==6)
    peak_max(counter) = max(m(1:20));
    elseif (ii==7)
    peak_max(counter) = min(m(1:20));
    elseif (ii==8)
    peak_max(counter) = min(m(1:20));
    elseif (ii==9)
    peak_max(counter) = min(m(1:20));
    elseif (ii==10)
    peak_max(counter) = min(m(1:20));
    elseif (ii==11)
    peak_max(counter) = min(m(1:20));
    end
    
% peak_max(counter) = max(m)
% % peak_max(counter) = max(m(0:2)); %want to find max in the first 2s
    
    legend([h1],sprintf('N = %d ( %d )',size(x,1),size(epochRats,1)),...
        'location','northeast');
%     plot(t, (round(mean(mTm9LexA.stims))*0.1)+0.8)
    ylim([-0.8 2.4]);
    line([0 5.5],[0 0],'color',[0 0 0]);

end


contrast = [-100 -80 -60 -40 -20 0 20 40 60 80 100]

figure
plot(contrast, peak_max,'k','Linewidth',4)
box off
ylim([-0.5 2.5]);

%% Marion playing with this function. 
% I added the stimulus structure as the output of the aggregate function,
% use this to now
% correlate with stimulus to select normal and inverted ROIs
iRATE = 10; %rate at which data are interpolated
dur = size(mTm9LexA.rats,3);

% start with all the data, keep the ones that are positively correlated
% with stimulus (by value Q)
cur_mat = mTm9LexA.rats;
cur_IDs = mTm9LexA.flyID;
% mean_res = mean(cur_mat,1); %was correlating with the mean before
% Q = corr(mean_res',cur_mat');

cur_t = [1:size(cur_mat,3)]/iRATE;

counter = 0; % starting counter value!

% for ii = [2 3 4 5 6 1 7 8 9 10 11] %In steps from OFFgrey to ONgrey
for ii = 1:10 %didn't have a real grey-grey transition, where did 11 epochs come from?
    epochRats = squeeze(cur_mat(:,ii,:));
    [x,m,e] = mean_cat_full(epochRats,1,cur_IDs); %m=mean; e=std
    
    counter = counter + 1;
    
    if ismember(ii,1:5) %negative contrasts
    stimulus = mTm9LexA.stimstruct;
    elseif ismember(ii,6:10) %positive contrasts
    stimulus = mTm9LexA.stimstruct.*(-1);
    end
    
    %positive correlation with stimulus    
    Q = corr(stimulus,epochRats')
    inds = find(Q>0.1);
    cur_mat_pos = epochRats(inds,:)
    cur_IDs_pos = cur_IDs(inds)
    %calculating means across flies
    [x_pos,m_pos,e_pos] = mean_cat_full(cur_mat_pos,1,cur_IDs_pos);
    %calculating the max for each trace
    max_pos = max(x_pos,[],2)-1;


    %negative correlation with stimulus
    Q = corr(stimulus,epochRats')
    inds = find(Q<-0.1);
    size(inds)
    cur_mat_neg = epochRats(inds,:)
    cur_IDs_neg = cur_IDs(inds)
    %calculating means across flies
    [x_neg,m_neg,e_neg] = mean_cat_full(cur_mat_neg,1,cur_IDs_neg);
    max_neg = max(x_neg,[],2)-1;

    
    figure(ii); hold on
    cm=colormap('lines');
    h1 = plot_err_patch_v2(cur_t,m,e,[0 0 1],[0.5 0.5 1]);
% % %     title('some genotype, all cells');
    if (ii==1)
        title('-100% OFFgrey')
    elseif (ii==2)
        title('-80% OFFgrey')
    elseif(ii==3)
        title('-60% OFFgrey')
    elseif(ii==4)
        title('-40% OFFgrey')
    elseif(ii==5)
        title('-20% OFFgrey') 
    elseif(ii==6)
        title('20% ONgrey')
    elseif(ii==7)
        title('40% ONgrey')
    elseif(ii==8)
        title('60% ONgrey')
    elseif(ii==9)
        title('80% ONgrey')
    elseif(ii==10)
        title('100% ONgrey') 
    end
    
    if ismember(ii,1:5) %the same if you would write esleif
%     peak_max(counter) = max(m);
    peak_max(counter) = max(m(20:100)); %for -40% it finds max in the first 1s
    elseif ismember(ii,6:10)
    peak_max(counter) = min(m);
    peak_ONtoGrey(counter) = max(m(40:70));
    end
%the same as above (if ismember(ii,1:5) is the same as  if ii == 1:5)
% % % %     if ii == 1:5
% % % %     peak_max(counter) = max(m(20:100)); %for -40% it finds max in the first 1s
% % % %     elseif ii == 6:10
% % % %     peak_max(counter) = min(m);
% % % % %     peak_ONtoGrey(counter) = max(m(40:70));
% % % %     end
% % % %     
    legend([h1],sprintf('N = %d ( %d )',size(x,1),size(epochRats,1)),...
        'location','northeast');
    plot(cur_t, mTm9LexA.stimstruct*0.01+0.03, 'k')
    ylim([-0.1 0.1]);
    line([0 2.5],[0 0],'color',[0 0 0]);

end

%to do: replace the wanted contrast values with the measured ones:
contrast = [-100 -80 -60 -40 -20 20 40 60 80 100]

figure
plot(contrast, peak_max,'k','Linewidth',4)
box off
ylim([-0.3 0.3]);

% % % % ON to grey response
% % % figure
% % % plot(contrast, peak_ONtoGrey,'k','Linewidth',4)
% % % box off
% % % ylim([-0.5 2.5]);



%%
% ON to grey responses
iRATE = 10; %rate at which data are interpolated
dur = size(mTm9LexA.rats,3);

% start with all the data, keep the ones that are positively correlated
% with stimulus (by value Q)
cur_mat = mTm9LexA.rats;
cur_IDs = mTm9LexA.flyID;
% mean_res = mean(cur_mat,1); %was correlating with the mean before
% Q = corr(mean_res',cur_mat');

cur_t = [1:size(cur_mat,3)]/iRATE;

counter = 0; % starting counter value!

for ii = 1:10 
    epochRats = squeeze(cur_mat(:,ii,:));
    [x,m,e] = mean_cat_full(epochRats,1,cur_IDs); %m=mean; e=std
    
    counter = counter + 1;
    
    if ismember(ii,1:5)
    peak_max(counter) = min(m(60:100));
    elseif ismember(ii,6:10)
    peak_max(counter) = max(m(60:80));
    end

end

%to do: replace the wanted contrast values with the measured ones:
contrast = [-100 -80 -60 -40 -20 20 40 60 80 100]

% ON to grey response
figure
plot(contrast, peak_max,'k','Linewidth',4)
box off
ylim([-0.5 2.5]);





%%
% % % % % % % % if ii == 
% % % % % % % % %ONgrey
% % % % % % % % stimulus = zeros(dur,1);
% % % % % % % % stimulus(1:dur/3) = 1
% % % % % % % % stimulus(dur/3+1: end) = 0
% % % % % % % % elseif ii == 
% % % % % % % % %OFFgrey
% % % % % % % % stimulus = zeros(dur,1);
% % % % % % % % stimulus(1:dur/3) = -1
% % % % % % % % stimulus(dur/3+1: end) = 0
% % % % % % % % end
% % % % % % % % Q = corr(stimulus',epochRats')
% % % % % % % % cur_mat_pos = epochRats(inds,:)
% % % % % % % % cur_IDs_pos = cur_IDs(inds)


%positive correlation with stimulus

%create stimulus values for one epoch
epochlengths = find(diff(mean(mTm9LexA.stims)));
realEpochlength = max(diff(epochlengths));
oneFullEpoch = zeros(2*realEpochlength,1);
oneFullEpoch(1:realEpochlength/2) = 0;
oneFullEpoch(realEpochlength/2+1 : realEpochlength) = 0.5;
oneFullEpoch(realEpochlength+1 : 1.5*realEpochlength) = 1;
oneFullEpoch(1.5*realEpochlength+1:end) = 0.5;
%  expand for full length of stimulus
stimlength = length(mean(mTm9LexA.stims));
fullStimulus = repmat(oneFullEpoch,100,1); %create somthing that' too big
fullStimulus = fullStimulus(1:stimlength); %cut down to real size


%positive correlation with stimulus
Q = corr(fullStimulus,cur_mat')
% Q = corr(mean(mTm9LexA.stims)',cur_mat');
inds = find(Q>0.1); %finds the cells whose response correlates well with
% the stimulus 
cur_mat_pos = cur_mat(inds,:);
cur_IDs_pos = cur_IDs(inds);
%calculating means across flies
[x_pos,m_pos,e_pos] = mean_cat_full(cur_mat_pos,1,cur_IDs_pos);
%calculating the max for each trace
max_pos = max(x_pos,[],2)-1;




%negative correlation with stimulus
Q = corr(fullStimulus,cur_mat')
% Q = corr(mean(mTm9LexA.stims)',cur_mat');
inds = find(Q<-0.1);
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
h1 = plot_err_patch_v2(cur_t,m_pos-1,e_pos,[0 0 1],[0.5 0.5 1]);
h2 = plot_err_patch_v2(cur_t,m_neg-1,e_neg,[0.75 0 0.75],[0.75 0.5 0.75]);
% plot([0 5],0.3*[1 1],'k-','linewidth',3);
% plot([10 15],0.3*[1 1],'k-','linewidth',3);
title('Tm9LexA, all "normal" and "inverted" cells');
legend([h1, h2],sprintf('Tm9LexA>>GCaMP6F, "fff pos corr", N = %d ( %d )',size(x_pos,1),size(cur_mat_pos,1)),...
    sprintf('Tm9LexA>>GCaMP6F, "fff neg corr", N = %d ( %d )',size(x_neg,1),size(cur_mat_neg,1)),...
    'location','northeast');
plot(t, (round(mean(mTm9LexA.stims))*0.1)+0.8)
ylim([-0.8 2.4]);
line([0 5.5],[0 0],'color',[0 0 0]);

% plot negatively correlated cells, mean across flies
figure; hold on
% subplot(2,2,1); hold on;
cm=colormap('lines');
h2 = plot_err_patch_v2(cur_t,m_neg-1,e_neg,[0.75 0 0.75],[0.75 0.5 0.75]);
% h2 = plot_err_patch_v2(cur_t,m_neg-1,e_neg,[0 0.5 0],[0 0.80 0]); %green
% h2 = plot_err_patch_v2(cur_t,m_neg-1,e_neg,[1 0.4 0],[1 0.7 0]); %orange
% h2 = plot_err_patch_v2(cur_t,m_neg-1,e_neg,[0.5 0.4 1],[0.5 0.7 1]); %blue
title('L3 UASGCaMP6f');
legend([h2],sprintf('L3>>GCaMP6F, N = %d ( %d )',size(x_neg,1),size(cur_mat_neg,1)),...
    'location','northeast');
plot(cur_t, (round(mean(mTm9LexA.stims))*0.1)+0.6)
ylim([-0.7 2.2]);
% line([0 10],[0 0],'color',[0 0 0]); %for 5 s
line([0 4],[0 0],'color',[0 0 0]); %for 2 s


%plot negatively correlated cells, mean across ROIs
mROI_neg = mean(cur_mat_neg);
eROI_neg = std(cur_mat_neg,[],1)/sqrt(size(cur_mat_neg,1)); %S.E.M

figure; hold on
% subplot(2,2,1); hold on;
cm=colormap('lines');
h2 = plot_err_patch_v2(cur_t,mROI_neg-1,eROI_neg,[0 0.5 0],[0 0.80 0]);
% h2 = plot_err_patch_v2(cur_t,mROI_neg-1,eROI_neg,[0.75 0 0.75],[0.75 0.5 0.75]);
title('L3 UASGCaMP6f');
legend([h2],sprintf('L3>>GCaMP6F, N = %d ( %d )',size(x_neg,1),size(cur_mat_neg,1)),...
    'location','northeast');
plot(cur_t, (round(mean(mTm9LexA.stims))*0.1)+0.6)
ylim([-0.7 1.5]);
% line([0 10],[0 0],'color',[0 0 0]); %for 5 s
line([0 4],[0 0],'color',[0 0 0]); %for 2 s


