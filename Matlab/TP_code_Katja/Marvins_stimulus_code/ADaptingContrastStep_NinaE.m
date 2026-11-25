%% Name of stimulus here.
% Stimulus works like a step function. Has 5 epochs which are displayed in
% order 0-4, increasing luminance.
% 
%


clear all;
close all;
clc;

% Change this variable to your pData path
pdatapath='/Users/ksporar/Documents/MATLAB/Katja_pData';
addpath(pdatapath);
cd(pdatapath);
ndFilter = 0
OFF_stimulus = 1 %1 in case its the OFF OFF stimulus 0 in case its the ON ON stimulus
DataLoad = 'NinaE-GCaMP6m';
% For the code
% addpath('W:\f.buschendorf\TP_code_Katja');

% fetch Information from Masterfoldersummary
database_select_samples_ks;

%% Processing Data 

% find matching pData files
% f_Tm9LexA = find(i_FullField_OFF_2s_OFF_2s.*i_UASort_UASGCaMP6f_L221DhhGal4_ort1_DfBSC809_Helen.*~i_moving);


%NinaE-GCaMP6m
% f_Tm9LexA = find(i_FullField_OFF_2s_OFF_2s.*i_NinaEGCaMP6m.*~i_moving);

%only nice ones:
f_Tm9LexA = find(i_FullField_OFF_2s_OFF_2s.*i_NinaEGCaMP6m.*~i_moving.*((flyID==681)|(flyID==683)|(flyID==684)|(flyID==689)|(flyID==690)|(flyID==692)|(flyID==693)));

%Without the bad ones:
% f_Tm9LexA = find(i_FullField_OFF_2s_OFF_2s.*i_NinaEGCaMP6m.*~i_moving.*((flyID~=691)|(flyID~=687)|(flyID~=688)));





% create structures by neuron
fTm9LexA = create_neuron_structure_all_ks(f_Tm9LexA);

% load all the data!
xTm9LexA = load_neuron_data10Hz_ks(fTm9LexA,pdatapath);

% This function groups the different interesting epoch combinations in a
% Matrix, stored in combination_storage
mTm9LexA = aggregate_Adaptingcontrast_test(xTm9LexA,OFF_stimulus);
mTm9LexA.OFF_stimulus = OFF_stimulus;
CorrelationA = crosscorrelation_negative(mTm9LexA); %Not ready yet
    
% if OFF_stimulus==1
%     negativecorr = CorrelationA.posresponse;
% elseif OFF_stimulus == 0
    negativecorr = CorrelationA.negresponse;
% end
negativecorr = logical(negativecorr);
Sample_size = length(unique(mTm9LexA.flyID));
    
%% Test plots to check data
%The data for all steps is ploted together in one plot with several
%subplots and independently for all the steps.
% % % N_ROIs = size(mTm9LexA.rats,1);
% % % N_EPOCHs = size(mTm9LexA.rats,2);
% % % for cc = 1:N_EPOCHs
% % %   rats(:,cc,:) = mTm9LexA.rats(negativecorr,cc,:);
% % %   
% % % end
% % % close all;

N_ROIs = size(mTm9LexA.rats,1);
N_EPOCHs = size(mTm9LexA.rats,2);
for cc = 1:N_EPOCHs
  rats = mTm9LexA.rats;
  
end
close all;





% How many seconds ?????
cur_t5 = linspace(0,1,size(mTm9LexA.rats,2))';
cur_t = linspace(0,1,size(mTm9LexA.rats,3))';


for ii =1:N_EPOCHs
%    figure(ii);
    hSubplot(ii) = subplot(7, 1, ii);
    hold on;
    epochRats = squeeze(rats(:,ii,:));
    [x,m,e] = mean_cat_full(epochRats,1,mTm9LexA.flyID); %m=mean; e=std
    h1 = plot_err_patch_v2((36*cur_t),m,e,[0 0 1],[0.8 0.8 1]);
   
    if ii ~= N_EPOCHs
        set(gca, 'XTick', [])
    end
   set(gca,'YGrid'       , 'on');
    set(gca, 'box', 'off');
    set(gca, 'ylim', [-0.5 0.5]);
