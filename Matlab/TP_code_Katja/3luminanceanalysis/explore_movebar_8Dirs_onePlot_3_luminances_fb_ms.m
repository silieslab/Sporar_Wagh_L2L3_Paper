
clc;
clear all;
close all;

% CONSTANTS
ANALYZE_BY_LAYER = true; % weather ROIs should be selected based on their layer in the lobula complex.
LAYER = 'LPB';  % which group or layer of ROIs will be included in this plot
% this layer info is stored as a string in the variable 'layer'in the MASTER excel spreadsheet

if(ANALYZE_BY_LAYER)
    GENOTYPE_STRING = ['T4T5 >> GCaMP6f , layer: ' LAYER];
    if(strcmp(LAYER,'LPB'))
        COLOR_OF_PLOT = [0 .5 0];% GREEN
        COLOR_CLOUD =[.5 .7 .5];% GREEN
    elseif(strcmp(LAYER,'LPC'))
        COLOR_OF_PLOT = [1 0 0]; %RED
        COLOR_CLOUD = [1 .5 .5]; %RED cloud
    elseif(strcmp(LAYER,'LPD'))
        COLOR_OF_PLOT = [.7 .7 0];% YELLOW
        COLOR_CLOUD = [.9 .9 .5];%YELLOW cloud
    else
        COLOR_OF_PLOT = [0 0 1]; %BLUE; 
        COLOR_CLOUD = [.5 .5 1]; %blue cloud
    end
else
    GENOTYPE_STRING = 'L2 >> GCaMP6f, all layers';
    COLOR_OF_PLOT = [0 0 1]; %BLUE; [.7 .7 0]% YELLOW %[1 0 0]; %RED% [0 .5 0]% GREEN %[0 0 1]; %BLUE;
    %COLOR_OF_PLOT = [1 0 0]; %RED; %[0 0 1] %BLUE;
    COLOR_CLOUD = [.5 .5 1];
end
gen_str = GENOTYPE_STRING;

MAX_LAG = 15; % the max that the alignement of receptive fields can shift the traces

%% Stimulus 'DriftingStripe_10deg_20degPerSek_8Directions_3luminances_darkOnBright_ks'
% 
% where a grey epoch was displayed 3 seconds in between 24 other epochs
% with moving bars in 8 different directions and 3 different luminance levels
% which were 5 seconds long.
% 
% epoch 0: grey
%
% first: 0.25 on 0.75 (dark grey on bright grey)
% second: 0 on 0.5 (dark on grey)
% third: 0.5 on 1.5 (grey on bright)
%
% epoch 1-3: rot 0 
% epoch 4-6: rot 90
% epoch 7-9: rot 180
% epoch 10-12: rot 270
% epoch 13-15: rot 45
% epoch 16-18: rot 135
% epoch 19-21: rot 225
% epoch 22-24: rot 315
% 
pdatapath='/Users/ksporar/Documents/MATLAB/Katja_pData';
addpath(pdatapath);
cd(pdatapath);


% fetch Information from Masterfoldersummary
database_select_samples_ks;

% find matching pData files
% f_mb_L2 = find(i_UASGCaMP6f_L3MH56Gal4_cross_to_w_06_37C.*i_DriftingStripe_3luminances.*~i_moving);
% f_mb_L2 = find(i_UASGCaMP6f_L3MH56Gal4_cross_to_w.*i_DriftingStripe_3luminances.*~i_moving);
% f_mb_L2 = find(i_UASGCaMP6F_L221DhhGal4_cross_to_w.*i_DriftingStripe_3luminances.*~i_moving);
% f_mb_L2 = [4548,4559] 


% f_mb_L2 = find(i_UASGCaMP6f_L3MH56Gal4_cross_to_w.*i_DriftingStripe_3luminances_new_WeberContrast.*~i_moving);
% f_mb_L2 = find(i_UASGCaMP6F_L221DhhGal4_cross_to_w.*i_DriftingStripe_3luminances_new_WeberContrast.*~i_moving);



