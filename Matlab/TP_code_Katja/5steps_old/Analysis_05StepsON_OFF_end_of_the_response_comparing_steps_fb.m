%% Analysis_05StepsON_OFF_ks_ms.m
% This script analyses Data from the Stimulus "LocalCircle_0.5steps_10s_randSteps_120deg_0degAz_0degEl_2Lum".
% It has 5 Epochs which vary in luminance (100% ON, 50% ON, grey, 50%OFF,100%OFF). 
% These Epochs are displayed one for 10 seconds, then switched randomly to 
% any other Epoch. Contrast difference between a (100 ON - 50 ON) and a 
% (grey - 50 OFF) switch might be the same and this is the question which 
% shall be examined here. Epochs are displayed randomly.
%
%
% Fabiola 8/2016
% ks: this is the script that we use for checking the calcium fluorescence at the end of the response 

clear all;
close all;
clc;

% Change this variable to your pData path
pdatapath='/Users/ksporar/Documents/MATLAB/Katja_pData';
addpath(pdatapath);
cd(pdatapath);

% For the code
% addpath('W:\f.buschendorf\TP_code_Katja');

% fetch Information from Masterfoldersummary
database_select_samples_ks;

%% Processing Data 

% find matching pData files
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6F_L221DhhGal4.*~i_moving);
%  f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6F_L3MH56Gal4.*~i_moving);
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_L3MH56Gal4_cross_to_w.*~i_moving);
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6F_L221DhhGal4_cross_to_w.*~i_moving.*(flyID~=400));

%ND filters
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_L221DhhGal4_06.*~i_moving);
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_L3MH56Gal4_cross_to_w_06.*~i_moving);

%shits
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_L3MH56Gal4_UASshits.*~i_moving);
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_L221DhhGal4_UASshits.*~i_moving);

%ort
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_UASort_UASGCaMP6f_L221DhhGal4_ort1_DfBSC809_Helen.*~i_moving.*(flyID~=528));
f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_UASort_UASGCaMP6f_L221DhhGal4_ort1_DfBSC809_Helen.*~i_moving);

% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_UASort_UASGCaMP6f_L30595Gal4_ort1_DfBSC809.*~i_moving);

%real ort rescue - controls
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_UASort_0595Gal4_ort1_plus.*~i_moving);
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_UASort_L221DhhGal4_ort1_plus_Helen.*~i_moving);
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_plus_0595Gal4_ort1_DfBSC809.*~i_moving);
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_plus_L221DhhGal4_ort1_DfBSC809_Helen.*~i_moving);

%UASFlagCFPbrp
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_L3MH56Gal4_UASFlagCFPbrp.*~i_moving);
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6F_L221DhhGal4_UASFlagCFPbrp.*~i_moving);

%ort overexpression
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6F_L221DhhGal4_UASort.*~i_moving);

%NorpA rescues
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_NorpA_Rh1NorpA_L2LexA_LexAopGCaMP6f.*~i_moving);
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_NorpA_Rh1NorpA_L3QF_QUAS_GCaMP6f.*~i_moving);

%Rh6
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_NorpA_Rh6NorpA_L2LexA_LexAopGCaMP6f.*~i_moving);

%NorpA rescues panR8
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_NorpA_panR8NorpA_L2LexA_LexAopGCaMP6f.*~i_moving);
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_NorpA_panR8NorpA_L3QF_QUAS_GCaMP6f.*~i_moving);

%NorpA controls
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_panR8_L2LexA_LexAopGCaMP6f.*~i_moving);
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_rh1NorpA_L2LexA_LexAopGCaMP6f.*~i_moving);

% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_panR8_L3QF_QUAS_GCaMP6f.*~i_moving);
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_rh1NorpA_L3QF_QUAS_GCaMP6f.*~i_moving);



% create structures by neuron
fTm9LexA = create_neuron_structure_all_ks(f_Tm9LexA);

% load all the data!
xTm9LexA = load_neuron_data10Hz_ks(fTm9LexA,pdatapath);

% This function groups the different interesting epoch combinations in a
% Matrix, stored in combination_storage
mTm9LexA = aggregate_05StepsON_OFF(xTm9LexA); %in=xTm9LexA




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

