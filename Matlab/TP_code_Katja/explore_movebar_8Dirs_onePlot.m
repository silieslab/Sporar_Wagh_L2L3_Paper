%%explore_movebar_8Dirs_onePlot
% % Yvette load in data
% 
% 
% what is the real timing of the mb_rperm_csl_md20_wide
% 20*/sec   moving across the screen
%  ~ +/-90 of angle covers... screen is only 45
%  90*2=180    180/20= 9seconds???   total per epoch?


clc;
clear all;
close all;
% moving bar stim 18 seconds per epoch

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
    GENOTYPE_STRING = 'T4T5 >> GCaMP6f, all layers';
    COLOR_OF_PLOT = [0 0 1]; %BLUE; [.7 .7 0]% YELLOW %[1 0 0]; %RED% [0 .5 0]% GREEN %[0 0 1]; %BLUE;
    %COLOR_OF_PLOT = [1 0 0]; %RED; %[0 0 1] %BLUE;
    COLOR_CLOUD = [.5 .5 1];
end
gen_str = GENOTYPE_STRING;

MAX_LAG = 15; % the max that the alignement of receptive fields can shift the traces

% pdatapath = set_pdatapath;  % obtains the correct path to the pData folder for either Yvette's or Marion's operating system, which ever it is run on.
pdatapath='/Users/ksporar/Fiala_2p/Katja_pData';
addpath(pdatapath);
cd(pdatapath);

database_select_samples_ks; % get the right stuff...


%ms: gets indices of the correct stuff from MASTER....txt
f_mb_T4T5 = find(i_T4T5QFGCaMP6F_UASshitsR_37C.*i_mb_lumdec_20degs_5deg_8dir_copy.*~i_moving.*(flyID~=130));  % T4T5 that were shown dark moving bar
% f_mb_T4T5 = find(i_T4T5QFGCaMP6F_UASshitsR_37C.*i_mb_luminc_20degs_5deg_8dir.*~i_moving);  % T4T5 that were shown light moving bar


fT4T5_mb = create_neuron_structure_all_ks(f_mb_T4T5);
%ms: for all the indices defined, loads the pData.mat file = x
%outputs out{i}.name = fname and out{i}.cell, which has the size of
%x.strct.dRatio

if (ANALYZE_BY_LAYER)
 %   T4T5_mb = load_neuron_data3ms_byLayer_yf(fT4T5_mb,pdatapath, LAYER);%
%     do not use this function, has a fps glitch, also confuses me because data3ms is 100Hz...
    T4T5_mb = load_neuron_data10Hz_byLayer(fT4T5_mb,pdatapath, LAYER);%

else
    % interpolates at 10 Hz now...
    T4T5_mb = load_neuron_data10Hz_ks(fT4T5_mb,pdatapath);
    % COMMENTED OUT fps GLITCH
end

% to save changing later variables:
f_mb_L2 = f_mb_T4T5;
fL2_mb = fT4T5_mb;
L2_mb = T4T5_mb;

%yf: Extracts epochs of particular stim responses
% aL2 = aggregate_mb_rpermcsl3_yf(L2_mb, DURATION_OF_EPOCH_IN_FRAMES); % this requires the variables 'ifstimpos1'and
% % centers be loaded in the load_data function
% aL2 = aggregate_mb_XorYcenter_8dirs(L2_mb); % this requires the variables 'ifstimpos1'and
 aL2 = aggregate_mb_XorYcenter_8dirs_allEpo_ks(L2_mb); %ms: aggregate function that takes averages across all epochs an ROI has seen
% centers be loaded in the load_data function, finds epoch duration automatically

%%

% Mean response in X as a function of angle (0 or 180)
dur = size(aL2(1).rats,3); %ms: the epoch duration is now automatically determined in the aggregate function
iFRAMERATE = 10; %ms: interpolated framerate that is used in load_neuron_data function

t = (1:dur)/iFRAMERATE;  %ms: create a real timing vector (fs / (fs/s)  = s)
mod_t = ((-t(end)/2)+(10^-1)):(10^-1):(t(end)/2); % shifts timing so that response will be at zero, in the middle of the plot
range = 1:length(t);


