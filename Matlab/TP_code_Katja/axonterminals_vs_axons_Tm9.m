%%% Analyse by different regions of the neuron

clc;
clearvars -EXCEPT slob* contr*;
close all;

% CONSTANTS

ANALYZE_BY_REGION = false;% weather ROIs should be selected based on their layer in the lobula complex. 
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


%Tm9
% f_fff_Tm9LexA  = find(i_fff2s.*i_Tm9LexAGCaMP6F.*~i_moving);
f_fff_Tm9LexA  = find(i_fff2s.*i_Tm9LexAGCaMP6F_L2L3shits_37C.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff5s.*i_Tm9LexAGCaMP6F_L1L3shits_37C.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff2s.*i_Tm9LexAGCaMP6F_L1shits_37C.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff5s.*i_Tm9LexAGCaMP6F_L2shits_37C.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff5s.*i_Tm9LexAGCaMP6F_L3shits_37C.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff5s.*i_Tm9LexAGCaMP6F_shits_37C.*~i_moving);

% L3
% f_fff_Tm9LexA  = find(i_fff2s.*i_UASGCaMP6F_L3MH56Gal4.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6F_L3MH56Gal4.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6F_L3MH56Gal4_06.*~i_moving.*(flyID>=409));

% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6F_L30595Gal4.*~i_moving.*(flyID==106));

% f_fff_Tm9LexA  = find(i_fff2s.*i_UASGCaMP6F_L30595Gal4.*~i_moving.*(flyID~=111));
% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6F_L30595Gal4.*~i_moving.*(flyID~=111));
% f_fff_Tm9LexA  = find(i_fff60s.*i_UASGCaMP6F_L30595Gal4.*~i_moving);

% f_fff_Tm9LexA  = find(i_fff5s.*(i_UASGCaMP6F_L3MH56Gal4|i_UASGCaMP6F_L30595Gal4).*~i_moving.*(flyID>=142));
% f_fff_Tm9LexA  = find(i_fff5s.*(i_UASGCaMP6F_L3MH56Gal4|i_UASGCaMP6F_L30595Gal4).*~i_moving);


% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6F_L3MH56Gal4.*~i_moving);


% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6f_L3MH56Gal4_cross_to_w.*~i_moving.*((flyID==339)|(flyID==341)|(flyID==348)|(flyID==349)|(flyID==350)));
% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6F_L221DhhGal4_cross_to_w.*~i_moving); %paper
% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6F_L221DhhGal4_cross_to_w_06.*~i_moving);

% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6f_L3MH56Gal4_cross_to_w.*~i_moving); %paper
% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6f_L3MH56Gal4_cross_to_w.*~i_moving.*((flyID==344)|(flyID==345)));
% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6f_L3MH56Gal4_cross_to_w.*~i_moving.*(flyID==344));


%L3 dendrites
% f_fff_Tm9LexA  = find(i_fff5s.*(i_UASGCaMP6F_L3MH56Gal4|i_UASGCaMP6f_L3MH56Gal4_cross_to_w).*~i_moving);

% 2s for the thesis
% f_fff_Tm9LexA  = find(i_fff2s.*i_UASGCaMP6F_L221DhhGal4.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff2s.*(i_UASGCaMP6F_L3MH56Gal4|i_UASGCaMP6f_L3MH56Gal4_cross_to_w).*~i_moving);



% L2
% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6F_L221DhhGal4.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6F_L221DhhGal4.*~i_moving.*(flyID>=390));
% f_fff_Tm9LexA  = find(i_fff2s.*i_UASGCaMP6F_L221DhhGal4.*~i_moving);

%shits
% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6f_L3MH56Gal4_UASshits.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6f_L221DhhGal4_UASshits.*~i_moving);

% GCaMP3
% f_fff_Tm9LexA  = find(i_fff2s.*i_UASGCaMP3_L3MH56Gal4.*~i_moving)
% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP3_L3MH56Gal4.*~i_moving)


% ONgrayOFFgray L3
% f_fff_Tm9LexA  = find(i_fff2sONgrayOFF.*i_UASGCaMP6F_L3MH56Gal4.*~i_moving); %old
% f_fff_Tm9LexA  = find(i_fff5sONgrayOFF.*i_UASGCaMP6F_L3MH56Gal4.*~i_moving); %old
% f_fff_Tm9LexA  = find(i_fff25msecONgrayOFF.*i_UASGCaMP6F_L3MH56Gal4.*~i_moving); %old
% f_fff_Tm9LexA  = find(i_fff2sONgrayOFF4sBG.*i_UASGCaMP6F_L3MH56Gal4.*~i_moving.*(flyID==226));

