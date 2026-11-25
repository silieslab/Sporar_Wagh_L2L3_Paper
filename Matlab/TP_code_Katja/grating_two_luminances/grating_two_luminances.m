%% grating_two_luminances.m
% This script analyses data from three stimuli
% "grating1Weber05_075_BG075_05", "grating2Weber025_075_BG075_25" and "grating3Weber04_075_BG075_25".
% gratings: 30deg per sec, spacing is 20 (so 40, because we have dark and bright bars)

% These three stimulus vary according to the backround step (so the OFF
% step between the epoch 2 and 3) and according to the contrast of the
% grating. 
% The stimuli have 4 epochs: epoch one has the same luminance as epoch 2, but the
% contrast of the grating is smaller than in epoch 2. Epoch 3 and 4 have
% darker luminance and the same as in previous two epochs, contrast between
% the grating and the background is smaller in epoch 3 than in epoch 4. The
% contrast in epoch 1 and 3 is the same, and the contrast is also the same
% in epochs 2 and 4. 

% Each epoch is displayed for 3 seconds, the order of the epochs is fixed. 
%
%
% Katja November 2017

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



%L3
% f_fff_Tm9LexA  = find(i_grating1Weber05_075_BG075_05.*i_UASGCaMP6f_L3MH56Gal4_cross_to_w.*~i_moving);
f_fff_Tm9LexA  = find(i_grating2Weber025_075_BG075_25.*i_UASGCaMP6f_L3MH56Gal4_cross_to_w.*~i_moving);
% f_fff_Tm9LexA  = find(i_grating3Weber04_075_BG075_25.*i_UASGCaMP6f_L3MH56Gal4_cross_to_w.*~i_moving);


%L2
% f_fff_Tm9LexA  = find(i_grating1Weber05_075_BG075_05.*i_UASGCaMP6F_L221DhhGal4_cross_to_w.*~i_moving);
% f_fff_Tm9LexA  = find(i_grating2Weber025_075_BG075_25.*i_UASGCaMP6F_L221DhhGal4_cross_to_w.*~i_moving);
% f_fff_Tm9LexA  = find(i_grating3Weber04_075_BG075_25.*i_UASGCaMP6F_L221DhhGal4_cross_to_w.*~i_moving);




% create structures by neuron
fTm9LexA = create_neuron_structure_all_ks(f_fff_Tm9LexA);

% load all the data!
xTm9LexA = load_neuron_data10Hz_ks(fTm9LexA,pdatapath);

% mTm9LexA = aggregate_fffall_means10Hz_BleedThruFix(xTm9LexA);
% mTm9LexA = aggregate_gratings_two_luminances(xTm9LexA); %when you wanna look into the aggregate function: in = xTm9LexA
mTm9LexA = aggregate_gratings_two_luminances_baseline_epoch1(xTm9LexA); %taking epoch1 as a baseline




%% Plotting

THRESHOLD = 0;
fprintf('THRESHOLD for Signal sum: %d \n',THRESHOLD );

% take a mean of all assigned values, ignore 0
crossing_rats = mTm9LexA.rats;
crossing_rats(crossing_rats==0) = NaN;


% Mean over all ROI's
mean_val = squeeze(mean(crossing_rats,1,'omitnan'));

plots = size(mTm9LexA.rats,2);
titles = {'epoch1';'epoch2'; 'epoch3';'epoch4'};

% Watch over 3 seconds period
cur_t = linspace(0,12,length(mean_val(1,:)))';


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
        
%         line([0 20],[0 0],'color',[0 0 0]);
%         line([0 10 10 20],[0.05 0.05 0.07 0.07],'color',[0 0 0]);
  
        hold off;
    else
        fprintf('Case %d did not cross THRESHOLD (%s).\n',ii,titles{ii});
    end
end




%% Plot individual fly means

% In the aggregate
in = xTm9LexA;

s = in(1).istim;

for ii=1:length(in)
in(ii).name
    % df/f, but recalculate later
     iratio = in(ii).iratio;
     iratio = iratio./mean(iratio) - 1;    
     
    % determine the treshold
    figure(63);
%     figure(ii); %to plot all of the ROIs
%     plot(iratio);
    plot(iratio(1:200));
