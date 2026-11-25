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
    GENOTYPE_STRING = ['L3 >> GCaMP6f, region: ' REGION];
%         GENOTYPE_STRING = ['lexAopGCaMP6fp10attp5 16HO3lexA,lexAopmyrtdTom 11-164Gal4 ermHA, region: ' REGION];
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
f_fff_Tm9LexA  = find(i_fff_01steps_5sONgrayOFF.*i_UASGCaMP6F_L3MH56Gal4.*~i_moving);

% ONgrayOFFgray L2
% f_fff_Tm9LexA  = find(i_fff_01steps_5sONgrayOFF.*i_UASGCaMP6F_L221DhhGal4.*~i_moving); %5s ON/OFF, 10s BG



%Cbp53E
% f_fff_Tm9LexA  = find(i_fff_01steps_5sONgrayOFF.*i_Cbp53E_L221DhhGal4.*~i_moving.*((flyID==244)|(flyID==245)));

%real ort rescue
% f_fff_Tm9LexA = find(i_fff_01steps_5sONgrayOFF.*i_UASort_UASGCaMP6f_L221DhhGal4_ort1_DfBSC809.*~i_moving); %doesn't work???
% f_fff_Tm9LexA = find(i_fff_01steps_5sONgrayOFF.*i_UASort_UASGCaMP6f_L30595Gal4_ort1_DfBSC809.*~i_moving);


%Matthew Pecot
% f_fff_Tm9LexA = find(i_fff_01steps_5sONgrayOFF.*i_lexAopGCaMP6fp10attp5_16HO3lexA_lexAopmyrtdTOM_11164Gal4_plus.*~i_moving);
% f_fff_Tm9LexA = find(i_fff_01steps_5sONgrayOFF.*i_lexAopGCaMP6fp10attp5_16HO3lexA_lexAopmyrtdTOM_11164Gal4ermHA.*~i_moving);



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

mTm9LexA = aggregate_standingStripe_ks_grey_baseline(xTm9LexA);



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

for ii = 1:10 
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
    peak_max(counter) = max(m(90:200)); %for -40% it finds max in the first 1s
    elseif ismember(ii,6:10)
    peak_max(counter) = min(m);
    peak_max(counter) = max(m(140:200));
    end

    
    legend([h1],sprintf('N = %d ( %d )',size(x,1),size(epochRats,1)),...
        'location','northeast');
    plot(cur_t, mTm9LexA.stimstruct*0.1+2.25, 'k')
    ylim([-0.8 2.0]);
    line([0 5.5],[0 0],'color',[0 0 0]);

end

contrast = [-100 -80 -60 -40 -20 20 40 60 80 100]

figure
plot(contrast, peak_max,'k','Linewidth',4)
box off
ylim([-0.5 2.5]);




%% New ks - analysis over ROIs
close all
THRESHOLD = 0;
fprintf('THRESHOLD for Signal sum: %d \n',THRESHOLD );

% take a mean of all assigned values, ignore 0
crossing_rats = mTm9LexA.rats;
crossing_rats(crossing_rats==0) = NaN;

% Mean over all ROI's
mean_val = squeeze(mean(crossing_rats,1,'omitnan'));


num_steps = size(mean_val,1);
numROIs = size(crossing_rats,1);

mean_calcium = zeros(1,num_steps);
err_calcium = zeros(1,num_steps);


% When are we going from grey to OFF?
on_step = [0 0 0 0 0 1 1 1 1 1];
on_step = logical(on_step);
off_step = ~ on_step;




% Calculate the height of the off peak
for kk =1:num_steps
    
    
    baseline = crossing_rats(:,kk,round(0.3*end):round(0.4*end)); %7.5s till 10s
    baselineONtogrey = crossing_rats(:,kk,round(0.5*end):round(0.6*end)); %12.5s till 15s
    baseline = squeeze(baseline);
    baselineONtogrey = squeeze(baselineONtogrey);
    baseline = nanmean(baseline,2);
    baselineONtogrey = nanmean(baselineONtogrey,2);
    
    search_peak = crossing_rats(:,kk,round(0.4*end):round(0.8*end)); %10s till 20s
    search_peak_ONtogrey = crossing_rats(:,kk,round(0.5*end):round(0.9*end)); %12.5s till 22.5s
    calcium = squeeze(nanmean(search_peak,1));
    calciumONtogrey = squeeze(nanmean(search_peak_ONtogrey,1));
    
    
    
    if on_step(kk)
        baseline = baselineONtogrey;
        peak = max(calciumONtogrey);
    else
        baseline = baseline;
        peak = max(calcium);
    end
%     




    mean_calcium(kk) = peak-nanmean(baseline);
    

    err_calcium(kk) = std(baseline,'omitnan')/sqrt(length(baseline));
end




% Plot ALL steps-------------------------------------------------
bar_all = figure;
grid on;

% Plot the data only for OFF steps
y1 = mean_calcium(off_step);
x1 = find(off_step);
e1 = err_calcium(off_step);