% Just those which crossed threshold:
% % cur_ROIs = mTm9LexA.flyID;
% cur_mat = crossing_rats;

% Watch over 20 seconds period
cur_t = linspace(0,20,length(mean_val(1,:)))';


for ii = 1:plots
    
    if abs(sum(mean_val(ii,:))) > THRESHOLD
        fprintf('Signal sum %d: %d \n',ii,abs(sum(mean_val(:,ii))));
        figure(ii);
        hold on;
        
        epochRats = squeeze(crossing_rats(:,ii,:));
        [x,m,e] = mean_cat_full(epochRats,1,mTm9LexA.flyID); %m=mean; e=std
        h1 = plot_err_patch_v2(cur_t,m,e,[0 0 1],[0.8 0.8 1]);
            
        
        xlabel('time (s)');
        ylabel('dF/F - Calcium Signal');
%         ylim([-0.05 0.07]);
        ylim([-1 2]);
        niceaxes;
        title(titles(ii));
        
        legend([h1],sprintf('N = %d ( %d )',size(x,1),size(epochRats,1)),... %ks added
        'location','northeast');
        
        line([0 20],[0 0],'color',[0 0 0]);
        line([0 10 10 20],[0.05 0.05 0.07 0.07],'color',[0 0 0]);
  
        hold off;
    else
        fprintf('Case %d did not cross THRESHOLD (%s).\n',ii,titles{ii});
    end
end
%% Evaluating the correlations between the same contrast differences - over ROIs
close all;

num_steps = size(mean_val,1);
% [x,m,e] = mean_cat_full(epochRats,2,cur_ROIs); %m=m
% cat = category (flyID)
% epochRat = max_data

numROIs = size(crossing_rats,1);

mean_calcium = zeros(1,num_steps);
err_calcium = zeros(1,num_steps);


% There might be some error in here
% % Search max-Signal per ROI and take the mean of all max's per ROI signals
% for kk=1:num_steps
%     %ks: defining the time where we look for the end calcium response
%     end_response = crossing_rats(:,kk,round(0.8*end):round(end)); %the last 4 seconds (16-20s for 20s long epoch)
%     end_response = squeeze(end_response);
% 
%     calcium = nanmean(end_response,2) %nanmean is the mean of X, computed after removing NaN values
%     
%     % take the mean of all steps
%     mean_calcium(kk) = mean(calcium,'omitnan');
%     % Standard error
%     err_calcium(kk) = std(calcium,'omitnan')/sqrt(length(calcium));
%        
%     
% end

% When does the full field get brighter?
on_step = [1 1 1 1 0 1 1 1 0 0 1 1 0 0 0 1 0 0 0 0];
on_step = logical(on_step);
off_step = ~ on_step;

% Calculate the height of the off/on peak
for kk =1:num_steps
    
    baseline = crossing_rats(:,kk,round(0.3*end):round(0.45*end));
    baseline = squeeze(baseline);
    
    baseline = nanmean(baseline,2);
    
    search_peak = crossing_rats(:,kk,round(0.45*end):round(0.9*end));
    calcium = squeeze(nanmean(search_peak,1));
    
    if on_step(kk)
        peak = min(calcium);
    else
        peak = max(calcium);
    end
    
    
    %mean_calcium(kk) = abs(peak-nanmean(baseline));
    mean_calcium(kk) = peak-nanmean(baseline);
    
    % It's kind of unsure which error to take here. One could also take the
    % variance of the maximum peaks of the different ROIs as an error. This would then be a
    % bigger value.
    err_calcium(kk) = std(baseline,'omitnan')/sqrt(length(baseline));
end



% Plot ALL steps-------------------------------------------------
bar_all = figure;
grid on;

% Plot the data only for OFF steps
y1 = mean_calcium(off_step); %ks
x1 = find(off_step);
e1 = err_calcium(off_step);

hold on;
bar(x1,y1,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.0);
errorbar(x1,y1,e1,'rx');

% Plot the data only for ON steps
y2 = mean_calcium(on_step); %ks
x2 = find(on_step);
e2 = err_calcium(on_step);

