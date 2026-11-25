% StandingStripes_figure
%
% This script takes data obtained using the "StandingStripes" stimulus
% where single static bars and presented sequentially at different points
% on the screen and analysizes the data to look at receptive field size/properties. 
%
% Yvette Fisher 4/2016
clear all;
close all;
clc;

pdatapath='/Users/ksporar/Documents/MATLAB/Katja_pData';
addpath(pdatapath);
cd(pdatapath);

database_select_samples_ks; % obtain the genotype and stimuli information for all of the data


% Select which data you actually want tto look at, include stimulus type
% (ie i_StandingStride and genotype ie i_Tm9LexAGCaMP6F)

%lumDec
% f_Tm9LexA = find(i_standingStripe_LumDec_Vert.*i_UASGCaMP6F_L221DhhGal4.*~i_moving.*(flyID>=300));
% f_Tm9LexA = find(i_standingStripe_LumDec_Vert.*i_UASGCaMP6F_L3MH56Gal4.*~i_moving.*(flyID>=300));

% f_Tm9LexA = find(i_standingStripe_LumDec_Horiz.*i_UASGCaMP6F_L221DhhGal4.*~i_moving.*(flyID>=300));
% f_Tm9LexA = find(i_standingStripe_LumDec_Horiz.*i_UASGCaMP6F_L3MH56Gal4.*~i_moving.*(flyID>=300));

%lumInc
f_Tm9LexA = find(i_standingStripe_LumInc_Vert.*i_UASGCaMP6F_L221DhhGal4.*~i_moving.*(flyID>=300));
% f_Tm9LexA = find(i_standingStripe_LumInc_Vert.*i_UASGCaMP6F_L3MH56Gal4.*~i_moving.*(flyID>=300));

% f_Tm9LexA = find(i_standingStripe_LumInc_Horiz.*i_UASGCaMP6F_L221DhhGal4.*~i_moving.*(flyID>=300));
% f_Tm9LexA = find(i_standingStripe_LumInc_Horiz.*i_UASGCaMP6F_L3MH56Gal4.*~i_moving.*(flyID>=300));

% create structures by neuron
fTm9LexA = create_neuron_structure_all_ks(f_Tm9LexA);
%
% load all the data!
xTm9LexA = load_neuron_data10Hz_ks(fTm9LexA,pdatapath);
%
% 
mTm9LexA = aggregate_standingStripe(xTm9LexA);

%% Plot receptive fields of individual ROIs
% ROI_num = numel(mTm9LexA.rats(:,1,1));
ROI_num = size(mTm9LexA.rats,1)
% THRESHOLD_FOR_RESPONDING = 1;  % value the response for the ROI must reach to be included in this analysis
THRESHOLD_FOR_RESPONDING = 0.5;
count = 1;

clear receptiveField
close all
% plot the receptive field for each ROI in a separete figure
for ii = 1:ROI_num
    
    % response traces for this ROI, for all bar locations
    d = squeeze(mTm9LexA.rats(ii,:,:));
    
    %save these data into a strucutre if the responses are "real" aka above
    %the set THRESHOLD values
    if sum(sum(d > THRESHOLD_FOR_RESPONDING),2)
        receptiveField{count} = d; % store the ones that hit the threshold
        count = count +1;
        
        % color used as a diplay of dF/F value 
        figure;
        colormap('parula')
        x = [0 3];
        y = [-15 30]; % sets plotting range, taken from screen corrdinates for vert... but might be different for horiz
        imagesc(x,y,d,[-0.5 2]) % [-0.5 2] sets the color of the plot
        
        c=colorbar; % sets the table bar on the right side
        ylabel(c,'dF/F')
        ylabel('bar location (deg)')
        xlabel('time (s)')
        niceaxes;
        title([mTm9LexA.name(ii) '  ROI #' num2str(mTm9LexA.neuron(ii))]);
        
        % another way to look at the data
        figure;
        for kk = 1:length(d(:,1))
            temp = d(kk,:) + 5 - kk*0.5; % add a value to each trace to move the traces to be non overlapping on the plot
            plot(temp); hold on
        end
        title([mTm9LexA.name(ii) ', ROI #' num2str(mTm9LexA.neuron(ii))]); % mTm9LexA.neuron tells you the number of yor ROI
        niceaxes; 
    end
    