hold on;
% bar(x1,y1,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.0);
bar(x1,y1,'FaceColor',[0 1 1]);
errorbar(x1,y1,e1,'rx');

% Plot the data only for ON steps
y2 = mean_calcium(on_step); %ks
x2 = find(on_step);
e2 = err_calcium(on_step);

% bar(x2,y2,'FaceColor',[.5 .5 0],'EdgeColor',[.9 .9 0],'LineWidth',1.0);
bar(x2,y2,'FaceColor',[1 0 1]);
legend({'grey --> OFF','Error','ON --> grey'},'Location','northwest');
errorbar(x2,y2,e2,'rx');
% ylim([0 1.5]); %abs 
ylim([-2.0 3.0]) %no abs

title('max response');

% Add titles
ax = gca;
ax.XTick = 1:length(on_step);
ax.XTickLabels = {'grey --> 100% OFF';'grey --> 80% OFF'; 'grey --> 60% OFF';'grey --> 40% OFF';'grey --> 20% OFF';...
    '20% ON --> grey';'40% ON --> grey';'60% ON --> grey' ;'80% ON --> grey'; ...
    '100% ON --> grey'};
ax.XTickLabelRotation = 45;
ylabel('Absolute height max (OFF) peak') ;

hold off;



%% bar plot - per fly! USE THIS ONE!!!!

THRESHOLD = 0;
fprintf('THRESHOLD for Signal sum: %d \n',THRESHOLD );

% Mean over flies

cur_mat = mTm9LexA.rats;
cur_IDs = mTm9LexA.flyID;

%calculating means across flies
[x_neg,m_neg,e_neg] = mean_cat_full(cur_mat_neg,1,cur_IDs_neg);


% Calculate the height of the off peak

for kk =1:num_steps
  
        
    traces = squeeze(mTm9LexA.rats(:,kk,:)); %because mean_cat_full works only with 2 dimensions %taking all ROIs, the epoch we are on, full lenth (200)
    [x,m,e] = mean_cat_full(traces,1,mTm9LexA.flyID); %m=mean; e=std
    
    
    %ks: defining the time where we look for the baseline
    baseline = x(:,round(0.3*end):round(0.4*end)); %7.5s till 10s
    baselineONtogrey = x(:,round(0.5*end):round(0.6*end)); %13.75s till 15s


    %ks: defining the time where we look for the response
    search_peak = x(:,round(0.4*end)+1:round(0.8*end));  %10s till 15s
    search_peakONtogrey = x(:,round(0.5*end)+1:round(0.9*end));  %12.5s till 22.5s
    calcium = squeeze(nanmean(search_peak,1));
    calciumONtogrey = squeeze(nanmean(search_peakONtogrey,1));
    

    if on_step(kk)
        baseline = baselineONtogrey;
        peak = max(calciumONtogrey);
    else
        baseline = baseline;
        peak = max(calcium);
    end


    not_NaN_flies = size(x,1); % Fabi: would crash otherwise, we have only 8 flies (not 12) evaluated here !
    

    
    calciumStep = zeros(not_NaN_flies,1);
    for ii = 1:not_NaN_flies
        if on_step(kk)
            calciumStep(ii) = max(search_peakONtogrey(ii,:)) - max(baselineONtogrey(ii,:));
        else
            calciumStep(ii) = max(search_peak(ii,:)) - max(baseline(ii,:));
        end

    end
        
    
    all_steps_all_means_flies(:,kk) = calciumStep; %use this for statistics!
    
    mean_calcium(kk) = mean(calciumStep);

    err_calcium(kk) = std(calciumStep,'omitnan')/sqrt(length(calciumStep));

    
  end  


% Plot ALL steps-------------------------------------------------
bar_all = figure;
grid on;

% Plot the data only for OFF steps
y1 = mean_calcium(off_step);
x1 = find(off_step);
e1 = err_calcium(off_step);

hold on;
% bar(x1,y1,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.0);
bar(x1,y1,'FaceColor',[0 1 1]);
errorbar(x1,y1,e1,'rx');

% Plot the data only for ON steps
y2 = mean_calcium(on_step); %ks
x2 = find(on_step);
e2 = err_calcium(on_step);

% bar(x2,y2,'FaceColor',[.5 .5 0],'EdgeColor',[.9 .9 0],'LineWidth',1.0);
bar(x2,y2,'FaceColor',[1 0 1]);
legend({'grey --> OFF','Error','ON --> grey'},'Location','northwest');
errorbar(x2,y2,e2,'rx');
% ylim([0 1.5]); %abs 
ylim([-0.5 2.0]) %no abs

title('max response');

% Add titles
ax = gca;
ax.XTick = 1:length(on_step);
ax.XTickLabels = {'grey --> 100% OFF';'grey --> 80% OFF'; 'grey --> 60% OFF';'grey --> 40% OFF';'grey --> 20% OFF';...
    '20% ON --> grey';'40% ON --> grey';'60% ON --> grey' ;'80% ON --> grey'; ...
    '100% ON --> grey'};
