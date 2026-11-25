%% Analysis_05StepsON_OFF_marvin_step_response.m
% This script analyses Data from the Stimulus "LocalCircle_0.5steps_10s_randSteps_120deg_0degAz_0degEl_2Lum".
% It has 5 Epochs which vary in luminance (100% ON, 50% ON, grey, 50%OFF,100%OFF). 
% These Epochs are displayed one for 10 seconds, then switched randomly to 
% any other Epoch. Contrast difference between a (100 ON - 50 ON) and a 
% (grey - 50 OFF) switch might be the same and this is the question which 
% shall be examined here. Epochs are displayed randomly.
%
%
% Fabiola 8/2016
%
% The epochs are distributed as:
% 
% 0 : 100% OFF
% 1 : 50% OFF
% 2 : GREY
% 3 : 50% ON
% 4 : 100% ON

clear all;
close all;
clc;

% CONSTANTS

ANALYZE_BY_REGION = true;% weather ROIs should be selected based on their layer in the lobula complex. 

% REGION = 'Lthree';
REGION = 'AT';
% REGION = 'Ltwo';

% AT=axon terminals; AX=axons; CB=cell bodies; DE=dendrites
% this region info is stored as a string in the variable 'layer'in the MASTER excel spreadsheet

if(ANALYZE_BY_REGION)

    GENOTYPE_STRING = ['L2 & L3 ort rescue, region: ' REGION];


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


% Change this variable to your pData path
pdatapath='/Users/ksporar/Documents/MATLAB/Katja_pData';
addpath(pdatapath);
cd(pdatapath);


% % % % Change this variable to your pData path
% % % addpath(genpath('/Users/marvin.seifert/Documents/Marvin'))
% % % pdatapath='/Users/marvin.seifert/Documents/working_data/2p_Data';
% % % addpath(pdatapath);
% % % cd(pdatapath);
% % %Select the Name and Neuron type for the output file
% % %The data for the different steps will be saved independently
% % DataSave = ('L2_LexA_Control');
% % DataSavePath = ('/Users/marvin.seifert/Documents/working_data/FigureData');
% % Dataslash = '/';
wantplot = 1; %If you want plot of step HMH enter 1
% % % For the code
% % % addpath('W:\f.buschendorf\TP_code_Katja');

% fetch Information from Masterfoldersummary
database_select_samples_ks;

%% Processing Data 

% find matching pData files
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_L2_LexA_Control.*~i_moving.*(flyID~=23));
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6F_L221DhhGal4.*~i_moving.*(flyID>=386));
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6F_L3MH56Gal4.*~i_moving);
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_L3MH56Gal4_cross_to_w.*~i_moving.*(flyID>=340));
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_L3MH56Gal4_cross_to_w.*~i_moving);

f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*(i_UASGCaMP6F_L3MH56Gal4 | i_UASGCaMP6f_L3MH56Gal4_cross_to_w).*~i_moving); %paper
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*(i_UASGCaMP6F_L221DhhGal4 | i_UASGCaMP6F_L221DhhGal4_cross_to_w).*~i_moving.*(flyID~=400)); %paper


%ND filters
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_L221DhhGal4_06.*~i_moving);
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_L3MH56Gal4_cross_to_w_06.*~i_moving);

% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6F_L3MH56Gal4.*~i_moving.*(flyID>=409));
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6F_L3MH56Gal4_06.*~i_moving.*(flyID>=409));

%shits
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_L3MH56Gal4_UASshits.*~i_moving);
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_L221DhhGal4_UASshits.*~i_moving);

% create structures by neuron
fTm9LexA = create_neuron_structure_all_ks(f_Tm9LexA);

% load all the data!
xTm9LexA = load_neuron_data10Hz_ks(fTm9LexA,pdatapath);

% This function groups the different interesting epoch combinations in a
% Matrix, stored in combination_storage
mTm9LexA = aggregate_05StepsON_OFF(xTm9LexA);

%% Correlation of Cells

numROIs = size(mTm9LexA.rats,1);


% There are 20 epochs which go from 0->1, 0->2 ...
from = [0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4];
to = [1,2,3,4,0,2,3,4,0,1,3,4,0,1,2,4,0,1,2,3];

step = to-from;
step(step<0) = 0; 
on_step = logical(step); 

negative_correlated = zeros(numROIs,1);
positive_correlated = zeros(numROIs,1);

    
% % % % % roi_rats = squeeze(mTm9LexA.rats(:,[],:))


% Check which cells are positively or negatively correlated
for ii=1:numROIs    
    
    roi_rats = squeeze(mTm9LexA.rats(ii,:,:));
    
%     roi_rats_znj = roi_rats(ii,:);
    
