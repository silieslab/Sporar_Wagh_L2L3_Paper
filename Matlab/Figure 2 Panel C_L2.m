%%% Analyse by different regions of the neuron

clc;
clearvars -EXCEPT slob* contr*;
close all;

% CONSTANTS

GENOTYPE_STRING = 'L2 >> GCaMP6f';
COLOR_OF_PLOT = [0 0 1]; %BLUE; [.7 .7 0]% YELLOW %[1 0 0]; %RED% [0 .5 0]% GREEN %[0 0 1]; %BLUE;
%COLOR_OF_PLOT = [1 0 0]; %RED; %[0 0 1] %BLUE;
COLOR_CLOUD = [.5 .5 1];

gen_str = GENOTYPE_STRING;



%%

% % % % % 
pdatapath='T:\Katja Sporar\MATLAB\Katja_pData';


addpath(pdatapath);
cd(pdatapath);

% Derive script and figure paths from the parent folder of pdatapath
DataSave = ('L2');
matlab_root  = fileparts(pdatapath);
code_path    = fullfile(matlab_root, 'TP_code_Katja', 'reledsynth_code');
DataSavePath = fullfile(code_path, 'figures');
Dataslash = '/';

database_select_samples_ks;


f_fff_Tm9LexA = find(i_MarkPoints_2s.*i_UASGCaMP6F_L221DhhGal4_cross_to_w_ND1_notaligned.*~i_moving.*((flyID==712)|(flyID==717)|(flyID==718)|(flyID==719)));

% create structures by neuron
fTm9LexA = create_neuron_structure_all_ks(f_fff_Tm9LexA);


xTm9LexA = load_neuron_data10Hz_byRegion_LedSynth(fTm9LexA,pdatapath);

%%
mTm9LexA = aggregate_fffall_means10Hz_LedSynth_fb(xTm9LexA); %when you wanna look into the aggregate function: in = xTm9LexA
% mTm9LexA = aggregate_fffall_means10Hz_BleedThruFix_v2_LedSynth(xTm9LexA); %when you wanna look into the aggregate function: zeros(1,length(in))

% mTm9LexA = trialAverageAndNormalizeArray_ks(xTm9LexA); %when you wanna look into the aggregate function: in = xTm9LexA

% save(LEDsynth_L3_datadescription_date, mTm9LexA); %create a .mat file LEDsynth_L3_datadescription_date where you store your variable mTm9LexA


% Plotting

% correlate with stimulus to select normal and inverted ROIs
iRATE = 10; %rate at which data are interpolated
num_ROIs = size(mTm9LexA.rats,1);
num_LEDs = size(mTm9LexA.rats,2);

signal = mTm9LexA.rats;
cur_IDs = mTm9LexA.flyID;

%% Test plots, Average across FlyIDs, individual LED responses
close all
dur = size(mTm9LexA.rats,3);
cur_t = (1:dur)/iRATE;

for kk=1:num_LEDs
    figure('Name',['All ROIs Led #', num2str(kk)]); 
    signal_thisLED = squeeze(signal(:,kk,:));
    
    [x,m,e] = mean_cat_full(signal_thisLED,1,cur_IDs); %m=mean; e=std . x=mean of flyID
    
    ylabel('dF/F');
    xlabel('time (s)');

 %    ylim([-0.2 0.2]) %for L3
%    ylim([-0.7 0.7]) %for L2
    ylim([-1 3]);
    xlim([0 2])
    
    colormap('lines');
    h1 = plot_err_patch_v2(cur_t,m,e,[0 0 1],[0.5 0.5 1]);
end
%% Test plots, Average across ROIs, individual LED responses
close all
dur = size(mTm9LexA.rats,3);
cur_t = (1:dur)/iRATE;

for kk=1:num_LEDs
    figure('Name',['All ROIs Led #', num2str(kk)]); 
    signal_thisLED = squeeze(signal(:,kk,:));
    mROI = mean(signal_thisLED,'omitnan');
    eROI = std(signal_thisLED,[],1,'omitnan')/sqrt(size(signal_thisLED,1)); %S.E.M

    colormap('lines');
    plot_err_patch_v2(cur_t,mROI,eROI,[0 0 1],[0.5 0.5 1]);
    
