%%% Analyse by different regions of the neuron

clc;
clearvars -EXCEPT slob* contr*;
close all;

% CONSTANTS

ANALYZE_BY_REGION = false;% weather ROIs should be selected based on their layer in the lobula complex. 
REGION = 'AT';  % which group or layer of ROIs will be included in this plot
% AT=axon terminals; AX=axons; CB=cell bodies; DE=dendrites
% this region info is stored as a string in the variable 'layer'in the MASTER excel spreadsheet

if(ANALYZE_BY_REGION)
%     GENOTYPE_STRING = ['RNAi btsz L3MH56Gal4 UASGCaMP6f >> GCaMP6f, region: ' REGION];
%     GENOTYPE_STRING = ['RNAi btsz L221DhhGal4 UASGCaMP6f >> GCaMP6f, region: ' REGION];
    GENOTYPE_STRING = ['erm L3 LOF >> GCaMP6f, region: ' REGION];


    if(strcmp(REGION,'AT'))
        COLOR_OF_PLOT = [0 .5 0];% GREEN
        COLOR_CLOUD =[.5 .7 .5];% GREEN
    elseif(strcmp(REGION,'AX'))
        COLOR_OF_PLOT = [1 0 0]; %RED
        COLOR_CLOUD = [1 .5 .5]; %RED cloud
    elseif(strcmp(REGION,'CB'))
        COLOR_OF_PLOT = [.7 .7 0]; % YELLOW
        COLOR_CLOUD = [.9 .9 .5]; %YELLOW cloud
    elseif(strcmp(REGION,'DE')) 
        COLOR_OF_PLOT = [0 0 1]; %BLUE; 
        COLOR_CLOUD = [.5 .5 1]; %blue cloud
    end
else
    GENOTYPE_STRING = 'L2 >> GCaMP6f, all regions';
    COLOR_OF_PLOT = [0 0 1]; %BLUE; [.7 .7 0]% YELLOW %[1 0 0]; %RED% [0 .5 0]% GREEN %[0 0 1]; %BLUE;
    %COLOR_OF_PLOT = [1 0 0]; %RED; %[0 0 1] %BLUE;
    COLOR_CLOUD = [.5 .5 1];
end
gen_str = GENOTYPE_STRING;





% % % % % 
pdatapath='T:\Katja Sporar\MATLAB\Katja_pData';
% pdatapath='/Volumes/ukme06/ksporar/MATLAB/TP_code_Katja';
addpath(pdatapath);
cd(pdatapath);

database_select_samples_ks;

% L3
% f_fff_Tm9LexA = find(i_MarkPoints_2s.*i_UASGCaMP6F_L3MH56Gal4.*~i_moving);
% f_fff_Tm9LexA = find(i_MarkPoints_200ms.*i_UASGCaMP6F_L3MH56Gal4.*~i_moving);

%L2
f_fff_Tm9LexA = find(i_MarkPoints_2s.*i_UASGCaMP6F_L221DhhGal4_cross_to_w.*~i_moving);
% f_fff_Tm9LexA = find(i_MarkPoints_200ms.*i_UASGCaMP6F_L221DhhGal4_cross_to_w.*~i_moving);

%Matthew Pecot
% f_fff_Tm9LexA = find(i_L3_ermMARCM_LOF.*~i_moving);
% f_fff_Tm9LexA = find(i_L3_MARCM_LOF_control.*~i_moving);


% create structures by neuron
fTm9LexA = create_neuron_structure_all_ks(f_fff_Tm9LexA);

if (ANALYZE_BY_REGION)
    xTm9LexA = load_neuron_data10Hz_byRegion_LedSynth(fTm9LexA,pdatapath, REGION);
else
    % interpolates at 10 Hz now...
    xTm9LexA = load_neuron_data10Hz_ks(fTm9LexA,pdatapath);
end

% mTm9LexA = aggregate_fffall_means10Hz_BleedThruFix(xTm9LexA);
mTm9LexA = aggregate_fffall_means10Hz_LedSynth(xTm9LexA); %when you wanna look into the aggregate function: in = xTm9LexA
% mTm9LexA = trialAverageAndNormalizeArray_ks(xTm9LexA); %when you wanna look into the aggregate function: in = xTm9LexA

% save(LEDsynth_L3_datadescription_date, mTm9LexA); %create a .mat file LEDsynth_L3_datadescription_date where you store your variable mTm9LexA



%% Plotting


    