dirs = [0 180 90 270 45 135 225 315];
[~, ind_dirs] = sort(dirs); %out the dirs to plot in assending order-yf%= [1 2 3 4 5 6 7 8];


onscreen=zeros(1,length(aL2.onscreen));
for jj = 1:length(aL2.onscreen)
    if sum(aL2.onscreen(jj,:))
        onscreen(jj)=1;
    end
end
onscreen = logical(onscreen);

% onscreen=aL2.onscreen;
% aL2.onscreen=onscreen(:,1);

% hyp_range = 85:95;
% dep_range = 100:110;
% ref_range = 20:60;


%***********************************************
%  PLOTS - by ROI
%***********************************************
% calculate means per ROI and fly,    plot individual ROI responses


TRACE_OFFSET_PLOT = 2.5;%0.7; % spacing in dF/F between the traces for the 4 directions

count=1;
for ii = ind_dirs % DIRS_TO_PLOT  %to make the degrees in order-yf
       
    % aligns onscreen traces based on correlation with mean
%     resps = squeeze(aL2.rats(aL2.onscreen==1,ii,:));

    resps = squeeze(aL2.rats(onscreen,ii,:));

    y = align_array_LB2(resps,MAX_LAG);
%     y = resps;
    
    for r = 1:size(resps,1)
        resp_all(ii,r,:) = y(r,:); %all aligned responses, store across directions
    end
    
%     [x,m,s] = mean_cat_full(y,1,aL2.flyID(aL2.onscreen==1));
    [x,m,s] = mean_cat_full(y,1,aL2.flyID(onscreen));

    %y contains aligned, onscreen ROI-times series, x is then mean by flyID
    %ms: m = mean of x, s = SEM
    
    
    %store for all directions:
    mL2f(ii,:,:) = x;  %means by flyID
    mmL2f(ii,:) = m;
    smL2f(ii,:) = s;
    
    mL2(ii,:) = mean(y,1);  %one mean across all single onscreen ROIs
%     sL2(ii,:) = std(y,[],1)/sqrt(sum(aL2.onscreen==1)); %SEM by ROI
    sL2(ii,:) = std(y,[],1)/sqrt(sum(onscreen)); %SEM by ROI

    
    
    %plot raw traces for each individual ROI (y)
    figure(1); subplot(8,1,count); plot(y');
    set(gcf, 'Color', 'w');
    title(num2str(dirs(ii)));

    count = count + 1;
    ylim([0, 6]);
    
end


% plot average across all ROIs
 

figure(2); hold on;
% patch([-1.6 -1.4 -1.4 -1.6]',[-0.15 -0.15 2 2]',[0.85 0.85 0.85],...
%     'EdgeColor','none');

%DIRS_TO_PLOT = [1 2 3 4 5 6 7 8];
%dirs = [0 180 90 270 45 135 225 315];
%[Y,ind_deg]=sort(dirs); %out the dirs to plot in assending order-yf
spacer_counter=1;  % since I changed the order, now we need a counter for spacing on the plot -yf

for ii= ind_dirs  %DIRS_TO_PLOT   % changed to plot the degrees in order-yf
     
    plot_err_patch_v2(mod_t(range), TRACE_OFFSET_PLOT*spacer_counter + mL2(ii,range)-1,sL2(ii,range),COLOR_OF_PLOT,COLOR_CLOUD);
    line([mod_t(range(1)) mod_t(range(end))],[TRACE_OFFSET_PLOT*spacer_counter  TRACE_OFFSET_PLOT*spacer_counter],...
        'color',[0 0 0],'LineStyle','--');
    text(0.5+mod_t(range(1)),0.25 + TRACE_OFFSET_PLOT*spacer_counter,num2str(dirs(ii)));
   
    
    spacer_counter = spacer_counter + 1; % counter for plot spacing
   
end

title([gen_str ', mean across ROIs, '' (N flies = '...
num2str(length(unique(aL2.flyID(onscreen))))...
   ', N ROIs = ' num2str(sum(onscreen)) ')']);
%         num2str(length(unique(aL2.flyID(aL2.onscreen==1))))...
%         ', N ROIs = ' num2str(sum(aL2.onscreen)) ')']);

xlabel('time (sec)');
ylabel('response (dF/F)');