%     niceaxes;
    hold off;
end
%     title(['Epoch ',num2str(ii)]);

     xlabel('time (s)');
    ylabel('dF/F - Calcium Signal');
    legend('error',['n = ' num2str(Sample_size)]);


for ii =1:N_EPOCHs
   figure(10*ii);
   hold on;
   
   epochRats = squeeze(rats(:,ii,120:230));
   [x,m,e] = mean_cat_full(epochRats,1,mTm9LexA.flyID); %m=mean; e=std
   h1 = plot_err_patch_v2(cur_t(120:230,1),m,e,[0 0 1],[0.8 0.8 1]);
   
   xlabel('time (s)');
   ylabel('dF/F - Calcium Signal');

   title(['Epoch ',num2str(ii)]);
   niceaxes;
  hold off;

legend('error',['n = ' num2str(Sample_size)]);
end
 %% Evaluating the responses to the first contrast step
 %here the response to the a steps of the stimulus will be evaluated. 
close all
clear ax
 THRESHOLD = 0;
fprintf('THRESHOLD for Signal sum: %d \n',THRESHOLD );

% take a mean of all assigned values, ignore 0
crossing_rats = mTm9LexA.rats; % Take all ROIs
% crossing_rats = rats; % Take only negative corelated ROIs
crossing_rats(crossing_rats==0) = NaN;

% Mean over all ROI's
mean_val = squeeze(mean(crossing_rats,1,'omitnan'));

numROIs = size(crossing_rats,1);
num_steps = (size(mean_val,1));
% [x,m,e] = mean_cat_full(epochRats,2,cur_ROIs); %m=m
% cat = category (flyID)
% epochRat = max_data



mean_calciumStep = zeros(1,num_steps-1);
err_calciumStep = zeros(1,num_steps-1);



% Search max-Signal per ROI and take the mean of all max's per ROI signals
for kk=1:num_steps-1
    
    %ks: defining the time where we look for the baseline
    baseline = crossing_rats(:,kk,100:150); %8-10s for 2*10s step
    baseline = squeeze(baseline);
    %ks: defining the time where we look for the response
    response = crossing_rats(:,kk,150:180); %10-12s for 2*10s step
    response = squeeze(response);
    
    %test if you're looking for an increase or a decrease in calcium (for each trace):
    decreasingCa = nanmean(baseline,2) - nanmean(response,2) >= 0; %nanmean is the mean of X, computed after removing NaN values
    increasingCa = nanmean(squeeze(baseline),2) - nanmean(squeeze(response),2) < 0;
    
    calciumStep = zeros(numROIs,1);
    for ii = 1:numROIs
        if decreasingCa(ii)
            calciumStep(ii) = min(response(ii,:)) - mean(baseline(ii,:));  %mars: Probably wrong because the min vs. max is not necessary the value we are looking for!?
        elseif increasingCa(ii) %this is necessary, if there are NaNs, both logicals are 0
            calciumStep(ii) = min(response(ii,:)) - mean(baseline(ii,:));  %        
        else
            calciumStep(ii) = NaN;
        end
    end
    
    % take the mean of all steps
    mean_calciumStep(kk) = mean(calciumStep,'omitnan');
    % Standard error
    err_calciumStep(kk) = std(calciumStep,'omitnan')/sqrt(length(calciumStep));
     
    
end




%% Contrast step
%This parts calculates the response to the B step.

close all
 THRESHOLD = 0;
fprintf('THRESHOLD for Signal sum: %d \n',THRESHOLD );

% take a mean of all assigned values, ignore 0
crossing_rats = mTm9LexA.rats; % Take all ROIs
% crossing_rats = rats; % Take only negative corelated ROIs
crossing_rats(crossing_rats==0) = NaN;

% Mean over all ROI's
mean_val = squeeze(mean(crossing_rats,1,'omitnan'));

numROIs = size(crossing_rats,1);
num_steps = (size(mean_val,1));
% [x,m,e] = mean_cat_full(epochRats,2,cur_ROIs); %m=m
% cat = category (flyID)
% epochRat = max_data