%T4/T5 imaging, L3 silencing
% f_mb_L2 = find(i_T4T5QF_QUASGCaMP6f_UASshits_MH56Gal4_38preincubated.*i_DriftingStripe_3luminances.*~i_moving);
% f_mb_L2 = find(i_T4T5QF_QUASGCaMP6f_UASshits_MH56Gal4_38preincubated.*i_DriftingStripe_3luminances.*~i_moving.*(flyID<=521));
% f_mb_L2 = find(i_T4T5QF_QUASGCaMP6f_UASshits_wcontrol_38preincubated.*i_DriftingStripe_3luminances.*~i_moving);


%T4/T5 imaging, L3 silencing - Michael Reiser T4/T5 stock
f_mb_L2 = find(i_T4T5LexA_LexAopGCaMP6m_UASshits_control.*i_DriftingStripe_3luminances_new_WeberContrast.*~i_moving);

% f_mb_L2 = find(i_T4T5lexA_lexAopGCaMP6m_UASshits_0595Gal4.*i_DriftingStripe_3luminances_new_WeberContrast.*~i_moving);


% f_mb_L2 = find(i_T4T5LexA_LexAopGCaMP6m_UASshits_MH56Gal4.*i_DriftingStripe_3luminances_new_WeberContrast.*~i_moving);
% f_mb_L2 = find(i_T4T5LexA_LexAopGCaMP6m_UASshits_L221DhhGal4.*i_DriftingStripe_3luminances_new_WeberContrast.*~i_moving);


% f_mb_L2 = find((i_T4T5lexA_lexAopGCaMP6m_UASshits_0595Gal4 | i_T4T5LexA_LexAopGCaMP6m_UASshits_MH56Gal4).*i_DriftingStripe_3luminances_new_WeberContrast.*~i_moving);


% f_mb_L2 = find(i_T4T5LexA_LexAopGCaMP6m_UASshits_control.*i_DriftingEDGE_3luminances_new_WeberContrast.*~i_moving);



% create structures by neuron
fL2_mb = create_neuron_structure_all_ks(f_mb_L2); % 4893

if (ANALYZE_BY_LAYER)
    L2_mb = load_neuron_data10Hz_byLayer(fL2_mb,pdatapath, LAYER);
else
    % interpolates at 10 Hz now...
    L2_mb = load_neuron_data10Hz_ks(fL2_mb,pdatapath);
end

% This function will sort the ratio signals into
% .rats[ROIs,EPOCHs,duration] -> [ROIs,24,110].
% The duration of one trace is (3 sec. grey + 5 sec. epoch + 3 sec. grey).
% It takes the mean over equal epochs, so if an epoch was shown more than
% once, the epochs signals are averaged. The std error of that mean is
% stored in .error. But this error is not used in the further analysis.
% It normalizes the signal with a baseline taken from the last second of
% the grey epoch.
aL2 = aggregate_mb_XorYcenter_8dirs_allEpo_3lum_added_Centers(L2_mb); %to get into the aggregate function: in = L2_mb
% aL2 = aggregate_mb_XorYcenter_8dirs_allEpo_ks_msplay_3_luminances_fb_ks_added_Centers(L2_mb);
%% Prerequisites

dur = size(aL2(1).rats,3); %ms: the epoch duration is now automatically determined in the aggregate function
iFRAMERATE = 10; %ms: interpolated framerate that is used in load_neuron_data function
cur_t = (1:dur)/iFRAMERATE;  %ms: create a real timing vector (fs / (fs/s)  = s)
% % % error_ROI = aL2.error; ks??????

cur_mat = aL2.rats;
cur_IDs = aL2.flyID;
n_epochs = size(cur_mat,2);

% Rotation of each epochs bar's
dirs = [0,0,0,90,90,90,180,180,180,270,270,270,45,45,45,135,135,135,225,225,225,315,315,315];

