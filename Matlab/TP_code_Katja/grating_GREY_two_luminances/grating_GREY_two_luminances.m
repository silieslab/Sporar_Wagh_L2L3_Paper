%% grating_two_luminances.m
% This script analyses data from three stimuli
% "grey_grating1Weber05_075_BG075_05", "grey_grating2Weber025_075_BG075_25" and "grey_grating3Weber04_075_BG075_25".
% gratings: 30deg per sec, spacing is 20 (so 40, because we have dark and bright bars)

% These three stimulus vary according to the backround step (so the OFF
% step between the epoch 2 and 3) and according to the contrast of the
% grating. The first and the fourth epoch are grey values, corresponding to
% the BG value of the next epoch with the moving grating. 

% The stimuli have 6 epochs: epoch 1 is only grey, no grating. Epoch 2 has the same luminance 
% as epoch 3, but the contrast of the grating is smaller than in epoch 3. Epoch 4 is grey (same
% luminance as epoch 5 and 6). Epoch 5 and 6 have darker luminance and the same as in previous 
% two epochs, contrast between the grating and the background is smaller in epoch 3 than in epoch 4.
% The contrast in epoch 2 and 5 is the same, and the contrast is also the same in epochs 3 and 6. 

% Each epoch is displayed for 3 seconds, the order of the epochs is fixed. 
%
%
% Katja December 2017

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
% f_fff_Tm9LexA  = find(i_grey_grating1Weber05_075_BG075_05.*i_UASGCaMP6f_L3MH56Gal4_cross_to_w.*~i_moving);
f_fff_Tm9LexA  = find(i_grey_grating2Weber025_075_BG075_25.*i_UASGCaMP6f_L3MH56Gal4_cross_to_w.*~i_moving);
% f_fff_Tm9LexA  = find(i_grey_grating3Weber04_075_BG075_25.*i_UASGCaMP6f_L3MH56Gal4_cross_to_w.*~i_moving);


%L2
% f_fff_Tm9LexA  = find(i_grey_grating1Weber05_075_BG075_05.*i_UASGCaMP6F_L221DhhGal4_cross_to_w.*~i_moving);
% f_fff_Tm9LexA  = find(i_grey_grating2Weber025_075_BG075_25.*i_UASGCaMP6F_L221DhhGal4_cross_to_w.*~i_moving);
% f_fff_Tm9LexA  = find(i_grey_grating3Weber04_075_BG075_25.*i_UASGCaMP6F_L221DhhGal4_cross_to_w.*~i_moving);


% create structures by neuron
fTm9LexA = create_neuron_structure_all_ks(f_fff_Tm9LexA);

% load all the data!
xTm9LexA = load_neuron_data10Hz_ks(fTm9LexA,pdatapath);


mTm9LexA = aggregate_GREY_gratings_two_luminances(xTm9LexA); %when you wanna look into the aggregate function: in = xTm9LexA
% mTm9LexA = aggregate_GREY_gratings_two_lum_baseline_epoch1_split_epochs(xTm9LexA); %taking epoch1 as a baseline




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
cur_t = linspace(0,18,length(mean_val(1,:)))';


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
  
        hold off;
    else
        fprintf('Case %d did not cross THRESHOLD (%s).\n',ii,titles{ii});
    end
end




%% Plot individual fly means




%% Quantification - End at a certain luminance

%First let's split into real 4 epochs (crossing_rats have to be 30 and not 120)
mTm9LexA = aggregate_GREY_gratings_two_lum_baseline_epoch1_split_epochs(xTm9LexA); %in = xTm9LexA


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

b = bar([1:6],baseline)
e = errorbar([1:6],baseline,err_base,'x')

set(b,'FaceColor',[0 0.8 0])
title('Max response');

% Add titles
ax = gca;
ax.XTick = 1:6;
ax.XTickLabels = {'mean_calcium_epoch1','mean_calcium_epoch2','mean_calcium_epoch3','mean_calcium_epoch4','mean_calcium_epoch5','mean_calcium_epoch6'};
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

baseline1 = [baseline_1 baseline_2 baseline_3 baseline_4]
baseline2 = [baseline_1 baseline_2 baseline_3 baseline_4]

[testDecision , pValue] = ttest2(baseline1(1), baseline2(2))