mean_ContrastStep = zeros(1,num_steps-1);
err_ContrastStep = zeros(1,num_steps-1);



% Search max-Signal per ROI and take the mean of all max's per ROI signals
for kk=1:num_steps-1
    
    %ks: defining the time where we look for the baseline
    baseline_Contrast = crossing_rats(:,kk,(100:150)); %8-10s for 2*10s step
    baseline_Contrast = squeeze(baseline_Contrast);
    %ks: defining the time where we look for the response
    response_Contrast = crossing_rats(:,kk,(180:210)); %10-12s for 2*10s step
    response_Contrast = squeeze(response_Contrast);
    
    
    ContrastStep = zeros(numROIs,1);
    for ii = 1:numROIs
        %this is necessary, if there are NaNs, both logicals are 0
            ContrastStep(ii) = min(response_Contrast(ii,:)) - mean(baseline_Contrast(ii,:));  %        
       
    end
    
    % take the mean of all steps
    mean_ContrastStep(kk) = mean(ContrastStep,'omitnan');
    % Standard error
    err_ContrastStep(kk) = std(ContrastStep,'omitnan')/sqrt(length(calciumStep));
     
    
end



%% Graphs

%Here all the data is plotted in several different ways. 



%These are the measured luminance and contrast values for the stimulus
real_contrast = [-0.244835501000000 -0.258178603000000 -0.254310345000000 -0.268874172000000 -0.262681159000000 -0.234828496000000 ];
real_contrast1 = [-0.262831359 -0.362098139 -0.476593345 -0.574168077 -0.688663283 -0.786238015 ];

real_luminance = [0.435666667 0.377 0.309333333 0.251666667 0.184 0.126333333 ];
real_luminance1 = [0.329 0.279666667 0.230666667 0.184 0.135666667 0.096666667 ];
%  
Difference_luminance = [-0.155333333, -0.214 -0.281666667 -0.339333333 -0.407 -0.464666667];
Difference_luminance1 =[-0.106666667 -0.097333333 -0.078666667 -0.067666667 -0.048333333 -0.029666667];

%Difference_LuminanceStep = real_luminance - real_luminance1;
% 
%  
% response_contrast = mean_ContrastStep .* abs(real_contrast);
% response_luminance = mean_calciumStep .* abs(real_luminance);
% 
% DifferenceSteps = mean_ContrastStep- mean_calciumStep;

%The data is plotted as a function of the real luminance after the step. 
figure('Units', 'pixels', 'Position',[100 100 500 375]);
grid on;

y1 = mean_calciumStep; %ks
x1 =     real_luminance; %Difference_luminance;  %real_luminance;
switch ndFilter
    case 0.6
        x1 = x1 / 4;
        real_luminance = real_luminance/4;
        Difference_luminance = Difference_luminance/4;
    case 1
        x1 = x1 / 10;
    otherwise
        x1 = x1;
end
e1 = err_calciumStep;

hold on;
Luminanceplot(1) = scatter(x1,y1,75,'filled','r','DisplayName','A Step (linear increasing contrast Steps)');
Luminanceplot(2) = errorbar(x1,y1,e1,'r','Linestyle','none','DisplayName','Standart error of the mean');

%This calculates a regression line and a confidence interval for that
%regression line. It is so far not possible to plot a weighted regression
%line plus the convidence interval to that regression line. 



% Weighted fitt
% clear Regression1
% Regression1(1,:) = real_luminance;
% Regression1(2,:) = mean_calciumStep;
% Regression1(3,:) = e1;
% Regression1 = Regression1';
% hold on
% Fitt1 = weightedfit (Regression1);