bar(x2,y2,'FaceColor',[.5 .5 0],'EdgeColor',[.9 .9 0],'LineWidth',1.0);
legend({'OFF Step','Error','ON Step'},'Location','northwest');
errorbar(x2,y2,e2,'rx');
% ylim([0 1.5]); %abs 
ylim([-2.0 3.0]) %no abs

title('All Steps - Signal strength');

% Add titles
ax = gca;
ax.XTick = 1:length(on_step);
ax.XTickLabels = {'100% OFF --> 50% OFF';'100% OFF --> GREY'; '100% OFF --> 50% ON';'100% OFF --> 100% ON';'50% OFF --> 100% OFF';...
    '50% OFF --> GREY ';'50% OFF --> 50% ON';'50% OFF --> 100% ON' ;'GREY --> 100% OFF'; ...
    'GREY --> 50% OFF ';' GREY --> 50% ON'; ' GREY --> 100% ON ';'50% ON --> 100% OFF';'50% ON --> 50% OFF';...
    ' 50% ON --> GREY ';'50% ON --> 100% ON ';'100% ON --> 100% OFF';'100% ON --> 50% OFF';' 100% ON --> GREY ';...
    ' 100% ON --> 50% ON'};
ax.XTickLabelRotation = 45;
ylabel('Absolute height of min (ON)/ max (OFF) peak') ;

hold off;


%% Plot by category - 1 Step ---------------------------------------------
% two_steps = [0 1 0 0 0 1 0 1 0 0 1 0 1 0 0 0 1 0];
% three_steps = [0 0 1 0 0 0 1 0 0 0 0 1 0 0 0 1 0 0];
% one_step = ~ two_steps & ~ three_steps;

%ks:
two_steps = [0 1 0 0 0 1 0 0 1 0 0 1 0 1 0 0 0 0 1 0];
three_steps = [0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 0 0];
four_steps = [0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0]
% one_step = ~ two_steps & ~ three_steps;
one_step = ~ two_steps & ~ three_steps & ~ four_steps;

bar_1 = figure;
grid on;
y1 = mean_calcium(off_step & one_step);
x1 = find(off_step & one_step);
e1 = err_calcium(off_step & one_step);

hold on;
w = 0.5;
bar(x1,y1,w,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.0);
errorbar(x1,y1,e1,'rx');

y2 = mean_calcium(find(on_step & one_step));
x2 = find(on_step & one_step);
e2 = err_calcium(on_step & one_step);

bar(x2,y2,w,'FaceColor',[.5 .5 0],'EdgeColor',[.9 .9 0],'LineWidth',1.0);
errorbar(x2,y2,e2,'rx');
% ylim([-0.6 1.5]);
ylim([-1.0 3.0])

legend({'OFF Step','Error','ON Step'},'Location','northwest');
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
y1 = mean_calcium(off_step & two_steps);
x1 = find(off_step & two_steps);
e1 = err_calcium(off_step &two_steps);

hold on;
w = 0.5;
bar(x1,y1,w,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.0);
errorbar(x1,y1,e1,'rx');

y2 = mean_calcium(find(on_step & two_steps));
x2 = find(on_step & two_steps);
e2 = err_calcium(on_step & two_steps);

bar(x2,y2,w,'FaceColor',[.5 .5 0],'EdgeColor',[.9 .9 0],'LineWidth',1.0);
errorbar(x2,y2,e2,'rx');
% ylim([-0.6 1.5]);
ylim([-1.0 3.0])

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
y1 = mean_calcium(off_step & three_steps);
x1 = find(off_step & three_steps);
e1 = err_calcium(off_step & three_steps);

hold on;
w = 0.5;
bar(x1,y1,w,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.0);
errorbar(x1,y1,e1,'rx');

y2 = mean_calcium(find(on_step & three_steps));
x2 = find(on_step & three_steps);
e2 = err_calcium(on_step & three_steps);

bar(x2,y2,w,'FaceColor',[.5 .5 0],'EdgeColor',[.9 .9 0],'LineWidth',1.0);
errorbar(x2,y2,e2,'rx');
% ylim([-0.6 1.5]);
ylim([-1.0 3.0])

legend({'OFF Step','Error','ON Step'},'Location','northwest');

title('Three Steps - Signal strength');