% Sort epochs to luminance categories:
darkgrey_on_brightgrey = [1,7,4,10,13,19,16,22];
dark_on_grey = [2, 8, 5, 11, 14, 20, 17, 23];
grey_on_bright= [3, 9, 6, 12, 15, 21, 18, 24];

%% Average across Fly IDs
% Analyze by epoch, mean over all FlyID's 
% Plot a figure for each direction with a subplot for each luminance type

% Adjust the threshold!
% THRESHOLD_FOR_RESPONDING = 0.1;
THRESHOLD_FOR_RESPONDING = 0.5;

num_ROIs = size(cur_mat,1);
cur_mat = aL2.rats;
omitted = cell(num_ROIs,n_epochs);

for ii=1:num_ROIs
    for kk=1:n_epochs
        d = squeeze(cur_mat(ii,kk,:));
        % Is there any value above threshold?
        if (sum( abs(d) > THRESHOLD_FOR_RESPONDING) > 0)
            
        % If this epoch from this ROI does NOT cross threshold, ignore
        % for analysis
        else
            cur_mat(ii,kk,:)= NaN;
            fprintf('ROI %d with epoch %d did not cross threshold.\n',ii,kk)
        end
    end
end

counter = 1;

% Make 8 plots with 3 subplots each.
for ii= darkgrey_on_brightgrey
    
    figure('Name',['Mean Fly, Direction ',num2str(dirs(ii)),'?']); hold on
    counter = counter + 1;
    
    % darkgrey_on_brightgrey
    ax1 = subplot(3,1,1);
    epochRats = squeeze(cur_mat(:,ii,:));
    [x,m,e] = mean_cat_full(epochRats,1,cur_IDs); %m=mean; e=std . x=mean of flyID
    colormap('lines');
    plot_err_patch_v2(cur_t,m,e,[0 0 1],[0.5 0.5 1]);
    
%     ylim([-0.4 2.5]); %L2
    ylim([-0.4 1.0]); %L3
    xlim([0 11]);
    ylabel('dF/F');
    xlabel('time (s)');
    
    % Indicate grey epoch end and begin
    line([3 3],get(gca,'ylim'),'color',[0 0 0 0.3]);
    line([8 8],get(gca,'ylim'),'color',[0 0 0 0.3]);

    title(ax1,'25% on 75% - darkgrey bar on brightgrey BG');
    
    
    % dark_on_grey
    ax2 = subplot(3,1,2);
    epochRats = squeeze(cur_mat(:,ii+1,:));
    [x,m,e] = mean_cat_full(epochRats,1,cur_IDs); %m=mean; e=std . x=mean of flyID
    colormap('lines');
%     plot_err_patch_v2(cur_t,m,e,[0 0 1],[0.5 0.5 1]);
    h1 = plot_err_patch_v2(cur_t,m,e,[0 0 1],[0.5 0.5 1]);
    % Indicate grey epoch end and begin
    line([3 3],get(gca,'ylim'),'color',[0 0 0 0.3]);
    line([8 8],get(gca,'ylim'),'color',[0 0 0 0.3]);
    
%     ylim([-0.4 2.5]); %L2
    ylim([-0.4 1.0]); %L3
    xlim([0 11]);
    ylabel('dF/F');
    xlabel('time (s)');
    
    title(ax2,'0% on 50% - dark bar on grey BG');
    
    % grey_on_bright
    ax3 = subplot(3,1,3);
    epochRats = squeeze(cur_mat(:,ii+2,:));
    [x,m,e] = mean_cat_full(epochRats,1,cur_IDs); %m=mean; e=std . x=mean of flyID
    cm=colormap('lines');
    h1 = plot_err_patch_v2(cur_t,m,e,[0 0 1],[0.5 0.5 1]);
    
    % Indicate grey epoch end and begin
    line([3 3],get(gca,'ylim'),'color',[0 0 0 0.3]);
    line([8 8],get(gca,'ylim'),'color',[0 0 0 0.3]);
    
