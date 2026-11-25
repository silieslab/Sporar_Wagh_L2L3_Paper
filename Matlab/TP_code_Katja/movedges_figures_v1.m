%%movedges_figure_v1
clc;
clear all;
close all;


% CONSTANTS
ANALYZE_BY_LAYER = false; % weather ROIs should be selected based on their layer in the lobula complex.
LAYER = 'LPA';  % which group or layer of ROIs will be included in this plot
% this layerG info is stored as a string in the variable 'layer' in the MASTER excel spreadsheet

GENOTYPE_STRING = 'T4/T5 >> GCaMP6F'; 
gen_str = GENOTYPE_STRING;

MAX_LAG = 0; % the max that the alignement of receptive fields can shift the traces

pdatapath='/Users/ksporar/Documents/MATLAB/Katja_pData';
addpath(pdatapath);
cd(pdatapath);


database_select_samples_ks; % get the right stuff...


%T4/T5 imaging, L3 silencing - Michael Reiser T4/T5 stock
% f_mb_L2 = find(i_T4T5LexA_LexAopGCaMP6m_UASshits_control.*i_DriftingStripe_3luminances_new_WeberContrast.*~i_moving);

% f_mb_L2 = find(i_T4T5lexA_lexAopGCaMP6m_UASshits_0595Gal4.*i_DriftingStripe_3luminances_new_WeberContrast.*~i_moving);


f_mb_T4T5 = find(i_DriftingEdge_LumDecLumInc_4Dirs.*i_T4T5LexA_LexAopGCaMP6m_UASshits_L221DhhGal4.*~i_moving);



fT4T5_mb = create_neuron_structure_all_ks(f_mb_T4T5);


if (ANALYZE_BY_LAYER)
%     T4T5_mb = load_neuron_data3ms_byLayer_yf(fT4T5_mb,pdatapath, LAYER);%
%     do not use this function, has a fps glitch, also confuses me because
%     data3ms is 100Hz...
%     T4T5_mb = load_neuron_data10Hz_byLayer_ms(fT4T5_mb,pdatapath, LAYER);%
    T4T5_mb = load_neuron_data10Hz_byLayer(fT4T5_mb,pdatapath, LAYER);%

else
    %T4T5_mb = load_neuron_data4ms(fT4T5_mb,pdatapath);
    % interpolates at 10 Hz now...
    T4T5_mb = load_neuron_data10Hz_ks(fT4T5_mb,pdatapath);
%     T4T5_mb = load_neuron_data10Hz_ms(fT4T5_mb,pdatapath);
    % COMMENTED OUT fps GLITCH
end
    
% to save changing later variables:
f_mb_L2 = f_mb_T4T5;
fL2_mb = fT4T5_mb;
L2_mb = T4T5_mb;


%yf: Extracts epochs of particular stim responses
% aL2 = aggregate_mb_rpermcsl3_yf(L2_mb, DURATION_OF_EPOCH_IN_FRAMES); % this requires the variables 'ifstimpos1'and
% % centers be loaded in the load_data function
aL2 = aggregate_mb_XorYcenter_4dirs_allEpo_v2EDGES(L2_mb); % this requires the variables 'ifstimpos1'and ____ in = L2_mb


% centers be loaded in the load_data function, finds epoch duration
any_onscreen = logical(max(aL2.onscreen,[],2));


% Mean response as a function of angle
dur = size(aL2(1).rats,3); %ms: the epoch duration is now automatically determined in the aggregate function
iFRAMERATE = 10; %ms: interpolated framerate that is used in load_neuron_data function

t = [1:dur]/iFRAMERATE;  %ms: create a real timing vector (fs / (fs/s)  = s)
mod_t = ((-t(end)/2)+(10^-1)):(10^-1):(t(end)/2); % shifts timing so that response will be at zero, in the middle of the plot
range = 1:length(t);

dirs = [0 180 90 270];
[~, ind_dirs] = sort(dirs); %out the dirs to plot in assending order-yf