% ONgrayOFFgray L2
% f_fff_Tm9LexA  =
% f_fff_Tm9LexA  = find(i_fff2sONgrayOFF.*i_UASGCaMP6F_L221DhhGal4.*~i_moving); %old
% f_fff_Tm9LexA  = find(i_fff5sONgrayOFF.*i_UASGCaMP6F_L221DhhGal4.*~i_moving); %old
% f_fff_Tm9LexA  = find(i_fff25msecONgrayOFF.*i_UASGCaMP6F_L221DhhGal4.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff2sONgrayOFF4sBG.*i_UASGCaMP6F_L221DhhGal4.*~i_moving);



% PTX experiment L3
% f_fff_Tm9LexA  = find(i_fff2s.*i_UASGCaMP6F_L3MH56Gal4.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6F_L3MH56Gal4.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6F_L3MH56Gal4.*~i_moving.*(flyID>=157));
% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6F_L3MH56Gal4_PTX.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff2s.*i_UASGCaMP6F_L3MH56Gal4.*~i_moving.*(flyID>=157));
% f_fff_Tm9LexA  = find(i_fff2s.*i_UASGCaMP6F_L3MH56Gal4_PTX.*~i_moving);

% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6F_L3MH56Gal4.*~i_moving.*((flyID==167)|(flyID==168)));
% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6F_L3MH56Gal4_PTX.*~i_moving.*((flyID==167)|(flyID==168)));
% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6F_L3MH56Gal4_PTX.*~i_moving.*(flyID==167));

% PTX experiment L2
% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6F_L221DhhGal4.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff2s.*i_UASGCaMP6F_L221DhhGal4.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff60s.*i_UASGCaMP6F_L221DhhGal4.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6F_L221DhhGal4.*~i_moving.*(flyID==159)|(flyID==160)|(flyID==161)|(flyID==165));
% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6F_L221DhhGal4.*~i_moving.*(flyID==161));
% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6F_L221DhhGal4_PTX.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff2s.*i_UASGCaMP6F_L221DhhGal4.*~i_moving.*((flyID==157)|(flyID==159)|(flyID==160)|(flyID==161)|(flyID==165)|(flyID==166)));
% f_fff_Tm9LexA  = find(i_fff2s.*i_UASGCaMP6F_L221DhhGal4_PTX.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff2s.*i_UASGCaMP6F_L221DhhGal4_PTX.*~i_moving);

% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6F_L221DhhGal4.*~i_moving.*(flyID==165));
% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6F_L221DhhGal4_PTX.*~i_moving.*(flyID==165));
% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6F_L221DhhGal4.*~i_moving.*((flyID==165)|(flyID==166)));
% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6F_L221DhhGal4_PTX.*~i_moving.*((flyID==165)|(flyID==166)));
% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6F_L221DhhGal4.*~i_moving.*(flyID==166));
% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6F_L221DhhGal4_PTX.*~i_moving.*(flyID==166));

%Cbp53E mutant
% f_fff_Tm9LexA  = find(i_fff2s.*i_Cbp53E_L221DhhGal4.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff5s.*i_Cbp53E_L221DhhGal4.*~i_moving);

%syp
% f_fff_Tm9LexA  = find(i_fff5s.*i_UASsyp_L221DhhGal4.*~i_moving.*(flyID==120));
% f_fff_Tm9LexA  = find(i_fff5s.*i_UASsyp_L221DhhGal4.*~i_moving); %here you have to put ANALYZE_BY_REGION = false
% f_fff_Tm9LexA  = find(i_fff2s.*i_UASsyp_L3MH56Gal4.*~i_moving);

%sypPhTomato
% f_fff_Tm9LexA  = find(i_fff2s.*i_UASsypPhTom_L3MH56Gal4.*~i_moving);


%Rh1
% f_fff_Tm9LexA  = find(i_fff2s.*i_UASGCaMP6f_Rh1Gal4.*~i_moving);


%RNAi
% f_fff_Tm9LexA  = find(i_fff5s.*i_RNAi_Ih_L221DhhGal4_UASGCaMP6f.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff5s.*i_RNAi_Ih_MH56Gal4_UASGCaMP6f.*~i_moving);

% f_fff_Tm9LexA  = find(i_fff5s.*i_RNAi_Slob_L221DhhGal4_UASGCaMP6f.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff5s.*i_RNAi_Slob_MH56Gal4_UASGCaMP6f.*~i_moving);

% f_fff_Tm9LexA  = find(i_fff5s.*i_RNAi_Shawl_L221DhhGal4_UASGCaMP6f.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff5s.*i_RNAi_Shawl_MH56Gal4_UASGCaMP6f.*~i_moving);