end

% %L2!!!!!! %Mean response peak distance for epoch 2 is 6.67 = 0.7 seconds (and for epoch 4 it is 0.6 seconds)
% %ii = 63 L2 for grating2 is really nice - analyse the modulation of the response to the grating here
% for ii = 63;
%     iratio = in(ii).iratio;
%     iratio = iratio./mean(iratio) - 1;    
%     plot(iratio(1:120));
%     max_epoch1 = max(iratio(15:25));
%     min_epoch1 = min(iratio(15:25));
%     fluorescence_change_epoch1 = max_epoch1 - min_epoch1;
% end

%L3!!!!!!  %Mean response peak distance for epoch 2 is 6.67 = 0.7 seconds (and for epoch 4 it is 0.67 seconds)
%ii = 34 L3 for grating2 is really nice - analyse the modulation of the response to the grating here
for ii = 34;
    iratio = in(ii).iratio;
    iratio = iratio./mean(iratio) - 1;    
    plot(iratio(1:120));
    max_epoch1 = max(iratio(15:25));
    min_epoch1 = min(iratio(15:25));
    fluorescence_change_epoch1 = max_epoch1 - min_epoch1;
end






%finding the peaks
epoch1 = iratio(1:30);
epoch2 = iratio(31:60);
epoch3 = iratio(61:90);
epoch4 = iratio(91:120);


s = 1:800
time1 = s(1:30);
time2 = s(31:60);
time3 = s(61:90);
time4 = s(91:120);

% 
% time1 = cur_t(1:30);
% time2 = cur_t(31:60);
% time3 = cur_t(61:90);
% time4 = cur_t(91:120);


[pks1,locs1] = findpeaks(epoch1, time1);
[pks2,locs2] = findpeaks(epoch2, time2); % returns a vector with the local maxima (peaks) and returns the indices at which the peaks occur
[pks3,locs3] = findpeaks(epoch3, time3);
[pks4,locs4] = findpeaks(epoch4, time4);



peaks1 = pks1;
peaks2 = pks2;
peaks3 = pks3;
peaks4 = pks4;

location1 = locs1;
location2 = locs2;
location3 = locs3;
location4 = locs4;