%Not weighted fitt with confidence intervals for the first step
%Plot a regression line
[coeffs1,S1] = polyfit(x1, y1, 1);
% Get fitted values
fittedX1 = linspace(min(x1), max(x1), 6);
fittedY1 = polyval(coeffs1, fittedX1);
% Plot the fitted line
hold on;
Luminanceplot(3) =  plot(fittedX1, fittedY1, 'k--', 'LineWidth', 1,'DisplayName','Linear regression');
Error_Fit1 = polyval(coeffs1,x1);
T1 = table(x1,y1,Error_Fit1,y1-Error_Fit1,'VariableNames',{'X','Y','Fit','FitError'});
% Calculate the confidence values and plot the confidence lines 
% The error is not yet included
[Y1,DELTA1] = polyconf(coeffs1,fittedX1,S1,'alpha',0.05);
% fittedX1 = sort(fittedX1,'descend');
Luminanceplot(4) = plot(fittedX1,Y1+DELTA1,'r--','DisplayName','95% confidence interval');
plot(fittedX1,Y1-DELTA1,'r--');
% Plot the data only for ON steps
y2 = mean_ContrastStep; %ks
x2 =  real_luminance1; % Difference_luminance1;  %real_luminance1;
switch ndFilter
    case 0.6
        x2 = x2 / 4;
        real_luminance1 = real_luminance1/4;
        Difference_luminance1 = Difference_luminance1/4; 
    case 1
        x2 = x2 / 10;
    otherwise
        x2 = x2;
end
e2 = err_ContrastStep;

ylim([-0.6 0.2]);
hold on
Luminanceplot(5) = scatter(x2,y2,75,'filled','b','DisplayName','B Step (25% contrast change');
hold on
Luminanceplot(6) =  errorbar(x2,y2,e2,'b','Marker','none','Linestyle', 'none','MarkerFaceColor','b','DisplayName','Standart error of the mean');
hold on



% clear Regression2
% Regression2(1,:) = real_luminance1;
% Regression2(2,:) = mean_ContrastStep;
% Regression2(3,:) = e2;
% Regression2 = Regression2';
% hold on
% Fitt2 = weightedfit (Regression2);


%Not weighted fitt with confidence intervals for the second step

%errorbar(x2,y2,e2,'none','b','DisplayName','Standart error of the mean');

[coeffs2,S2] = polyfit(x2, y2, 1);
% Get fitted values
fittedX2 = linspace(min(x2), max(x2), 6);
fittedY2 = polyval(coeffs2, fittedX2);
% Plot the fitted line
hold on;
Luminanceplot(7) = plot(fittedX2, fittedY2, 'k--', 'LineWidth', 2,'DisplayName','Linear regression');
%Calculate the confidence values and plot the confidence lines 
%The error is not yet included
[Y2,DELTA2] = polyconf(coeffs2,fittedX2,S2,'alpha',0.05);
% fittedX2 = sort(fittedX2,'descend');
Luminanceplot(8) = plot(fittedX2,Y2+DELTA2,'b--','DisplayName','95 % confidence interval');
plot(fittedX2,Y2-DELTA2,'b--', 'DisplayName','none');

Error_Fit2 = polyval(coeffs2,x2);
T2 = table(x2,y2,Error_Fit2,y2-Error_Fit2,'VariableNames',{'X','Y','Fit','FitError'});
hold on 
xlabel('Luminance');
fprintf(['n = ' num2str(Sample_size)]);
title('L2 Response to linear increasing and 25% contrast steps');
ylabel('dF/F');
legend(Luminanceplot(1:8),'location','best');
ax = gca;
ax.FontSize = 24;
set(gca, ...
  'Box'         , 'off'     , ...
  'TickDir'     , 'out'     , ...
  'TickLength'  , [.02 .02] , ...
  'XMinorTick'  , 'on'      , ...
  'YMinorTick'  , 'on'      , ...
  'YGrid'       , 'on'      , ...
  'XColor'      , [.2 .2 .2], ...
  'YColor'      , [.2 .2 .2], ...
  'YTick'       , -0.6:0.1:0.2, ...
  'LineWidth'   , 1         );

% print(['C:\Matlab\Working_Data\FigureData\Response_over_Luminance_',num2str(DataLoad)],'-depsc')

hold off;


plot_contrast = figure;

%This plots the measured values for luminance and contrast to show the
%characteristics of the stimulus in a plot

y3 = abs(real_contrast);
x3 = real_luminance1;

plot(x3,y3,'-xk','DisplayName','real contrast 25% contrast step');