%     roi_rats_znj_norm = (roi_rats_znj / max(roi_rats_znj));
    
    % Mean signal over all On Steps or Off Steps
    mean_onStep = nanmean(roi_rats(on_step,:),1);
    mean_offStep = nanmean(roi_rats(~on_step,:),1);
   
    reaction_onStep = nanmean(mean_onStep(100:120))-nanmean(mean_onStep(80:100)); % if <0 then neg. correlated, if >0 then pos. correlated
    reaction_offStep = nanmean(mean_offStep(100:120))-nanmean(mean_offStep(80:100)); % if >0 then neg. correlated, if <0 then pos. correlated 
    
    if reaction_offStep < 0 && reaction_onStep > 0
       % positive correlated
       positive_correlated(ii)=1;
    elseif reaction_offStep > 0 && reaction_onStep < 0
        % negative correlated
        negative_correlated(ii)=1;
    else 
        % weird stuff, better drop this ROI
    end

%      if positive_correlated(ii)
%         figure(ii);
%         hold on
%         plot(mean_onStep);
%         plot(mean_offStep,'g');
%         
%         title(['ROI No ',num2str(ii)])
%         
%         legend('On Step','Off Step')
%         %     % Plot with error bars - just to check Sometimes only 3 steps out of 10
%         %     % possible were recorded
%         %
%         %     %[x,m,e] = mean_cat_full(roi_rats(step,:),1,mTm9LexA.flyID); %m=mean; e=std
%         %     %h1 = plot_err_patch_v2(cur_t,m,e,[0 0 1],[0.8 0.8 1]);
%         hold off
%      end
end

% Array stores 'true' (1) if this ROI is negatively correlated
negative_correlated = logical(negative_correlated);
% Array stores 'true' (1) if this ROI is positively correlated
positive_correlated = logical(positive_correlated);
%% Printing ALL Traces

THRESHOLD = 0;
fprintf('THRESHOLD for Signal sum: %d \n',THRESHOLD );

% take a mean of all assigned values, ignore 0
%crossing_rats = mTm9LexA.rats; % Take all ROIs
crossing_rats = mTm9LexA.rats(negative_correlated,:,:); % Take only negative corelated ROIs

crossing_rats(crossing_rats==0) = NaN;

% % % % % % % %%%%%%%%%%%%%%%%%%%%%ks
% % % % % % % %getting rid of the second row (20 steps)
% % % % % % % new_matrix = squeeze(nanmean(crossing_rats,2));
% % % % % % % %%%%%%%%%%%%%%%%%%%%%ks
% % % % % % % numROIs = size(new_matrix,1)
% % % % % % % 
% % % % % % % for ii=1:numROIs    
% % % % % % %     
% % % % % % % %     roi_rats(ii,:) = squeeze(new_matrix(ii,:));
% % % % % % %     roi_rats = squeeze(new_matrix(ii,:));
% % % % % % %     roi_rats_max = max(roi_rats);
% % % % % % %     roi_rats_norm = (roi_rats / roi_rats_max);
% % % % % % %     plot(roi_rats_norm)
% % % % % % % end

% 
% Mean over all ROI's
mean_val = squeeze(nanmean(crossing_rats,1));
% mean_val = squeeze(nanmean(new_matrix,1));

% Watch over 20 seconds period
cur_t = linspace(0,20,length(mean_val(1,:)))';

plots = size(mTm9LexA.rats,2);
titles = {'-100% -> -50%','-100% -> GREY','-100% -> +50%','100% OFF -> 100% On','-50% -> -100%', '-50% -> GREY','-50% -> +50%',...
    '-50% -> +100% ','GREY -> -100%','GREY -> -50%' ,'GREY -> +50%', ...
    'GREY -> +100%','+50 -> -100%', '+50% -> -50%','+50% -> GREY',...
    '+50% -> +100%','100% ON --> 100% OFF','+100% -> -50% ','+100% -> GREY ',...
    '+100% -> +50%'};
titles1 = {'MHMF','MHG','MHF','MHH','MFMH', 'MFG','MFF',...
    'MFH','GMH','GMF' ,'GF', ...
    'GH','FMH', 'FMF','FG',...
    'FH','HMH','HMF','HG',...
    'HF'};

% Just those which crossed threshold:
% % cur_ROIs = mTm9LexA.flyID;
% cur_mat = crossing_rats;

color = varycolor(20);