% f_fff_Tm9LexA  = find(i_fff5s.*i_RNAi_HCl1_L221DhhGal4_UASGCaMP6f.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff5s.*i_RNAi_HCl1_MH56Gal4_UASGCaMP6f.*~i_moving);

% f_fff_Tm9LexA  = find(i_fff5s.*i_RNAi_Ace_L221DhhGal4_UASGCaMP6f.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff5s.*i_RNAi_Ace_MH56Gal4_UASGCaMP6f.*~i_moving);

% f_fff_Tm9LexA  = find(i_fff5s.*i_RNAi_btsz_L221DhhGal4_UASGCaMP6f.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff5s.*i_RNAi_btsz_MH56Gal4_UASGCaMP6f.*~i_moving);


%ort rescue - only R7 & R8
% f_fff_Tm9LexA = find(i_fff5s.*i_UASort_UASGCaMP6f_0595Gal4_ort1_ort1.*~i_moving);
% f_fff_Tm9LexA = find(i_fff5s.*i_UASort_UASGCaMP6f_L221DhhGal4_ort1_ort1.*~i_moving);
% f_fff_Tm9LexA = find(i_fff5s.*i_UASGCaMP6f_plus_0595Gal4_ort1_ort1.*~i_moving); %negative control
% f_fff_Tm9LexA = find(i_fff5s.*i_UASGCaMP6f_UASort_0595Gal4_ort1_plus.*~i_moving); %positive control
% f_fff_Tm9LexA = find(i_fff5s.*i_UASGCaMP6f_UASort_L221DhhGal4_ort1_plus_Helen.*~i_moving);

%real ort rescue
% f_fff_Tm9LexA =
% find(i_fff5s.*i_UASort_UASGCaMP6f_L221DhhGal4_ort1_DfBSC809_Helen.*~i_moving); %paper
% f_fff_Tm9LexA = find(i_fff5s.*i_UASort_UASGCaMP6f_L30595Gal4_ort1_DfBSC809.*~i_moving); %paper

%double ort erscue: L2 ans L3
% f_fff_Tm9LexA = find(i_fff5s.*i_UASort_UASGCaMP6f_L221DhhGal4_MH56Gal4_ort1_plus.*~i_moving);
% f_fff_Tm9LexA = find(i_fff5s.*i_UASort_UASGCaMP6f_L221DhhGal4_MH56Gal4_ort1_DfBSC809.*~i_moving);
% f_fff_Tm9LexA = find(i_fff5s.*i_UASGCaMP6f_L221DhhGal4_MH56Gal4_ort1_plus_DfBSC809.*~i_moving);


% f_fff_Tm9LexA = find(i_fff2s.*i_UASort_UASGCaMP6f_L221DhhGal4_MH56Gal4_ort1_plus.*~i_moving);
% f_fff_Tm9LexA = find(i_fff2s.*i_UASort_UASGCaMP6f_L221DhhGal4_MH56Gal4_ort1_DfBSC809.*~i_moving);
% f_fff_Tm9LexA = find(i_fff2s.*i_UASGCaMP6f_L221DhhGal4_MH56Gal4_ort1_plus_DfBSC809.*~i_moving);

%real ort rescue - controls
% f_fff_Tm9LexA = find(i_fff5s.*i_UASGCaMP6f_UASort_0595Gal4_ort1_plus.*~i_moving.*(flyID>=495)); %paper
% f_fff_Tm9LexA = find(i_fff5s.*i_UASGCaMP6f_UASort_L221DhhGal4_ort1_plus_Helen.*~i_moving); %paper
% f_fff_Tm9LexA = find(i_fff5s.*i_UASGCaMP6f_plus_0595Gal4_ort1_DfBSC809.*~i_moving); %paper - Q>0.1
% f_fff_Tm9LexA = find(i_fff5s.*i_UASGCaMP6f_plus_L221DhhGal4_ort1_DfBSC809_Helen.*~i_moving); %paper - Q>0.1


%Matthew Pecot
% f_fff_Tm9LexA = find(i_fff5s.*i_lexAopGCaMP6fp10attp5_16HO3lexA_lexAopmyrtdTOM_11164Gal4_plus.*~i_moving);
% f_fff_Tm9LexA = find(i_fff5s.*i_lexAopGCaMP6fp10attp5_16HO3lexA_lexAopmyrtdTOM_11164Gal4ermHA.*~i_moving);
% f_fff_Tm9LexA = find(i_fff2s.*i_lexAopGCaMP6fp10attp5_16HO3lexA_lexAopmyrtdTOM_11164Gal4_plus.*~i_moving);
% f_fff_Tm9LexA = find(i_fff2s.*i_lexAopGCaMP6fp10attp5_16HO3lexA_lexAopmyrtdTOM_11164Gal4ermHA.*~i_moving);
% f_fff_Tm9LexA = find(i_fff5s.*i_lexAopGCaMP6fp10attp5_16HO3lexA_lexAopmyrtdTOM_plus_plus.*~i_moving);
% f_fff_Tm9LexA = find(i_fff2s.*i_lexAopGCaMP6fp10attp5_16HO3lexA_lexAopmyrtdTOM_plus_plus.*~i_moving);
% f_fff_Tm9LexA = find(i_fff5s.*i_lexAopGCaMP6fp10attp5_16HO3lexA_lexAopmyrtdTOM_plus_UASerm.*~i_moving);



