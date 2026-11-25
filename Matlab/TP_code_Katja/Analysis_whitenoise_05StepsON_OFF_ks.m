%% Analysis_whitenoise_05StepsON_OFF_ks_ms.m
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
% f_Tm9LexA = find(i_whitenoise_5steps1s.*i_UASGCaMP6F_L221DhhGal4_cross_to_w.*~i_moving);
% f_Tm9LexA = find(i_whitenoise_5steps1s.*i_UASGCaMP6f_L3MH56Gal4_cross_to_w.*~i_moving);

%ND filters
% f_Tm9LexA = find(i_whitenoise_5steps1s.*i_UASGCaMP6F_L221DhhGal4_cross_to_w_06.*~i_moving);
f_Tm9LexA = find(i_whitenoise_5steps1s.*i_UASGCaMP6f_L3MH56Gal4_cross_to_w_06.*~i_moving);


% create structures by neuron
fTm9LexA = create_neuron_structure_all_ks(f_Tm9LexA);

% load all the data!
xTm9LexA = load_neuron_data10Hz_ks(fTm9LexA,pdatapath);

% This function groups the different interesting epoch combinations in a
% Matrix, stored in combination_storage
mTm9LexA = aggregate_whitenoise_05StepsON_OFF1s(xTm9LexA);

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
    ' 50% ON --> GREY ';'50% ON --> 100% ON ';'100% ON --> 100% OFF';'100% ON --> 50 OFF';' 100% ON --> GREY ';...
    ' 100% ON --> 50 % ON'};

% Just those which crossed threshold:
% % cur_ROIs = mTm9LexA.flyID;
% cur_mat = crossing_rats;

% Watch over 2 seconds period
cur_t = linspace(0,2,length(mean_val(1,:)))';

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
        
        line([0 2],[0 0],'color',[0 0 0]);
        line([0 1 1 2],[0.05 0.05 0.07 0.07],'color',[0 0 0]);
  
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

mean_calciumStep = zeros(1,num_steps);
err_calciumStep = zeros(1,num_steps);



% Search max-Signal per ROI and take the mean of all max's per ROI signals
for kk=1:num_steps
    
    %ks: defining the time where we look for the baseline
    baseline = crossing_rats(:,kk,round(0.4*end):round(0.5*end)); %0.8s-1s for 2*1s step
    baseline = squeeze(baseline);
    %ks: defining the time where we look for the response
    response = crossing_rats(:,kk,round(0.5*end)+1:round(0.6*end)); %1s-1.2s for 2*1s step
    response = squeeze(response);
    
    %test if you're looking for an increase or a decrease in calcium (for each trace):
    decreasingCa = nanmean(baseline,2) - nanmean(response,2) >= 0; %nanmean is the mean of X, computed after removing NaN values
    increasingCa = nanmean(squeeze(baseline),2) - nanmean(squeeze(response),2) < 0;
    
    calciumStep = zeros(numROIs,1);
    for ii = 1:numROIs
        if decreasingCa(ii)
            calciumStep(ii) = min(response(ii,:)) - max(baseline(ii,:));
        elseif increasingCa(ii) %this is necessary, if there are NaNs, both logicals are 0
            calciumStep(ii) = max(response(ii,:)) - min(baseline(ii,:));  %        
        else
            calciumStep(ii) = NaN;
        end
    end
    
    % take the mean of all steps
    mean_calciumStep(kk) = mean(calciumStep,'omitnan');
    % Standard error
    err_calciumStep(kk) = std(calciumStep,'omitnan')/sqrt(length(calciumStep));
       
    
end


% When does the full field get brighter?
% on_step = [1 1 1 0 1 1 1 0 0 1 1 0 0 0 1 0 0 0]; %18 steps
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
% ylim([-0.6 1.5]);
ylim([-0.2 0.3]);

title('All Steps - Signal strength');