for ii = 1:plots
    
    if abs(sum(mean_val(ii,:))) > THRESHOLD
        fprintf('Signal sum %d: %d \n',ii,abs(sum(mean_val(:,ii))));
        figure(ii);
        hold on;
        
        epochRats = squeeze(crossing_rats(:,ii,:));
        [x,m,e] = mean_cat_full(epochRats,1,mTm9LexA.flyID); %m=mean; e=std
        h1 = plot_err_patch_v2(cur_t,m,e,color(ii,:),color(ii,:),'-',0);
        
        xlabel('time (s)');
        ylabel('dF/F - Calcium Signal');
%         ylim([-0.05 0.07]);
        ylim([-1 2]);
        niceaxes;
        title(titles(ii));
        
        legend(h1,sprintf('N = %d ( %d )',size(x,1),size(epochRats,1)),... %ks added
        'location','northeast');
        
        line([0 20],[0 0],'color',[0 0 0]);
        line([0 10 10 20],[0.05 0.05 0.07 0.07],'color',[0 0 0]);
  
%         hold off;
    else
        fprintf('Case %d did not cross THRESHOLD (%s).\n',ii,titles{ii});
    end
end
%% Evaluating the correlations between the same contrast differences - over ROIs
close all;
numROIs = size(crossing_rats,1);
num_steps = size(mean_val,1);
% [x,m,e] = mean_cat_full(epochRats,2,cur_ROIs); %m=m
% cat = category (flyID)
% epochRat = max_data



mean_calciumStep = zeros(1,num_steps);
err_calciumStep = zeros(1,num_steps);



% Search max-Signal per ROI and take the mean of all max's per ROI signals
for kk=1:num_steps
    
    %ks: defining the time where we look for the baseline
    baseline = crossing_rats(:,kk,round(0.4*end):round(0.5*end)); %8-10s for 2*10s step
    baseline = squeeze(baseline);
    %ks: defining the time where we look for the response
    response = crossing_rats(:,kk,round(0.5*end)+1:round(0.6*end)); %10-12s for 2*10s step
    response = squeeze(response);
    
    %test if you're looking for an increase or a decrease in calcium (for each trace):
    decreasingCa = nanmean(baseline,2) - nanmean(response,2) >= 0; %nanmean is the mean of X, computed after removing NaN values
    increasingCa = nanmean(squeeze(baseline),2) - nanmean(squeeze(response),2) < 0;
    
    calciumStep = zeros(numROIs,1);
    for ii = 1:numROIs
        if decreasingCa(ii)
            calciumStep(ii) = min(response(ii,:)) - mean(baseline(ii,:));  %mars: Probably wrong because the min vs. max is not necessary the value we are looking for!?
        elseif increasingCa(ii) %this is necessary, if there are NaNs, both logicals are 0
            calciumStep(ii) = max(response(ii,:)) - mean(baseline(ii,:));  %        
        else
            calciumStep(ii) = NaN;
        end
    end
    
    % take the mean of all steps
    mean_calciumStep(kk) = nanmean(calciumStep);
    % Standard error
    err_calciumStep(kk) = nanstd(calciumStep)/sqrt(length(calciumStep));
     str = strjoin(titles1(kk));
%     filename = [ DataSavePath, Dataslash, 'ROISave_', num2str(DataSave),str, '.mat' ];
    
    
    
%     save(filename,'calciumStep');   
    
end


% When does the full field get brighter?
% on_step = [1 1 1 0 1 1 1 0 0 1 1 0 0 0 1 0 0 0];
on_step = [1 1 1 1 0 1 1 1 0 0 1 1 0 0 0 1 0 0 0 0]; %ks: 20 steps (added 100% OFF --> 100% ON and 100% ON --> 100% OFF)
on_step = logical(on_step);
off_step = ~ on_step;


%%
% Plot ALL steps-------------------------------------------------
bar_all = figure;
grid on;

% Plot the data only for OFF steps
y1 = mean_calciumStep(off_step); %ks
x1 = find(off_step);
e1 = err_calciumStep(off_step);

hold on;
bar(x1,y1,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.0);
errorbar(x1,y1,e1,'rx');

% Plot the data only for ON steps
y2 = mean_calciumStep(on_step); %ks
x2 = find(on_step);
e2 = err_calciumStep(on_step);

bar(x2,y2,'FaceColor',[.5 .5 0],'EdgeColor',[.9 .9 0],'LineWidth',1.0);
legend({'OFF Step','Error','ON Step'},'Location','northwest');
errorbar(x2,y2,e2,'rx');
ylim([-1 4]);
% ylim([-0.6 1.9]);
% ylim([-0.9 1.5]);

title('All Steps - Signal strength');