%Matthew Pecot - L3 LOF
% f_fff_Tm9LexA = find(i_fff5s.*i_L3_ermMARCM_LOF.*~i_moving);
% f_fff_Tm9LexA = find(i_fff5s.*i_L3_MARCM_LOF_control.*~i_moving);

%Matthew Pecot - erm RNAi
% f_fff_Tm9LexA = find(i_fff5s.*i_UASGCaMP6f_L3MH56Gal4_UASshits_UASermRNAi.*~i_moving);


%paper
% f_fff_Tm9LexA = find(i_fff5s.*i_lexAopGCaMP6fp10attp5_16HO3lexA_lexAopmyrtdTOM_plus_UASerm.*~i_moving);
% f_fff_Tm9LexA = find(i_fff5s.*i_lexAopGCaMP6fp10attp5_16HO3lexA_lexAopmyrtdTOM_11164Gal4ermHA.*~i_moving); %paper
% f_fff_Tm9LexA = find(i_fff5s.*i_lexAopGCaMP6fp10attp5_16HO3lexA_lexAopmyrtdTOM_plus_plus.*~i_moving);
% f_fff_Tm9LexA = find(i_fff5s.*i_lexAopGCaMP6fp10attp5_16HO3lexA_lexAopmyrtdTOM_11164Gal4_plus.*~i_moving); %paper


%Overexpression candidates
% f_fff_Tm9LexA = find(i_fff5s.*i_UASGCaMP6F_L221DhhGal4_UASbtsz.*~i_moving);


%R8
% f_fff_Tm9LexA = find(i_fff5s.*i_UASGCaMP6m_sensFlp_act_CD2_Gal4_R8.*~i_moving);
% f_fff_Tm9LexA = find(i_fff2s.*i_UASGCaMP6m_sensFlp_act_CD2_Gal4_R8.*~i_moving);



% L3 ND filters
% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6f_L3MH56Gal4_cross_to_w_noND.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6f_L3MH56Gal4_cross_to_w_ND01.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6f_L3MH56Gal4_cross_to_w_ND03.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6f_L3MH56Gal4_cross_to_w_ND06.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6f_L3MH56Gal4_cross_to_w_ND1.*~i_moving);

% f_fff_Tm9LexA = find(i_fff5s.*(i_UASGCaMP6F_L3MH56Gal4_06 | i_UASGCaMP6f_L3MH56Gal4_cross_to_w_06).*~i_moving.*((flyID==409)|(flyID==410)|(flyID==411)|(flyID==412)|(flyID==413)|(flyID==414)|(flyID==415)|(flyID==416)|(flyID==436)|(flyID==437)|(flyID==438)|(flyID==442)|(flyID==443)|(flyID==444)|(flyID==445)|(flyID==446)|(flyID==451)|(flyID==452)|(flyID==453)|(flyID==454)|(flyID==455)|(flyID==456)|(flyID==457)));
% f_fff_Tm9LexA = find(i_fff5s.*(i_UASGCaMP6F_L3MH56Gal4 | i_UASGCaMP6f_L3MH56Gal4_cross_to_w).*~i_moving.*((flyID==409)|(flyID==410)|(flyID==411)|(flyID==412)|(flyID==413)|(flyID==414)|(flyID==415)|(flyID==416)|(flyID==436)|(flyID==437)|(flyID==438)|(flyID==442)|(flyID==443)|(flyID==444)|(flyID==445)|(flyID==446)|(flyID==451)|(flyID==452)|(flyID==453)|(flyID==454)|(flyID==455)|(flyID==456)|(flyID==457)));

% f_fff_Tm9LexA = find(i_fff5s.*(i_UASGCaMP6f_L221DhhGal4_06 | i_UASGCaMP6F_L221DhhGal4_cross_to_w_06).*~i_moving.*(flyID~=400));
% f_fff_Tm9LexA = find(i_fff5s.*(i_UASGCaMP6F_L221DhhGal4 | i_UASGCaMP6F_L221DhhGal4_cross_to_w).*~i_moving.*(flyID==401)|(flyID==402)|(flyID==403)|(flyID==404)|(flyID==405)|(flyID==406)|(flyID==439)|(flyID==440)|(flyID==441)|(flyID==447)|(flyID==448)|(flyID==458)|(flyID==459)|(flyID==460)|(flyID==461)|(flyID==462));