% a few constants for plotting
COLOR_OF_PLOT =[0 0 1]; %BLUE%[1 0 0]; %RED %[0 0 1]; %BLUE; [.7 .7 0]% YELLOW %[1 0 0]; %RED% [0 .5 0]% GREEN
COLOR_CLOUD = [.5 .5 1]; %BLUE%[1 .5 .5] %RED cloud%[.5 .5 1]; %BLUE%[.9 .9 .5] %YELLOW %[1 .5 .5] %RED cloud%[.5 .7 .5]% GREEN %[.5 .5 1];
TRACE_OFFSET_PLOT = 2.5; %0.7; % spacing in dF/F between the traces for the 4 directions



mL2 = zeros(4,dur);
sL2 = zeros(4,dur);
mL2f = zeros(4,length(unique(aL2.flyID(any_onscreen))),dur);


%plot all single traces on top of each other
for ii = ind_dirs%1:4
    resps = squeeze(aL2.rats(any_onscreen,ii,:));
    
    %yf: handle the single ROI case by 'turning' the matrix since squeeze
    %leaves it in the wrong dimention for later processing
    if(size(resps,2) == 1)
       resps = resps'; 
    end
    
%     y = resps; %just plot, alignment was done by centers in aggregate function
    y = align_array_LB2(resps,MAX_LAG); %use an alignment function based