%     ylim([-0.4 2.5]); %L2
    ylim([-0.4 1.0]); %L3
    xlim([0 11]);
    ylabel('dF/F');
    xlabel('time (s)');
    
    legend([h1],sprintf('N = %d ( %d )',size(x,1),size(epochRats,1)),... %ks added
    'location','northeast');
    
    title(ax3,'50% on 100% - grey bar on bright BG');
end
%% Quantification Fabiola
% Search for a peak, substract the baseline and add errorbars (by FlyID)
close all

peak_val = zeros(1,n_epochs);
err_peak =  zeros(1,n_epochs);
baseline =  zeros(1,n_epochs);
err_base =  zeros(1,n_epochs);

for ii=1:n_epochs
    epochRats = squeeze(cur_mat(:,ii,:));
    % Error by Fly
    [x,m,e] = mean_cat_full(epochRats,1,cur_IDs); %m=mean; e=std
    % The range for the baseline can be changed
    baseline(ii) = mean(m(1:30));
    baseline_range = m(1:30);
    err_base(ii) = std(baseline_range,'omitnan')/sqrt(length(baseline_range));
    
    peak_range = m(30:80);
    peak_val(ii) = max(peak_range)-baseline(ii)
    % Error propagation: Add the two errors
    err_peak(ii) = err_base(ii) + std(peak_range,'omitnan')/sqrt(length(peak_range));
end

figure;
hold on;
grid on;
ylim([-0.1 2.0]); %L2
% ylim([-0.1 0.7]); %L3

b = bar([1:24],peak_val)
e = errorbar([1:24],peak_val,err_peak,'x')

set(b,'FaceColor',[0 0.8 0])
title('Max response');

% Add titles
ax = gca;
ax.XTick = 1:24;
ax.XTickLabels = {'darkgrey on brightgrey 1','dark on grey 2','grey on bright 3','darkgrey on brightgrey 4', 'dark on grey 5','grey on bright 6',...
    'darkgrey on brightgrey 7','dark on grey 8','grey on bright 9' ,'darkgrey on brightgrey 10', ...
    'dark on grey 11','grey on bright 12', 'darkgrey on brightgrey 13','dark on grey 14', 'grey on bright 15', 'darkgrey on brightgrey 16',...
    'dark on grey 17','grey on bright 18','darkgrey on brightgrey 19', 'dark on grey 20', 'grey on bright 21', 'darkgrey on brightgrey 22',...
    'dark on grey 23', 'grey on bright 24'};
ax.XTickLabelRotation = 45;

hold off;
%% Quantification 3 Luminances
% Averaged over 8 directions
n_lum = 3;
n_dir = 8;

peak_mean(1) = mean(peak_val(darkgrey_on_brightgrey));
peak_mean(2) = mean(peak_val(dark_on_grey));
peak_mean(3) = mean(peak_val(grey_on_bright));

% Error propagation. err(x+y) = sqrt(x^2+y^2)
peak_mean_err(1) = sqrt(sum(err_peak(darkgrey_on_brightgrey).^2))/sqrt(n_dir);
% OR ??
% peak_mean_err(1) = sqrt(sum(err_peak(darkgrey_on_brightgrey).^2))/n_dir;
peak_mean_err(2) = sqrt(sum(err_peak(dark_on_grey).^2))/sqrt(n_dir);
peak_mean_err(3) = sqrt(sum(err_peak(grey_on_bright).^2))/sqrt(n_dir);

figure;
hold on;
grid on;
ylim([-0.1 2.0]); %L2
% ylim([-0.1 0.7]); %L3

b = bar([1:n_lum],peak_mean)
e = errorbar([1:n_lum],peak_mean,peak_mean_err,'x')

set(b,'FaceColor',[0 0.8 0])
title('Max avrg. response per luminance');

% Add titles
ax = gca;
ax.XTick = 1:24;
ax.XTickLabels = {'darkgrey on brightgrey','dark on grey','grey on bright'};
ax.XTickLabelRotation = 45;

hold off;



%ks added: make a plot with all the directions pooled together!!










%% Average across ROIs
% Analyze by epoch, mean over all ROIs
% Plot a figure for each direction with a subplot for each luminance type