end

%% Build a plot for the average spatial receptive field

close all
clear peakResp peakRespShifted

%receptiveField stores the traces from each ROI, extra the peak values of
%each and then shift them to be centered

for jj = 1:length(receptiveField)
    
    % pull out these traces and the period during the bar presnetation
    % (1sec before 1sec bar 1 sec after  (@10hz by interpolation by now)
    % 0-10 is zero  10-20 is bar on screen 20-30 is zero again
    % add in flexible coding where this uses the saved variable epochstruct to determine the timing
    bar_start = 10; %frames
    bar_end = 20; %frames
    barResponse = receptiveField{jj}(:,bar_start:bar_end);
    
    temp = max(barResponse,[],2)';
    peakResp(jj,:) = temp;
    
    [~, ind_max] = max(temp);
    ind_center = round(length(temp)/2);
    
    amountToShift = ind_center- ind_max;
    shifted = circshift(temp,amountToShift,2);
    
    % set 'stitched on' values (after circshift) to NaN since they were not acutally measured at
    % those bar positions, if the shift is zero, do nothing
    if amountToShift > 0
        shifted(1:amountToShift) = NaN;
    elseif amountToShift < 0
        shifted(end+amountToShift + 1:end) = NaN;
    end

    peakRespShifted(jj,:) = shifted;
   
    
end

% check the plots of these values
% UNSHIFTED
        figure;
        subplot(2,2,1)
        colormap('parula')
        y = [1:length(peakResp)];
        x = [-15 30]; % sets plotting range
        imagesc(x,y,peakResp)

        c=colorbar;
        ylabel(c,'dF/F')
        title('UNSHIFTED Receptive Fields')
        xlabel('Bar location (deg)');
        ylabel('ROI number');
        niceaxes;

% SHIFTED to be centered at the 5th index
        subplot(2,2,3)
        colormap('parula')
        y = [1:length(peakRespShifted)];
        x = [-15 30]; % sets plotting range
        map = imagesc(x,y,peakRespShifted);
        set(map,'AlphaData',~isnan(peakRespShifted)) %sets NaN data white, somehow

        c=colorbar;
        ylabel(c,'dF/F')
        title('SHIFTED Receptive Fields')
        xlabel('Bar location (deg)');
        ylabel('ROI number');
        niceaxes;
%        
        
% Plot average of these sorted receptive field peak resposnes
        subplot(2,2,2)
        xaxis = 5*((1:length(peakRespShifted(1,:)))- round(length(peakRespShifted(1,:))/2)); % because bars are 5 degrees apart

        bar(xaxis,nanmean(peakRespShifted)); hold on
        niceaxes
        
        sem = nanstd(peakRespShifted)/sqrt(length(peakRespShifted(:,1))); %
        errorbar(xaxis,nanmean(peakRespShifted),sem,'.'); 
        xlabel('Bar location (deg)')
        ylabel('dF/F');
        title(['cutoff Threshold used: ' num2str(THRESHOLD_FOR_RESPONDING)]);
        niceaxes
        
% Plot NORMALIZED average of these sorted receptive field peak resposnes
ROI_max = max(peakRespShifted,[],2)*ones(1,length(peakRespShifted(1,:)));
peakRespShiftNorm = peakRespShifted./ROI_max; % normalized by dividing by the max resposnes for each ROI

  subplot(2,2,4)
        xaxis = 5*((1:length(peakRespShifted(1,:)))- round(length(peakRespShifted(1,:))/2)); % because bars are 5 degrees apart

        bar(xaxis,nanmean(peakRespShiftNorm)); hold on
        niceaxes
        
        sem = nanstd(peakRespShiftNorm)/sqrt(length(peakRespShiftNorm(:,1))); %
        errorbar(xaxis,nanmean(peakRespShiftNorm),sem,'.'); 
        xlabel('Bar location (deg)')
        ylabel('dF/F');
        title(['cutoff Threshold used: ' num2str(THRESHOLD_FOR_RESPONDING)]);
        ylim([-0.2 1.1]);
        niceaxes

% potentially add Gaussian fitting to the mean spatial receptive field map