y4 = abs(real_contrast1);
x4 = real_luminance;
hold on
plot (x4,y4,'-*k','DisplayName','real contrast linear increasing contrast steps');
ylim([0 2]);
% ylim([-0.6 1.9]);
% ylim([-0.9 1.5]);
hold off
xlabel('Luminance before the step');
grid on
ylabel('Contrast of the step (arb. unit)');
legend('show');
title('Real contrast changes of the stimulus');







plot_luminance = figure;

y5 = abs(real_luminance);
x5 = [1 2 3 4 5 6];

plot(x5,y5,'-xk','DisplayName','real luminance A step');

y6 = real_luminance1;
x6 = [1 2 3 4 5 6];
hold on
plot (x6,y6,'-*k','DisplayName','real luminance B step');
ylim([0 0.6]);
% ylim([-0.6 1.9]);
% ylim([-0.9 1.5]);
hold off
xlabel('Step');
grid on
ylabel('Luminance of the step (Lv)');
legend('show');
title('Real luminance of the stimulus');
%% Last ON  step in the OFF_OFF stimulus



close all
 THRESHOLD = 0;
fprintf('THRESHOLD for Signal sum: %d \n',THRESHOLD );

% take a mean of all assigned values, ignore 0
crossing_rats = mTm9LexA.rats; % Take all ROIs
% crossing_rats = rats; % Take only negative corelated ROIs
crossing_rats(crossing_rats==0) = NaN;

% Mean over all ROI's
mean_val = squeeze(mean(crossing_rats,1,'omitnan'));

numROIs = size(crossing_rats,1);
num_steps = (size(mean_val,1));
% [x,m,e] = mean_cat_full(epochRats,2,cur_ROIs); %m=m
% cat = category (flyID)
% epochRat = max_data



mean_LastStep = zeros(1,num_steps);
err_LastStep = zeros(1,num_steps);



% Search max-Signal per ROI and take the mean of all max's per ROI signals
for kk=1:num_steps
    
    %ks: defining the time where we look for the baseline
    baseline_Contrast = crossing_rats(:,kk,(120:150)); %8-10s for 2*10s step
    baseline_Contrast = squeeze(baseline_Contrast);
    %ks: defining the time where we look for the response
    response_Contrast = crossing_rats(:,kk,(210:230)); %10-12s for 2*10s step
    response_Contrast = squeeze(response_Contrast);
    
    
    LastStep = zeros(numROIs,1);
    for ii = 1:numROIs
        %this is necessary, if there are NaNs, both logicals are 0
            LastStep(ii) = min(response_Contrast(ii,:)) - mean(baseline_Contrast(ii,:));  %        
       
    end
    
    % take the mean of all steps
    mean_LastStep(kk) = mean(LastStep,'omitnan');
    % Standard error
    err_LastStep(kk) = std(LastStep,'omitnan')/sqrt(length(LastStep));
     
    
end




%% Plot ALL steps over contrast

bar_all2 = figure;
grid on;

% Plot the data only for OFF steps
y1 = mean_calciumStep; %ks
x1 = real_contrast1;
e1 = err_calciumStep;

hold on;
ContrastGra(1) = scatter(x1,y1,75,'filled','r','DisplayName','A Step (linear increasing contrast Steps)');
ContrastGra (2) = errorbar(x1,y1,e1,'r','Marker','none','Linestyle','none','DisplayName','Standart error of the mean');
% clear Regression1
% Regression1(1,:) = real_contrast1;
% Regression1(2,:) = mean_calciumStep;
% Regression1(3,:) = e1;
% Regression1 = Regression1';
% hold on
% Fitt1 = weightedfit (Regression1);


%Plot a regression line
[coeffs1,S1] = polyfit(x1, y1, 1);
% Get fitted values
fittedX1 = linspace(min(x1), max(x1), 6);
fittedY1 = polyval(coeffs1, fittedX1);
% Plot the fitted line
hold on;
ContrastGra(3) = plot(fittedX1, fittedY1, 'k--', 'LineWidth', 2,'DisplayName','Linear regression');
Error_Fit1 = polyval(coeffs1,x1);
T1 = table(x1,y1,Error_Fit1,y1-Error_Fit1,'VariableNames',{'X','Y','Fit','FitError'});
% Calculate the confidence values and plot the confidence lines 
% The error is not yet included
[Y1,DELTA1] = polyconf(coeffs1,fittedX1,S1,'alpha',0.05);
% fittedX1 = sort(fittedX1,'descend');
ContrastGra(4) = plot(fittedX1,Y1+DELTA1,'r--','DisplayName', '95% confidence interval');
plot(fittedX1,Y1-DELTA1,'r--');



