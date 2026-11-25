%%% Analyse by different regions of the neuron

clc;
clear all;
close all;

% CONSTANTS
ANALYZE_BY_REGION = false;% weather ROIs should be selected based on their layer in the lobula complex. 

GENOTYPE_STRING = 'L3, norpA[36]';
COLOR_OF_PLOT = [0 0 1]; %BLUE; [.7 .7 0]% YELLOW %[1 0 0]; %RED% [0 .5 0]% GREEN %[0 0 1]; %BLUE;
    %COLOR_OF_PLOT = [1 0 0]; %RED; %[0 0 1] %BLUE;
COLOR_CLOUD = [.5 .5 1];

gen_str = GENOTYPE_STRING;

% % % % % 
pdatapath='W:\Katja\Katja_pData'; % path where the pdata is stored
addpath(pdatapath);
cd(pdatapath);

database_select_samples_ks;


%NorpA rescues Rh1

% L3, norpa[36]
f_fff_Tm9LexA  = find(i_fff2sONgrayOFF4sBG.*i_norpA_UASnorpA_L3QF_QUAS_GCaMP6f.*~i_moving);



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




%% 
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

for ii = 1:2
    epochRats = squeeze(cur_mat(:,ii,:));
    [x,m,e] = mean_cat_full(epochRats,1,cur_IDs); %m=mean; e=std
    
    counter = counter + 1;
    
    if ismember(ii,1) %negative contrasts
    stimulus = mTm9LexA.stimstruct;
    elseif ismember(ii,2) %positive contrasts
    stimulus = mTm9LexA.stimstruct.*(-1);
    end
    
    %positive correlation with stimulus    
    Q = corr(stimulus,epochRats')
    inds = find(Q>0.5);
    cur_mat_pos = epochRats(inds,:)
    cur_IDs_pos = cur_IDs(inds)
    %calculating means across flies
    [x_pos,m_pos,e_pos] = mean_cat_full(cur_mat_pos,1,cur_IDs_pos);
    %calculating the max for each trace
    max_pos = max(x_pos,[],2)-1;


    %negative correlation with stimulus
    Q = corr(stimulus,epochRats')
    inds = find(Q<-0.5);
    size(inds)
    cur_mat_neg = epochRats(inds,:)
    cur_IDs_neg = cur_IDs(inds)
    %calculating means across flies
    [x_neg,m_neg,e_neg] = mean_cat_full(cur_mat_neg,1,cur_IDs_neg);
    max_neg = max(x_neg,[],2)-1;

    
    figure(ii); hold on
    cm=colormap('lines');
    h1 = plot_err_patch_v2(cur_t,m,e,[0 0 1],[0.5 0.5 1],'-',1);
% % %     title('some genotype, all cells');
    if (ii==1)
        title('-100% OFFgrey')
    elseif (ii==2)
        title('100% ONgrey')
    end
    
    if ismember(ii,1) 
%     peak_max(counter) = max(m);
    peak_max(counter) = max(m); %for -40% it finds max in the first 1s
    elseif ismember(ii,2)
    peak_max(counter) = min(m);
%     peak_ONtoGrey(counter) = max(m(40:70));
    end
  
    legend([h1],sprintf('N = %d ( %d )',size(x,1),size(epochRats,1)),...
        'location','northeast');
    plot(cur_t, mTm9LexA.stimstruct*0.1+1.25, 'k')
%     plot(cur_t, mTm9LexA.stimstruct*0.05+0.25, 'k') %ort rescue R7 & R8
%     ylim([-0.8 2.4]);
      ylim([-0.8 2.0]);
%     ylim([-0.3 0.3]); %ort rescue R7 & R8
%     line([0 5.5],[0 0],'color',[0 0 0]);

end

%to do: replace the wanted contrast values with the measured ones:
contrast = [-100 100]

% figure
% plot(contrast, peak_max,'k','Linewidth',4)
% box off
% ylim([-0.5 2.5]);

% % % % ON to grey response
% % % figure
% % % plot(contrast, peak_ONtoGrey,'k','Linewidth',4)
% % % box off
% % % ylim([-0.5 2.5]);




%% statistics!

THRESHOLD = 0;
fprintf('THRESHOLD for Signal sum: %d \n',THRESHOLD );

% Mean over flies
cur_mat = mTm9LexA.rats;
cur_IDs = mTm9LexA.flyID;

%calculating means across flies
[x_neg,m_neg,e_neg] = mean_cat_full(cur_mat_neg,1,cur_IDs_neg);

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
on_step = [0 1];
on_step = logical(on_step);
off_step = ~ on_step;



for kk =1:num_steps
  
        
    traces = squeeze(mTm9LexA.rats(:,kk,:)); %because mean_cat_full works only with 2 dimensions %taking all ROIs, the epoch we are on, full lenth (200)
    [x,m,e] = mean_cat_full(traces,1,mTm9LexA.flyID); %m=mean; e=std
    
    
    %ks: defining the time where we look for the baseline
%     baseline = x(:,round(0.2*end):round(0.4*end)); %5s till 10s
%     baselineONtogrey = x(:,round(0.2*end):round(0.4*end)); %5s till 10s
    baseline = x(:,round(0.1*end):round(0.4*end)); %5s till 10s
    baselineONtogrey = x(:,round(0.4*end):round(0.6*end)); %4s till 6s


    %ks: defining the time where we look for the response
%     search_peak = x(:,round(0.4*end)+1:round(0.6*end));  %10s till 15s out of 25s
%     search_peakONtogrey = x(:,round(0.6*end)+1:round(0.8*end));  %15s till 20s
    search_peak = x(:,round(0.1*end)+1:round(0.9*end));  %10s till 15s out of 25s
    search_peakONtogrey = x(:,round(0.6*end)+1:round(0.9*end));  %15s till 20s
%     calcium = squeeze(nanmean(search_peak,1));
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

    
    calciumStep = zeros(not_NaN_flies,1);
%     for ii = 1:not_NaN_flies
%         if on_step(kk)
%             calciumStep(ii) = max(search_peakONtogrey(ii,:)) - max(baselineONtogrey(ii,:));
%         else
%             calciumStep(ii) = max(search_peak(ii,:)) - max(baseline(ii,:));
%         end
% 
%     end

    for ii = 1:not_NaN_flies
        if on_step(kk)
            calciumStep(ii) = max(search_peakONtogrey(ii,:)) - min(baselineONtogrey(ii,:));
        else
            calciumStep(ii) = max(search_peak(ii,:)) - min(baseline(ii,:));
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
ylim([0 1.5]); %abs 
% ylim([-0.5 2.5]) %no abs

title('max response');

% Add titles
ax = gca;
ax.XTick = 1:length(on_step);
ax.XTickLabels = {'grey --> 100% OFF';'grey --> 100% ON'};
ax.XTickLabelRotation = 45;
ylabel('max (OFF) peak') ;

hold off;


%% Student t-test

step1 = all_steps_all_means_flies(:,1);
step2 = all_steps_all_means_flies(:,2);


%grey to 100OFF vs 100ON to grey
[h,p,ci,stats] = ttest2(step1,step2);
p_step1 = p
h_step1 = h
stats_step1 = stats


% L3: 1 and 2 are stat different!!! p1 = 0.0482, p2 = 0.0333, p3 = 0.066, p4 = 0.066, p5 = 0.07
% L2: none of them! p1 = 0.173, p2 = 0.194, p3 = 0.269, p4 = 0.1775, p5 = 0.417





%% For the norpA rescues
% Student t-test

%step1
step1controlpanR8 = step1control(:,1);
step1panR8 = step1(:,1);

[h,p,ci,stats] = ttest2(step1controlpanR8,step1panR8);
p_step1 = p
h_step1 = h
stats_step1 = stats

%step2
%%%step2control = step2 (so that I can compare control with the rescue since I saved them with the same name)
step2controlpanR8 = step2control(:,1);
step2panR8 = step2(:,1);

[h,p,ci,stats] = ttest2(step2controlpanR8,step2panR8);
p_step1 = p
h_step1 = h
stats_step1 = stats



% L3 panR8 control versus L3 panR8 rescue => step1 = p = 0.0125, step2  = p = 0.0340

% L3 Rh1 control versus L3 Rh1 rescue => step1 = p = 0.9218, step2  = p = 0.2141


% L2 panR8 control versus L2 panR8 rescue => step1 = p = 0.0037, step2  = p = 2.5313e-04

% L2 Rh1 control versus L2 Rh1 rescue => step1 = p = 0.9147, step2  = p = 0.3768


%step1
step1control = step1_L2(:,1);
step1RNAi = step1(:,1);

[h,p,ci,stats] = ttest2(step1control,step1RNAi);
p_step1 = p
h_step1 = h
stats_step1 = stats

%step2
%%%step2control = step2 (so that I can compare control with the rescue since I saved them with the same name)
step2control = step2_L2(:,1);
step2RNAi = step2(:,1);

[h,p,ci,stats] = ttest2(step2control,step2RNAi);
p_step1 = p
h_step1 = h
stats_step1 = stats













