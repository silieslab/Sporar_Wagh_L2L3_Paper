%% Name of stimulus here.
% This script evaluates the data from the OFF OFF stimulus from adapted
% background. The data is displayed by different plots. 
% 
clc;
clearvars -EXCEPT slob* contr*;
close all;

% CONSTANTS

ANALYZE_BY_REGION = true;% weather ROIs should be selected based on their layer in the lobula complex. 
REGION = 'AT';  % which group or layer of ROIs will be included in this plot
% REGION = 'DE';
% REGION = 'AX';

% REGION = 'Lthree';
% REGION = 'Ltwo';

% AT=axon terminals; AX=axons; CB=cell bodies; DE=dendrites
% this region info is stored as a string in the variable 'layer'in the MASTER excel spreadsheet

if(ANALYZE_BY_REGION)
%     GENOTYPE_STRING = ['UASort UASGCaMP6f L221DhhGal4 ort1 DfBSC809, region: ' REGION];
%     GENOTYPE_STRING = ['L3 >> GCaMP6f, region: ' REGION];
%     GENOTYPE_STRING = ['L3 ort rescue R7 R8 >> ort GCaMP6f, region: ' REGION];
%     GENOTYPE_STRING = ['lexAopGCaMP6fp10attp5 16HO3lexA lexAopmyrtdTOM, region: ' REGION];
%     GENOTYPE_STRING = ['UASGCaMP6f UASort 0595Gal4,ort1, region: ' REGION];
%     GENOTYPE_STRING = ['UASort UASGCaMP6f 0595Gal4,ort1 ort1, region: ' REGION];
%     GENOTYPE_STRING = ['UASGCaMP6f plus 0595Gal4,ort1 ort1, region: ' REGION];
%     GENOTYPE_STRING = ['UASGCaMP6f plus 0595Gal4,ort1 ort1, region: ' REGION];

%     GENOTYPE_STRING = ['lexAopGCaMP6fp10attp5 16HO3lexA,lexAopmyrtdTom 11-164Gal4 ermHA, region: ' REGION];
%     GENOTYPE_STRING = ['lexAopGCaMP6fp10attp5 16HO3lexA,lexAopmyrtdTom 11-164Gal4, region: ' REGION];

%     GENOTYPE_STRING = ['UASort UASGCaMP6f L30595Gal4,ort1 DfBSC809, region: ' REGION];

%     GENOTYPE_STRING = ['RNAi btsz L3MH56Gal4 UASGCaMP6f >> GCaMP6f, region: ' REGION];
%     GENOTYPE_STRING = ['RNAi btsz L221DhhGal4 UASGCaMP6f >> GCaMP6f, region: ' REGION];
    GENOTYPE_STRING = ['L2 ort rescue, region: ' REGION];


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
pdatapath='/Users/ksporar/Documents/MATLAB/Katja_pData';
addpath(pdatapath);
cd(pdatapath);

database_select_samples_ks;


%% Processing Data 

f_Tm9LexA = find(i_Diff_Adapting_OFFstep_6s.*i_UASGCaMP6f_L3MH56Gal4_cross_to_w.*~i_moving);

% f_Tm9LexA = find(i_Diff_Adapting_OFFstep_6s.*i_UASGCaMP6F_L221DhhGal4_cross_to_w.*~i_moving);



% create structures by neuron
fTm9LexA = create_neuron_structure_all_ks(f_Tm9LexA);

% load all the data!
xTm9LexA = load_neuron_data10Hz_ks(fTm9LexA,pdatapath);

% This function groups the different interesting epoch combinations in a
% Matrix
mTm9LexA = aggregate_Adaptingcontrasts_30s_same_OFF_6s(xTm9LexA);