ax.XTickLabelRotation = 45;
ylabel('Absolute height max (OFF) peak') ;

hold off;


%% Scatter plot --> gray-to-dark and bright-to-gray responses are plotted together!!!
% % % % Reordering (before we had 100% (gray-to-dark) to 0 and then 50% (bright-to-gray))
% % % step1 = all_steps_all_means_flies(:,6);
% % % step2 = all_steps_all_means_flies(:,5);
% % % step3 = all_steps_all_means_flies(:,7);
% % % step4 = all_steps_all_means_flies(:,8);
% % % step5 = all_steps_all_means_flies(:,4);
% % % step6 = all_steps_all_means_flies(:,9);
% % % step7 = all_steps_all_means_flies(:,10);
% % % step8 = all_steps_all_means_flies(:,3);
% % % step9 = all_steps_all_means_flies(:,2);
% % % step10 = all_steps_all_means_flies(:,1);
% % % 
% % % contrast = [16 20 28 37 40 44 50 60 80 100]; 
% % % contrast(1:10);
% % % 
% % % a = length(contrast);
% % % % b = [contrast;contrast;contrast;contrast;contrast;contrast]; %for L2
% % % b = [contrast;contrast;contrast;contrast;contrast]; %for L3
% % % 
% % % x1 = b(:,1);
% % % x2 = b(:,2);
% % % x3 = b(:,3);
% % % x4 = b(:,4);
% % % x5 = b(:,5);
% % % x6 = b(:,6);
% % % x7 = b(:,7);
% % % x8 = b(:,8);
% % % x9 = b(:,9);
% % % x10 = b(:,10);
% % % 
% % % %plot
% % % 
% % % hold on
% % % scatter(x1,step1);
% % % scatter(x2,step2);
% % % scatter(x3,step3);
% % % scatter(x4,step4);
% % % scatter(x5,step5);
% % % scatter(x6,step6);
% % % scatter(x7,step7);
% % % scatter(x8,step8);
% % % scatter(x9,step9);
% % % scatter(x10,step10);
% % % 
% % % mean_step1 = mean(step1);
% % % mean_step2 = mean(step2);
% % % mean_step3 = mean(step3);
% % % mean_step4 = mean(step4);
% % % mean_step5 = mean(step5);
% % % mean_step6 = mean(step6);
% % % mean_step7 = mean(step7);
% % % mean_step8 = mean(step8);
% % % mean_step9 = mean(step9);
% % % mean_step10 = mean(step10);
% % % 
% % % xaxis = [x1(1), x2(1), x3(1), x4(1), x5(1), x6(1), x7(1), x8(1), x9(1), x10(1)];
% % % mean = [mean_step1 mean_step2 mean_step3 mean_step4 mean_step5 mean_step6 mean_step7 mean_step8 mean_step9 mean_step10];
% % % 
% % % hold on
% % % plot(xaxis,mean, 'k-')
% % % plot(xaxis,mean, 'rs')
% % % 
% % % % Add titles
% % % ax = gca;
% % % ax.XTick = [16 20 28 37 40 44 50 60 80 100];
% % % ax.XTickLabels = {'bright --> 16% OFF';'grey --> 20% OFF'; 'bright --> 28% OFF';'bright --> 37% OFF';'grey --> 40% OFF';...
% % %     'ON --> 44% OFF';'ON --> 50% OFF';'grey --> 60% OFF' ;'grey --> 80% OFF'; ...
% % %     'grey --> 100% OFF'};
% % % ax.XTickLabelRotation = 45;
% % % ylabel('Absolute height max (OFF) peak') ;
% % % 
% % % hold off;
% % % 
% % % 
% % % 
% % % 
% % % %% Scatter plot and split mean traces of gray-to-dark and bright-to-gray responses
% % % %plot
% % % hold on
% % % scatter(x1,step1);
% % % scatter(x2,step2);
% % % scatter(x3,step3);
% % % scatter(x4,step4);
% % % scatter(x5,step5);
% % % scatter(x6,step6);
% % % scatter(x7,step7);
% % % scatter(x8,step8);
% % % scatter(x9,step9);
% % % scatter(x10,step10);
% % % 
% % % xaxis_bright_to_gray = [x1(1), x3(1), x4(1), x6(1), x7(1)];
% % % xaxis_gray_to_dark = [x2(1), x5(1), x8(1), x9(1), x10(1)];
% % % 
% % % mean_bright_to_gray = [mean_step1 mean_step3 mean_step4 mean_step6 mean_step7];
% % % mean_gray_to_dark = [mean_step2 mean_step5 mean_step8 mean_step9 mean_step10];
% % % 
% % % hold on
% % % plot(xaxis_bright_to_gray,mean_bright_to_gray, 'k-')
% % % plot(xaxis,mean, 'rs')
% % % 
% % % hold on
% % % plot(xaxis_gray_to_dark,mean_gray_to_dark, 'b-')
% % % plot(xaxis,mean, 'gs')