%UASFlagCFPbrp
% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6f_L3MH56Gal4_UASFlagCFPbrp.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6F_L221DhhGal4_UASFlagCFPbrp.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff2s.*i_UASGCaMP6F_L221DhhGal4_UASFlagCFPbrp.*~i_moving);



%ort overexpression
% f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6F_L221DhhGal4_UASort.*~i_moving);

%NinaEGal4_UASGCaMP6m
% f_fff_Tm9LexA  = find(i_fff2s.*i_NinaEGal4_UASGCaMP6m.*~i_moving);


%NorpA rescues
% f_fff_Tm9LexA  = find(i_fff2s.*i_NorpA_Rh1NorpA_L2LexA_LexAopGCaMP6f.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff5s.*i_NorpA_Rh1NorpA_L2LexA_LexAopGCaMP6f.*~i_moving);

% f_fff_Tm9LexA  = find(i_fff2s.*i_NorpA_Rh1NorpA_L3QF_QUAS_GCaMP6f.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff5s.*i_NorpA_Rh1NorpA_L3QF_QUAS_GCaMP6f.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff5s.*i_NorpA_Rh1NorpA_L3QF_QUAS_GCaMP6f.*~i_moving.*(flyID~=800));
% f_fff_Tm9LexA  = find(i_fff2s.*i_NorpA_Rh1NorpA_L3QF_QUAS_GCaMP6f.*~i_moving.*(flyID~=800));

% f_fff_Tm9LexA  = find(i_fff5s.*i_norpA_rh1_panR8_UASnorpA_L2LexA_LexAopGCaMP6f.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff5s.*i_norpA_rh1_panR8_UASnorpA_L3QF_QUAS_GCaMP6f.*~i_moving); %ID 1129 has a very slow kinetics

%Rh6
% f_fff_Tm9LexA  = find(i_fff2s.*i_NorpA_Rh6NorpA_L2LexA_LexAopGCaMP6f.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff5s.*i_NorpA_Rh6NorpA_L2LexA_LexAopGCaMP6f.*~i_moving);

% f_fff_Tm9LexA  = find(i_fff2s.*i_NorpA_Rh6NorpA_L3QF_QUAS_GCaMP6f.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff5s.*i_NorpA_Rh6NorpA_L3QF_QUAS_GCaMP6f.*~i_moving);

%panR8
% f_fff_Tm9LexA  = find(i_fff2s.*i_NorpA_panR8NorpA_L2LexA_LexAopGCaMP6f.*~i_moving.*(flyID~=824));
% f_fff_Tm9LexA  = find(i_fff5s.*i_NorpA_panR8NorpA_L2LexA_LexAopGCaMP6f.*~i_moving.*(flyID~=824));

% f_fff_Tm9LexA  = find(i_fff2s.*i_NorpA_panR8NorpA_L3QF_QUAS_GCaMP6f.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff5s.*i_NorpA_panR8NorpA_L3QF_QUAS_GCaMP6f.*~i_moving);

%NorpA controls
% f_fff_Tm9LexA  = find(i_fff5s.*i_panR8_L2LexA_LexAopGCaMP6f.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff5s.*i_norpA_UASnorpA_L2LexA_LexAopGCaMP6f.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff5s.*i_rh1NorpA_L2LexA_LexAopGCaMP6f.*~i_moving);

% f_fff_Tm9LexA  = find(i_fff5s.*i_panR8_L3QF_QUAS_GCaMP6f.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff5s.*i_norpA_UASnorpA_L3QF_QUAS_GCaMP6f.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff5s.*i_rh1NorpA_L3QF_QUAS_GCaMP6f.*~i_moving);

% f_fff_Tm9LexA  = find(i_fff2s.*i_panR8_L2LexA_LexAopGCaMP6f.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff2s.*i_norpA_UASnorpA_L2LexA_LexAopGCaMP6f.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff2s.*i_rh1NorpA_L2LexA_LexAopGCaMP6f.*~i_moving);

% f_fff_Tm9LexA  = find(i_fff2s.*i_panR8_L3QF_QUAS_GCaMP6f.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff2s.*i_norpA_UASnorpA_L3QF_QUAS_GCaMP6f.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff2s.*i_rh1NorpA_L3QF_QUAS_GCaMP6f.*~i_moving);



% create structures by neuron
fTm9LexA = create_neuron_structure_all_ks(f_fff_Tm9LexA);

