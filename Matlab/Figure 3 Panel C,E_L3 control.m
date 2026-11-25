%% Analysis_05StepsON_OFF_marvin.m
% This script analyses Data from the Stimulus "LocalCircle_0.5steps_10s_randSteps_120deg_0degAz_0degEl_2Lum".
% It has 5 Epochs which vary in luminance (100% ON, 50% ON, grey, 50%OFF,100%OFF). 
% These Epochs are displayed one for 10 seconds, then switched randomly to 
% any other Epoch. Contrast difference between a (100 ON - 50 ON) and a 
% (grey - 50 OFF) switch might be the same and this is the question which 
% shall be examined here. Epochs are displayed randomly.

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

%%Figure 3

GENOTYPE_STRING = 'L3 control'; 

COLOR_OF_PLOT = [0 0 1]; %BLUE; [.7 .7 0]% YELLOW %[1 0 0]; %RED% [0 .5 0]% GREEN %[0 0 1]; %BLUE;
%COLOR_OF_PLOT = [1 0 0]; %RED; %[0 0 1] %BLUE;
COLOR_CLOUD = [.5 .5 1];

gen_str = GENOTYPE_STRING;

pdatapath= 'W:\Katja\Katja_pData'; % Change to where data is stored
addpath(pdatapath);
% cd(pdatapath);
try
    cd(pdatapath);
catch error1
    error('Katja''s pData path not accesible')
end

% Run database 
database_select_samples_ks;

wantplot = 0; %If you want plot of step HMH enter 1
%% Processing Data 

% find matching pData files

% Figure 3 L3 ort rescue
% L3 control
f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_UASort_0595Gal4_ort1_plus.*~i_moving);

% create structures by neuron
fTm9LexA = create_neuron_structure_all_ks(f_Tm9LexA);

% load all the data!
xTm9LexA = load_neuron_data10Hz_ks(fTm9LexA,pdatapath);

% This function groups the different interesting epoch combinations in a
% Matrix, stored in combination_storage
mTm9LexA = aggregate_05StepsON_OFF(xTm9LexA); %taking 100ON as a baseline
% mTm9LexA = aggregate_05StepsON_OFF_grey_baseline(xTm9LexA); %taking grey as a baseline


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

% Check which cells are positively or negatively correlated
for ii=1:numROIs
    roi_rats = squeeze(mTm9LexA.rats(ii,:,:));
    
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

% Mean over all ROI's
mean_val = squeeze(nanmean(crossing_rats,1));


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



%% Evaluating the correlations between the same contrast differences - over flyIDs
% BG: Changed it to plot plateaue compared to baseline and not the previous
% step. Also changed calculation of SEM so that the flies that are NaN are
% not included in the division.

close all;

num_steps = size(mean_val,1);
% [x,m,e] = mean_cat_full(epochRats,2,cur_ROIs); %m=m
% cat = category (flyID)
% epochRat = max_data


numFlies = length(unique(mTm9LexA.flyID));

mean_calciumStep = zeros(1,num_steps);
err_calciumStep = zeros(1,num_steps);
all_step_samples = {};


% Search max-Signal per ROI and take the mean of all max's per ROI signals
for kk=1:num_steps
    
    traces = squeeze(mTm9LexA.rats(negative_correlated,kk,:)); %because mean_cat_full works only with 2 dimensions %taking all ROIs, the epoch we are one, full lenth (200)
    [x,m,e] = mean_cat_full(traces,1,mTm9LexA.flyID(negative_correlated)); %m=mean; e=std
   
    
    
    %ks: defining the time where we look for the baseline
    baseline = x(:,round(0.4*end):round(0.5*end)); %8-10s for 2*10s step
%     baseline = squeeze(baseline);
    %ks: defining the time where we look for the response
%     response = x(:,round(0.8*end)+1:end); %10-12s for 2*10s step
    response = x(:,round(0.9*end)+1:round(end)); %18-20s for 2*10s step
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
            calciumStep(ii) = mean(response(ii,:));
        elseif increasingCa(ii) %this is necessary, if there are NaNs, both logicals are 0
            calciumStep(ii) = mean(response(ii,:));  %        
        else
            calciumStep(ii) = NaN;
        end
    end
    
