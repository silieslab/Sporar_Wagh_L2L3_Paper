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
%     GENOTYPE_STRING = ['L2 >> GCaMP6f, region: ' REGION];
        GENOTYPE_STRING = ['lexAopGCaMP6fp10attp5 16HO3lexA,lexAopmyrtdTom 11-164Gal4 ermHA, region: ' REGION];
%     GENOTYPE_STRING = ['lexAopGCaMP6fp10attp5 16HO3lexA,lexAopmyrtdTom 11-164Gal4, region: ' REGION];
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
% f_fff_Tm9LexA  = find(i_fff_01steps_2sONgrayOFF.*i_UASGCaMP6F_L3MH56Gal4.*(flyID~=216)); % it breaks at flyID 216

% ONgrayOFFgray L2
% f_fff_Tm9LexA  = find(i_fff_01steps_2sONgrayOFF.*i_UASGCaMP6F_L221DhhGal4.*~i_moving); %2s ON/OFF, 4s BG


%Cbp53E
% f_fff_Tm9LexA  = find(i_fff_01steps_2sONgrayOFF.*i_Cbp53E_L221DhhGal4.*~i_moving.*((flyID==244)|(flyID==245)));

%real ort rescue
% f_fff_Tm9LexA = find(i_fff_01steps_2sONgrayOFF.*i_UASort_UASGCaMP6f_L221DhhGal4_ort1_DfBSC809.*~i_moving); %doesn't work???
% f_fff_Tm9LexA = find(i_fff_01steps_2sONgrayOFF.*i_UASort_UASGCaMP6f_L30595Gal4_ort1_DfBSC809.*~i_moving);

%Matthew Pecot
f_fff_Tm9LexA = find(i_fff_01steps_2sONgrayOFF.*i_lexAopGCaMP6fp10attp5_16HO3lexA_lexAopmyrtdTOM_11164Gal4_plus.*~i_moving.*(flyID~=318)); %318 had weird responses
% f_fff_Tm9LexA = find(i_fff_01steps_2sONgrayOFF.*i_lexAopGCaMP6fp10attp5_16HO3lexA_lexAopmyrtdTOM_11164Gal4ermHA.*~i_moving);




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
mTm9LexA = aggregate_standingStripe_ms(xTm9LexA);


% % % % % % % %ONLY for 25msec:
% % % % % % % fTm9LexA = create_neuron_structure_all_ks(f_fff_Tm9LexA);
% % % % % % % xTm9LexA = load_neuron_data40Hz_ks(fTm9LexA,pdatapath);
% % % % % % % mTm9LexA = aggregate_fff300ms_means10Hz_BleedThruFix(xTm9LexA);
% % % % % % % dur = size(mTm9LexA.rats,2);
% % % % % % % durs=1.75;

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
    subplot(2,1,1); 
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

    legend([h1],sprintf('N = %d ( %d )',size(x,1),size(epochRats,1)),...
        'location','northeast');
    plot(cur_t, mTm9LexA.stimstruct*0.1+2.25, 'k')
    ylim([-0.8 2.4]);
    line([0 5.5],[0 0],'color',[0 0 0]);

    %Katja: plot individual fly means
    subplot(2,1,2);
    plot(cur_t,x)
    title('individual fly means');
    ylim([-0.8 2.0]);
    set(gcf,'Color','w');
    niceaxes;
end

%to do: replace the wanted contrast values with the measured ones:
contrast = [-100 -80 -60 -40 -20 20 40 60 80 100]

figure
plot(contrast, peak_max,'k','Linewidth',4)
box off
ylim([-0.5 2.5]);



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


%% comparing responses to grey-OFF / ON-grey steps

counter = 0; % starting counter value!

for ii = 1:10
    epochRats = squeeze(cur_mat(:,ii,:));
    [x,m,e] = mean_cat_full(epochRats,1,cur_IDs); %m=mean; e=std
    
    counter = counter + 1;
    
    if ismember(ii,1:5) %negative contrasts
    stimulus = mTm9LexA.stimstruct;
    elseif ismember(ii,6:10) %positive contrasts
    stimulus = mTm9LexA.stimstruct.*(-1);
    end
    
    if (ii==1)
        title('-100% OFFgrey')
        stepOFF100 = max(m(20:100))
    elseif (ii==2)
        title('-80% OFFgrey')
        stepOFF80 = max(m(20:100))
    elseif(ii==3)
        title('-60% OFFgrey')
        stepOFF60 = max(m(20:100))
    elseif(ii==4)
        title('-40% OFFgrey')
        stepOFF40 = max(m(20:100))
    elseif(ii==5)
        title('-20% OFFgrey')
        stepOFF20 = max(m(20:100))
    elseif(ii==6)
        title('20% ONgrey')
        stepON20 = max(m(60:70))-m(59) %because the response from ON to grey strats below 0
    elseif(ii==7)
        title('40% ONgrey')
        stepON40 = max(m(60:70))-m(59)
    elseif(ii==8)
        title('60% ONgrey')
        stepON60 = max(m(60:70))-m(59)
    elseif(ii==9)
        title('80% ONgrey')
        stepON80 = max(m(60:70))-m(59)
    elseif(ii==10)
        title('100% ONgrey')
        stepON100 = max(m(60:70))-m(59)
    end
    
    if ismember(ii,1:5) 
    peak_max(counter) = max(m(20:100)); %for -40% it finds max in the first 1s
    elseif ismember(ii,6:10)
    peak_max(counter) = min(m);
    peak_ONtoGrey(counter) = max(m(40:70));
    end

    
end



figure; hold on
b = bar(1:2, [stepOFF100, stepON100])
set(b,'FaceColor',[1 1 .5])
hold on
b = bar([3:4], [stepOFF80, stepON80])
set(b,'FaceColor',[1 .5 .5])
hold on
b = bar([5:6], [stepOFF60, stepON60])
set(b,'FaceColor',[.5 1 .5])
hold on
b = bar([7:8], [stepOFF40, stepON40])
set(b,'FaceColor',[.5 .5 1])
hold on
b = bar([9:10], [stepOFF20, stepON20])
set(b,'FaceColor',[.5 0 .5])
name = {'stepOFF100', 'stepON100','stepOFF80', 'stepON80','stepOFF60', 'stepON60','stepOFF40', 'stepON40','stepOFF20', 'stepON20'}
% name = {'step100', 'step80','step60', 'step40','step20'}
set(gca,'XTickLabel', name);



figure; hold on
grey_to_OFF = ([stepOFF100, stepOFF80, stepOFF60, stepOFF40, stepOFF20])
ON_to_grey = ([stepON100, stepON80, stepON60, stepON40, stepON20])
plot([grey_to_OFF], [ON_to_grey],'k','Linewidth',4)
title('Grey to OFF vs ON to grey ')
xlim([0 2]);
ylim([0 2]);
xlabel('grey to OFF')
ylabel('ON to grey')
box off