%% Making the gray-to-dark and bright-to-gray contrast the same!
% Reordering (before we had 100% (gray-to-dark) to 0 and then 50% (bright-to-gray))
step1 = all_steps_all_means_flies(:,5); %-20 -> gray-to-dark
step2 = all_steps_all_means_flies(:,6); %+20 -> bright-to-gray
step3 = all_steps_all_means_flies(:,4); %-40
step4 = all_steps_all_means_flies(:,7); %+40
step5 = all_steps_all_means_flies(:,3); %-60
step6 = all_steps_all_means_flies(:,8); %+60
step7 = all_steps_all_means_flies(:,2); %-80
step8 = all_steps_all_means_flies(:,9); %+80
step9 = all_steps_all_means_flies(:,1); %-100
step10 = all_steps_all_means_flies(:,10); %+100

contrast = [20 20 40 40 60 60 80 80 100 100]; 
contrast(1:10);

a = length(contrast);
% b = [contrast;contrast;contrast;contrast;contrast;contrast]; %for L2
b = [contrast;contrast;contrast;contrast;contrast]; %for L3

x1 = b(:,1);
% x2 = b(:,2);
x3 = b(:,3);
% x4 = b(:,4);
x5 = b(:,5);
% x6 = b(:,6);
x7 = b(:,7);
% x8 = b(:,8);
x9 = b(:,9);
% x10 = b(:,10);

%plot

hold on
scatter(x1,step1);
scatter(x1,step2);
scatter(x3,step3);
scatter(x3,step4);
scatter(x5,step5);
scatter(x5,step6);
scatter(x7,step7);
scatter(x7,step8);
scatter(x9,step9);
scatter(x9,step10);

mean_step1 = mean(step1);
mean_step2 = mean(step2);
mean_step3 = mean(step3);
mean_step4 = mean(step4);
mean_step5 = mean(step5);
mean_step6 = mean(step6);
mean_step7 = mean(step7);
mean_step8 = mean(step8);
mean_step9 = mean(step9);
mean_step10 = mean(step10);

xaxis = [x1(1), x3(1), x5(1), x7(1), x9(1)];

xaxis_bright_to_gray = [x1(1), x3(1), x5(1), x7(1), x9(1)];
xaxis_gray_to_dark = [x1(1), x3(1), x5(1), x7(1), x9(1)];

mean_bright_to_gray = [mean_step2 mean_step4 mean_step6 mean_step8 mean_step10];
mean_gray_to_dark = [mean_step1 mean_step3 mean_step5 mean_step7 mean_step9];

hold on
plot(xaxis_bright_to_gray,mean_bright_to_gray, 'k-')
plot(xaxis_bright_to_gray,mean_bright_to_gray, 'rs')

hold on
plot(xaxis_gray_to_dark,mean_gray_to_dark, 'b-')
plot(xaxis_gray_to_dark,mean_gray_to_dark, 'gs')



%% Plot bright-to-gray and gray-to-dark resposnes seperately
% % % % Reordering (before we had 100% (gray-to-dark) to 0 and then 50% (bright-to-gray))
step1 = all_steps_all_means_flies(:,6);
% % % step2 = all_steps_all_means_flies(:,5);
step3 = all_steps_all_means_flies(:,7);
step4 = all_steps_all_means_flies(:,8);
% % % step5 = all_steps_all_means_flies(:,4);
step6 = all_steps_all_means_flies(:,9);
step7 = all_steps_all_means_flies(:,10);
% % % step8 = all_steps_all_means_flies(:,3);
% % % step9 = all_steps_all_means_flies(:,2);
% % % step10 = all_steps_all_means_flies(:,1);
% % % 
contrast = [16 28 37 44 50]; 
contrast(1:5);

a = length(contrast);
% b = [contrast;contrast;contrast;contrast;contrast;contrast]; %for L2
b = [contrast;contrast;contrast;contrast;contrast]; %for L3

x1 = b(:,1);
x2 = b(:,2);
x3 = b(:,3);
x4 = b(:,4);
x5 = b(:,5);

hold on
scatter(x1,step1);
scatter(x2,step3);
scatter(x3,step4);
scatter(x4,step6);
scatter(x5,step7);

mean_step1 = mean(step1);
mean_step3 = mean(step3);
mean_step4 = mean(step4);
mean_step6 = mean(step6);
mean_step7 = mean(step7);

xaxis = [x1(1), x2(1), x3(1), x4(1), x5(1)];
mean_bright_to_gray = [mean_step1 mean_step3 mean_step4 mean_step6 mean_step7];

hold on
plot(xaxis,mean_bright_to_gray, 'k-')
plot(xaxis,mean_bright_to_gray, 'rs')

ylim([0 1.5]) %no abs