% % %     calciumStep_all(:,kk) = calciumStep;
    
    % take the mean off all steps
    mean_calciumStep(kk) = nanmean(calciumStep);
    % Standard error
    err_calciumStep(kk) = nanstd(calciumStep)/sqrt(length(~isnan(calciumStep)));
    %Save the Data for analysis
    str = strjoin(titles1(kk));
%     filename = [ DataSavePath,Dataslash,'FlySave_', num2str(DataSave),str, '.mat' ];
    
    all_step_samples{kk} = calciumStep;
    
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
ylim([-0.5 3]);
% ylim([-0.5 3.5]);
% ylim([-0.5 1.5]);

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

%% End at a certain luminance (by katja)--------------------------------------------------------------
% BG: Changed it to plot fly means and errors
close all;

num_steps = size(mean_val,1);
% [x,m,e] = mean_cat_full(epochRats,2,cur_ROIs); %m=m
% cat = category (flyID)
% epochRat = max_data

numROIs = size(crossing_rats,1);

mean_calcium = zeros(1,num_steps);
err_calcium = zeros(1,num_steps);





OFF_100 = [0 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0];
OFF_50 = [1 0 0 0 0 0 0 0 0 1 0 0 0 1 0 0 0 1 0 0];
grey = [0 1 0 0 0 1 0 0 0 0 0 0 0 0 1 0 0 0 1 0]; 
ON_50 = [0 0 1 0 0 0 1 0 0 0 1 0 0 0 0 0 0 0 0 1];
ON_100 = [0 0 0 1 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0 0];
OFF_100 = logical(OFF_100);
OFF_50 = logical(OFF_50);
grey = logical(grey);
ON_50 = logical(ON_50);
ON_100 = logical(ON_100);

THRESHOLD = 0;
fprintf('THRESHOLD for Signal sum: %d \n',THRESHOLD );

% take a mean of all assigned values, ignore 0
crossing_rats = mTm9LexA.rats;
crossing_rats(crossing_rats==0) = NaN;

% Mean over all ROI's
mean_val = squeeze(mean(crossing_rats,1,'omitnan'));

plots = size(mTm9LexA.rats,2);
titles = {'100% OFF --> 50% OFF';'100% OFF --> GREY'; '100% OFF --> 50% ON';'100% OFF --> 100% ON';'50% OFF --> 100% OFF';...
    '50% OFF --> GREY ';'50% OFF --> 50% ON';'50% OFF --> 100% ON' ;'GREY --> 100% OFF'; ...
    'GREY --> 50% OFF ';' GREY --> 50% ON'; ' GREY --> 100% ON ';'50% ON --> 100% OFF';'50% ON --> 50% OFF';...
    ' 50% ON --> GREY ';'50% ON --> 100% ON ';'100% ON --> 100% OFF';'100% ON --> 50% OFF';' 100% ON --> GREY ';...
    ' 100% ON --> 50% ON'};

% Watch over 20 seconds period
cur_t = linspace(0,20,length(mean_val(1,:)))';


bar_1 = figure;
grid on;
y1 = mean_calciumStep(OFF_100);
x1 = find(OFF_100);
e1 = err_calciumStep(OFF_100);

hold on;
w = 0.5;
bar(x1,y1,w,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.0);
errorbar(x1,y1,e1,'rx');




y2 = mean_calciumStep(find(OFF_50));
x2 = find(OFF_50);
e2 = err_calciumStep(OFF_50);

bar(x2,y2,w,'FaceColor',[.5 .5 0],'EdgeColor',[.9 .9 0],'LineWidth',1.0);
errorbar(x2,y2,e2,'rx');
ylim([-0.6 1]);



y3= mean_calciumStep(find(grey));
x3 = find(grey);
e3 = err_calciumStep(grey);

bar(x3,y3,w,'FaceColor',[.1 .5 0],'EdgeColor',[.2 .9 .9],'LineWidth',1.0);
errorbar(x3,y3,e3,'rx');
ylim([-0.6 1]);




y4= mean_calciumStep(find(ON_50));
x4 = find(ON_50);
e4 = err_calciumStep(ON_50);

bar(x4,y4,w,'FaceColor',[.8 .5 0],'EdgeColor',[.7 .9 .9],'LineWidth',1.0);
errorbar(x4,y4,e4,'rx');
ylim([-0.6 1]);



y5= mean_calciumStep(find(ON_100));
x5 = find(ON_100);
e5 = err_calciumStep(ON_100);