% Add titles
ax = gca;
ax.XTick = 1:20;
ax.XTickLabels = {'100% OFF --> 50% OFF';'100% OFF --> GREY'; '100% OFF --> 50% ON';'100% OFF --> 100% ON';'50% OFF --> 100% OFF';...
    '50% OFF --> GREY ';'50% OFF --> 50% ON';'50% OFF --> 100% ON' ;'GREY --> 100% OFF'; ...
    'GREY --> 50% OFF ';' GREY --> 50% ON'; ' GREY --> 100% ON ';'50% ON --> 100% OFF';'50% ON --> 50% OFF';...
    ' 50% ON --> GREY ';'50% ON --> 100% ON ';'100% ON --> 100% OFF';'100% ON --> 50 OFF';' 100% ON --> GREY ';...
    ' 100% ON --> 50 % ON'};
ax.XTickLabelRotation = 45;

hold off;

%% Evaluating the correlations between the same contrast differences - over flyIDs
close all;

num_steps = size(mean_val,1);
% [x,m,e] = mean_cat_full(epochRats,2,cur_ROIs); %m=m
% cat = category (flyID)
% epochRat = max_data

numROIs = size(crossing_rats,1);
numFlies = length(unique(mTm9LexA.flyID));

mean_calciumStep = zeros(1,num_steps);
err_calciumStep = zeros(1,num_steps);



% Search max-Signal per ROI and take the mean of all max's per ROI signals
for kk=1:num_steps
    
    traces = squeeze(mTm9LexA.rats(:,kk,:)); %because mean_cat_full works only with 2 dimensions %taking all ROIs, the epoch we are one, full lenth (200)
    [x,m,e] = mean_cat_full(traces,1,mTm9LexA.flyID); %m=mean; e=std
   
    
    
    %ks: defining the time where we look for the baseline
    baseline = x(:,round(0.4*end):round(0.5*end)); %8-10s for 2*10s step
%     baseline = squeeze(baseline);
    %ks: defining the time where we look for the response
    response = x(:,round(0.5*end)+1:round(0.6*end)); %10-12s for 2*10s step
%     response = squeeze(response);
    
    %test if you're looking for an increase or an decrease in calcium (for each trace):
    decreasingCa = nanmean(baseline,2) - nanmean(response,2) >= 0; %nanmean is the mean of X, computed after removing NaN values
    increasingCa = nanmean(squeeze(baseline),2) - nanmean(squeeze(response),2) < 0;
    
    calciumStep = zeros(numFlies,1);
    for ii = 1:numFlies
        if decreasingCa(ii)
            calciumStep(ii) = min(response(ii,:)) - max(baseline(ii,:));
        elseif increasingCa(ii) %this is necessary, if there are NaNs, both logicals are 0
            calciumStep(ii) = max(response(ii,:)) - min(baseline(ii,:));  %        
        else
            calciumStep(ii) = NaN;
        end
    end
    
    % take the mean off all steps
    mean_calciumStep(kk) = mean(calciumStep,'omitnan');
    % Standard error
    err_calciumStep(kk) = std(calciumStep,'omitnan')/sqrt(length(calciumStep));
       
    
end


% When does the full field get brighter?
on_step = [1 1 1 0 1 1 1 0 0 1 1 0 0 0 1 0 0 0];
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
ax.XTick = 1:18;
ax.XTickLabels = {'-100% -> -50%','-100% -> GREY','-100% -> +50%','-50% -> -100%', '-50% -> GREY','-50% -> +50%',...
    '-50% -> +100% ','GREY -> -100%','GREY -> -50%' ,'GREY -> +50%', ...
    'GREY -> +100%','+50 -> -100%', '+50% -> -50%','+50% -> GREY',...
    '+50% -> +100%','+100% -> -50% ','+100% -> GREY ',...
    '+100% -> +50%'};
ax.XTickLabelRotation = 45;

hold off;