%% bar plot - per fly! OLD VERSION!
% 
% THRESHOLD = 0;
% fprintf('THRESHOLD for Signal sum: %d \n',THRESHOLD );
% 
% % Mean over flies
% 
% cur_mat = mTm9LexA.rats;
% cur_IDs = mTm9LexA.flyID;
% 
% %calculating means across flies
% [x_neg,m_neg,e_neg] = mean_cat_full(cur_mat_neg,1,cur_IDs_neg);
% 
% 
% % Calculate the height of the off peak
% 
% for kk =1:num_steps
%   
%         
%     traces = squeeze(mTm9LexA.rats(:,kk,:)); %because mean_cat_full works only with 2 dimensions %taking all ROIs, the epoch we are on, full lenth (200)
%     [x,m,e] = mean_cat_full(traces,1,mTm9LexA.flyID); %m=mean; e=std
%     
%     
%         %ks: defining the time where we look for the baseline
%     baseline = x(:,round(0.3*end):round(0.4*end)); %7.5s till 10s
%     %ks: defining the time where we look for the response
%     search_peak = x(:,round(0.4*end)+1:round(0.9*end));  %10s till 22.5s
%        calcium = squeeze(nanmean(search_peak,1));
% 
%            %test if you're looking for an increase or an decrease in calcium (for each trace):
%     decreasingCa = nanmean(baseline,2) - nanmean(search_peak,2) >= 0; %nanmean is the mean of X, computed after removing NaN values
%     increasingCa = nanmean(squeeze(baseline),2) - nanmean(squeeze(search_peak),2) < 0;
%     
%     not_NaN_flies = size(x,1); % Fabi: would crash otherwise, we have only 8 flies (not 12) evaluated here !
%     
%     calciumStep = zeros(not_NaN_flies,1);
%     for ii = 1:not_NaN_flies
%         if decreasingCa(ii)
%             calciumStep(ii) = max(search_peak(ii,:)) - max(baseline(ii,:));
%         elseif increasingCa(ii) %this is necessary, if there are NaNs, both logicals are 0
%             calciumStep(ii) = max(search_peak(ii,:)) - max(baseline(ii,:));  %        
%         else
%             calciumStep(ii) = NaN;
%         end
%     end
%     
% 
%     
%     all_steps_all_means_flies(:,kk) = calciumStep;  %use this for statistics!
%     
%     mean_calcium(kk) = mean(calciumStep);
%     
%     % It's kind of unsure which error to take here. One could also take the
%     % variance of the maximum peaks of the different ROIs as an error. This would then be a
%     % bigger value.
%     err_calcium(kk) = std(calciumStep,'omitnan')/sqrt(length(calciumStep));
% %     err_calcium(kk) = std(calcium,'omitnan')/sqrt(length(calcium)); %is this better than baseline???
%     
%   end  
% 
% 
% % Plot ALL steps-------------------------------------------------
% bar_all = figure;
% grid on;
% 
% % Plot the data only for OFF steps
% y1 = mean_calcium(off_step);
% x1 = find(off_step);
% e1 = err_calcium(off_step);
% 
% hold on;
% % bar(x1,y1,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.0);
% bar(x1,y1,'FaceColor',[0 1 1]);
% errorbar(x1,y1,e1,'rx');
% 
% % Plot the data only for ON steps
% y2 = mean_calcium(on_step); %ks
% x2 = find(on_step);
% e2 = err_calcium(on_step);
% 
% % bar(x2,y2,'FaceColor',[.5 .5 0],'EdgeColor',[.9 .9 0],'LineWidth',1.0);
% bar(x2,y2,'FaceColor',[1 0 1]);
% legend({'grey --> OFF','Error','ON --> grey'},'Location','northwest');
% errorbar(x2,y2,e2,'rx');
% % ylim([0 1.5]); %abs 
% ylim([-2.0 3.0]) %no abs
% 
% title('max response');
% 
% % Add titles
% ax = gca;
% ax.XTick = 1:length(on_step);
% ax.XTickLabels = {'grey --> 100% OFF';'grey --> 80% OFF'; 'grey --> 60% OFF';'grey --> 40% OFF';'grey --> 20% OFF';...
%     '20% ON --> grey';'40% ON --> grey';'60% ON --> grey' ;'80% ON --> grey'; ...
%     '100% ON --> grey'};
% ax.XTickLabelRotation = 45;
% ylabel('Absolute height max (OFF) peak') ;
% 
% hold off;




%% Statistics NEW!!!

for kk =1:num_steps
  
        
    traces = squeeze(mTm9LexA.rats(:,kk,:)); %because mean_cat_full works only with 2 dimensions %taking all ROIs, the epoch we are on, full lenth (200)
    [x,m,e] = mean_cat_full(traces,1,mTm9LexA.flyID); %m=mean; e=std
    
    
        %ks: defining the time where we look for the baseline
    baseline = x(:,round(0.3*end):round(0.4*end)); %7.5s till 10s
    baselineONtogrey = x(:,round(0.5*end):round(0.6*end)); %13.75s till 15s
%     baseline = squeeze(baseline);

    %ks: defining the time where we look for the response
    search_peak = x(:,round(0.4*end)+1:round(0.8*end));  %10s till 15s
    search_peakONtogrey = x(:,round(0.5*end)+1:round(0.9*end));  %12.5s till 22.5s