bar(x5,y5,w,'FaceColor',[.9 .8 0],'EdgeColor',[.9 .9 .9],'LineWidth',1.0);
errorbar(x5,y5,e5,'rx');
ylim([-0.6 1]);


legend({'OFF_100','OFF_50','grey','ON_50','ON_100'},'Location','northwest');%???
title('max response - coming to the same luminance');

ax = gca;
ax.XTick = sort([x1, x2, x3, x4, x5]);
ax.XTickLabels = {'OFF_100','OFF_50','grey','ON_50','ON_100'};
ax.XTickLabelRotation = 45;

hold off;

figure
plot(contrast, means_all,'k','Linewidth',4)
box off
ylim([-0.5 1]);
% xlim([-100:50:100])

%% End at certain luminance ----------

bar_2 = figure;
hold on;

% Take the mean of the mean here, I think that's okay
% First mean: Over ROIs, Second mean: over 

mean_calcium_OFF_100 = mean(y1);
mean_calcium_OFF_50 = mean(y2);
mean_calcium_grey = mean(y3);
mean_calcium_ON_50 = mean(y4);
mean_calcium_ON_100 = mean(y5);

error_calcium_OFF_100 = mean(e1);
error_calcium_OFF_50 = mean(e2);
error_calcium_grey = mean(e3);
error_calcium_ON_50 = mean(e4);
error_calcium_ON_100 = mean(e5);

bar(1,mean_calcium_OFF_100,w,'FaceColor',[0 .5 .5],'EdgeColor',[.9 .9 .9],'LineWidth',1.0);
errorbar(1,mean_calcium_OFF_100,error_calcium_OFF_100,'rx');

bar(2,mean_calcium_OFF_50,w,'FaceColor',[.5 .5 0],'EdgeColor',[.9 .9 .9],'LineWidth',1.0);
errorbar(2,mean_calcium_OFF_50,error_calcium_OFF_50,'rx');

bar(3,mean_calcium_grey,w,'FaceColor',[.1 .5 0],'EdgeColor',[.9 .9 .9],'LineWidth',1.0);
errorbar(3,mean_calcium_grey,error_calcium_grey,'rx');

bar(4,mean_calcium_ON_50,w,'FaceColor',[.8 .5 0],'EdgeColor',[.9 .9 .9],'LineWidth',1.0);
errorbar(4,mean_calcium_ON_50,error_calcium_ON_50,'rx');

bar(5,mean_calcium_ON_100,w,'FaceColor',[.9 .8 0],'EdgeColor',[.9 .9 .9],'LineWidth',1.0);
errorbar(5,mean_calcium_ON_100,error_calcium_ON_100,'rx');


title('max response - coming to the same luminance');


ax = gca;
ax.XTick = 1:5;
ax.XTickLabels = {'OFF 100%','OFF 50%','grey','ON 50%','ON 100%'};
ax.XTickLabelRotation = 45;


means_all = [mean_calcium_OFF_100 mean_calcium_OFF_50 mean_calcium_grey mean_calcium_ON_50 mean_calcium_ON_100];
%contrast = [-100 -50 0 +50 +100]


% plot(1:5, means_all,'k','Linewidth',4) - this is just a line connecting the peaks
box off
ylim([-0.5 2.0]); %for L2
% ylim([-0.5 4.0]);
% ylim([-0.5 0.5]); %for L2 ort, L2 NorpA

%ks: fitting an exponential functionf
ax = gca;
ax.FontSize = 20;
set(gca, ...
 'Box'         , 'off'     , ...
 'TickDir'     , 'out'     , ...
 'TickLength'  , [.02 .02] , ...
 'XMinorTick'  , 'on'      , ...
 'YMinorTick'  , 'on'      , ...
 'YGrid'       , 'on'      , ...
 'XColor'      , [.2 .2 .2], ...
 'YColor'      , [.2 .2 .2], ...
 'YTick'       , -0.5:0.5:4, ...
 'LineWidth'   , 1         );
hold on;

[fitresult,gof,h] = createFitFFF (1:5,means_all);
set(h, 'LineWidth', 2,...
   'Color'       , 'k');
ylabel ('df/F(baseline)');
text(4.5,0.1,[num2str(fitresult.a),'exp^(',num2str(fitresult.b),'*x)']);


% ylim([-0.5 4.0]);
hold off;