%    ylim([-0.2 0.2]);
    ylim([-1 3]);
    ylabel('dF/F');
    xlabel('time (s)');
end

%% Test plots, Average across ROIs, all LEDs (only a part of epoch)
% Plots all 20 LEDs (mean over 3 presentations taken in aggregate function)
close all
plot_begin = 5;
plot_end = 10; % Plot signal only up to THIS index (dur = 20 for 2s)
dur = plot_end-plot_begin +1;

signal_tROI =[];% zeros([num_ROIs,num_LEDs*part_to_be_plotted]);
signal_ROI = zeros([num_ROIs,num_LEDs*dur]);
cur_t = (1:(num_LEDs*dur))/iRATE;


for ii=1:num_ROIs
    
    for kk=1:num_LEDs
        signal_tROI = cat(1,signal_tROI,squeeze(signal(ii,kk,plot_begin:plot_end)));
    end
    
    signal_ROI(ii,:) = signal_tROI;
    signal_tROI =[];
end

figure('Name',['All ROIs, all Leds']);
mROI = mean(signal_ROI,'omitnan');
eROI = std(signal_ROI,[],1,'omitnan')/sqrt(size(signal_ROI,1)); %S.E.M


% legend([h1],sprintf('N = %d ( %d )',size(x,1),size(signal_thisLED,1)),...
%         'location','northeast');

% legend([h1],sprintf('N = %d ( %d )',size(x,1),size(squeeze(mTm9LexA.rats),1)),...
%         'location','northeast');

colormap('lines');
plot_err_patch_v2(cur_t,mROI,eROI,[0 0 1],[0.5 0.5 1]);

%ylim([-0.7 0.7]);
%ylim([0 3]); % L2
ylim([-1 1]); %L3
ylabel('dF/F');
xlabel('time (s)');



%% Katja added: FINAL PLOTS (with the right X-axis)
% Plots max response of each LED in a way that we get a spoctral response
% of the neuron. Here we are taking into the account the distances between
% the peak wavelengths of the LEDs. 
% Using the max response in the first half (either 1s for 2s imaging 
% (2s long flash, followed by a 2s long imaging) or 50ms for 1s of imaging (200ms flash, followed by a 1s of imaging))

% close all
plot_begin = 1;
plot_end = 10; % Plot signal only up to THIS index (dur = 20 for 2s)
dur = plot_end-plot_begin +1;

signal_tROI =[];% zeros([num_ROIs,num_LEDs*part_to_be_plotted]);
signal_ROI = zeros([num_ROIs,num_LEDs]); % only one value per LED
LED_peak_wavelengths = [367 373 385 405 420 439 451 469 485 500 518 530 554 573 590 626 651 660 672 682];
diff_LED_peak_wavelengths = diff(LED_peak_wavelengths);

for ii=1:num_ROIs
    
    for kk=1:num_LEDs
        max_signal = max(squeeze(signal(ii,kk,plot_begin:plot_end)));
        signal_tROI = cat(1,signal_tROI,max_signal);
    end
    
    signal_ROI(ii,:) = signal_tROI;
    signal_tROI =[];
end



figure('Name',['All ROIs, all Leds']);
mROI = mean(signal_ROI,'omitnan');
eROI = std(signal_ROI,[],1,'omitnan')/sqrt(size(signal_ROI,1)); %S.E.M


colormap('lines');
plot_err_patch_v2(LED_peak_wavelengths,mROI,eROI,[0 0 1],[0.5 0.5 1]);

% ylim([-0.7 0.7]);
% ylim([0 2.5]);
ylim([0 4.5]);
xlim([367 682]);
ylabel('dF/F');
xlabel('wavelength');


hold on
plot(LED_peak_wavelengths(1:20),mROI(1:20),'r*')
hold on
plot(LED_peak_wavelengths(1:20),0, 'r*')