%% Plot by category - 1 Step ---------------------------------------------
two_steps = [0 1 0 0 0 1 0 0 1 0 0 1 0 1 0 0 0 0 1 0];
three_steps = [0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 0 0];
four_steps = [0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0] %ks added
% one_step = ~ two_steps & ~ three_steps;
one_step = ~ two_steps & ~ three_steps & ~ four_steps; %ks added

bar_1 = figure;
grid on;
y1 = mean_calciumStep(off_step & one_step);
x1 = find(off_step & one_step);
e1 = err_calciumStep(off_step & one_step);

hold on;
w = 0.5;
bar(x1,y1,w,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.0);
errorbar(x1,y1,e1,'rx');

y2 = mean_calciumStep(find(on_step & one_step));
x2 = find(on_step & one_step);
e2 = err_calciumStep(on_step & one_step);

bar(x2,y2,w,'FaceColor',[.5 .5 0],'EdgeColor',[.9 .9 0],'LineWidth',1.0);
errorbar(x2,y2,e2,'rx');
% ylim([-0.6 1.5]);
ylim([-0.6 1.0]);

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
% ylim([-0.6 1.5]);
ylim([-0.6 1.0]);

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
% ylim([-0.6 1.5]);
ylim([-0.6 1.0]);

legend({'OFF Step','Error','ON Step'},'Location','northwest');

title('Three Steps - Signal strength');

ax = gca;
ax.XTick = sort([x1, x2]);
ax.XTickLabels = {'-100% -> +50%','-50% -> +100%','+50% -> -100%','+100% -> -50%'};
ax.XTickLabelRotation = 45;

hold off;
%% Just if needed: Printing - Sorted by FlyID (there will be lots of plots!)
close all;

num_flies = length(unique(mTm9LexA.flyID));
fly_ID = unique(mTm9LexA.flyID);

% Do the same like above, just now for each fly
for ii=1:num_flies
    this_fly = fly_ID(ii);
    
    temp = zeros(size(mTm9LexA.rats));
    counter = 1;
    
    % Select data recorded from this fly
    for jj=1:length(mTm9LexA.rats)
        
        if(mTm9LexA.flyIDpN(jj)==this_fly)
            temp(:,:,counter) = crossing_rats(:,:,jj);
            counter = counter +1;
        end
    end
    
    % Mean
    temp = temp(:,:,1:counter);
    temp = mean(temp,3,'omitnan');
    
    % Prepare plots
    plots = length(temp(1,:));
    fly_string = strcat('Fly #',num2str(this_fly),' ');
    
    % Plot for all interesting epoch combinations
    for hh = 1:plots
   
        if abs(sum(mean_val(:,ii))) > THRESHOLD
            fprintf('Signal sum %d: %d \n',ii,abs(sum(mean_val(:,ii))));
            figure(ii*plots + hh);
          %  hold on;
            
            epochRats = squeeze(cur_mat(:,hh,:));
            [x,m,e] = mean_cat_full(epochRats,2,mTm9LexA.flyIDpN); %m=mean; e=std
            h1 = plot_err_patch_v2(cur_t,m,e,[0 0 1],[0.8 0.8 1]);
            
            xlabel('time (s)');
            ylabel('dF/F - Calcium Signal');
            ylim([-0.4 1]);
            niceaxes;
            title([fly_string,titles(hh)]);
            
            line([0 20],[0 0],'color',[0 0 0]);
            flash = line([10 10],[-0.4 1],'color',[0.5 0.5 1], 'LineWidth',4,'LineStyle',':');
            legend(flash,'Stimulus flash','location','northeast');
          %  hold off;
        else
            fprintf('Case %d did not cross THRESHOLD (%s).\n',ii,titles{ii});
        end
        
    end

end

%% Plotting a raw trace together with a stimulus
close all;

plot(mTm9LexA.rats,x)
title('raw trace');
ylim([-0.8 2.0]);
set(gcf,'Color','w');
niceaxes;