if (ANALYZE_BY_REGION)
    xTm9LexA = load_neuron_data10Hz_byRegion(fTm9LexA,pdatapath, REGION);
else
    % interpolates at 10 Hz now...
    xTm9LexA = load_neuron_data10Hz_ks(fTm9LexA,pdatapath);
end

% mTm9LexA = aggregate_fffall_means10Hz_BleedThruFix(xTm9LexA);
mTm9LexA = aggregate_fffall_means10Hz_BleedThruFix_v2(xTm9LexA);
% mTm9LexA = aggregate_fffall_means10Hz_BleedThruFix_v2_nodFF(xTm9LexA); %for plotting without dF/F for the thesis


%when you wanna look into the aggregate function: in = xTm9LexA


%%
% correlate with stimulus to select normal and inverted ROIs
iRATE = 10; %rate at which data are interpolated
dur = size(mTm9LexA.rats,2);
DURS = 2;


% start with all the data, keep the ones that are positively correlated
% with stimulus (by value Q)
cur_mat = mTm9LexA.rats;
cur_IDs = mTm9LexA.flyID;
%clean up by zeros-only datasets and NaN dataset
inds = find(sum(cur_mat,2)~=0);
cur_mat = cur_mat(inds,:);
cur_IDs = cur_IDs(inds);
inds = ~isnan(sum(cur_mat,2));%ms: added these two lines, because there were NaN in dataset
cur_mat = cur_mat(inds,:);
cur_IDs = cur_IDs(inds);
% mean_res = mean(cur_mat,1); %was correlating with the mean beforee
% Q = corr(mean_res',cur_mat');

cur_t = [1:size(cur_mat,2)]/iRATE;


%positive correlation with stimulus


Q = corr(nanmean(mTm9LexA.stims)',cur_mat');
% Q = corr(mean(mTm9LexA.stims)',cur_mat');
% inds = find(Q>0.5); %finds the cells whose response correlates well with the stimulus 
inds = find(Q>0.1); %ONLY for ort!!!!!
cur_mat_pos = cur_mat(inds,:);
cur_IDs_pos = cur_IDs(inds);

%calculating means across flies
[x_pos,m_pos,e_pos] = mean_cat_full(cur_mat_pos,1,cur_IDs_pos);
%calculating the max for each trace
max_pos = max(x_pos,[],2)-1;




%negative correlation with stimulus

Q = corr(nanmean(mTm9LexA.stims)',cur_mat');
% inds = find(Q<-0.5);
inds = find(Q<-0.1); %ONLY for the L2 ort control!!!!!
size(inds)
cur_mat_neg = cur_mat(inds,:);
cur_IDs_neg = cur_IDs(inds);

%calculating means across flies
[x_neg,m_neg,e_neg] = mean_cat_full(cur_mat_neg,1,cur_IDs_neg);
max_neg = max(x_neg,[],2)-1;




%plot both normal and inverted (by correlation with stimulus) in one plot
figure; hold on
t = [1:dur]/10;
% subplot(2,2,1); hold on;
cm=colormap('lines');
h1 = plot_err_patch_v2(cur_t,m_pos,e_pos,[0 0 1],[0.5 0.5 1]);
h2 = plot_err_patch_v2(cur_t,m_neg,e_neg,[0.75 0 0.75],[0.75 0.5 0.75]);
% plot([0 5],0.3*[1 1],'k-','linewidth',3);
% plot([10 15],0.3*[1 1],'k-','linewidth',3);
title([gen_str ', all "normal" and "inverted" cells']);
legend([h1, h2],sprintf([gen_str ', "fff pos corr", N = %d ( %d )'],size(x_pos,1),size(cur_mat_pos,1)),...
    sprintf([gen_str ', "fff neg corr", N = %d ( %d )'],size(x_neg,1),size(cur_mat_neg,1)),...
    'location','northeast');
plot(t, (round(mean(mTm9LexA.stims))*0.1)+0.8)
% ylim([-0.3 0.5]);
line([0 5.5],[0 0],'color',[0 0 0]);


% plot negatively correlated cells, mean across flies
figure; hold on
subplot(2,1,1); 
cm=colormap('lines');
% h2 = plot_err_patch_v2(cur_t,m_neg,e_neg,[0.75 0 0.75],[0.75 0.5 0.75]);
h2 = plot_err_patch_v2(cur_t,m_neg,e_neg,[0 0.5 0],[0 0.80 0]); %green
% h2 = plot_err_patch_v2(cur_t,m_neg,e_neg,[1 0.4 0],[1 0.7 0]); %orange
% h2 = plot_err_patch_v2(cur_t,m_neg,e_neg,[0.5 0.4 1],[0.5 0.7 1]); %blue
title([gen_str ', neg corr, mean by fly']);
legend([h2],sprintf([gen_str ', N = %d ( %d )'],size(x_neg,1),size(cur_mat_neg,1)),...
    'location','northeast');