% Add titles
ax = gca;
ax.XTick = 1:20;
ax.XTickLabels = {'-100% -> -50%','-100% -> GREY','-100% -> +50%','100% OFF -> 100% On','-50% -> -100%', '-50% -> GREY','-50% -> +50%',...
    '-50% -> +100% ','GREY -> -100%','GREY -> -50%' ,'GREY -> +50%', ...
    'GREY -> +100%','+50 -> -100%', '+50% -> -50%','+50% -> GREY',...
    '+50% -> +100%','100% ON --> 100% OFF','+100% -> -50% ','+100% -> GREY ',...
    '+100% -> +50%'};
ax.XTickLabelRotation = 45;
ylabel('dF/F - Calcium Signal');
hold off;

%% Evaluating the correlations between the same contrast differences - over flyIDs
close all;

num_steps = size(mean_val,1);
% [x,m,e] = mean_cat_full(epochRats,2,cur_ROIs); %m=m
% cat = category (flyID)
% epochRat = max_data


numFlies = length(unique(mTm9LexA.flyID));

mean_calciumStep = zeros(1,num_steps);
err_calciumStep = zeros(1,num_steps);



% Search max-Signal per ROI and take the mean of all max's per ROI signals
for kk=1:num_steps
    
    traces = squeeze(mTm9LexA.rats(negative_correlated,kk,:)); %because mean_cat_full works only with 2 dimensions %taking all ROIs, the epoch we are one, full lenth (200)
    [x,m,e] = mean_cat_full(traces,1,mTm9LexA.flyID(negative_correlated)); %m=mean; e=std
   
    
    
    %ks: defining the time where we look for the baseline
    baseline = x(:,round(0.4*end):round(0.5*end)); %8-10s for 2*10s step
%     baseline = squeeze(baseline);
    %ks: defining the time where we look for the response
%     response = x(:,round(0.8*end)+1:end); %10-12s for 2*10s step
    response = x(:,round(0.5*end)+1:round(0.6*end)); %10-12s for 2*10s step
%     response = squeeze(response);
    
    %test if you're looking for an increase or an decrease in calcium (for each trace):
    %decreasingCa=zeros(numFlies,1); 
    %increasingCa=zeros(numFlies,1);

    decreasingCa = nanmean(baseline,2) - nanmean(response,2) >= 0; %nanmean is the mean of X, computed after removing NaN values
    increasingCa = nanmean(squeeze(baseline),2) - nanmean(squeeze(response),2) < 0;
    
    %for pp=1:length(decreasingCaI)
    %   decreasingCa(pp)= decreasingCaI(pp);
    %   increasingCa(pp)= increasingCaI(pp);
   % end
    numFlies=size(x,1);%mars Added to prevent crash when number of flies does not equal number of Ca. traces. 
    calciumStep = zeros(numFlies,1);
    for ii = 1:numFlies
        if decreasingCa(ii);
            calciumStep(ii) = min(response(ii,:)) - mean(baseline(ii,:));
        elseif increasingCa(ii) %this is necessary, if there are NaNs, both logicals are 0
            calciumStep(ii) = mean(response(ii,:)) - mean(baseline(ii,:));  %        
        else
            calciumStep(ii) = NaN;
        end
    end
    
    % take the mean off all steps
    mean_calciumStep(kk) = nanmean(calciumStep);
    % Standard error
    err_calciumStep(kk) = nanstd(calciumStep)/sqrt(length(calciumStep));
    %Save the Data for analysis
    str = strjoin(titles1(kk));
%     filename = [ DataSavePath,Dataslash,'FlySave_', num2str(DataSave),str, '.mat' ];
    
    
    
%     save(filename,'calciumStep');
    
end


% When does the full field get brighter?
on_step = [1 1 1 1 0 1 1 1 0 0 1 1 0 0 0 1 0 0 0 0];
on_step = logical(on_step);
off_step = ~ on_step;



% Plot ALL steps-------------------------------------------------
bar_all = figure;
grid on;

% Plot the data only for OFF steps
y1 = mean_calciumStep(off_step); %ks
x1 = find(off_step);
e1 = err_calciumStep(off_step);

hold on;
bar(x1,y1,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.0);
errorbar(x1,y1,e1,'rx');

% Plot the data only for ON steps
y2 = mean_calciumStep(on_step); %ks
x2 = find(on_step);
e2 = err_calciumStep(on_step);

bar(x2,y2,'FaceColor',[.5 .5 0],'EdgeColor',[.9 .9 0],'LineWidth',1.0);
legend({'OFF Step','Error','ON Step'},'Location','northwest');
errorbar(x2,y2,e2,'rx');

title('All Steps - Signal strength');