%     on correlations
    
    %plot raw traces as well`
    figure(11); subplot(2,2,ii); plot(y');
    set(gcf, 'Color', 'w');%make background white
    title(num2str(dirs(ii)));
    ylim([0, 5]);
    
    
    for r = 1:size(resps,1)
      
        resp_all(ii,r,:) = y(r,:);
    end
    

    [x,m,s] = mean_cat_full(y,1,aL2.flyID(any_onscreen));
    
    % added for so we can also plot fly means -yf
    %store for all directions:
    mL2f(ii,:,:) = x;  %means by flyID
    mmL2f(ii,:) = m;
    smL2f(ii,:) = s;
%     
    
    mL2f(ii,:,:) = x;
    mL2(ii,:) = mean(y,1); 
    sL2(ii,:) = std(y,[],1)/sqrt(sum(any_onscreen));
    
   
end


figure; hold on;
% patch([-1.6 -1.4 -1.4 -1.6]',[-0.15 -0.15 2 2]',[0.85 0.85 0.85],...
%     'EdgeColor','none');
set(gcf, 'Color', 'w');

spacer_counter=1;  % since I changed the order, now we need a counter for spacing on the plot -yf

for ii= ind_dirs % 1:4
     
    plot_err_patch_v2(mod_t(range), TRACE_OFFSET_PLOT*spacer_counter + mL2(ii,range)-1,sL2(ii,range),COLOR_OF_PLOT,COLOR_CLOUD);
    line([mod_t(range(1)) mod_t(range(end))],[TRACE_OFFSET_PLOT*spacer_counter  TRACE_OFFSET_PLOT*spacer_counter],...
        'color',[0 0 0],'LineStyle','--');
    text(0.5+mod_t(range(1)),0.15 + TRACE_OFFSET_PLOT*spacer_counter + 0.5,num2str(dirs(ii)));
    
    spacer_counter = spacer_counter + 1; % counter for plot spacing
end

title([gen_str ' (N flies = '...
        num2str(length(unique(aL2.flyID(any_onscreen))))...
        ', N cells = ' num2str(sum(any_onscreen)) ')']);
xlabel('time (sec)');
ylabel('response (dF/F)');
ylim([0 12]);

niceaxes;


%% ***********************************************
%  PLOT with nice figure spacing DARK and BRIGHT EDGES
%**********************************************
%%movedges_figure_v1
clc;
clear all;
close all;


% CONSTANTS
ANALYZE_BY_LAYER = true; % weather ROIs should be selected based on their layer in the lobula complex.
LAYER = 'M';  % which group or layer of ROIs will be included in this plot
% this layerG info is stored as a string in the variable 'layer' in the MASTER excel spreadsheet
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

MAX_LAG = 0; % the max that the alignement of receptive fields can shift the traces

pdatapath=set_pdatapath;
% pdatapath='/Users/Kunibert/CalciumImaging/MarionYvette_pData';
% pdatapath='/Users/Kunibert/CalciumImaging/MarionDaryl_pData';
addpath(pdatapath);
cd(pdatapath);

database_select_samples_msyf; % get the right stuff...

% antagonist / blocker (CGP and PTX) experiments
% f_mb_T4T5 = find(i_me_20d4dir.*i_T4T5g4_GCF_before.*~i_moving.*(flyID==160)); 
% f_mb_T4T5 = find(i_me_20d4dir.*i_T4T5g4_GCF_PTX.*~i_moving)%.*(flyID~=102)); 
% f_mb_T4T5 = find(i_me_20d4dir.*i_T4T5g4_GCF_PTX); 
% f_mb_T4T5 = find(i_me_20d4dir.*i_T4T5g4_GCF_1PTX_before); 
% f_mb_T4T5 = find(i_me_20d4dir.*i_T4T5g4_GCF_1PTX); 
% f_mb_T4T5 = find(i_me_20d4dir.*i_T4T5g4_GCF_CGP_before);

 f_mb_T4T5 = find(i_me_20d4dir.*i_T4g4_GCF_before.*~i_moving.*(flyID==219));
% f_mb_T4T5 = find(i_me_20d4dir.*i_T4g4_GCF_PTX.*~i_moving)%.*(flyID==189));

%hsFLP T4T5 clones
% f_mb_T4T5 = find(i_me_20d4dir.*i_hsFLP_TubG80_T4T5g4.*~i_moving.*(flyID==187));
% f_mb_T4T5 = find(i_me_20d4dir.*i_hsFLP_TubG80_T4T5g4_PTX.*~i_moving)%.*(flyID==190));

% RDL flp-stop
% f_mb_T4T5 = find(i_me_20d4dir.*i_T4T5g4_FLPSTOP1_1_MII_Rdl.*~i_moving);
 
 %f_mb_T4T5 = find(i_me_20d4dir.*i_T4T5g4_FLPSTOP1_1_MII_Rdl.*~i_moving)%.*(flyID==218));
 


%Other manipulations:
% f_mb_T4T5 = find(i_me_20d4dir.*i_T4T5_6F_UASshitsR); 
% f_mb_T4T5 = find(i_me_20d4dir.*i_T4T5QFVK18_GC6F_C2C3G4_shitsR.*~i_moving)%; 
% f_mb_T4T5 = find(i_me_20d4dir.*i_T4T5QFVK18_GC6F_Gad1G4_shitsR);
% f_mb_T4T5 = find(i_me_20d4dir.*i_T4T5QF_6F_Tm9LexA);

fT4T5_mb = create_neuron_structure_all_msyf(f_mb_T4T5);
% fT4T5_mb = create_neuron_structure_all_ms(f_mb_T4T5);
%ms: for all the indices defined, loads the pData.mat file = x
%outputs out{i}.name = fname and out{i}.cell, which has the size of
%x.strct.dRatio

if (ANALYZE_BY_LAYER)
%     T4T5_mb = load_neuron_data3ms_byLayer_yf(fT4T5_mb,pdatapath, LAYER);%
%     do not use this function, has a fps glitch, also confuses me because
%     data3ms is 100Hz...
%     T4T5_mb = load_neuron_data10Hz_byLayer_ms(fT4T5_mb,pdatapath, LAYER);%
    T4T5_mb = load_neuron_data10Hz_byLayer(fT4T5_mb,pdatapath, LAYER);%

else
    %T4T5_mb = load_neuron_data4ms(fT4T5_mb,pdatapath);
    % interpolates at 10 Hz now...
    T4T5_mb = load_neuron_data10Hz_ms_yf(fT4T5_mb,pdatapath);
%     T4T5_mb = load_neuron_data10Hz_ms(fT4T5_mb,pdatapath);
    % COMMENTED OUT fps GLITCH
end
    
% to save changing later variables:
f_mb_L2 = f_mb_T4T5;
fL2_mb = fT4T5_mb;
L2_mb = T4T5_mb;


%yf: Extracts epochs of particular stim responses
% aL2 = aggregate_mb_rpermcsl3_yf(L2_mb, DURATION_OF_EPOCH_IN_FRAMES); % this requires the variables 'ifstimpos1'and
% % centers be loaded in the load_data function
aL2 = aggregate_mb_XorYcenter_4dirs_allEpo_v2EDGES(L2_mb); % this requires the variables 'ifstimpos1'and


% centers be loaded in the load_data function, finds epoch duration
any_onscreen = logical(max(aL2.onscreen,[],2));

% Mean response as a function of angle
dur = size(aL2(1).rats,3); %ms: the epoch duration is now automatically determined in the aggregate function
iFRAMERATE = 10; %ms: interpolated framerate that is used in load_neuron_data function

t = [1:dur]/iFRAMERATE;  %ms: create a real timing vector (fs / (fs/s)  = s)
mod_t = ((-t(end)/2)+(10^-1)):(10^-1):(t(end)/2); % shifts timing so that response will be at zero, in the middle of the plot

% DARK EDGES range
range = (1+25):(length(t)-60);

dirs = [0 180 90 270];
[~, ind_dirs] = sort(dirs); %out the dirs to plot in assending order-yf


TRACE_OFFSET_PLOT = 4.0; %0.7; % spacing in dF/F between the traces for the 4 directions

mL2 = zeros(4,dur);
sL2 = zeros(4,dur);
mL2f = zeros(4,length(unique(aL2.flyID(any_onscreen))),dur);


%plot all single traces on top of each other
for ii = ind_dirs%1:4
    resps = squeeze(aL2.rats(any_onscreen,ii,:));
    
    %yf: handle the single ROI case by 'turning' the matrix since squeeze
    %leaves it in the wrong dimention for later processing
    if(size(resps,2) == 1)
       resps = resps'; 
    end
    
%     y = resps; %just plot, alignment was done by centers in aggregate function
    y = align_array_LB2(resps,MAX_LAG); %use an alignment function based
%     on correlations
    
    %plot raw traces as well`
    figure(11); subplot(2,2,ii); plot(y');
    set(gcf, 'Color', 'w');%make background white
    title(num2str(dirs(ii)));
    ylim([0, 5]);
    
    
    for r = 1:size(resps,1)
      
        resp_all(ii,r,:) = y(r,:);
    end
    
    % this break if there is only a single ROI
    [x,m,s] = mean_cat_full(y,1,aL2.flyID(any_onscreen));
    
    % added for so we can also plot fly means -yf
    %store for all directions:
    mL2f(ii,:,:) = x;  %means by flyID
    mmL2f(ii,:) = m;
    smL2f(ii,:) = s;
%     
    
    mL2f(ii,:,:) = x;
    mL2(ii,:) = mean(y,1); 
    sL2(ii,:) = std(y,[],1)/sqrt(sum(any_onscreen));
    
   
end

h = figure; hold on;
% patch([-1.6 -1.4 -1.4 -1.6]',[-0.15 -0.15 2 2]',[0.85 0.85 0.85],...
%     'EdgeColor','none');
set(gcf, 'Color', 'w');
set(h,'Position', [0 0 500 700]);

spacer_counter=1;  % since I changed the order, now we need a counter for spacing on the plot -yf

for ii= ind_dirs % 1:4
     
    plot_err_patch_v2(mod_t(range), TRACE_OFFSET_PLOT*spacer_counter + mL2(ii,range)-1,sL2(ii,range),COLOR_OF_PLOT,COLOR_CLOUD);
    line([mod_t(range(1)) mod_t(range(end))],[TRACE_OFFSET_PLOT*spacer_counter  TRACE_OFFSET_PLOT*spacer_counter],...
        'color',[0 0 0],'LineStyle','--');
    text(0.5+mod_t(range(1)),0.15 + TRACE_OFFSET_PLOT*spacer_counter + 0.5,num2str(dirs(ii)));
    
    spacer_counter = spacer_counter + 1; % counter for plot spacing
end

title([gen_str ' (N flies = '...
        num2str(length(unique(aL2.flyID(any_onscreen))))...
        ', N cells = ' num2str(sum(any_onscreen)) ')']);
xlabel('time (sec)');
ylabel('response (dF/F)');
ylim([0 18]);
xlim([-10 6])
niceaxes;




















%***********************************************
%  PLOTS - by fly
%***********************************************
%% added in 7/15/14 -yf
% plot individual fly means

TRACE_OFFSET_PLOT = 3.0; %0.7; % spacing in dF/F between the traces for the 4 directions


figure(3); hold on
count=1;
for ii = 1:4%dirs % DIRS_TO_PLOT  %to make the degrees in order-yf
       
    % mL2f contains means by fly
    flyMeans = squeeze(mL2f(ii,:,:));
    
    %plot raw traces for each individual flyMean    
    figure(3); subplot(4,1,count); plot(flyMeans');
    set(gcf, 'Color', 'w');
    title(num2str(dirs(ii)));
    
        
%     % save by fly trace  for later processing
     trace_byFly{count} = flyMeans;
     count = count + 1;

    ylim([0, 7]);
    
end



% plot mean across fly means

figure(4); hold on;

spacer_counter=1;  % since I changed the order, now we need a counter for spacing on the plot -yf

for ii= 1:4   % changed to plot the degrees in order-yf
     
    plot_err_patch_v2(mod_t(range), TRACE_OFFSET_PLOT*spacer_counter + mmL2f(ii,range)-1,smL2f(ii,range),COLOR_OF_PLOT,COLOR_CLOUD);
    line([mod_t(range(1)) mod_t(range(end))],[TRACE_OFFSET_PLOT*spacer_counter  TRACE_OFFSET_PLOT*spacer_counter],...
        'color',[0 0 0],'LineStyle','--');
    text(0.5+mod_t(range(1)),0.25 + TRACE_OFFSET_PLOT*spacer_counter,num2str(dirs(ii)));
   
    
    spacer_counter = spacer_counter + 1; % counter for plot spacing
   
end


title([gen_str ', mean across flies, '' (N flies = '...
        num2str(length(unique(aL2.flyID(any_onscreen))))...
        ', N ROIs = ' num2str(sum(any_onscreen)) ')']);
xlabel('time (sec)');
ylabel('response (dF/F)');

set(gcf, 'Color', 'w');
ylim([0, 15]);
niceaxes;




%%
%****************************
%  MS: distinguish hyperpolarizing and depolarizing moving bar responses
%******************************
L2wCentersRats = squeeze(aL2.rats(any_onscreen,:,:));
flyIDwCenters = aL2.flyID(any_onscreen);

%ms: select cell by cell if they're hyperpolarizing (inverted, I think, weirdly), or not

hyperpolFlag = zeros(1,size(L2wCentersRats,1));
    % plot all traces for one cell all directions and ask if this cell is inverted or normal
    for jj=1:size(L2wCentersRats,1)
        singleCellsResps = squeeze(L2wCentersRats(jj,:,:));
        figure(1); hold on;
        plot(singleCellsResps');        
        title('single cell response to all 8 epochs');         
        hyperpolFlag(jj) = strcmp(input('hyperpolarized?','s'),'y');
        close(1)

    end
save('hyperpolFlag_130731.mat','hyperpolFlag');
% load('hyperpolFlag_130731.mat');


%which polarity do you want? hyperpolarized (1) or depolarized (0)
POLARITY = hyperpolFlag==0; 


%plot all single traces on top of each other, distinguish hyper and pol
mL2 = zeros(4,dur);
sL2 = zeros(4,dur);
mL2f = zeros(4,length(unique(flyIDwCenters(POLARITY))),dur);
figure;
for ii = 1:8
    resps = squeeze(L2wCentersRats(POLARITY,ii,:));
    
    y = resps; %just plot, alignment was done by centers in aggregate function
%     y = align_array_LB2(resps,MAX_LAG); %use an alignment function based
%     on correlations

    %plot raw traces as well
%     figure(3); 
    subplot(2,2,ii); plot(y');
    set(gcf, 'Color', 'w');%make background white
    title(num2str(dirs(ii)));
    ylim([0, 2.5]);
    
    
    for r = 1:size(resps,1)
      
        resp_all(ii,r,:) = y(r,:);
    end
    [x,m,s] = mean_cat_full(y,1,flyIDwCenters(POLARITY));
    mL2f(ii,:,:) = x;
    mL2(ii,:) = mean(y,1); 
    sL2(ii,:) = std(y,[],1)/sqrt(size(L2wCentersRats(POLARITY,1,:),1)); % IS THIS THE CORRECT NUMBER?!
   
end


figure; hold on;
set(gcf, 'Color', 'w');
for ii=1:8
     
    plot_err_patch(mod_t(range), TRACE_OFFSET_PLOT*ii + mL2(ii,range)-1,sL2(ii,range),COLOR_OF_PLOT,COLOR_CLOUD);
    line([mod_t(range(1)) mod_t(range(end))],[TRACE_OFFSET_PLOT*ii  TRACE_OFFSET_PLOT*ii],...
        'color',[0 0 0],'LineStyle','--');
    text(0.5+mod_t(range(1)),0.15 + TRACE_OFFSET_PLOT*ii,num2str(dirs(ii)));
end

title([gen_str ' (N flies = '...
        num2str(length(unique(flyIDwCenters(POLARITY))))...
        ', N cells = ' num2str(size(L2wCentersRats(POLARITY,1,:),1)) ')']);
xlabel('time (sec)');
ylabel('response (dF/F)');
ylim([0.0 4.5]);
%xlim([mod_t(range(1)) mod_t(range(end))]);
niceaxes;





%% mean MB response figures
dur = size(aL2(1).rats,3); %ms: the epoch duration is now automatically determined in the aggregate function
iFRAMERATE = 10; %ms: interpolated framerate that is used in load_neuron_data function

t = [1:dur]/iFRAMERATE;  %ms: create a real timing vector (fs / (fs/s)  = s)
mod_t = ((-t(end)/2)+(10^-1)):(10^-1):(t(end)/2); % shifts timing so that response will be at zero, in the middle of the plot
range = 1:length(t);
% dirs = [0 180 90 270];
dirs = [0 180 90 270 45 135 225 315];

mL2 = zeros(8,dur);%mean
sL2 = zeros(8,dur);%sem
mL2f = zeros(8,length(unique(aL2.flyID(any_onscreen))),dur);%mean by fly

MAXLAG = 50;

% mean of all cells (mL2) or mean across all flies (mL2f) for the four
% directions individually
for ii = 1:8
    resps = squeeze(aL2.rats(any_onscreen,ii,:)); %load all responses that have a RF (center of symmetry, in the case of Tm9)
    y = resps;    %for a given direction
%     y = align_array_LB2(resps,MAXLAG);
    for r = 1:size(resps,1) %puts all the responses for all direction in resp_all
        resp_all(ii,r,:) = y(r,:); 
    end
    [x,m,s] = mean_cat_full(y,1,aL2.flyID(any_onscreen)); %calculate mean by fly
    mL2f(ii,:,:) = x;   %mean by fly traces (all 4 directions) (still three-dimensional, with [#direction, #flies, dur])
    
    mL2(ii,:) = mean(y,1);    %mean of all cells  (two-dimensional [# directions, dur]
    sL2(ii,:) = std(y,[],1)/sqrt(sum(any_onscreen)); %sem of all cells
end

% mean across all directions (for each cell)
n_cells = sum(any_onscreen); 
mL2_all = zeros(sum(any_onscreen),dur); 
for r = 1:n_cells
    resps = squeeze(resp_all(:,r,:));
    y = resps;
%     y = align_array_LB2(resps,MAX_LAG);
    mL2_all(r,:) = mean(y,1);       %[#ncells, dur]
end
m_mL2 = mean(mL2_all,1)-1;                          %mean across all cells (directions pooled)
s_sL2 = std(mL2_all,[],1)./sqrt(size(mL2_all,1));   %sem across all cells (directions pooled)


% mean across all directions  (for each fly)
m_mL2f = zeros(length(unique(aL2.flyID(any_onscreen))),dur);
for i = 1:size(mL2f,2) %number of flies
    [y,lags] = align_array_LB2(squeeze(mL2f(:,i,:)),MAX_LAG); %y = re-aligned mean by fly
    m_mL2f(i,:) = mean(y,1)-1; %mean across four directions, still per fly
end
m_m_mL2f = mean(m_mL2f,1);                          %mean across all flies now (directions pooled)
s_m_sL2f = std(m_mL2f,[],1)./sqrt(size(m_mL2f,1));


figure;hold all;
h = plot_err_patch_v2(mod_t(range),m_mL2(range),s_sL2(range),[0 0 1],[0.5 0.5 1]);
legend(h,sprintf('%s: %d (%d)',gen_str,length(aL2.neuron(any_onscreen)),...
    length(unique(aL2.flyID(any_onscreen)))),'location','southeast');
% line([0 0],[-0.3 0.2],'color',[0 0 0],'lineWidth',1);
line([-4 7],[0 0],'color',[0 0 0],'lineWidth',1);
xlabel('time (sec)');ylabel('response (dR/R)');
xlim([min(mod_t) max(mod_t)]);
%ylim([-0.3 0.2]);xlim([-4 6]);
title('moving bar response by cells');
set(gca,'Ylim',[-0.2 1.2]);
set(gcf,'Color','w')
niceaxes



figure;hold all;
h = plot_err_patch_v2(mod_t(range),m_m_mL2f(range),s_m_sL2f(range),[0 0 1],[0.5 0.5 1]);
legend(h,sprintf('%s: %d (%d)',gen_str,length(aL2.neuron(any_onscreen)),...
    length(unique(aL2.flyID(any_onscreen)))),'location','southeast');

% line([0 0],[-0.3 0.2],'color',[0 0 0],'lineWidth',1);
line([-4 7],[0 0],'color',[0 0 0],'lineWidth',1);
xlabel('time (sec)');ylabel('response (dR/R)');
xlim([min(mod_t) max(mod_t)]);
ylim([-0.2 1.2]);%xlim([-4 6]);
title('moving bar response by fly');
set(gca,'Ylim',[-0.2 1.2]);
set(gcf,'Color','w')
niceaxes




%% Response by fly

figure;hold all;
% patch([-1.6 -1.4 -1.4 -1.6]',[-0.3 -0.3 0.25 0.25]',[0.85 0.85 0.85],...
%     'EdgeColor','none');
for i = 1:size(m_mL2f,1)
    plot(mod_t(range),m_mL2f(i,range));
end
% line([0 0],[-0.3 0.25],'color',[0 0 0],'lineWidth',1);
% line([-4 7],[0 0],'color',[0 0 0],'lineWidth',1);
xlabel('time (sec)');ylabel('response (dR/R)');
%ylim([-0.3 0.25]);xlim([-4 6]);
title(sprintf('%s moving bar response by fly',gen_str));
set(gcf,'Color','w')
niceaxes;

% %% Save
% 
% cd('C:\Users\hyang\Desktop\Ca imaging');
% save('moving_bars_Z3_101806_new_130221_v1','aL2','mL2','sL2','mL2f',...
%     'm_mL2','s_sL2','m_mL2f','m_mL2_Hmet','s_sL2_Hmet','m_mL2_Dmet','s_sL2_Dmet',...
%     'met_Hall','met_Dall','mL2_all',...
%     'm_mL2_Hmet2','s_sL2_Hmet2','m_mL2_Dmet2','s_sL2_Dmet2','met_Hall2','met_Dall2');

%% mean MB response figures, split into depolarizations and hyperpolarization
load('hyperpolFlag_130731.mat');
POLARITY = hyperpolFlag==0;

dur = size(aL2(1).rats,3); %ms: the epoch duration is now automatically determined in the aggregate function
iFRAMERATE = 10; %ms: interpolated framerate that is used in load_neuron_data function

t = [1:dur]/iFRAMERATE;  %ms: create a real timing vector (fs / (fs/s)  = s)
mod_t = ((-t(end)/2)+(10^-1)):(10^-1):(t(end)/2); % shifts timing so that response will be at zero, in the middle of the plot
range = 1:length(t);
dirs = [0 180 90 270];

flyIDsWithRF=aL2.flyID(any_onscreen);
mL2 = zeros(4,dur);%mean
sL2 = zeros(4,dur);%sem
mL2f = zeros(4,length(unique(flyIDsWithRF(POLARITY))),dur);%mean by fly

MAXLAG = 50;

% mean of all cells (mL2) or mean across all flies (mL2f) for the four
% directions individually
for ii = 1:4
    resps = squeeze(aL2.rats(any_onscreen,ii,:)); %load all responses that have a RF (center of symmetry, in the case of Tm9)
    resps = resps(POLARITY, :);
    y = resps;    %for a given direction
%     y = align_array_LB2(resps,MAXLAG);
    for r = 1:size(resps,1) %puts all the responses for all direction in resp_all
        resp_all(ii,r,:) = y(r,:); 
    end
    [x,m,s] = mean_cat_full(y,1,flyIDsWithRF(POLARITY)); %calculate mean by fly
    mL2f(ii,:,:) = x;   %mean by fly traces (all 4 directions) (still three-dimensional, with [#direction, #flies, dur])
    
    mL2(ii,:) = mean(y,1);    %mean of all cells  (two-dimensional [# directions, dur]
    sL2(ii,:) = std(y,[],1)/sqrt(sum(flyIDsWithRF(POLARITY))); %sem of all cells
end

% mean across four directions (for each cell)
n_cells = sum(POLARITY==1); 
mL2_all = zeros(sum(POLARITY==1),dur); 
for r = 1:n_cells
    resps = squeeze(resp_all(:,r,:));
    y = resps;
%     y = align_array_LB2(resps,MAX_LAG);
    mL2_all(r,:) = mean(y,1);       %[#ncells, dur]
end
m_mL2 = mean(mL2_all,1)-1;                          %mean across all cells (directions pooled)
s_sL2 = std(mL2_all,[],1)./sqrt(size(mL2_all,1));   %sem across all cells (directions pooled)


% mean across four direction  (for each fly)
m_mL2f = zeros(length(unique(flyIDsWithRF(POLARITY))),dur);
for i = 1:size(mL2f,2) %number of flies
    [y,lags] = align_array_LB2(squeeze(mL2f(:,i,:)),MAX_LAG); %y = re-aligned mean by fly
    m_mL2f(i,:) = mean(y,1)-1; %mean across four directions, still per fly
end
m_m_mL2f = mean(m_mL2f,1);                          %mean across all flies now (directions pooled)
s_m_sL2f = std(m_mL2f,[],1)./sqrt(size(m_mL2f,1));




figure;hold all;niceaxes;
h = plot_err_patch_v2(mod_t(range),m_mL2(range),s_sL2(range),[0 0 1],[0.5 0.5 1]);
legend(h,sprintf('%s: %d (%d)',gen_str,sum(POLARITY),...
    length(unique(flyIDsWithRF(POLARITY)))),'location','southeast');

% line([0 0],[-0.3 0.2],'color',[0 0 0],'lineWidth',1);
line([-4 7],[0 0],'color',[0 0 0],'lineWidth',1);
xlabel('time (sec)');ylabel('response (dR/R)');
xlim([min(mod_t) max(mod_t)]);
%ylim([-0.3 0.2]);xlim([-4 6]);
title('moving bar response by cells');
set(gcf,'Color','w')
niceaxes


figure;hold all;niceaxes;
h = plot_err_patch_v2(mod_t(range),m_m_mL2f(range),s_m_sL2f(range),[0 0 1],[0.5 0.5 1]);
legend(h,sprintf('%s: %d (%d)',gen_str,sum(POLARITY),...
    length(unique(flyIDsWithRF(POLARITY)))),'location','southeast');

% line([0 0],[-0.3 0.2],'color',[0 0 0],'lineWidth',1);
line([-4 7],[0 0],'color',[0 0 0],'lineWidth',1);
xlabel('time (sec)');ylabel('response (dR/R)');
xlim([min(mod_t) max(mod_t)]);
%ylim([-0.3 0.2]);xlim([-4 6]);
title('moving bar response by fly');
set(gcf,'Color','w')
niceaxes