ax = gca;
ax.XTick = sort([x1, x2]);
ax.XTickLabels = {'-100% -> +50%','-50% -> +100%','+50% -> -100%','+100% -> -50%'};
ax.XTickLabelRotation = 45;

hold off;


%% End at a certain luminance (by katja)--------------------------------------------------------------

close all;

num_steps = size(mean_val,1);
% [x,m,e] = mean_cat_full(epochRats,2,cur_ROIs); %m=m
% cat = category (flyID)
% epochRat = max_data

numROIs = size(crossing_rats,1);

mean_calcium = zeros(1,num_steps);
err_calcium = zeros(1,num_steps);


% Search max-Signal per ROI and take the mean of all max's per ROI signals
for kk=1:num_steps
    %ks: defining the time where we look for the end calcium response
%     mean_response = crossing_rats(:,kk,end/2:round(end*0.6)); 
%     mean_response = crossing_rats(:,kk,round(0.5*end):end); 
    mean_response = crossing_rats(:,kk,round(0.8*end):end); 
    mean_response = squeeze(mean_response);

    calcium = nanmean(mean_response,2) %nanmean is the mean of X, computed after removing NaN values
    
    % take the mean of all steps
    mean_calcium(kk) = mean(calcium,'omitnan');
    % Standard error
    err_calcium(kk) = std(calcium,'omitnan')/sqrt(length(calcium))
       
    
end



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
y1 = mean_calcium(OFF_100);
x1 = find(OFF_100);
e1 = err_calcium(OFF_100);

hold on;
w = 0.5;
bar(x1,y1,w,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.0);
errorbar(x1,y1,e1,'rx');




y2 = mean_calcium(find(OFF_50));
x2 = find(OFF_50);
e2 = err_calcium(OFF_50);

bar(x2,y2,w,'FaceColor',[.5 .5 0],'EdgeColor',[.9 .9 0],'LineWidth',1.0);
errorbar(x2,y2,e2,'rx');
ylim([-0.6 1]);



y3= mean_calcium(find(grey));
x3 = find(grey);
e3 = err_calcium(grey);

bar(x3,y3,w,'FaceColor',[.1 .5 0],'EdgeColor',[.2 .9 .9],'LineWidth',1.0);
errorbar(x3,y3,e3,'rx');
ylim([-0.6 1]);




y4= mean_calcium(find(ON_50));
x4 = find(ON_50);
e4 = err_calcium(ON_50);

bar(x4,y4,w,'FaceColor',[.8 .5 0],'EdgeColor',[.7 .9 .9],'LineWidth',1.0);
errorbar(x4,y4,e4,'rx');
ylim([-0.6 1]);



y5= mean_calcium(find(ON_100));
x5 = find(ON_100);
e5 = err_calcium(ON_100);

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

%% End at certain luminance (by fabiola) (let Katja's part run before, for now)----------

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
% ylim([-0.5 2.0]); %for L2
ylim([-0.5 3.0]);
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
 'YTick'       , -0.5:0.5:3, ...
 'LineWidth'   , 1         );
hold on;

[fitresult,gof,h] = createFitFFF (1:5,means_all);
set(h, 'LineWidth', 2,...
   'Color'       , 'k');
ylabel ('df/F(maximal luminance)');
text(4.5,0.1,[num2str(fitresult.a),'exp^(',num2str(fitresult.b),'*x)']);


% ylim([-0.5 4.0]);
hold off;



%% Plateau responses coming to 100% OFF

%      100% OFF --> 50% OFF';'100% OFF --> GREY'; '100% OFF --> 50% ON';'100% OFF --> 100% ON';'50% OFF --> 100% OFF';...
%     '50% OFF --> GREY ';'50% OFF --> 50% ON';'50% OFF --> 100% ON' ;'GREY --> 100% OFF'; ...
%     'GREY --> 50% OFF ';' GREY --> 50% ON'; ' GREY --> 100% ON ';'50% ON --> 100% OFF';'50% ON --> 50% OFF';...
%     ' 50% ON --> GREY ';'50% ON --> 100% ON ';'100% ON --> 100% OFF';'100% ON --> 50% OFF';' 100% ON --> GREY ';...
%     ' 100% ON --> 50% ON'