% Add titles
ax = gca;
ax.XTick = 1:20;
ax.XTickLabels = {'-100% -> -50%','-100% -> GREY','-100% -> +50%','100% OFF -> 100% On','-50% -> -100%', '-50% -> GREY','-50% -> +50%',...
    '-50% -> +100% ','GREY -> -100%','GREY -> -50%' ,'GREY -> +50%', ...
    'GREY -> +100%','+50 -> -100%', '+50% -> -50%','+50% -> GREY',...
    '+50% -> +100%','100% ON --> 100% OFF','+100% -> -50% ','+100% -> GREY ',...
    '+100% -> +50%'};
ax.XTickLabelRotation = 45;

hold off;

%% Plot by category - 1 Step ---------------------------------------------
two_steps = [0 1 0 0 0 1 0 0 1 0 0 1 0 1 0 0 0 0 1 0 ];
three_steps = [0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 ];
four_steps =  [0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 ]; %ks added
% one_step = ~ two_steps & ~ three_steps;
one_step = ~ two_steps & ~ three_steps & ~ four_steps; %ks added

bar_1 = figure;
grid on;
y1 = mean_calciumStep(off_step & one_step);
%x1 = find(off_step & one_step);
x1 = ([2 6 10 14]);
e1 = err_calciumStep(off_step & one_step);

hold on;
w = 0.5;
bar(x1,y1,w,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.0);
errorbar(x1,y1,e1,'rx');

y2 = mean_calciumStep(find(on_step & one_step));
%x2 = find(on_step & one_step);
x2 = ([3 7 11 15]);
e2 = err_calciumStep(on_step & one_step);

bar(x2,y2,w,'FaceColor',[.5 .5 0],'EdgeColor',[.9 .9 0],'LineWidth',1.0);
errorbar(x2,y2,e2,'rx');
ylim([-1 1]);
% ylim([-0.6 1.9]);
% ylim([-0.9 1.5]);

legend({'OFF Step','Error','ON Ste'},'Location','northwest');
title('One Step - Signal strength');

ax = gca;
ax.XTick = sort([x1, x2]);
ax.XTickLabels = {'-100% -> -50%','-50% -> -100%',...
    '-50% -> GREY ','GREY -> -50%','GREY -> +50%',...
    '+50% -> GREY ','+50% -> +100%',...
    '+100% -> +50%'};
ax.XTickLabelRotation = 45;

hold off;

%% 2 Steps --------------------------------------------------------------
bar_2 = figure;
grid on;
y1 = mean_calciumStep(off_step & two_steps);
x1 = find(off_step & two_steps);
e1 = err_calciumStep(off_step &two_steps);

hold on;
w = 0.5;
bar(x1,y1,w,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.0);
errorbar(x1,y1,e1,'rx');

y2 = mean_calciumStep(find(on_step & two_steps));
x2 = find(on_step & two_steps);
e2 = err_calciumStep(on_step & two_steps);

bar(x2,y2,w,'FaceColor',[.5 .5 0],'EdgeColor',[.9 .9 0],'LineWidth',1.0);
errorbar(x2,y2,e2,'rx');
ylim([-1 1]);
% ylim([-0.6 1.9]);
% ylim([-0.9 1.5]);

legend({'OFF Step','Error','ON Step'},'Location','northwest');
title('Two Steps - Signal strength');

ax = gca;
ax.XTick = sort([x1, x2]);
ax.XTickLabels = {'-100% -> GREY',...
    '-50% -> +50%','GREY -> -100%', ...
     'GREY -> +100%','+50% -> -50%',...
    '+100% -> GREY ',...
    };
ax.XTickLabelRotation = 45;

hold off;
%% 3 Steps --------------------------------------------------------------

bar_3 = figure;
grid on;
y1 = mean_calciumStep(off_step & three_steps);
x1 = find(off_step & three_steps);
e1 = err_calciumStep(off_step & three_steps);

hold on;
w = 0.5;
bar(x1,y1,w,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.0);
errorbar(x1,y1,e1,'rx');

y2 = mean_calciumStep(find(on_step & three_steps));
x2 = find(on_step & three_steps);
e2 = err_calciumStep(on_step & three_steps);

bar(x2,y2,w,'FaceColor',[.5 .5 0],'EdgeColor',[.9 .9 0],'LineWidth',1.0);
errorbar(x2,y2,e2,'rx');
ylim([-0.6 1.5]);
% ylim([-0.6 1.9]);
% ylim([-0.9 1.5]);

legend({'OFF Step','Error','ON Step'},'Location','northwest');

title('Three Steps - Signal strength');

ax = gca;
ax.XTick = sort([x1, x2]);
ax.XTickLabels = {'-100% -> +50%','-50% -> +100%','+50% -> -100%','+100% -> -50%'};
ax.XTickLabelRotation = 45;

hold off;




 %% Normalized Evaluation of the correlations between the same contrast differences - over ROIs
