
clc;
clear all;
close all;

% CONSTANTS
ANALYZE_BY_LAYER = false; % weather ROIs should be selected based on their layer in the lobula complex.
LAYER = 'LPC';  % which group or layer of ROIs will be included in this plot
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
% Change this variable to your pData path
% pdatapath='W:\f.buschendorf\#Projects\3_luminances';
pdatapath='/Users/ksporar/Documents/MATLAB/Katja_pData';
addpath(pdatapath);
cd(pdatapath);

% % For the code
% addpath('W:\f.buschendorf\TP_code_Katja');

% fetch Information from Masterfoldersummary
database_select_samples_ks;

% find matching pData files
% f_mb_L2 = find(i_UASGCaMP6f_L3MH56Gal4_cross_to_w_06_37C.*i_DriftingStripe_3luminances.*~i_moving);
f_mb_L2 = find(i_UASGCaMP6f_L3MH56Gal4_cross_to_w.*i_DriftingStripe_3luminances.*~i_moving);
% f_mb_L2 = find(i_UASGCaMP6F_L221DhhGal4_cross_to_w.*i_DriftingStripe_3luminances.*~i_moving);


%T4/T5 imaging, L3 silencing
% f_mb_L2 = find(i_T4T5QF_QUASGCaMP6f_UASshits_MH56Gal4_38preincubated.*i_DriftingStripe_3luminances.*~i_moving);
% f_mb_L2 = find(i_T4T5QF_QUASGCaMP6f_UASshits_MH56Gal4_38preincubated.*i_DriftingStripe_3luminances.*~i_moving.*(flyID<=521));
% f_mb_L2 = find(i_T4T5QF_QUASGCaMP6f_UASshits_wcontrol_38preincubated.*i_DriftingStripe_3luminances.*~i_moving);



% create structures by neuron
fL2_mb = create_neuron_structure_all_ks(f_mb_L2);

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
THRESHOLD_FOR_RESPONDING = 0.1;

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
    
    ylim([-0.4 2.5]); %L2
%     ylim([-0.4 0.7]); %L3
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
    
    ylim([-0.4 2.5]); %L2
%     ylim([-0.4 0.7]); %L3
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
    
    ylim([-0.4 2.5]); %L2
%     ylim([-0.4 0.7]); %L3
    xlim([0 11]);
    ylabel('dF/F');
    xlabel('time (s)');
    
    legend([h1],sprintf('N = %d ( %d )',size(x,1),size(epochRats,1)),... %ks added
    'location','northeast');
    
    title(ax3,'50% on 100% - grey bar on bright BG');
end


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



%% Quantification
close all;

    counter = 0; % starting counter value!