%ylim([-0.15 0.95]);xlim([mod_t(range(1)) mod_t(range(end))]);
% % scale bar lines
% line([1.5+mod_t(range(1)) 1.5+mod_t(range(1))],[0.2 0.3],'color',[0 0 0]);
% line([1.5+mod_t(range(1)) 2+mod_t(range(1))],[0.2 0.2],'color',[0 0 0]); 

set(gcf, 'Color', 'w');
niceaxes;


%***********************************************
%  PLOTS - by fly
%***********************************************

% plot individual fly means
figure(3); hold on
count=1;
for ii = ind_dirs % DIRS_TO_PLOT  %to make the degrees in order-yf
       
    % mL2f contains means by fly
    flyMeans = squeeze(mL2f(ii,:,:));
    
    %plot raw traces for each individual flyMean
    figure(3); subplot(8,1,count); plot(flyMeans');
    set(gcf, 'Color', 'w');
    title(num2str(dirs(ii)));

    count = count + 1;
    ylim([0, 6]);
    
end

% plot mean across fly means
figure(4); hold on;

%DIRS_TO_PLOT = [1 2 3 4 5 6 7 8];
%dirs = [0 180 90 270 45 135 225 315];
%[Y,ind_deg]=sort(dirs); %out the dirs to plot in assending order-yf
spacer_counter=1;  % since I changed the order, now we need a counter for spacing on the plot -yf

for ii= ind_dirs  %DIRS_TO_PLOT   % changed to plot the degrees in order-yf
     
    plot_err_patch_v2(mod_t(range), TRACE_OFFSET_PLOT*spacer_counter + mmL2f(ii,range)-1,smL2f(ii,range),COLOR_OF_PLOT,COLOR_CLOUD);
    line([mod_t(range(1)) mod_t(range(end))],[TRACE_OFFSET_PLOT*spacer_counter  TRACE_OFFSET_PLOT*spacer_counter],...
        'color',[0 0 0],'LineStyle','--');
    text(0.5+mod_t(range(1)),0.25 + TRACE_OFFSET_PLOT*spacer_counter,num2str(dirs(ii)));
   
    
    spacer_counter = spacer_counter + 1; % counter for plot spacing
   
end


title([gen_str ', mean across flies, '' (N flies = '...
        num2str(length(unique(aL2.flyID(onscreen))))...
        ', N ROIs = ' num2str(sum(onscreen)) ')']);
xlabel('time (sec)');
ylabel('response (dF/F)');

set(gcf, 'Color', 'w');
niceaxes;



%***********************************************
%  4 DIRECTION PLOTS - by fly
%***********************************************
% plot mean across fly means
figure(5); hold on;

%DIRS_TO_PLOT = [1 2 3 4 5 6 7 8];
%dirs = [0 180 90 270 45 135 225 315];
%[Y,ind_deg]=sort(dirs); %out the dirs to plot in assending order-yf
spacer_counter=1;  % since I changed the order, now we need a counter for spacing on the plot -yf

% since only plotting 0 180 90 270 take ind_dirs 1-4
ind_dirs   =  ind_dirs (ind_dirs < 5);

for ii= ind_dirs  %DIRS_TO_PLOT   % changed to plot the degrees in order-yf
     
    plot_err_patch_v2(mod_t(range), TRACE_OFFSET_PLOT*spacer_counter + mmL2f(ii,range)-1,smL2f(ii,range),COLOR_OF_PLOT,COLOR_CLOUD);
    line([mod_t(range(1)) mod_t(range(end))],[TRACE_OFFSET_PLOT*spacer_counter  TRACE_OFFSET_PLOT*spacer_counter],...
        'color',[0 0 0],'LineStyle','--');
    text(0.5+mod_t(range(1)),0.25 + TRACE_OFFSET_PLOT*spacer_counter,num2str(dirs(ii)));
   
    
    spacer_counter = spacer_counter + 1; % counter for plot spacing
   
end


title([gen_str ', mean across flies, '' (N flies = '...
        num2str(length(unique(aL2.flyID(onscreen))))...
        ', N ROIs = ' num2str(sum(onscreen)) ')']);
xlabel('time (sec)');
ylabel('response (dF/F)');
ylim([2 12])
set(gcf, 'Color', 'w');
niceaxes;