%find the peaks and plot them
text(locs1+.02,pks1,num2str((1:numel(pks1))'));
text(locs2+.02,pks2,num2str((1:numel(pks2))'));
text(locs3+.02,pks3,num2str((1:numel(pks3))'));
text(locs4+.02,pks4,num2str((1:numel(pks4))'));



diff_epoch1 = diff(locs1);
diff_epoch2 = diff(locs2);
diff_epoch3 = diff(locs3);
diff_epoch4 = diff(locs4);


mean_response_peak1 = mean(diff_epoch1) %responses to epoch 1 and 3 are super small so I will take just the mean of epochs 2 and 4
mean_response_peak2 = mean(diff_epoch2)
mean_response_peak3 = mean(diff_epoch3)
mean_response_peak4 = mean(diff_epoch4)



%% Version 2


cur_t = linspace(0,80,length(mean_val(1,:)))';

for ii=1:length(in)

    % df/f
    iratio = in(ii).iratio;
    iratio = iratio./mean(iratio) - 1;   
    
%     s = in(ii).istim;
    s = in(ii).istim + 1
    
    % finding the actual epochs    
    ds = diff(s);
    inds = find(ds)+1; %ks: finding epochs (everything that is not zero - e.g. -1 4 3 -2 ...)
    inds = inds(1:end-1); %clipping of the last epoch, almost always too short
        
    epochs = s(inds);
    uepochs = unique(epochs);
    

    
    for jj=1;
        currepoch = uepochs(jj);
        I = find(epochs==currepoch); %ms: take all the epochs
        bind = inds(I);
        epoch1 = iratio(1:30);
%         epoch1 = [iratio(1:30) iratio(121:150) iratio(241:270) iratio(361:390) iratio(481:510) iratio(601:630) iratio(721:750)];
        time1 = cur_t(1:30)         
%         time1 = [cur_t(1:30) cur_t(121:150) cur_t(241:270) cur_t(361:390) cur_t(481:510) cur_t(601:630) cur_t(721:750)];
        [pks1,locs1] = findpeaks(epoch1, time1);
        peaks1 = pks1;
        diff_epoch1 = diff(locs1);
        mean_response_peak1 = mean(diff_epoch1)
    end
%     name{ii}=in(ii).name;








    for jj=2;
        currepoch = uepochs(jj);
        I = find(epochs==currepoch); %ms: take all the epochs
        bind = inds(I);
%         epoch2 = iratio(31:60);
        epoch2 = iratio(31:60);
        % stimulus1 = s(1:30);
        time2 = cur_t(31:60);
        [pks2,locs2] = findpeaks(epoch2, time2);
        peaks2 = pks2;
        diff_epoch2 = diff(locs2);
        mean_response_diff_peak2 = mean(diff_epoch2)
    end
    
    
    
    for jj=3;
        currepoch = uepochs(jj);
        I = find(epochs==currepoch); %ms: take all the epochs
        bind = inds(I);
        epoch3 = iratio(61:90);
        % stimulus1 = s(1:30);
        time3 = cur_t(61:90);
        [pks3,locs3] = findpeaks(epoch3, time3);
        peaks3 = pks3;
        diff_epoch3 = diff(locs3);
        mean_response_diff_peak3 = mean(diff_epoch3)
    end
    
    
    
    for jj=4;
        currepoch = uepochs(jj);
        I = find(epochs==currepoch); %ms: take all the epochs
        bind = inds(I);
        epoch4 = iratio(91:120);
        % stimulus1 = s(1:30);
        time4 = cur_t(91:120);
        [pks4,locs4] = findpeaks(epoch4, time4);
        peaks4 = pks4;
        diff_epoch4 = diff(locs4);
        mean_response_diff_peak4 = mean(diff_epoch4)
    end
    

end


%% Quantification - End at a certain luminance

%First let's split into real 4 epochs (crossing_rats have to be 30 and not 120)
mTm9LexA = aggregate_gratings_two_luminances_baseline_epoch1_split_epochs(xTm9LexA); %in = xTm9LexA


close all
cur_mat = mTm9LexA.rats;
cur_IDs = mTm9LexA.flyID;
n_epochs = size(cur_mat,2);


peak_val = zeros(1,n_epochs);
err_peak =  zeros(1,n_epochs);
baseline =  zeros(1,n_epochs);
err_base =  zeros(1,n_epochs);

for ii=1:n_epochs
    epochRats = squeeze(cur_mat(:,ii,:));
    % Error by Fly
    [x,m,e] = mean_cat_full(epochRats,1,cur_IDs); %m=mean; e=std
    % The range for the baseline can be changed
    baseline(ii) = mean(m(20:30)); %looking at the last 1 sec of the epoch
    baseline_range = m(20:30);
    err_base(ii) = std(baseline_range,'omitnan')/sqrt(length(baseline_range));

end

figure;
hold on;
grid on;
% ylim([-0.4 2.0]); %L2
ylim([-0.1 0.7]); %L3

b = bar([1:4],baseline)
e = errorbar([1:4],baseline,err_base,'x')

set(b,'FaceColor',[0 0.8 0])
title('Max response');

% Add titles
ax = gca;
ax.XTick = 1:4;
ax.XTickLabels = {'mean_calcium_epoch1','mean_calcium_epoch2','mean_calcium_epoch3','mean_calcium_epoch4'};
ax.XTickLabelRotation = 45;

hold off;



%% T-test

for ii=1:n_epochs
    epochRats = squeeze(cur_mat(:,ii,:));
    % Error by Fly
    [x,m,e] = mean_cat_full(epochRats,1,cur_IDs); %m=mean; e=std
    % The range for the baseline can be changed
    baseline(ii) = mean(m(20:30)); %looking at the last 1 sec of the epoch
    baseline_range = m(20:30);
    err_base(ii) = std(baseline_range,'omitnan')/sqrt(length(baseline_range));
%     acc_baseline{ii} = baseline;
%     acc_err_base{ii}= err_base;

end

baseline1 = [baseline(1) baseline(2) baseline(3) baseline(4)]
baseline2 = [baseline(1) baseline(2) baseline(3) baseline(4)]

[testDecision , pValue] = ttest2(baseline1(1), baseline2(2))