for ii = 1:24
    epochRats = squeeze(cur_mat(:,ii,:));
    [x,m,e] = mean_cat_full(epochRats,1,cur_IDs); %m=mean; e=std
    
    counter = counter + 1;
    
    if (ii==1)
       title('darkgrey on brightgrey 1')
    peak_response_1 = m(30:80);
    m_peak_response_1 = max(m(30:80));
    err_peak_response_1 = std(peak_response_1,'omitnan')/sqrt(length(peak_response_1));
    elseif(ii==2)
               title('dark on grey 2')
    peak_response_2 = m(30:80);
    m_peak_response_2 = max(m(30:80));
    err_peak_response_2 = std(peak_response_2,'omitnan')/sqrt(length(peak_response_2));
    elseif(ii==3)
               title('grey on bright 3')
    peak_response_3 = m(30:80);
    m_peak_response_3 = max(m(30:80));
    err_peak_response_3 = std(peak_response_3,'omitnan')/sqrt(length(peak_response_3));
    elseif(ii==4)
               title('darkgrey on brightgrey 4')
    peak_response_4 = m(30:80);
    m_peak_response_4 = max(m(30:80));
    err_peak_response_4 = std(peak_response_4,'omitnan')/sqrt(length(peak_response_4));
    elseif(ii==5)
               title('dark on grey 5')
    peak_response_5 = m(30:80);
    m_peak_response_5 = max(m(30:80));
    err_peak_response_5 = std(peak_response_5,'omitnan')/sqrt(length(peak_response_5));
    elseif(ii==6)
               title('grey on bright 6')
    peak_response_6 = m(30:80);
    m_peak_response_6 = max(m(30:80));
    err_peak_response_6 = std(peak_response_6,'omitnan')/sqrt(length(peak_response_6));
    elseif(ii==7)
               title('darkgrey on brightgrey 7')
    peak_response_7 = m(30:80);
    m_peak_response_7 = max(m(30:80));
    err_peak_response_7 = std(peak_response_7,'omitnan')/sqrt(length(peak_response_7));
    elseif(ii==8)
               title('dark on grey 8')
    peak_response_8 = m(30:80);
    m_peak_response_8 = max(m(30:80));
    err_peak_response_8 = std(peak_response_8,'omitnan')/sqrt(length(peak_response_8));
    elseif(ii==9)
               title('grey on bright 9')
    peak_response_9 = m(30:80);
    m_peak_response_9 = max(m(30:80));
    err_peak_response_9 = std(peak_response_9,'omitnan')/sqrt(length(peak_response_9));
    elseif(ii==10)
               title('darkgrey on brightgrey 10')
    peak_response_10 = m(30:80);
    m_peak_response_10 = max(m(30:80));
    err_peak_response_10 = std(peak_response_10,'omitnan')/sqrt(length(peak_response_10));
    elseif(ii==11)
               title('dark on grey 11')
    peak_response_11 = m(30:80);
    m_peak_response_11 = max(m(30:80));
    err_peak_response_11 = std(peak_response_11,'omitnan')/sqrt(length(peak_response_11));
    elseif(ii==12)
               title('grey on bright 12')
    peak_response_12 = m(30:80);
    m_peak_response_12 = max(m(30:80));
    err_peak_response_12 = std(peak_response_12,'omitnan')/sqrt(length(peak_response_12));
    elseif(ii==13)
               title('darkgrey on brightgrey 13')
    peak_response_13 = m(30:80);
    m_peak_response_13 = max(m(30:80));
    err_peak_response_13 = std(peak_response_13,'omitnan')/sqrt(length(peak_response_13));
    elseif(ii==14)
               title('dark on grey 14')
    peak_response_14 = m(30:80);
    m_peak_response_14 = max(m(30:80));
    err_peak_response_14 = std(peak_response_14,'omitnan')/sqrt(length(peak_response_14));
    elseif(ii==15)
               title('grey on bright 15')
    peak_response_15 = m(30:80);
    m_peak_response_15 = max(m(30:80));
    err_peak_response_15 = std(peak_response_15,'omitnan')/sqrt(length(peak_response_15));
    elseif(ii==16)
               title('darkgrey on brightgrey 16')
    peak_response_16 = m(30:80);
    m_peak_response_16 = max(m(30:80));
    err_peak_response_16 = std(peak_response_16,'omitnan')/sqrt(length(peak_response_16));
    elseif(ii==17)
               title('dark on grey 17')
    peak_response_17 = m(30:80);
    m_peak_response_17 = max(m(30:80));
    err_peak_response_17 = std(peak_response_17,'omitnan')/sqrt(length(peak_response_17));
    elseif(ii==18)
               title('grey on bright 18')
    peak_response_18 = m(30:80);
    m_peak_response_18 = max(m(30:80));
    err_peak_response_18 = std(peak_response_18,'omitnan')/sqrt(length(peak_response_18));
    elseif(ii==19)
               title('darkgrey on brightgrey 19')
    peak_response_19 = m(30:80);
    m_peak_response_19 = max(m(30:80));
    err_peak_response_19 = std(peak_response_19,'omitnan')/sqrt(length(peak_response_19));
    elseif(ii==20)
               title('dark on grey 20')
    peak_response_20 = m(30:80);
    m_peak_response_20 = max(m(30:80));
    err_peak_response_20 = std(peak_response_20,'omitnan')/sqrt(length(peak_response_20));
    elseif(ii==21)
               title('grey on bright 21')
    peak_response_21 = m(30:80);
    m_peak_response_21 = max(m(30:80));
    err_peak_response_21 = std(peak_response_21,'omitnan')/sqrt(length(peak_response_21));
    elseif(ii==22)
               title('darkgrey on brightgrey 22')
    peak_response_22 = m(30:80);
    m_peak_response_22 = max(m(30:80));
    err_peak_response_22 = std(peak_response_22,'omitnan')/sqrt(length(peak_response_22));
    elseif(ii==23)
               title('dark on grey 23')
    peak_response_23 = m(30:80);
    m_peak_response_23 = max(m(30:80));
    err_peak_response_23 = std(peak_response_23,'omitnan')/sqrt(length(peak_response_23));
    elseif(ii==24)
               title('grey on bright 24')
    peak_response_24 = m(30:80);
    m_peak_response_24 = max(m(30:80));
    err_peak_response_24 = std(peak_response_24,'omitnan')/sqrt(length(peak_response_24));
        
    end     
end
   
figure, hold on
% title()
b = bar(1:24, [m_peak_response_1, m_peak_response_2, m_peak_response_3, m_peak_response_4, m_peak_response_5, m_peak_response_6, m_peak_response_7,...
    m_peak_response_8, m_peak_response_9, m_peak_response_10, m_peak_response_11, m_peak_response_12, m_peak_response_13, m_peak_response_14,...
    m_peak_response_15, m_peak_response_16, m_peak_response_17, m_peak_response_18, m_peak_response_19, m_peak_response_20, m_peak_response_21,...
    m_peak_response_22, m_peak_response_23, m_peak_response_24])