close all;
numROIs = size(crossing_rats,1);
num_steps = size(mean_val,1);
% [x,m,e] = mean_cat_full(epochRats,2,cur_ROIs); %m=m
% cat = category (flyID)
% epochRat = max_data



mean_calciumStep = zeros(1,num_steps);
err_calciumStep = zeros(1,num_steps);



% Search max-Signal per ROI and take the mean of all max's per ROI signalsd
for kk=1:num_steps
    
    %ks: defining the time where we look for the baseline
    baseline = crossing_rats(:,kk,round(0.4*end):round(0.5*end)); %8-10s for 2*10s step
    baseline = squeeze(baseline);
    %ks: defining the time where we look for the response
    response = crossing_rats(:,kk,round(0.5*end)+1:round(0.6*end)); %10-12s for 2*10s step
    response = squeeze(response);
    
    %test if you're looking for an increase or a decrease in calcium (for each trace):
    decreasingCa = nanmean(baseline,2) - nanmean(response,2) >= 0; %nanmean is the mean of X, computed after removing NaN values
    increasingCa = nanmean(squeeze(baseline),2) - nanmean(squeeze(response),2) < 0;
    
    calciumStep = zeros(numROIs,1);
    for ii = 1:numROIs
        if decreasingCa(ii)
            calciumStep(ii) =  mean(baseline(ii,:)) - mean(response(ii,:));  %mars: Probably wrong because the min vs. max is not necessary the value we are looking for!?
        elseif increasingCa(ii) %this is necessary, if there are NaNs, both logicals are 0
            calciumStep(ii) =  mean(baseline(ii,:)) - mean(response(ii,:));  %        
        else
            calciumStep(ii) = NaN;
        end
    end
    
    % take the mean of all steps
    mean_calciumStep(kk) = nanmean(calciumStep);
%     filename = [ DataSavePath, Dataslash, 'ROISaveNormalized', num2str(DataSave), '.mat' ];
%     save(filename,'calciumStep')
    % Standard error
    err_calciumStep(kk) = nanstd(calciumStep)/sqrt(length(calciumStep));
       
    
end


% When does the full field get brighter?
% on_step = [1 1 1 0 1 1 1 0 0 1 1 0 0 0 1 0 0 0];
on_step = [1 1 1 1 0 1 1 1 0 0 1 1 0 0 0 1 0 0 0 0]; %ks: 20 steps (added 100% OFF --> 100% ON and 100% ON --> 100% OFF)
on_step = logical(on_step);
off_step = ~ on_step;


%% Normalization
Norm = min(mean_calciumStep(off_step));
mean_calciumStep(off_step) =(mean_calciumStep(off_step))/Norm;
Norm = max(mean_calciumStep(on_step));
mean_calciumStep(on_step) = -(mean_calciumStep(on_step)/Norm);

%%
% Plot ALL steps-------------------------------------------------
bar_all = figure;
grid on;

% Plot the data only for OFF steps
y1 = mean_calciumStep(off_step); %ks
x1 = find(off_step);
e1 = err_calciumStep(off_step);

hold on;
bar(x1,y1,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.0);
errorbar(x1,y1,e1,'rx');

% Plot the data only for ON steps
y2 = mean_calciumStep(on_step); %ks
x2 = find(on_step);
e2 = err_calciumStep(on_step);

bar(x2,y2,'FaceColor',[.5 .5 0],'EdgeColor',[.9 .9 0],'LineWidth',1.0);
legend({'OFF Step','Error','ON Step'},'Location','northwest');
errorbar(x2,y2,e2,'rx');
ylim([-1.5 1.5]);
% ylim([-0.6 1.9]);
% ylim([-0.9 1.5]);

title('All Steps - Signal strength');

% Add titles
ax = gca;
ax.XTick = 1:20;
ax.XTickLabels = {'-100% -> -50%','-100% -> GREY','-100% -> +50%','100% OFF -> 100% On','-50% -> -100%', '-50% -> GREY','-50% -> +50%',...
    '-50% -> +100% ','GREY -> -100%','GREY -> -50%' ,'GREY -> +50%', ...
    'GREY -> +100%','+50 -> -100%', '+50% -> -50%','+50% -> GREY',...
    '+50% -> +100%','100% ON --> 100% OFF','+100% -> -50% ','+100% -> GREY ',...
    '+100% -> +50%'};
ax.XTickLabelRotation = 45;
ylabel('dF/F - Calcium Signal');
hold off;


if wantplot == 1
    kk=17;
    traces = squeeze(mTm9LexA.rats(negative_correlated,kk,:)); %because mean_cat_full works only with 2 dimensions %taking all ROIs, the epoch we are one, full lenth (200)
    [x,m,e] = mean_cat_full(traces,1,mTm9LexA.flyID(negative_correlated)); %m=mean; e=std
   
    
    
    %ks: defining the time where we look for the baseline
    baseline = x(:,round(0.4*end):round(0.5*end)); %8-10s for 2*10s step