%     response = squeeze(response);
    calcium = squeeze(nanmean(search_peak,1));
    calciumONtogrey = squeeze(nanmean(search_peakONtogrey,1));
    
    
    

    if on_step(kk)
        baseline = baselineONtogrey;
        peak = max(calciumONtogrey);
    else
        baseline = baseline;
        peak = max(calcium);
    end


    not_NaN_flies = size(x,1); % Fabi: would crash otherwise, we have only 8 flies (not 12) evaluated here !
    
    
    calciumStep = zeros(not_NaN_flies,1);
    for ii = 1:not_NaN_flies
        if on_step(kk)
            calciumStep(ii) = max(search_peakONtogrey(ii,:)) - max(baselineONtogrey(ii,:));
        else
            calciumStep(ii) = max(search_peak(ii,:)) - max(baseline(ii,:));
        end

    end
        

    
    all_steps_all_means_flies(:,kk) = calciumStep; %use this for statistics!
    
    mean_calcium(kk) = mean(calciumStep);
    
    err_calcium(kk) = std(calciumStep,'omitnan')/sqrt(length(calciumStep));
%     err_calcium(kk) = std(calcium,'omitnan')/sqrt(length(calcium)); %is this better than baseline???
    
  end  

  
step1 = all_steps_all_means_flies(:,1);
step2 = all_steps_all_means_flies(:,2);
step3 = all_steps_all_means_flies(:,3);
step4 = all_steps_all_means_flies(:,4);
step5 = all_steps_all_means_flies(:,5);
step6 = all_steps_all_means_flies(:,6);
step7 = all_steps_all_means_flies(:,7);
step8 = all_steps_all_means_flies(:,8);
step9 = all_steps_all_means_flies(:,9);
step10 = all_steps_all_means_flies(:,10);


%grey to 100OFF vs 100ON to grey
[h,p,ci,stats] = ttest2(step1,step10);
p_step1 = p
h_step1 = h
stats_step1 = stats

% [a p1] = ttest2(step1 , step10{2})

%grey to 80OFF vs 80ON to grey
[h,p,ci,stats] = ttest2(step2,step9);
p_step2 = p
h_step2 = h
stats_step2 = stats

%grey to 60OFF vs 60ON to grey
[h,p,ci,stats] = ttest2(step3,step8);
p_step3 = p
h_step3 = h
stats_step3 = stats

%grey to 40OFF vs 40ON to grey
[h,p,ci,stats] = ttest2(step4,step7);
p_step4 = p
h_step4 = h
stats_step4 = stats

%grey to 20OFF vs 20ON to grey
[h,p,ci,stats] = ttest2(step5,step6);
p_step5 = p
h_step5 = h
stats_step5 = stats

% L3: 1 and 2 are stat different!!! p1 = 0.0482, p2 = 0.0333, p3 = 0.066, p4 = 0.066, p5 = 0.07
% L2: none of them! p1 = 0.173, p2 = 0.194, p3 = 0.269, p4 = 0.1775, p5 = 0.417