e = errorbar(1:24, [m_peak_response_1, m_peak_response_2, m_peak_response_3, m_peak_response_4, m_peak_response_5, m_peak_response_6, m_peak_response_7,...
    m_peak_response_8, m_peak_response_9, m_peak_response_10, m_peak_response_11, m_peak_response_12, m_peak_response_13, m_peak_response_14,...
    m_peak_response_15, m_peak_response_16, m_peak_response_17, m_peak_response_18, m_peak_response_19, m_peak_response_20, m_peak_response_21,...
    m_peak_response_22, m_peak_response_23, m_peak_response_24],[err_peak_response_1, err_peak_response_2, err_peak_response_3, err_peak_response_4,...
    err_peak_response_5, err_peak_response_6, err_peak_response_7, err_peak_response_8, err_peak_response_9, err_peak_response_10,...
    err_peak_response_11, err_peak_response_12, err_peak_response_13, err_peak_response_14, err_peak_response_15, err_peak_response_16,...
    err_peak_response_17, err_peak_response_18, err_peak_response_19, err_peak_response_20, err_peak_response_21, err_peak_response_22...
    err_peak_response_23, err_peak_response_24], '.')




ylim([-0.1 2.0]); %L2
% ylim([-0.1 0.7]); %L3
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


%% Normalized

close all;

bla = m
minVal = min(bla);
maxVal = max(bla);
norm_data = (bla - minVal) / ( maxVal - minVal )
% your_original_data = minVal + norm_data.*(maxVal - minVal)



znj = [m_peak_response_1, m_peak_response_2, m_peak_response_3, m_peak_response_4, m_peak_response_5, m_peak_response_6, m_peak_response_7,...
    m_peak_response_8, m_peak_response_9, m_peak_response_10, m_peak_response_11, m_peak_response_12, m_peak_response_13, m_peak_response_14,...
    m_peak_response_15, m_peak_response_16, m_peak_response_17, m_peak_response_18, m_peak_response_19, m_peak_response_20, m_peak_response_21,...
    m_peak_response_22, m_peak_response_23, m_peak_response_24]

minVal = min(znj)
maxVal = max(znj);
norm_data = (znj - minVal) / ( maxVal - minVal )


bar(norm_data)


   


% % ylim([-0.1 2.0]); %L2
% % ylim([-0.1 0.7]); %L3
% set(b,'FaceColor',[0 0.8 0])
% 
% title('Max response');
% 
% % Add titles
% ax = gca;
% ax.XTick = 1:24;
% ax.XTickLabels = {'darkgrey on brightgrey 1','dark on grey 2','grey on bright 3','darkgrey on brightgrey 4', 'dark on grey 5','grey on bright 6',...
%     'darkgrey on brightgrey 7','dark on grey 8','grey on bright 9' ,'darkgrey on brightgrey 10', ...
%     'dark on grey 11','grey on bright 12', 'darkgrey on brightgrey 13','dark on grey 14', 'grey on bright 15', 'darkgrey on brightgrey 16',...
%     'dark on grey 17','grey on bright 18','darkgrey on brightgrey 19', 'dark on grey 20', 'grey on bright 21', 'darkgrey on brightgrey 22',...
%     'dark on grey 23', 'grey on bright 24'};
% ax.XTickLabelRotation = 45;
% 
% hold off;

%% Quantification of the responses - over flyIDs
close all;

% take a mean of all assigned values, ignore 0
crossing_rats = aL2.rats;
crossing_rats(crossing_rats==0) = NaN;

% Mean over all ROI's
mean_val = squeeze(mean(crossing_rats,1,'omitnan'));

num_steps = size(mean_val,1); %24

numROIs = size(aL2.rats,1);
numFlies = length(unique(aL2.flyID));

mean_calciumStep = zeros(1,num_steps);
err_calciumStep = zeros(1,num_steps);

for kk=1:num_steps
    
    traces = squeeze(aL2.rats(:,kk,:)); %because mean_cat_full works only with 2 dimensions %taking all ROIs, the epoch we are on, full lenth (200)
    [x,m,e] = mean_cat_full(traces,1,aL2.flyID); %m=mean; e=std
   
    
    
    %ks: defining the time where we look for the baseline
    baseline = x(:,round(0.2*end):round(0.3*end)); 
%     baseline = squeeze(baseline);
    %ks: defining the time where we look for the response
    response = x(:,round(0.3*end)+1:round(0.8*end));
%     response = squeeze(response);
    
    calciumStep = zeros(numFlies,1);

    for ii = 1:numFlies
            calciumStep(ii) = max(response(ii,:)) - min(baseline(ii,:));  %        
    end
    
    % take the mean off all steps
    mean_calciumStep(kk) = mean(calciumStep,'omitnan');
    % Standard error
    err_calciumStep(kk) = std(calciumStep,'omitnan')/sqrt(length(calciumStep));
    
%     mean_calcium_all(kk) = mode(mean_calciumStep)
%     err_calcium_all(kk) = mode(err_calciumStep)
end

epochs = 1:24;

bar_all = figure;
grid on;

% Plot the data only for OFF steps
y1 = mean_calciumStep(epochs); %ks
x1 = find(epochs);
e1 = err_calciumStep(epochs);

hold on;
bar(x1,y1,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.0);
errorbar(x1,y1,e1,'rx');

title('All responses');

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