close all;

% % Do you want another threshold?
% THRESHOLD_FOR_RESPONDING = 0.0;
% num_ROIs = size(cur_mat,1);
% cur_mat = aL2.rats;
% 
% for ii=1:num_ROIs
%     for kk=1:n_epochs
%         d = squeeze(cur_mat(ii,kk,:));
%         % Is there any value above threshold?
%         if sum(d > THRESHOLD_FOR_RESPONDING)
%             
%         % If this epoch from this ROI does NOT cross threshold, ignore
%         % for analysis
%         else
%             cur_mat(ii,kk,:)= NaN;
%         end
%     end
% end

counter = 1;

for ii= darkgrey_on_brightgrey
    
    figure('Name',['Mean ROI, Direction ',num2str(dirs(ii)),'?']); hold on
    counter = counter + 1;
    
    % darkgrey_on_brightgrey
    ax1 = subplot(3,1,1);
    epochRats = squeeze(cur_mat(:,ii,:));
    mROI = mean(epochRats,'omitnan');
    eROI = std(epochRats,[],1,'omitnan')/sqrt(size(epochRats,1)); %S.E.M

    colormap('lines');
    plot_err_patch_v2(cur_t,mROI,eROI,[0 0 1],[0.5 0.5 1]);
    
    ylim([-0.2 2.4]);
    xlim([0 11]);
    ylabel('dF/F');
    xlabel('time (s)');
    
    % Indicate grey epoch end and begin
    line([3 3],get(gca,'ylim'),'color',[0 0 0 0.3]);
    line([8 8],get(gca,'ylim'),'color',[0 0 0 0.3]);

    title(ax1,'25% on 75%');

    % dark_on_grey
    ax2 = subplot(3,1,2);
    epochRats = squeeze(cur_mat(:,ii+1,:));
    mROI = mean(epochRats,'omitnan');
    eROI = std(epochRats,[],1,'omitnan')/sqrt(size(epochRats,1)); %S.E.M

    colormap('lines');
    plot_err_patch_v2(cur_t,mROI,eROI,[0 0 1],[0.5 0.5 1]);
    
    ylim([-0.2 2.4]);
    xlim([0 11]);
    ylabel('dF/F');
    xlabel('time (s)');
    
    title(ax2,'0% on 50%');
    
    % grey_on_bright
    ax3 = subplot(3,1,3);
    epochRats = squeeze(cur_mat(:,ii+2,:));
    mROI = mean(epochRats,'omitnan');
    eROI = std(epochRats,[],1,'omitnan')/sqrt(size(epochRats,1)); %S.E.M

    colormap('lines');
    plot_err_patch_v2(cur_t,mROI,eROI,[0 0 1],[0.5 0.5 1]);
    
    % Indicate grey epoch end and begin
    line([3 3],get(gca,'ylim'),'color',[0 0 0 0.3]);
    line([8 8],get(gca,'ylim'),'color',[0 0 0 0.3]);
    
    ylim([-0.2 2.4]);
    xlim([0 11]);
    ylabel('dF/F');
    xlabel('time (s)');
    
    title(ax3,'50% on 100%');
end