%% Fitting two gaussians (for L3 data) new try! The peakfit doesn' work!
[FitResults,MeanFitError] = peakfit([LED_peak_wavelengths' mROI'])

%% Fitting two gaussians (for L3 data)!

% peak1 = max(mROI(1:9));
% peak2 = max(mROI(9:20));


%finding the peaks
[pks,locs] = findpeaks(mROI); % returns a vector with the local maxima (peaks) and returns the indices at which the peaks occur

[pks,locs,w,p] = findpeaks(mROI,LED_peak_wavelengths); %additionally returns the widths of the peaks as the vector w and the prominences of the peaks as the vector p.
[pks,locs,w,p] = findpeaks(mROI,LED_peak_wavelengths,'MinPeakHeight',0.2); %getting rid of the small peak

findpeaks(mROI,LED_peak_wavelengths); %find the peaks and plot them
text(locs+.02,pks,num2str((1:numel(pks))'))


%Sort the peaks from tallest to shortest
[psor,lsor] = findpeaks(mROI,LED_peak_wavelengths,'SortStr','descend');
text(lsor+.02,psor,num2str((1:numel(psor))'))

findpeaks(mROI,LED_peak_wavelengths)




%% Normalization step

% close all
plot_begin = 1;
plot_end = 10;
signal_tROI =[];% zeros([num_ROIs,num_LEDs*part_to_be_plotted]);
signal_ROI = zeros([num_ROIs,num_LEDs]); % only one value per LED
LED_peak_wavelengths = [367 373 385 405 420 439 451 469 485 500 518 530 554 573 590 626 651 660 672 682];
diff_LED_peak_wavelengths = diff(LED_peak_wavelengths);

for ii=1:num_ROIs
    
    for kk=1:num_LEDs
        max_signal = max(squeeze(signal(ii,kk,plot_begin:plot_end)));
        signal_tROI = cat(1,signal_tROI,max_signal);
        signal_tROI_norm_L2 = signal_tROI ./ max(signal_tROI);
%         signal_tROI_norm_L3 = signal_tROI ./ max(signal_tROI);
    end
%     signal_ROI(ii,:) = signal_tROI;
%     signal_tROI =[];
    signal_ROI_norm_L2(ii,:) = signal_tROI_norm_L2;
%     signal_ROI_norm_L3(ii,:) = signal_tROI_norm_L3;
    signal_tROI =[];
    
    %Save the Data for analysis
%     str = strjoin(titles1(kk));
    filename = [ DataSavePath, Dataslash, 'normalized', num2str(DataSave),'.mat' ];    
    save(filename,'signal_ROI_norm_L2');   
%     save(filename,'signal_ROI_norm_L3'); 
end



figure('Name',['All ROIs, all Leds']);
mROI_norm = mean(signal_ROI_norm_L2,'omitnan');
% mROI_norm = mean(signal_ROI_norm_L3,'omitnan');
eROI_norm = std(signal_ROI_norm_L2,[],1,'omitnan')/sqrt(size(signal_ROI_norm_L2,1)); %S.E.M
% eROI_norm = std(signal_ROI_norm_L3,[],1,'omitnan')/sqrt(size(signal_ROI_norm_L3,1)); %S.E.M

colormap('lines');
plot_err_patch_v2(LED_peak_wavelengths,mROI_norm,eROI_norm,[0 0 1],[0.5 0.5 1]);

% ylim([-0.7 0.7]);
% ylim([0 2.5]);
ylim([0 1.2]);
xlim([367 682]);
ylabel('dF/F');
xlabel('wavelength');

scatter(LED_peak_wavelengths(1:20),mROI_norm(1:20),'filled')
hold on
% plot(LED_peak_wavelengths(1:20),mROI_norm(1:20),'r*')

 
%% Statistics
load(fullfile(pdatapath, '..', 'TP_code_Katja', 'reledsynth_code', 'figures', 'normalizedL2.mat'))
load(fullfile(pdatapath, '..', 'TP_code_Katja', 'reledsynth_code', 'figures', 'normalizedL3.mat'))
L3_data = signal_ROI_norm;
L2_data = signal_ROI_norm_L2;


LED1_L2 = L2_data(:,1);
LED1_L3 = L3_data(:,1);

LED2_L2 = L2_data(:,2);
LED2_L3 = L3_data(:,2);

LED3_L2 = L2_data(:,3);
LED3_L3 = L3_data(:,3);

LED4_L2 = L2_data(:,4);
LED4_L3 = L3_data(:,4);

LED5_L2 = L2_data(:,5);
LED5_L3 = L3_data(:,5);

LED6_L2 = L2_data(:,6);
LED6_L3 = L3_data(:,6);

LED7_L2 = L2_data(:,7);
LED7_L3 = L3_data(:,7);

LED8_L2 = L2_data(:,8);
LED8_L3 = L3_data(:,8);

LED9_L2 = L2_data(:,9);
LED9_L3 = L3_data(:,9);

LED10_L2 = L2_data(:,10);
LED10_L3 = L3_data(:,10);

LED11_L2 = L2_data(:,11);
LED11_L3 = L3_data(:,11);

LED12_L2 = L2_data(:,12);
LED12_L3 = L3_data(:,12);

LED13_L2 = L2_data(:,13);
LED13_L3 = L3_data(:,13);

LED14_L2 = L2_data(:,14);
LED14_L3 = L3_data(:,14);

LED15_L2 = L2_data(:,15);
LED15_L3 = L3_data(:,15);

LED16_L2 = L2_data(:,16);
LED16_L3 = L3_data(:,16);

LED17_L2 = L2_data(:,17);
LED17_L3 = L3_data(:,17);

LED18_L2 = L2_data(:,18);
LED18_L3 = L3_data(:,18);

LED19_L2 = L2_data(:,19);
LED19_L3 = L3_data(:,19);

LED20_L2 = L2_data(:,20);
LED20_L3 = L3_data(:,20);


[h1,p1] = ttest2(LED1_L2,LED1_L3);
[h2,p2] = ttest2(LED2_L2,LED2_L3);
[h3,p3] = ttest2(LED3_L2,LED3_L3);
[h4,p4] = ttest2(LED4_L2,LED4_L3);
[h5,p5] = ttest2(LED5_L2,LED5_L3);
[h6,p6] = ttest2(LED6_L2,LED6_L3);
[h7,p7] = ttest2(LED7_L2,LED7_L3);
[h8,p8] = ttest2(LED8_L2,LED8_L3);
[h9,p9] = ttest2(LED9_L2,LED9_L3);
[h10,p10] = ttest2(LED10_L2,LED10_L3);
[h11,p11] = ttest2(LED11_L2,LED11_L3);
[h12,p12] = ttest2(LED12_L2,LED12_L3);
[h13,p13] = ttest2(LED13_L2,LED13_L3);
[h14,p14] = ttest2(LED14_L2,LED14_L3);
[h15,p15] = ttest2(LED15_L2,LED15_L3);
[h16,p16] = ttest2(LED16_L2,LED16_L3);
[h17,p17] = ttest2(LED17_L2,LED17_L3);
[h18,p18] = ttest2(LED18_L2,LED18_L3);
[h19,p19] = ttest2(LED19_L2,LED19_L3);
[h20,p20] = ttest2(LED20_L2,LED20_L3);

% p1 = 9.8150e-04   *
% p2 = 0.0049       *
% p3 = 2.3490e-04   *
% p4 = 0.0021       *
% p5 = 0.0948
% p6 = 0.9498
% p7 = 0.0508       *
% p8 = 0.4852
% p9 = 0.9075
% p10 = 0.4292
% p11 = 0.3351
% p12 = 0.5582
% p13 = 0.5160
% p14 = 0.5870
% p15 = 0.3904
% p16 = 0.6759
% p17 = 0.4355
% p18 = 0.1365
% p19 = 0.1227
% p20 = 0.4383