two_steps_100OFF = [0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0];
three_steps_100OFF = [0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0];
four_steps_100OFF = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0];
one_step_100OFF = [0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];



bar_1 = figure;
grid on;
y1 = mean_calcium(off_step & one_step_100OFF);
x1 = find(off_step & one_step_100OFF);
e1 = err_calcium(off_step & one_step_100OFF);

hold on;
w = 0.5;
bar(x1,y1,w,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.0);
errorbar(x1,y1,e1,'rx');

y2 = mean_calcium(find(off_step & two_steps_100OFF));
x2 = find(off_step & two_steps_100OFF);
e2 = err_calcium(off_step & two_steps_100OFF);

bar(x2,y2,w,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.0);
errorbar(x2,y2,e2,'rx');
% ylim([-0.6 1.5]);
ylim([-1.0 3.0])


y3 = mean_calcium(find(off_step & three_steps_100OFF));
x3 = find(off_step & three_steps_100OFF);
e3 = err_calcium(off_step & three_steps_100OFF);

bar(x3,y3,w,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.0);
errorbar(x3,y3,e3,'rx');
% ylim([-0.6 1.5]);
ylim([-1.0 3.0])


y4 = mean_calcium(find(off_step & four_steps_100OFF));
x4 = find(off_step & four_steps_100OFF);
e4 = err_calcium(off_step & four_steps_100OFF);

bar(x4,y4,w,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.0);
errorbar(x4,y4,e4,'rx');
% ylim([-0.6 1.5]);
ylim([-1.0 3.0])


% legend({'OFF Step','Error','ON Step'},'Location','northwest');
title('Plateau responses to 100% OFF');

ax = gca;
ax.XTick = sort([x1, x2, x3, x4]);
ax.XTickLabels = {'-50% -> -100%','GREY -> -100%','50% -> -100%','100% -> -100%'};
ax.XTickLabelRotation = 45;

hold off;



%% Just if needed: Printing - Sorted by FlyID (there will be lots of plots!)
% close all;
% 
% num_flies = length(unique(mTm9LexA.flyID));
% fly_ID = unique(mTm9LexA.flyID);
% 
% % Do the same like above, just now for each fly
% for ii=1:num_flies
%     this_fly = fly_ID(ii);
%     
%     temp = zeros(size(mTm9LexA.rats));
%     counter = 1;
%     
%     % Select data recorded from this fly
%     for jj=1:length(mTm9LexA.rats)
%         
%         if(mTm9LexA.flyIDpN(jj)==this_fly)
%             temp(:,:,counter) = crossing_rats(:,:,jj);
%             counter = counter +1;
%         end
%     end
%     
%     % Mean
%     temp = temp(:,:,1:counter);
%     temp = mean(temp,3,'omitnan');
%     
%     % Prepare plots
%     plots = length(temp(1,:));
%     fly_string = strcat('Fly #',num2str(this_fly),' ');
%     
%     % Plot for all interesting epoch combinations
%     for hh = 1:plots
%    
%         if abs(sum(mean_val(:,ii))) > THRESHOLD
%             fprintf('Signal sum %d: %d \n',ii,abs(sum(mean_val(:,ii))));
%             figure(ii*plots + hh);
%           %  hold on;
%             
%             epochRats = squeeze(cur_mat(:,hh,:));
%             [x,m,e] = mean_cat_full(epochRats,2,mTm9LexA.flyIDpN); %m=mean; e=std
%             h1 = plot_err_patch_v2(cur_t,m,e,[0 0 1],[0.8 0.8 1]);
%             
%             xlabel('time (s)');
%             ylabel('dF/F - Calcium Signal');
%             ylim([-0.4 1]);
%             niceaxes;
%             title([fly_string,titles(hh)]);
%             
%             line([0 20],[0 0],'color',[0 0 0]);
%             flash = line([10 10],[-0.4 1],'color',[0.5 0.5 1], 'LineWidth',4,'LineStyle',':');
%             legend(flash,'Stimulus flash','location','northeast');
%           %  hold off;
%         else
%             fprintf('Case %d did not cross THRESHOLD (%s).\n',ii,titles{ii});
%         end
%         
%     end
% 
% end