%% bar plot - per fly! NOT!!! It's also per ROI, just a different way!
% 
% 
% grey_100OFF = [1 0 0 0 0 0 0 0 0 0];
% grey_80OFF = [0 1 0 0 0 0 0 0 0 0];
% grey_60OFF = [0 0 1 0 0 0 0 0 0 0];
% grey_40OFF = [0 0 0 1 0 0 0 0 0 0];
% grey_20OFF = [0 0 0 0 1 0 0 0 0 0];
% ON20_grey = [0 0 0 0 0 1 0 0 0 0];
% ON40_grey = [0 0 0 0 0 0 1 0 0 0];
% ON60_grey = [0 0 0 0 0 0 0 1 0 0];
% ON80_grey = [0 0 0 0 0 0 0 0 1 0];
% ON100_grey = [0 0 0 0 0 0 0 0 0 1];
% 
% grey_100OFF = logical(grey_100OFF);
% grey_80OFF = logical(grey_80OFF);
% grey_60OFF = logical(grey_60OFF);
% grey_40OFF = logical(grey_40OFF);
% grey_20OFF = logical(grey_20OFF);
% ON20_grey = logical(ON20_grey);
% ON40_grey = logical(ON40_grey);
% ON60_grey = logical(ON60_grey);
% ON80_grey = logical(ON80_grey);
% ON100_grey = logical(ON100_grey);
% 
% 
% % take a mean of all assigned values, ignore 0
% crossing_rats = mTm9LexA.rats;
% crossing_rats(crossing_rats==0) = NaN;
% 
% % Mean over all flies
% mean_val = squeeze(mean(crossing_rats,1,'omitnan'));
% 
% % Watch over 25 seconds period
% cur_t = linspace(0,25,length(mean_val(1,:)))';
% 
% 
% bar_1 = figure;
% grid on;
% y1 = mean_calcium(find(grey_100OFF));
% x1 = find(grey_100OFF);
% e1 = err_calcium(grey_100OFF);
% 
% hold on;
% w = 0.5;
% bar(x1,y1,w,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.0);
% errorbar(x1,y1,e1,'rx');
% 
% 
% grid on;
% y2 = mean_calcium(find(grey_80OFF));
% x2 = find(grey_80OFF);
% e2 = err_calcium(grey_80OFF);
% 
% hold on;
% w = 0.5;
% bar(x2,y2,w,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.0);
% errorbar(x2,y2,e2,'rx');
% 
% 
% 
% y3= mean_calcium(find(grey_60OFF));
% x3 = find(grey_60OFF);
% e3 = err_calcium(grey_60OFF);
% 
% bar(x3,y3,w,'FaceColor',[.1 .5 0],'EdgeColor',[.2 .9 .9],'LineWidth',1.0);
% errorbar(x3,y3,e3,'rx');
% ylim([-0.6 1]);
% 
% 
% 
% 
% y4= mean_calcium(find(grey_40OFF));
% x4 = find(grey_40OFF);
% e4 = err_calcium(grey_40OFF);
% 
% bar(x4,y4,w,'FaceColor',[.8 .5 0],'EdgeColor',[.7 .9 .9],'LineWidth',1.0);
% errorbar(x4,y4,e4,'rx');
% ylim([-0.6 1]);
% 
% 
% 
% y5= mean_calcium(find(grey_20OFF));
% x5 = find(grey_20OFF);
% e5 = err_calcium(grey_20OFF);
% 
% bar(x5,y5,w,'FaceColor',[.9 .8 0],'EdgeColor',[.9 .9 .9],'LineWidth',1.0);
% errorbar(x5,y5,e5,'rx');
% ylim([-0.6 1]);
% 
% 
% 
% y6= mean_calcium(find(ON20_grey));
% x6 = find(ON20_grey);
% e6 = err_calcium(ON20_grey);
% 
% bar(x6,y6,w,'FaceColor',[.9 .8 0],'EdgeColor',[.9 .9 .9],'LineWidth',1.0);
% errorbar(x6,y6,e6,'rx');
% ylim([-0.6 1]);
% 
% 
% 
% y7= mean_calcium(find(ON40_grey));
% x7 = find(ON40_grey);
% e7 = err_calcium(ON40_grey);
% 
% bar(x7,y7,w,'FaceColor',[.9 .8 0],'EdgeColor',[.9 .9 .9],'LineWidth',1.0);
% errorbar(x7,y7,e7,'rx');
% ylim([-0.6 1]);
% 
% 
% 
% y8= mean_calcium(find(ON60_grey));
% x8 = find(ON60_grey);
% e8 = err_calcium(ON60_grey);
% 
% bar(x8,y8,w,'FaceColor',[.9 .8 0],'EdgeColor',[.9 .9 .9],'LineWidth',1.0);
% errorbar(x8,y8,e8,'rx');
% ylim([-0.6 1]);
% 
% 
% 
% y9= mean_calcium(find(ON80_grey));
% x9 = find(ON80_grey);
% e9 = err_calcium(ON80_grey);
% 
% bar(x9,y9,w,'FaceColor',[.9 .8 0],'EdgeColor',[.9 .9 .9],'LineWidth',1.0);
% errorbar(x9,y9,e9,'rx');
% ylim([-0.6 1]);
% 
% 
% 
% y10= mean_calcium(find(ON100_grey));
% x10 = find(ON100_grey);
% e10 = err_calcium(ON100_grey);
% 
% bar(x10,y10,w,'FaceColor',[.9 .8 0],'EdgeColor',[.9 .9 .9],'LineWidth',1.0);
% errorbar(x10,y10,e10,'rx');
% ylim([-0.6 2]);
% 
% 
% legend({'grey --> 100% OFF';'grey --> 80% OFF'; 'grey --> 60% OFF';'grey --> 40% OFF';'grey --> 20% OFF';...
%     '20% ON --> grey';'40% ON --> grey';'60% ON --> grey' ;'80% ON --> grey'; ...
%     '100% ON --> grey'});%???
% title('test');
% 
% ax = gca;
% ax.XTick = sort([x1, x2, x3, x4, x5 x6, x7, x8, x9, x10]);
% ax.XTickLabels = {'grey --> 100% OFF';'grey --> 80% OFF'; 'grey --> 60% OFF';'grey --> 40% OFF';'grey --> 20% OFF';...
%     '20% ON --> grey';'40% ON --> grey';'60% ON --> grey' ;'80% ON --> grey'; ...
%     '100% ON --> grey'};
% ax.XTickLabelRotation = 45;
% 
% hold off;
% 
% % figure
% % plot(contrast, means_all,'k','Linewidth',4)
% % box off
% % ylim([-0.5 2]);
% 
% 
% 
% bar_2 = figure;
% hold on;
% 
% 
% mean_calcium_grey_100OFF = mean(y1);
% mean_calcium_grey_80OFF = mean(y2);
% mean_calcium_grey_60OFF = mean(y3);
% mean_calcium_grey_40OFF = mean(y4);
% mean_calcium_grey_20OFF = mean(y5);
% mean_calcium_ON20_grey = mean(y6);
% mean_calcium_ON40_grey = mean(y7);
% mean_calcium_ON60_grey = mean(y8);
% mean_calcium_ON80_grey = mean(y9);
% mean_calcium_ON100_grey = mean(y10);
% 
% 
% error_calcium_grey_100OFF = mean(e1);
% error_calcium_grey_80OFF = mean(e2);
% error_calcium_grey_60OFF = mean(e3);
% error_calcium_grey_40OFF = mean(e4);
% error_calcium_grey_20OFF = mean(e5);
% error_calcium_ON20_grey = mean(e6);
% error_calcium_ON40_grey = mean(e7);
% error_calcium_ON60_grey = mean(e8);
% error_calcium_ON80_grey = mean(e9);
% error_calcium_ON100_grey = mean(e10);
% 
% 
% 
% bar(1,mean_calcium_grey_100OFF,w,'FaceColor',[0 1 1],'EdgeColor',[0 1 1],'LineWidth',1.0);
% errorbar(1,mean_calcium_grey_100OFF,error_calcium_grey_100OFF,'rx');
% 
% bar(2,mean_calcium_grey_80OFF,w,'FaceColor',[0 1 1],'EdgeColor',[0 1 1],'LineWidth',1.0);
% errorbar(2,mean_calcium_grey_80OFF,error_calcium_grey_80OFF,'rx');
% 
% bar(3,mean_calcium_grey_60OFF,w,'FaceColor',[0 1 1],'EdgeColor',[0 1 1],'LineWidth',1.0);
% errorbar(3,mean_calcium_grey_60OFF,error_calcium_grey_60OFF,'rx');
% 
% bar(4,mean_calcium_grey_40OFF,w,'FaceColor',[0 1 1],'EdgeColor',[0 1 1],'LineWidth',1.0);
% errorbar(4,mean_calcium_grey_40OFF,error_calcium_grey_40OFF,'rx');
% 
% bar(5,mean_calcium_grey_20OFF,w,'FaceColor',[0 1 1],'EdgeColor',[0 1 1],'LineWidth',1.0);
% errorbar(5,mean_calcium_grey_20OFF,error_calcium_grey_20OFF,'rx');
% 
% 
% 
% bar(6,mean_calcium_ON20_grey,w,'FaceColor',[1 0 1],'EdgeColor',[.9 .9 .9],'LineWidth',1.0);
% errorbar(6,mean_calcium_ON20_grey,error_calcium_ON20_grey,'rx');
% 
% bar(7,mean_calcium_ON40_grey,w,'FaceColor',[1 0 1],'EdgeColor',[.9 .9 .9],'LineWidth',1.0);
% errorbar(7,mean_calcium_ON40_grey,error_calcium_ON40_grey,'rx');
% 
% bar(8,mean_calcium_ON60_grey,w,'FaceColor',[1 0 1],'EdgeColor',[.9 .9 .9],'LineWidth',1.0);
% errorbar(8,mean_calcium_ON60_grey,error_calcium_ON60_grey,'rx');
% 
% bar(9,mean_calcium_ON80_grey,w,'FaceColor',[1 0 1],'EdgeColor',[.9 .9 .9],'LineWidth',1.0);
% errorbar(9,mean_calcium_ON80_grey,error_calcium_ON80_grey,'rx');
% 
% bar(10,mean_calcium_ON100_grey,w,'FaceColor',[1 0 1],'EdgeColor',[.9 .9 .9],'LineWidth',1.0);
% errorbar(10,mean_calcium_ON100_grey,error_calcium_ON100_grey,'rx');
% 
% 
% title('max response - coming to the same luminance');
% 
% 
% ax = gca;
% ax.XTick = 1:10;
% ax.XTickLabels = {'grey --> 100% OFF';'grey --> 80% OFF'; 'grey --> 60% OFF';'grey --> 40% OFF';'grey --> 20% OFF';...
%     '20% ON --> grey';'40% ON --> grey';'60% ON --> grey' ;'80% ON --> grey'; ...
%     '100% ON --> grey'};
% ax.XTickLabelRotation = 45;
% 
% box off
% 
% % ylim([-0.5 2.0]); %for L2
% % ylim([-0.5 3.0]);
% ylim([-0.5 2]); %for L2 ort, L2 NorpA
% 
% %ks: fitting an exponential functionf
% ax = gca;
% ax.FontSize = 20;
% set(gca, ...
%  'Box'         , 'off'     , ...
%  'TickDir'     , 'out'     , ...
%  'TickLength'  , [.02 .02] , ...
%  'XMinorTick'  , 'on'      , ...
%  'YMinorTick'  , 'on'      , ...
%  'YGrid'       , 'on'      , ...
%  'XColor'      , [.2 .2 .2], ...
%  'YColor'      , [.2 .2 .2], ...
%  'YTick'       , -0.5:0.2:3, ...
%  'LineWidth'   , 1         );
% hold on;
% 
% hold off;