%% PLOTS - ROIs individual (maybe we dont need this)- Lots of plots!
% cur_mat = aL2.rats;
% 
% counter = 1;
% 
% % Analyze by epoch, for each ROI
% % Plot a figure for each direction with a subplot for each luminance type
% for jj=1:size(cur_mat,1)
%     for ii= darkgrey_on_brightgrey
%         figure('Name',['Direction ',num2str(dirs(ii)),'? Fly #',num2str(cur_IDs(jj)), 'ROI #',num2str(jj)]); hold on
%         counter = counter + 1;
% 
%         % darkgrey_on_brightgrey
%         ax1 = subplot(3,1,1);
%         epochRats_mean = squeeze(cur_mat(jj,ii,:));
%         error = squeeze(error_ROI(jj,ii,:));
%         colormap('lines');
%         plot_err_patch_v2(cur_t,epochRats_mean,error,[0 0 1],[0.5 0.5 1]);
% 
%         ylim([-0.2 0.4]);
%         xlim([0 11]);
%         ylabel('dF/F');
%         xlabel('time (s)');
% 
%         % Indicate grey epoch end and begin
%         line([3 3],get(gca,'ylim'),'color',[0 0 0 0.3]);
%         line([8 8],get(gca,'ylim'),'color',[0 0 0 0.3]);
% 
%         title(ax1,'25% on 75%');
% 
%         % dark_on_grey
%         ax2 = subplot(3,1,2);
%         epochRats_mean = squeeze(cur_mat(jj,ii+1,:));
%         error = squeeze(error_ROI(jj,ii+1,:));
%         colormap('lines');
%         plot_err_patch_v2(cur_t,epochRats_mean,error,[0 0 1],[0.5 0.5 1]);
% 
%         % Indicate grey epoch end and begin
%         line([3 3],get(gca,'ylim'),'color',[0 0 0 0.3]);
%         line([8 8],get(gca,'ylim'),'color',[0 0 0 0.3]);
% 
%         ylim([-0.2 0.4]);
%         xlim([0 11]);
%         ylabel('dF/F');
%         xlabel('time (s)');
% 
%         title(ax2,'0% on 50%');
% 
%         % grey_on_bright
%         ax3 = subplot(3,1,3);
%         epochRats_mean = squeeze(cur_mat(jj,ii+2,:));
%         error = squeeze(error_ROI(jj,ii+2,:));
%         colormap('lines');
%         plot_err_patch_v2(cur_t,epochRats_mean,error,[0 0 1],[0.5 0.5 1]);
% 
%         % Indicate grey epoch end and begin
%         line([3 3],get(gca,'ylim'),'color',[0 0 0 0.3]);
%         line([8 8],get(gca,'ylim'),'color',[0 0 0 0.3]);
% 
%         ylim([-0.2 0.4]);
%         xlim([0 11]);
%         ylabel('dF/F');
%         xlabel('time (s)');
% 
%         title(ax3,'50% on 100%');
%     end
% end



%% Polar plot - 4 directions
close all

% epoch 1-3: rot 0 
% epoch 4-6: rot 90
% epoch 7-9: rot 180
% epoch 10-12: rot 270
% epoch 13-15: rot 45
% epoch 16-18: rot 135
% epoch 19-21: rot 225
% epoch 22-24: rot 315



% Rotation of each epochs bar's
dirs = [0,0,0,90,90,90,180,180,180,270,270,270,45,45,45,135,135,135,225,225,225,315,315,315];

% Sort epochs to luminance categories:
darkgrey_on_brightgrey = [1,7,4,10,13,19,16,22];
dark_on_grey = [2, 8, 5, 11, 14, 20, 17, 23];
grey_on_bright= [3, 9, 6, 12, 15, 21, 18, 24];

%Make it 0 to 315 in order
theta = darkgrey_on_brightgrey([1, 5, 3, 7, 2, 6, 4, 8]);
theta2 = dark_on_grey([1, 5, 3, 7, 2, 6, 4, 8]);
theta3 = grey_on_bright([1, 5, 3, 7, 2, 6, 4, 8]);

%PolarPlot
PP=figure('Color', [1 1 1]);


peaks_darkgrey_on_brightgrey = peak_val([1, 13, 4, 16, 7, 19, 10, 22]);
peaks_dark_on_grey = peak_val([2, 14, 5, 17, 8, 20, 11, 23]);
peaks_grey_on_bright = peak_val([3, 15, 6, 18, 9, 21, 12, 24]);


for i = 1;
    polar(theta, peaks_darkgrey_on_brightgrey); 
    PolarPlot_std
end

polar(theta1, peaks_darkgrey_on_brightgrey); 
polar(theta1, peaks_dark_on_grey);
polar(theta1, peaks_grey_on_bright);
PolarPlot_std









