%% Analysis_Figure_25ms.m
% This script analyses Data from the Stimulus "OngrayOFF25ms". It has 2
% Epochs, of which one is a black screen shwon 25ms and the other is a
% bright screen shown 25ms. In between is a 2s grey screen shown. Epochs
% are displayed randomly.
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
% % % 
% % % % For the code
% % % addpath('W:\f.buschendorf\TP_code_Katja');

database_select_samples_ks; % obtain the genotype and stimuli information for all of the data

% Select which data you actually want tto look at, include stimulus type
% (ie i_StandingStride and genotype ie i_Tm9LexAGCaMP6F)
% f_Tm9LexA = find(i_fffOngrayOFF25ms.*i_UASGCaMP6F_L221DhhGal4.*~i_moving);
% f_Tm9LexA = find(i_fffOngrayOFF25ms.*i_UASGCaMP6F_L3MH56Gal4.*~i_moving);


% f_Tm9LexA = find(i_fff30msONgrayOFF.*i_L3MH56Gal4_Asap2f.*~i_moving);
f_Tm9LexA = find(i_fff30msONgrayOFF.*(i_L3MH56Gal4_Asap2f | i_pJFRCASAP2f_L3MH56Gal4).*~i_moving);




%Matthew Pecot
% f_Tm9LexA = find(i_fffOngrayOFF25ms.*i_lexAopGCaMP6fp10attp5_16HO3lexA_lexAopmyrtdTOM_11164Gal4_plus.*~i_moving);
% f_Tm9LexA = find(i_fffOngrayOFF25ms.*i_lexAopGCaMP6fp10attp5_16HO3lexA_lexAopmyrtdTOM_11164Gal4ermHA.*~i_moving);



% create structures by neuron
fTm9LexA = create_neuron_structure_all_ks(f_Tm9LexA);
%
% load all the data!
xTm9LexA = load_neuron_data10Hz_25ms_ks(fTm9LexA,pdatapath);
%
% 
mTm9LexA = aggregate_zeronumzero_25ms_v2(xTm9LexA);

%%
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
%     plot(cur_t, mTm9LexA.stimstruct*0.1+1.25, 'k')
    plot(cur_t, mTm9LexA.stimstruct*0.01+0.05, 'k')
    plot(cur_t, (round(mean(mTm9LexA.stimstruct))*0.01)+0.05) %ks: why this doen' work???
    ylim([-0.1 0.1]);
%     ylim([-0.02 0.02]); %for ASAP

    line([0 4],[0 0],'color',[0 0 0]);

end

%% Plot receptive fields of individual ROIs
ROI_num = numel(mTm9LexA.rats(:,1,1));
% value the response for the ROI must reach to be included in this analysis
THRESHOLD_FOR_RESPONDING = 0.15; % or 2 is also good
count = 1;

close all
% plot the receptive field for each ROI in a separete figure
for ii = 1:ROI_num
    
    % response traces for this ROI, for all bar locations
    d = squeeze(mTm9LexA.rats(ii,:,:));
    
    %save these data into a strucutre if the responses are "real" aka above
    %the set THRESHOLD values
    if sum(sum(d > THRESHOLD_FOR_RESPONDING),2)
        
        
        % color used as a diplay of dF/F value 
        figure;
        colormap('parula')
        x = [0 4]; % time
        y = [0 3]; % sets plotting range
        imagesc(x,y,d,[-0.5 0.5])
        set(gca, 'YTick',[1 2]);
        
        %imagesc(d)close al
        c=colorbar;
        ylabel(c,'dF/F')
        ylabel('Epoch')
        xlabel('time (s)')
        niceaxes;
        title([ mTm9LexA.name(ii) '  ROI #' num2str(mTm9LexA.neuron(ii))]);
        
        % another way to look at the data
        figure;  
        for kk = 1:length(d(:,1))
            temp = d(kk,:) + 5 - kk*0.5; % add a value to each trace to move the traces to be non overlapping on the plot
            plot(temp); hold on
        end
        title([mTm9LexA.name(ii) ', ROI #' num2str(mTm9LexA.neuron(ii))]);
        niceaxes; 
     
    else
        % Store neurons which don't cross threshold in array
        neurons(count) = ii; 
        count = count +1;
    end
    
end

%% Plotting mean values by Fly and also for all Flies

close all;

meanEpoch = zeros(size(squeeze(mTm9LexA.rats(1,:,:))));
flyIDs = unique(nonzeros(mTm9LexA.flyID));
meanEpochByFly = zeros(size(mTm9LexA.rats((1:length(flyIDs)),:,:)));

% Erase entries which don't cross threshold
mTm9LexA.flyID(neurons)= 0;

% For each epoch
for jj=1:length(mTm9LexA.rats(1,:,1))
    
    % For each Fly
    for ii=1:length(flyIDs)
        figure;
        cur_flyID = flyIDs(ii);
        
        % Find entries by fly which cross threshold and calculate mean
        meanEpochByFly(ii,jj,:)= mean(mTm9LexA.rats(find(mTm9LexA.flyID==cur_flyID),jj,:),1);
        
        % Standard error
        errorThisFly = std(mTm9LexA.rats(find(mTm9LexA.flyID==cur_flyID),jj,:))/sqrt(length(mTm9LexA.rats(ii,jj,:)));
        
        % Plotting with shadedErrorBar
        x = linspace(0,4,length(squeeze(meanEpochByFly(ii,jj,:))))';
        try
            H = shadedErrorBar(x,squeeze(meanEpochByFly(ii,jj,:)),errorThisFly,'-k',0);
        catch
            warning('Length of errorbar was unequal to length of x and y. Fixing ...');
            errorThisFly = errorThisFly*ones(size(x));
            H = shadedErrorBar(x,squeeze(meanEpochByFly(ii,jj,:)),errorThisFly,'-k',0);
        end
        
        xlabel('time (s)');
        ylabel('dF/F');
        niceaxes;
        title([  'FLY #', num2str(cur_flyID), ' Epoch ', num2str(jj)]);
    end
    
    %Calculate mean error and plot mean of all flies and all neurons which
    %crossed threshold
    figure;
    % Delete neurons which didn't cross threshold
    mTm9LexA.rats(neurons,:,:) = NaN;
    
    % Mean of all Data by Epoch (without NaN values)
    meanEpoch(jj,:)=mean(squeeze(mTm9LexA.rats(:,jj,:)),1,'omitnan');
    errorAll = std(mTm9LexA.rats(:,jj,:),'omitnan')/sqrt(length(mTm9LexA.rats(1,jj,:)));
    Ha = shadedErrorBar(x,squeeze(meanEpoch(jj,:)),errorAll,'-k',0);
    
    xlabel('time (s)');
    ylabel('dF/F');
    niceaxes;
    title(['All Flies' ' Epoch ', num2str(jj)]);
end