plot(cur_t, (round(mean(mTm9LexA.stims))*0.1)+0.6)
ylim([-1.0 2.0]); %for L2
% ylim([-0.8 1.0]); %for L3
% ylim([-0.5 0.5]); %DE
% ylim([-0.1 0.1]); %no dF/F
% ylim([-0.5 0.4]); %ort rescue
% line([0 10],[0 0],'color',[0 0 0]); %for 5 s
line([0 4],[0 0],'color',[0 0 0]); %for 2 s

subplot(2,1,2);
plot(t,x_neg)
title('individual fly means');
ylim([-1.0 2.0]); %for L2
% ylim([-0.8 1.0]); %for L3
% ylim([-0.5 0.5]); %DE
% ylim([-0.1 0.1]); %no dF/F
% ylim([-0.5 0.4]); %ort rescue
line([DURS DURS],[-0.6 0.6],'color',[0 0 0],'linestyle','--');
line([0 DURS],[0 0],'color',[0 0 0]);
set(gcf,'Color','w');
niceaxes;




%plot negatively correlated cells, mean across ROIs
mROI_neg = mean(cur_mat_neg);
eROI_neg = std(cur_mat_neg,[],1)/sqrt(size(cur_mat_neg,1)); %S.E.M

figure; hold on
subplot(2,1,1);
cm=colormap('lines');
% h2 = plot_err_patch_v2(cur_t,mROI_neg,eROI_neg,[0 0.5 0],[0 0.80 0]);
h2 = plot_err_patch_v2(cur_t,mROI_neg,eROI_neg,[0.75 0 0.75],[0.75 0.5 0.75]);
title([gen_str ', neg corr, mean by ROI']);
legend([h2],sprintf([gen_str ', N = %d ( %d )'],size(x_neg,1),size(cur_mat_neg,1)),...
    'location','northeast');
plot(cur_t, (round(mean(mTm9LexA.stims))*0.1)+0.6)
ylim([-1.0 2.0]); %for L2
% ylim([-0.8 1.0]); %for L3
% ylim([-0.5 0.5]); %DE
% ylim([-0.5 0.4]); %ort rescue
% line([0 10],[0 0],'color',[0 0 0]); %for 5 s
line([0 4],[0 0],'color',[0 0 0]); %for 2 s

subplot(2,1,2);
plot(t,cur_mat_neg)
title('individual fly means');
ylim([-1.0 2.0]); %for L2
% ylim([-0.8 1.0]); %for L3
% ylim([-0.5 0.5]); %DE
% ylim([-0.5 0.4]); %ort rescue
line([DURS DURS],[-0.6 0.6],'color',[0 0 0],'linestyle','--');
line([0 DURS],[0 0],'color',[0 0 0]);
set(gcf,'Color','w');
niceaxes;


%% Statistics


THRESHOLD = 0;
fprintf('THRESHOLD for Signal sum: %d \n',THRESHOLD );

% Mean over flies
cur_mat = mTm9LexA.rats;
cur_IDs = mTm9LexA.flyID;

%calculating means across flies
[x_neg,m_neg,e_neg] = mean_cat_full(cur_mat_neg,1,cur_IDs_neg);


% take a mean of all assigned values, ignore 0
crossing_rats = mTm9LexA.rats;
crossing_rats(crossing_rats==0) = NaN;

% Mean over all ROI's
mean_val = squeeze(mean(crossing_rats,1,'omitnan'));

num_steps = size(mean_val,1);
numROIs = size(crossing_rats,1);

mean_calcium = zeros(1,num_steps);
err_calcium = zeros(1,num_steps);

off_step = [1];
off_step = logical(off_step);



for kk =1:num_steps
%     traces = squeeze(mTm9LexA.rats(:,kk,:)); %because mean_cat_full works only with 2 dimensions %taking all ROIs, the epoch we are on, full lenth (200)
%     [x,m,e] = mean_cat_full(traces,1,mTm9LexA.flyID); %m=mean; e=std
    [x,m,e] = mean_cat_full(cur_mat_neg,1,cur_IDs_neg);
    
    %ks: defining the time where we look for the baseline
    baseline = x(:,round(0.61*end):round(0.7*end)); %7.9 - 9.1 s of the 13s trace
    Peak = x(:,round(0.01*end):round(0.25*end)); %0.13 - 3.25 s of the 13s trace


    %ks: defining the time where we look for the response
%     search_peak = x(:,round(0.4*end)+1:round(0.6*end));  %10s till 15s out of 25s
%     search_peakONtogrey = x(:,round(0.6*end)+1:round(0.8*end));  %15s till 20s
    search_peak = x(:,round(0.01*end)+1:round(0.3*end));  %10s till 15s out of 25s