% Plot the data only for ON steps
y2 = mean_ContrastStep; %ks
x2 = real_contrast;
e2 = err_ContrastStep;

ContrastGra (5) = scatter(x2,y2,75,'filled','b','DisplayName','B Step (25% contrast change');
ContrastGra (6) = errorbar(x2,y2,e2,'b','Marker','none','Linestyle','none','DisplayName','Standart error of the mean');
% clear Regression2
% Regression2(1,:) = real_contrast;
% Regression2(2,:) = mean_ContrastStep;
% Regression2(3,:) = e2;
% Regression2 = Regression2';
% hold on
% Fitt2 = weightedfit (Regression2);
% ylim('auto');
% % ylim([-0.6 1.9]);

[coeffs2,S2] = polyfit(x2, y2, 1);
% Get fitted values
fittedX2 = linspace(min(x2), max(x2), 6);
fittedY2 = polyval(coeffs2, fittedX2);
% Plot the fitted line
hold on;
ContrastGra(7) = plot(fittedX2, fittedY2, 'k--', 'LineWidth', 2,'Displayname', 'Linear regression');
%Calculate the confidence values and plot the confidence lines 
%The error is not yet included
[Y2,DELTA2] = polyconf(coeffs2,fittedX2,S2,'alpha',0.05);
% fittedX2 = sort(fittedX2,'descend');
ContrastGra(8) = plot(fittedX2,Y2+DELTA2,'b--', 'DisplayName','95% confidence interval');
plot(fittedX2,Y2-DELTA2,'b--');

Error_Fit2 = polyval(coeffs2,x2);
T2 = table(x2,y2,Error_Fit2,y2-Error_Fit2,'VariableNames',{'X','Y','Fit','FitError'});
hold on 
ylim([-0.6 0.2]);
hold off
title('Response to linear increasing and 25% contrast steps');

% Add titles

xlabel('Contrast');

ylabel('dF/F - Calcium Signal');
legend (ContrastGra(1:8),'location','best');
ax=gca;
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
  'YTick'       , -0.6:0.1:0.2, ...
  'LineWidth'   , 1         );

% print(['C:\Matlab\Working_Data\FigureData\Response_over_Contrast_',num2str(DataLoad)],'-depsc')
hold off;


%% Calculate Weber contrast from response differences

figure('Units', 'pixels', 'Position',[100 100 500 375]);
real_diff_contrast = real_contrast1-real_contrast;
mean_weber_contrast = mean_ContrastStep - mean_calciumStep;
x1 = real_diff_contrast;
y1 = mean_weber_contrast;

Condiff(1) = scatter(x1,y1,75,'k','filled','Displayname','dF/F(A Step)'); 
xlabel('Contrast difference between the steps');
ylabel('Difference in response between the steps');


[coeffs1,S1] = polyfit(x1, y1, 1);
% Get fitted values
fittedX1 = linspace(min(x1), max(x1), 6);
fittedY1 = polyval(coeffs1, fittedX1);
% Plot the fitted line
hold on;
Condiff(2) = plot(fittedX1, fittedY1, 'k--', 'LineWidth', 2,'DisplayName','Linear regression');
Error_Fit1 = polyval(coeffs1,x1);
T1 = table(x1,y1,Error_Fit1,y1-Error_Fit1,'VariableNames',{'X','Y','Fit','FitError'});
% Calculate the confidence values and plot the confidence lines 
% The error is not yet included
[Y1,DELTA1] = polyconf(coeffs1,fittedX1,S1,'alpha',0.05);
% fittedX1 = sort(fittedX1,'descend');
Condiff(3) = plot(fittedX1,Y1+DELTA1,'k--','DisplayName','95% confidence interval');
plot(fittedX1,Y1-DELTA1,'k--');

