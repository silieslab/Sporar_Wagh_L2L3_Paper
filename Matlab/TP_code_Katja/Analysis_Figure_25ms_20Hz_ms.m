%% Analysis_Figure_25ms.m
% This script analyses Data from the Stimulus "OngrayOFF25ms". It has 2
% Epochs, of which one is a black screen shown 25ms and the other is a
% bright screen shown 25ms. In between is a 2s grey screen shown. Epochs
% are displayed randomly. Epoch 1: Black, Epoch 2: Bright.
%
% I updated the function arguments so, that the 25ms stimulus is being
% processed. Then all the ROIs which cross a Threshold are being plotted
% and in the end you find mean-plots by epoch for every Fly and the resuming
% mean-plots per Epoch.
%
% Fabiola 6/2016
%

clear all;
close all;
clc;

pdatapath='/Users/ksporar/Documents/MATLAB/Katja_pData';
addpath(pdatapath);
cd(pdatapath);

% For the code
% addpath('W:\f.buschendorf\TP_code_Katja');

database_select_samples_ks; % obtain the genotype and stimluli information for all of the data

%%
% Select which data you actually want to look at, include stimulus type
% (ie i_StandingStride and genotype ie i_Tm9LexAGCaMP6F)
% f_Tm9LexA = find(i_fffOngrayOFF25ms.*i_UASGCaMP6F_L221DhhGal4.*~i_moving);
f_Tm9LexA = find(i_fffOngrayOFF25ms.*i_UASGCaMP6F_L3MH56Gal4.*~i_moving.*(flyID~=287));




% create structures by neuron
% fTm9LexA = create_neuron_structure_all_yf(f_Tm9LexA);
fTm9LexA = create_neuron_structure_all_ks(f_Tm9LexA);
%
% load all the data! 
xTm9LexA = load_neuron_data20Hz_25ms_ks(fTm9LexA,pdatapath);
%
% aggregate data
mTm9LexA = aggregate_zeronumzero_25ms_v2(xTm9LexA);


%% Plot response of individual ROIs (Plots might be less interesting)
close all

% value the response for the ROI must reach to be included in this analysis
THRESHOLD_FOR_RESPONDING = 0.2; % or 0.15 is also good
% count = 1;


% plot the response trace for each ROI in a separate figure
ROI_num = numel(mTm9LexA.rats(:,1,1));

belowThresh_neurons = zeros(1,ROI_num);
for ii = 1:ROI_num
    
    % response traces for this ROI, for all flashes
    d = squeeze(mTm9LexA.rats(ii,:,:));
    abs_d = abs(d);
    abs_d_2ndhalf = abs_d(:,round(end/2+1):end); %looking just at the second half
    %save these data into a strucutre if the responses are "real" aka above
    %the set THRESHOLD values
    % if 0 -> false , if NUMBER_ELSE_THAN_0 -> True
    if sum(sum(abs_d_2ndhalf > THRESHOLD_FOR_RESPONDING),2)
        
        
        % color used as a diplay of dF/F value 
%         figure;
%         colormap('parula')
%         x = [0 4]; % time
%         y = [0 3]; % sets plotting range
%         imagesc(x,y,d,[-0.5 0.5])
%         set(gca, 'YTick',[1 2]);
%         
%         %imagesc(d)close al
%         c=colorbar;
%         ylabel(c,'dF/F')
%         ylabel('Epoch')
%         xlabel('time (s)')
%         niceaxes;
%         title([ mTm9LexA.name(ii) '  ROI #' num2str(mTm9LexA.neuron(ii))]);
%         
%         % another way to look at the data
%         figure;  
%         for kk = 1:length(d(:,1))
%             temp = d(kk,:) + 5 - kk*0.5; % add a value to each trace to move the traces to be non overlapping on the plot
%             plot(temp); hold on
%         end
%         title([mTm9LexA.name(ii) ', ROI #' num2str(mTm9LexA.neuron(ii))]);
%         niceaxes; 
%      
    else
        % Store neurons which don't cross threshold in array
        belowThresh_neurons(ii) = 1; 
        
%         count = count +1;
    end
    
end

belowThresh_neurons = logical(belowThresh_neurons);
%%  Erase entries which didn't cross threshold

if exist('belowThresh_neurons','var')
    crossing_flyIDs = mTm9LexA.flyID;
    crossing_flyIDs(belowThresh_neurons)= 0;
    
    % For each epoch
    for jj=1:size(mTm9LexA.rats,2)
        
        % Delete neurons which didn't cross threshold
        crossing_rats = mTm9LexA.rats;
        crossing_rats(belowThresh_neurons,:,:) = NaN;
        
    end
else
    crossing_flyIDs = mTm9LexA.flyID;
    crossing_rats = mTm9LexA.rats;
end

%% Mean by ROIs - code by Katja/Marion
close all;

iRATE = 20; %rate at which data are interpolated

% Just those which crossed threshold:
cur_ROIs = 1:size(mTm9LexA.rats,1);
cur_mat = crossing_rats;
% Just those which crossed threshold:
cur_IDs = crossing_flyIDs;

% Or without any threshold:
%cur_mat = mTm9LexA.rats;
%cur_IDs = mTm9LexA.flyID;

cur_t = (1:size(cur_mat,3))/iRATE;


% For each epoch
for ii = 1:size(mTm9LexA.rats,2)
    epochRats = squeeze(cur_mat(:,ii,:));
    [x,m,e] = mean_cat_full(epochRats,1,cur_ROIs); %m=mean; e=std

    figure; hold on
    cm=colormap('lines');
    h1 = plot_err_patch_v2(cur_t,m,e,[0 0 1],[0.5 0.5 1]);

    if (ii==1)
        title('-100% OFFgrey - mean by ROI')
    elseif (ii==2)
        title('100% ONgrey - mean by ROI')
    end
    
    
    % How many flies and ROIs crossed the threshold ?
    num_crossed_flies = size(unique(crossing_flyIDs(crossing_flyIDs>0)),2);
    num_crossing_ROIs = size(find(all(~isnan(epochRats),2)),1);

    % n =   CROSSED_ROIS (ALL_ROIS) -> e.g. N = 60 (145)
    legend([h1],sprintf('N = %d ( %d )',num_crossed_flies,num_crossing_ROIs),...
        'location','northeast');
    plot(cur_t, mTm9LexA.stimstruct*0.05+0.05, 'k')
    ylim([-0.2 0.2]);
    line([0 2],[0 0],'color',[0 0 0]);
    ylabel('Calcium Signal df/f');
    xlabel('time (s)');

end
hold off;

%% Mean by Flies (by ID) - code by Fabiola (with Katja's example)


% For each epoch
for ii = 1:size(mTm9LexA.rats,2)
    epochRats = squeeze(cur_mat(:,ii,:));
    [x,m,e] = mean_cat_full(epochRats,1,cur_IDs); %m=mean; e=std

    figure; hold on
    cm=colormap('lines');
    h1 = plot_err_patch_v2(cur_t,m,e,[0 0 1],[0.5 0.5 1]);

    if (ii==1)
        title('-100% OFFgrey - mean by Fly')
    elseif (ii==2)
        title('100% ONgrey - mean by Fly')
    end

    legend([h1],sprintf('N = %d ( %d )',num_crossed_flies,num_crossing_ROIs),...
        'location','northeast');
    plot(cur_t, mTm9LexA.stimstruct*0.05+0.05, 'k')
    ylim([-0.2 0.2]);
    line([0 2],[0 0],'color',[0 0 0]);
    ylabel('Calcium Signal df/f');
    xlabel('time (s)');

end