%     search_peakONtogrey = x(:,round(0.6*end)+1:round(0.9*end));  %15s till 20s
%     calcium = squeeze(nanmean(search_peak,1));
    calcium = squeeze(nanmean(search_peak,1));
%     calciumONtogrey = squeeze(nanmean(search_peakONtogrey,1));
    

    if off_step(kk)
        baseline = baseline;
        peak = max(calcium);
    end


    not_NaN_flies = size(x,1); % Fabi: would crash otherwise, we have only 8 flies (not 12) evaluated here !
    
    calciumStep = zeros(not_NaN_flies,1);

    
    calciumStep = zeros(not_NaN_flies,1);
%     for ii = 1:not_NaN_flies
%         if on_step(kk)
%             calciumStep(ii) = max(search_peakONtogrey(ii,:)) - max(baselineONtogrey(ii,:));
%         else
%             calciumStep(ii) = max(search_peak(ii,:)) - max(baseline(ii,:));
%         end
% 
%     end

    for ii = 1:not_NaN_flies

            calciumStep(ii) = max(search_peak(ii,:)) - min(baseline(ii,:));
    end
        
    
    all_steps_all_means_flies(:,kk) = calciumStep; %use this for statistics!
    
    mean_calcium(kk) = mean(calciumStep);

    err_calcium(kk) = std(calciumStep,'omitnan')/sqrt(length(calciumStep));


end

% Plot ALL steps-------------------------------------------------
bar_all = figure;
grid on;

% Plot the data only for OFF steps
y1 = mean_calcium(off_step);
x1 = find(off_step);
e1 = err_calcium(off_step);

hold on;
% bar(x1,y1,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.0);
bar(x1,y1,'FaceColor',[0 1 1]);
errorbar(x1,y1,e1,'rx');

% % Plot the data only for ON steps
% y2 = mean_calcium(on_step); %ks
% x2 = find(on_step);
% e2 = err_calcium(on_step);

% bar(x2,y2,'FaceColor',[.5 .5 0],'EdgeColor',[.9 .9 0],'LineWidth',1.0);
% bar(x2,y2,'FaceColor',[1 0 1]);
% legend({'grey --> OFF','Error','ON --> grey'},'Location','northwest');
legend({'grey --> OFF','Error'},'Location','northwest');
% errorbar(x2,y2,e2,'rx');
ylim([0 3.0]); %abs 
% ylim([-0.5 2.5]) %no abs

title('max response');

% Add titles
ax = gca;
% ax.XTick = 1:length(on_step);
ax.XTickLabels = {'grey --> 100% OFF'};
ax.XTickLabelRotation = 45;
ylabel('max (OFF) peak') ;

hold off;


%% ANOVA
a = Tm9control(:,1)
b = L1shits(:,1)
c = L2shits(:,1)
d = L3shits(:,1)
e = L1L3shits(:,1)
f = L2L3shits(:,1)

A=nan(15,6);
A(1:length(a),1)=a;
A(1:length(b),2)=b;
A(1:length(c),3)=c;
A(1:length(d),4)=d;
A(1:length(e),5)=e;
A(1:length(f),6)=f;


[p,tbl,stats] = anova1(A);



%For single silenced ones
B = nan(15,4);
B(1:length(a),1)=a;
B(1:length(b),2)=b;
B(1:length(c),3)=c;
B(1:length(d),4)=d;
[p,tbl,stats] = anova1(B);


%I actually have to do the unpaired two-tailed Student?s t test

% Tm9control = Tm9control(:,1);
Tm9control = L3shits(:,1);
shits = L2L3shits(:,1);

[h,p,ci,stats] = ttest2(Tm9control,shits);
p_step1 = p
h_step1 = h
stats_step1 = stats





%L1 shits: p = 7.5731e-04; L2 shits: p = 0.1015; L3 shits: p = 2.3916e-05;
%L1+L3 shits: p = 1.1768e-09, %L2+L3 shits: p = 1.6465e-05 (compared to the Tm9 control)

%L1+L3 shits: p = 0.1788, %L2+L3 shits: p = 0.6587 (compared to the L3 silenced)




%Mean calcium step control = 1.4530
%Mean calcium step L1shits = 0.7789 -> 46.4% reduction
%Mean calcium step L2shits = 1.1617 -> 20% reduction
%Mean calcium step L3shits = 0.3691 -> 75% reduction
% Mean calcium step L1L3shits = 0.2497 -> 83% reduction compare to control and 32% to L3 shits
%Mean calcium step L2L3shits = 0.3122 -> 79% reduction compare to control and 15% to L3 shits