%     baseline = squeeze(baseline);
    %ks: defining the time where we look for the response
    response = x(:,round(0.5*end)+1:round(0.6*end)); %10-12s for 2*10s step
%     response = squeeze(response);
    
    %test if you're looking for an increase or an decrease in calcium (for each trace):
    %decreasingCa=zeros(numFlies,1); 
    %increasingCa=zeros(numFlies,1);

    decreasingCa = nanmean(baseline,2) - nanmean(response,2) >= 0; %nanmean is the mean of X, computed after removing NaN values
    increasingCa = nanmean(squeeze(baseline),2) - nanmean(squeeze(response),2) < 0;
    
    %for pp=1:length(decreasingCaI)
    %   decreasingCa(pp)= decreasingCaI(pp);
    %   increasingCa(pp)= increasingCaI(pp);
   % end
    numFlies=size(x,1);%mars Added to prevent crash when number of flies does not equal number of Ca. traces. 
    calciumStep = zeros(numFlies,1);
    for ii = 1:numFlies
        if decreasingCa(ii);
            calciumStep(ii) = mean(response(ii,:)) - mean(baseline(ii,:));
        elseif increasingCa(ii) %this is necessary, if there are NaNs, both logicals are 0
            calciumStep(ii) = mean(response(ii,:)) - mean(baseline(ii,:));  %        
        else
            calciumStep(ii) = NaN;
        end
    end
    
    % take the mean off all steps
    mean_calciumStep(kk) = nanmean(calciumStep);
    % Standard error
    err_calciumStep(kk) = nanstd(calciumStep)/sqrt(length(calciumStep));
   
%plot Step 100 - -100    
figure;
for ii=1:size(x,1);
plot(x(ii,:));
hold on
end
    


end




%% Evaluating the correlations between the same contrast differences - over flyIDs
close all;

num_steps = size(mean_val,1);
% [x,m,e] = mean_cat_full(epochRats,2,cur_ROIs); %m=m
% cat = category (flyID)
% epochRat = max_data


numFlies = length(unique(mTm9LexA.flyID));

mean_calciumStep = zeros(1,num_steps);
err_calciumStep = zeros(1,num_steps);



% Search max-Signal per ROI and take the mean of all max's per ROI signals
for kk=1:num_steps
    
    traces = squeeze(mTm9LexA.rats(negative_correlated,kk,:)); %because mean_cat_full works only with 2 dimensions %taking all ROIs, the epoch we are one, full lenth (200)
    [x,m,e] = mean_cat_full(traces,1,mTm9LexA.flyID(negative_correlated)); %m=mean; e=std
   
    
    
    %ks: defining the time where we look for the baseline
    baseline = x(:,round(0.4*end):round(0.5*end)); %8-10s for 2*10s step
%     baseline = squeeze(baseline);
    %ks: defining the time where we look for the response
%     response = x(:,round(0.8*end)+1:end); %10-12s for 2*10s step
    response = x(:,round(0.5*end)+1:round(0.6*end)); %10-12s for 2*10s step
%     response = squeeze(response);
    
    %test if you're looking for an increase or an decrease in calcium (for each trace):
    %decreasingCa=zeros(numFlies,1); 
    %increasingCa=zeros(numFlies,1);

    decreasingCa = nanmean(baseline,2) - nanmean(response,2) >= 0; %nanmean is the mean of X, computed after removing NaN values
    increasingCa = nanmean(squeeze(baseline),2) - nanmean(squeeze(response),2) < 0;
    
    %for pp=1:length(decreasingCaI)
    %   decreasingCa(pp)= decreasingCaI(pp);
    %   increasingCa(pp)= increasingCaI(pp);
   % end
    numFlies=size(x,1);%mars Added to prevent crash when number of flies does not equal number of Ca. traces. 
    calciumStep = zeros(numFlies,1);
    for ii = 1:numFlies
        if decreasingCa(ii);
            calciumStep(ii) = min(response(ii,:)) - mean(baseline(ii,:));
        elseif increasingCa(ii) %this is necessary, if there are NaNs, both logicals are 0
            calciumStep(ii) = mean(response(ii,:)) - mean(baseline(ii,:));  %        
        else
            calciumStep(ii) = NaN;
        end
    end
    
    % take the mean off all steps
    mean_calciumStep(kk) = nanmean(calciumStep);
    % Standard error
    err_calciumStep(kk) = nanstd(calciumStep)/sqrt(length(calciumStep));
    %Save the Data for analysis
    str = strjoin(titles1(kk));