ylim([0 1]);
legend (Condiff(1:3),'location','best');
ax=gca;
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
  'YTick'       , 0:0.2:2, ...
  'LineWidth'   , 1         );

% print(['C:\Matlab\Working_Data\FigureData\Difference_Response_Contrast',num2str(DataLoad)],'-depsc')
hold off;
% %% Calculate the gain of the contrast response
% %Needs more thinking
% bar_all2 = figure;
% grid on;
% 
% % Plot the data only for OFF steps
% y1 = mean_calciumStep; %ks
% x1 = real_luminance;
% e1 = err_calciumStep;
% 
% hold on;
% scatter(x1,y1,75,'filled','r','DisplayName','A Step (linear increasing contrast Steps)');
% errorbar(x1,y1,e1,'r','Marker','none','Linestyle','none','DisplayName','Standart error of the mean');
% % clear Regression1
% % Regression1(1,:) = real_contrast1;
% % Regression1(2,:) = mean_calciumStep;
% % Regression1(3,:) = e1;
% % Regression1 = Regression1';
% % hold on
% % Fitt1 = weightedfit (Regression1);
% 
% 
% %Plot a regression line
% [coeffs1,S1] = polyfit(x1, y1, 2);
% % Get fitted values
% fittedX1 = linspace(min(x1), max(x1), 6);
% fittedY1 = polyval(coeffs1, fittedX1);
% % Plot the fitted line
% hold on;
% plot(fittedX1, fittedY1, 'k--', 'LineWidth', 1);
% Error_Fit1 = polyval(coeffs1,x1);
% T1 = table(x1,y1,Error_Fit1,y1-Error_Fit1,'VariableNames',{'X','Y','Fit','FitError'});
% % Calculate the confidence values and plot the confidence lines 
% % The error is not yet included
% [Y1,DELTA1] = polyconf(coeffs1,x1,S1,'alpha',0.05);
% fittedX1 = sort(fittedX1,'descend');
% plot(fittedX1,Y1+DELTA1,'r--');
% plot(fittedX1,Y1-DELTA1,'r--');
% 
% 
% 
% % Plot the data only for ON steps
% y2 = mean_ContrastStep./(Difference_luminance1); %ks
% x2 = real_luminance;
% e2 = err_ContrastStep;
% 
% scatter(x2,y2,75,'filled','b','DisplayName','B Step (25% contrast change');
% errorbar(x2,y2,e2,'b','Marker','none','Linestyle','none','DisplayName','Standart error of the mean');
% % clear Regression2
% % Regression2(1,:) = real_contrast;
% % Regression2(2,:) = mean_ContrastStep;
% % Regression2(3,:) = e2;
% % Regression2 = Regression2';
% % hold on
% % Fitt2 = weightedfit (Regression2);
% % ylim('auto');
% % % ylim([-0.6 1.9]);
% 
% [coeffs2,S2] = polyfit(x2, y2, 1);
% % Get fitted values
% fittedX2 = linspace(min(x2), max(x2), 6);
% fittedY2 = polyval(coeffs2, fittedX2);
% % Plot the fitted line
% hold on;
% plot(fittedX2, fittedY2, 'k--', 'LineWidth', 2);
% %Calculate the confidence values and plot the confidence lines 
% %The error is not yet included
% [Y2,DELTA2] = polyconf(coeffs2,x2,S2,'alpha',0.05);
% fittedX2 = sort(fittedX2,'descend');
% plot(fittedX2,Y2+DELTA2,'b--');
% plot(fittedX2,Y2-DELTA2,'b--');
% 
% Error_Fit2 = polyval(coeffs2,x2);
% T2 = table(x2,y2,Error_Fit2,y2-Error_Fit2,'VariableNames',{'X','Y','Fit','FitError'});
% hold on 
% % ylim([-0.9 1.5]);
% hold off
% legend('show');
% title('Response to linear increasing and 25% contrast steps');
% 
% % Add titles
% 
% xlabel('Delta luminance');
% 
% ylabel('dF/F');
% hold off;
% 