%     filename = [ DataSavePath,Dataslash,'FlySave_', num2str(DataSave),str, '.mat' ];
    
    
    
%     save(filename,'calciumStep');
    
end


% When does the full field get brighter?
on_step = [1 1 1 1 0 1 1 1 0 0 1 1 0 0 0 1 0 0 0 0];
on_step = logical(on_step);
off_step = ~ on_step;

%% Normalization
Norm = max(mean_calciumStep(off_step));
mean_calciumStep(off_step) =(mean_calciumStep(off_step))/Norm;
Norm = min(mean_calciumStep(on_step));
mean_calciumStep(on_step) = -(mean_calciumStep(on_step)/Norm);


%%
% Plot ALL steps-------------------------------------------------
bar_all = figure;
grid on;

% Plot the data only for OFF steps
y1 = mean_calciumStep(off_step); %ks
x1 = find(off_step);
e1 = err_calciumStep(off_step);

hold on;
bar(x1,y1,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.0);
errorbar(x1,y1,e1,'rx');

% Plot the data only for ON steps
y2 = mean_calciumStep(on_step); %ks
x2 = find(on_step);
e2 = err_calciumStep(on_step);

bar(x2,y2,'FaceColor',[.5 .5 0],'EdgeColor',[.9 .9 0],'LineWidth',1.0);
legend({'OFF Step','Error','ON Step'},'Location','northwest');
errorbar(x2,y2,e2,'rx');
ylim([-1.5 1.5]);
% ylim([-0.6 1.9]);
% ylim([-0.9 1.5]);

title('All Steps - Signal strength');

% Add titles
ax = gca;
ax.XTick = 1:20;
ax.XTickLabels = {'-100% -> -50%','-100% -> GREY','-100% -> +50%','100% OFF -> 100% On','-50% -> -100%', '-50% -> GREY','-50% -> +50%',...
    '-50% -> +100% ','GREY -> -100%','GREY -> -50%' ,'GREY -> +50%', ...
    'GREY -> +100%','+50 -> -100%', '+50% -> -50%','+50% -> GREY',...
    '+50% -> +100%','100% ON --> 100% OFF','+100% -> -50% ','+100% -> GREY ',...
    '+100% -> +50%'};
ax.XTickLabelRotation = 45;
ylabel('dF/F - Calcium Signal');
hold off;


if wantplot == 1
    kk=17;
    traces = squeeze(mTm9LexA.rats(negative_correlated,kk,:)); %because mean_cat_full works only with 2 dimensions %taking all ROIs, the epoch we are one, full lenth (200)
    [x,m,e] = mean_cat_full(traces,1,mTm9LexA.flyID(negative_correlated)); %m=mean; e=std
   
    
    
    %ks: defining the time where we look for the baseline
    baseline = x(:,round(0.4*end):round(0.5*end)); %8-10s for 2*10s step
%     baseline = squeeze(baseline);
    %ks: defining the time where we look for the response
    response = x(:,round(0.5*end)+1:round(0.6*end)); %10-12s for 2*10s step
%     response = squeeze(response);
    
    %test if you're looking for an increase or an decrease in calcium (for each trace):
    %decreasingCa=zeros(numFlies,1); 
    %increasingCa=zeros(numFlies,1);

    decreasingCa = nanmean(baseline,2) - nanmean(response,2) >= 0; %nanmean is the mean of X, computed after removing NaN values
    increasingCa = nanmean(squeeze(baseline),2) - nanmean(squeeze(response),2) < 0;
    
    %for pp=1:length(decreasingCaI)
    %   decreasingCa(pp)= decreasingCaI(pp);
    %   increasingCa(pp)= increasingCaI(pp);
   % end
    numFlies=size(x,1);%mars Added to prevent crash when number of flies does not equal number of Ca. traces. 
    calciumStep = zeros(numFlies,1);
    for ii = 1:numFlies
        if decreasingCa(ii);
            calciumStep(ii) = mean(response(ii,:)) - mean(baseline(ii,:));
        elseif increasingCa(ii) %this is necessary, if there are NaNs, both logicals are 0
            calciumStep(ii) = mean(response(ii,:)) - mean(baseline(ii,:));  %        
        else
            calciumStep(ii) = NaN;
        end
    end
    
    % take the mean off all steps
    mean_calciumStep(kk) = nanmean(calciumStep);
    % Standard error
    err_calciumStep(kk) = nanstd(calciumStep)/sqrt(length(calciumStep));
   
%plot Step 100 - -100    
figure;
for ii=1:size(x,1);
plot(x(ii,:));
hold on
end
    


end