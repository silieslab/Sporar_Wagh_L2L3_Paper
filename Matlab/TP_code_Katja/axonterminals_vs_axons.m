%%% Analyse by different regions of the neuron

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


%Tm9
% f_fff_Tm9LexA  = find(i_fff2s.*i_Tm9LexAGCaMP6F.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff2s.*i_Tm9LexAGCaMP6F_L2L3shits_37C.*~i_moving);
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

%L2 and L3 shits recorded after thesis submission
% f_fff_Tm9LexA  = find(i_fff5s.*i_MH56Gal4_UASGCaMP6f_shits_37_new.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff5s.*i_L221DhhGal4_UASGCaMP6f_shits_37_new.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff5s.*i_MH56Gal4_UASGCaMP6f_shits_new.*~i_moving);
% f_fff_Tm9LexA  = find(i_fff5s.*i_L221DhhGal4_UASGCaMP6f_shits_new.*~i_moving);


% GCaMP3 in mitochondria
f_fff_Tm9LexA  = find(i_fff5s.*i_UASGCaMP6F_L221DhhGal4_UAS4mt_GCaMP3.*~i_moving);



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


%% At wich percent of the response is the plateau?


numFlies = length(unique(mTm9LexA.flyID));

numROIs = size(cur_mat,1);
baseline = cur_mat(:,round(0.61*end):round(0.7*end)); %7.9 - 9.1 s of the 13s trace
response = cur_mat(:,round(0.01*end):round(0.25*end)); %0.13 - 3.25 s of the 13s trace
plateau = cur_mat(:,round(0.31*end):round(0.38*end)); %4 s - 4.9 s of the 13s trace

% TIMEWINDOW = 2:50;
% [peak_max idx_max] = max(cur_mat(TIMEWINDOW));
% peak_max = peak_max;

    for ii = 1:numROIs
        maxresponse(ii) = max(response(ii,:));
        meanbaseline(ii) = mean(baseline(ii,:));
        meanplateau(ii) = mean(plateau(ii,:));
        calciumStep(ii) = max(response(ii,:)) - mean(baseline(ii,:));  %baseline have negative values - I need to make absolute
        calciumStep_Baseline(ii) = max(plateau(ii,:)) - mean(baseline(ii,:));
    end
   
    
mean_calciumStep = nanmean(calciumStep);
err_calciumStep = nanstd(calciumStep)/sqrt(length(calciumStep));

mean_maxresponse = nanmean(maxresponse);
err_maxresponse = nanstd(maxresponse)/sqrt(length(maxresponse));    

mean_meanbaseline = nanmean(meanbaseline);
err_meanbaseline = nanstd(meanbaseline)/sqrt(length(meanbaseline));    

mean_plateau = nanmean(meanplateau);
err_plateau = nanstd(meanplateau)/sqrt(length(meanplateau));   

mean_calciumStep_Baseline = nanmean(calciumStep_Baseline);
err_calciumStep_Baseline = nanstd(calciumStep_Baseline)/sqrt(length(calciumStep_Baseline));   


bar_all = figure;
grid on;

% Plot the data for the STEP
y1 = mean_calciumStep; %ks
x1 = 1;
e1 = err_calciumStep;

hold on;
bar(x1,y1,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.0);
errorbar(x1,y1,e1,'rx');



% Plot the data only for the MAX
y2 = mean_maxresponse; %ks
x2 = 3;
e2 = err_maxresponse;

hold on;
bar(x2,y2,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.0);
errorbar(x2,y2,e2,'rx');





% Plot the data only for the BASELINE
y3 = mean_meanbaseline; %ks
x3 = 5;
e3 = err_meanbaseline;

hold on;
bar(x3,y3,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.0);
errorbar(x3,y3,e3,'rx');





% Plot the data only for the PLATEAU
y4 = mean_plateau; %ks
x4 = 7;
e4 = err_plateau;

hold on;
bar(x4,y4,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.0);
errorbar(x4,y4,e4,'rx');





% Plot the data only for the PLATEAU
y5 = mean_calciumStep_Baseline; %ks
x5 = 9;
e5 = err_calciumStep_Baseline;

hold on;
bar(x5,y5,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.0);
errorbar(x5,y5,e5,'rx');


% At Which percent of the max response do we end at?
% y2: max response
% y4: plateau
plateau_percent = (y4*100) / y2

%taking into on account the calcium signal from before (so the calcium change)
% y1: mean_calciumStep
% y5: mean_calciumStep_Baseline
plateau_percent_from_baseline = (y5*100) / y1


%Plateau for the L3 is at 73.5%
%Plateau for the L2 is at 4.7%






%% Fitting an exponential to the decay

%test
TIMEWINDOW = 2:50; %the window of the time trace in which we're looking for the max response

%Find the max value
[peak_max, idx_max] = max(m_neg(TIMEWINDOW));
peak_max = peak_max;

peakMaxValue = m_neg(idx_max);
peakMaxTime = cur_t(idx_max);


p1 = [peakMaxTime, peakMaxValue];


%Find the min
[peak_min, idx_min] = min(m_neg(TIMEWINDOW));
peak_min = peak_min;

peakMinValue = m_neg(idx_min);
peakMinTime = cur_t(idx_min);

p2 = [peakMinTime, peakMinValue];


figure; hold on
cm=colormap('lines');
% h2 = plot_err_patch_v2(cur_t,mROI_neg,eROI_neg,[0 0.5 0],[0 0.80 0]);
h2 = plot_err_patch_v2(cur_t,mROI_neg,eROI_neg,[0.75 0 0.75],[0.75 0.5 0.75]);
title([gen_str ', neg corr, mean by ROI']);
legend([h2],sprintf([gen_str ', N = %d ( %d )'],size(x_neg,1),size(cur_mat_neg,1)),...
    'location','northeast');
plot(cur_t, (round(mean(mTm9LexA.stims))*0.1)+0.6)
ylim([-0.8 2.0]); %for L2
% ylim([-0.8 1.0]); %for L3
% ylim([-0.5 0.5]); %DE
% line([0 10],[0 0],'color',[0 0 0]); %for 5 s
line([0 4],[0 0],'color',[0 0 0]); %for 2 s
plot(p1(1),p1(2),'Marker','.','Color',[0 0 0],'MarkerSize',20)
plot(p2(1),p2(2),'Marker','.','Color',[0 0 0],'MarkerSize',20)



[fitresult,gof,h] = createFitFFF (cur_t(idx_max:idx_min),m_neg(idx_max:idx_min));
set(h, 'LineWidth', 1,...
   'Color'       , 'k');
ylabel ('df/F(maximal luminance)');
text(4.5,0.4,[num2str(fitresult.a),'exp^(',num2str(fitresult.b),'*x)']);  %  General model Exp1: f(x) = a*exp(b*x)




%% Maybe it is better to check the dt from 100% to 50% of the response
TIMEWINDOW = 1:50;
[peak_max idx_max] = max(m_neg(TIMEWINDOW));
peak_max = peak_max;
hundred_percent_max = peak_max; %100% of the max response
twenty_percent_max = 2*peak_max/10; %20% of the max response

%finding the true datapoint that is closest to 100% and 20% max
diff_20_percent = abs(twenty_percent_max - m_neg(1:idx_max));  %where peak_max lies
diff_100_percent = abs(hundred_percent_max - m_neg(1:idx_max));
[~,idx_20] = min(diff_20_percent);
[~,idx_100] = min(diff_100_percent);
% still find better way to find the (interpolated) time of 10/90% max
closest_value_20 = m_neg(idx_20);
closest_time_20 = cur_t(idx_20);
closest_value_100 = m_neg(idx_100);
closest_time_100 = cur_t(idx_100);


%finding the interpolated time of 10/90% max response
t = cur_t;
p = m_neg;
x = t(1):0.01:t(52); %smaller time windows
interpol_m_neg = interp1(t,p,x);

%calculating time between 100% and 50% response
% time_100to20 = closest_time_20 - closest_time_100;
time_100to20 = closest_time_20 - closest_time_100;


figure; hold on
cm=colormap('lines');
% h2 = plot_err_patch_v2(cur_t,mROI_neg,eROI_neg,[0 0.5 0],[0 0.80 0]);
h2 = plot_err_patch_v2(cur_t,mROI_neg,eROI_neg,[0.75 0 0.75],[0.75 0.5 0.75]);
title([gen_str ', neg corr, mean by ROI']);
legend([h2],sprintf([gen_str ', N = %d ( %d )'],size(x_neg,1),size(cur_mat_neg,1)),...
    'location','northeast');
plot(cur_t, (round(mean(mTm9LexA.stims))*0.1)+0.6)
ylim([-0.8 2.0]); %for L2
% ylim([-0.8 1.0]); %for L3
% ylim([-0.5 0.5]); %DE
% line([0 10],[0 0],'color',[0 0 0]); %for 5 s
line([0 4],[0 0],'color',[0 0 0]); %for 2 s
p1 = [closest_time_100, hundred_percent_max] %should be:  closest (interpolated) time, ten_percent_max
plot(p1(1),p1(2),'Marker','.','Color',[0 0 0],'MarkerSize',20)

p2 = [closest_time_20, twenty_percent_max]
plot(p2(1),p2(2),'Marker','.','Color',[0 0 0],'MarkerSize',20)

line([p1(1),p2(1)], [p1(2),p2(2)])






%% Find the peak (another way)
[pks,locs] = findpeaks(m_neg); % returns a vector with the local maxima (peaks) and returns the indices at which the peaks occur

[pks,locs,w,p] = findpeaks(m_neg,cur_t); %additionally returns the widths of the peaks as the vector w and the prominences of the peaks as the vector p.
[pks,locs,w,p] = findpeaks(m_neg,cur_t,'MinPeakHeight',0.4); %getting rid of the small peak


findpeaks(m_neg,cur_t,'MinPeakDistance',5); %I want only one peak

text(locs+.02,pks,num2str((1:numel(pks))'))


%% dt 10% and 90% of the initial response
TIMEWINDOW = 1:15; %the window of the time trace in which we're looking for the max response
[peak_max idx_max] = max(m_neg(TIMEWINDOW));
ten_percent_max = 1*peak_max/10; %10% of the max response
ninety_percent_max = 9*peak_max/10; %90% of the max response

%finding the true datapoint that is closest to 10 and 90% max
diff_10_percent = abs(ten_percent_max - m_neg(1:idx_max));  %where peak_max lies
diff_90_percent = abs(ninety_percent_max - m_neg(1:idx_max));
[~,idx_10] = min(diff_10_percent)
[~,idx_90] = min(diff_90_percent)
% still find better way to find the (interpolated) time of 10/90% max
closest_value_10 = m_neg(idx_10);
closest_time_10 = cur_t(idx_10);
closest_value_90 = m_neg(idx_90);
closest_time_90 = cur_t(idx_90);

%finding the interpolated time of 10/90% max response

t = cur_t
p = m_neg
x = t(1):0.01:t(52) %smaller time windows
interpol_m_neg = interp1(t,p,x)


%calculating time between 10% and 90% response
time_10to90 = closest_time_90 - closest_time_10;


figure; hold on
cm=colormap('lines');
% h2 = plot_err_patch_v2(cur_t,mROI_neg,eROI_neg,[0 0.5 0],[0 0.80 0]);
h2 = plot_err_patch_v2(cur_t,mROI_neg,eROI_neg,[0.75 0 0.75],[0.75 0.5 0.75]);
title([gen_str ', neg corr, mean by ROI']);
legend([h2],sprintf([gen_str ', N = %d ( %d )'],size(x_neg,1),size(cur_mat_neg,1)),...
    'location','northeast');
plot(cur_t, (round(mean(mTm9LexA.stims))*0.1)+0.6)
ylim([-0.8 2.0]); %for L2
% ylim([-0.8 1.0]); %for L3
% ylim([-0.5 0.5]); %DE
% line([0 10],[0 0],'color',[0 0 0]); %for 5 s
line([0 4],[0 0],'color',[0 0 0]); %for 2 s
p1 = [closest_time_10, ten_percent_max] %should be:  closest (interpolated) time, ten_percent_max
plot(p1(1),p1(2),'Marker','.','Color',[0 0 0],'MarkerSize',20)

p2 = [closest_time_90, ninety_percent_max]
plot(p2(1),p2(2),'Marker','.','Color',[0 0 0],'MarkerSize',20)

line([p1(1),p2(1)], [p1(2),p2(2)])

znj1 = [ten_percent_max closest_time_10]
znj2 = [ninety_percent_max closest_time_90]
str = {'10% to 90% response rise time:', time_10to90};
text(0.3, 1.3, str)



%% dt between 10% and 90% of the initial response

%INTERPOLATION_TIME
t = cur_t
p = m_neg
x = t(1):0.001:t(52) %smaller time windows
interpol_m_neg = interp1(t,p,x, 'linear')

TIMEWINDOW = 1:1401; %the window of the time trace in which we're looking for the max response
[peak_max idx_max] = max(interpol_m_neg(TIMEWINDOW));
ten_percent_max = 10*peak_max/100 %10% of the max response
ninety_percent_max = 90*peak_max/100 %90% of the max response

%finding the true datapoint that is closest to 10 and 90% max
% diff_10_percent = abs(ten_percent_max - interpol_m_neg(1:idx_max));  %where peak_max lies
diff_10_percent = abs(ten_percent_max - interpol_m_neg(1:idx_max))
diff_90_percent = abs(ninety_percent_max - interpol_m_neg(1:idx_max))
[~,idx_10] = min(diff_10_percent)
[~,idx_90] = min(diff_90_percent)
% still find better way to find the (interpolated) time of 10/90% max
closest_value_10 = interpol_m_neg(idx_10);
closest_time_10 = x(idx_10);
closest_value_90 = interpol_m_neg(idx_90);
closest_time_90 = x(idx_90);


%calculating time between 10% and 90% response
time_10to90 = closest_time_90 - closest_time_10;


figure; hold on
cm=colormap('lines');
% h2 = plot_err_patch_v2(cur_t,mROI_neg,eROI_neg,[0 0.5 0],[0 0.80 0]);
h2 = plot_err_patch_v2(cur_t,mROI_neg,eROI_neg,[0.75 0 0.75],[0.75 0.5 0.75]);
title([gen_str ', neg corr, mean by ROI']);
legend([h2],sprintf([gen_str ', N = %d ( %d )'],size(x_neg,1),size(cur_mat_neg,1)),...
    'location','northeast');
plot(cur_t, (round(mean(mTm9LexA.stims))*0.1)+0.6)
ylim([-0.8 2.0]); %for L2
% ylim([-0.8 1.0]); %for L3
% ylim([-0.5 0.5]); %DE
% line([0 10],[0 0],'color',[0 0 0]); %for 5 s
line([0 4],[0 0],'color',[0 0 0]); %for 2 s
p1 = [closest_time_10, ten_percent_max] %should be:  closest (interpolated) time, ten_percent_max
plot(p1(1),p1(2),'Marker','.','Color',[0 0 0],'MarkerSize',20)

p2 = [closest_time_90, ninety_percent_max]
plot(p2(1),p2(2),'Marker','.','Color',[0 0 0],'MarkerSize',20)

line([p1(1),p2(1)], [p1(2),p2(2)])

znj1 = [ten_percent_max closest_time_10]
znj2 = [ninety_percent_max closest_time_90]
str = {'10% to 90% response rise time:', time_10to90};
text(0.3, 1.3, str)


%% dt between 10% and 90% of the initial response - calculating over ROI


delta_ROI = zeros(1,size(cur_mat_neg,1));
for ii = 1:size(cur_mat_neg,1)
    t = cur_t;
    p = cur_mat_neg(ii,:);
    x = t(1):0.001:t(130); %smaller time windows
    interpol_cur_mat_neg = interp1(t,p,x);
    
    
TIMEWINDOW = 1:1401; %the window of the time trace in which we're looking for the max response
[peak_max , idx_max] = max(interpol_cur_mat_neg(TIMEWINDOW));
ten_percent_max = 10*peak_max/100; %10% of the max response
ninety_percent_max = 90*peak_max/100; %90% of the max response

%finding the true datapoint that is closest to 10 and 90% max
% diff_10_percent = abs(ten_percent_max - interpol_m_neg(1:idx_max));  %where peak_max lies
diff_10_percent = abs(ten_percent_max - interpol_cur_mat_neg(1:idx_max));
diff_90_percent = abs(ninety_percent_max - interpol_cur_mat_neg(1:idx_max));
[~,idx_10] = min(diff_10_percent);
[~,idx_90] = min(diff_90_percent);
% still find better way to find the (interpolated) time of 10/90% max
closest_value_10 = interpol_cur_mat_neg(idx_10);
closest_time_10 = x(idx_10);
closest_value_90 = interpol_cur_mat_neg(idx_90);
closest_time_90 = x(idx_90);


%calculating time between 10% and 90% response
time_10to90 = closest_time_90 - closest_time_10;
delta_ROI(ii) = time_10to90;
end


mean_time_10to90 = mean(delta_ROI);
error_time_10to90 = std(delta_ROI)/sqrt(size(delta_ROI,1)); %S.E.M

%%
slobRNAi_mean = mean_time_10to90;
slobRNAi_error = error_time_10to90;
slobRNAi_deltaROI = delta_ROI;
% controlRNAi_mean = mean_time_10to90;
% controlRNAi_error = error_time_10to90;
% control_deltaROI = delta_ROI;

figure; hold on
bar([1:2],[controlRNAi_mean, slobRNAi_mean])
errorbar([1:2],[controlRNAi_mean, slobRNAi_mean], [controlRNAi_error, slobRNAi_error])
[H,P] = ttest2(control_deltaROI, slobRNAi_deltaROI)
xlim([0 3])


%% dt between 10% and 90% of the initial response - calculating over fly


delta_fly = zeros(1,size(m_neg,1));
for ii = 1:size(m_neg,1)
    t = cur_t;
    p = m_neg(ii,:);
    x = t(1):0.001:t(130); %smaller time windows
    interpol_m_neg = interp1(t,p,x);
    
    
TIMEWINDOW = 1:1401; %the window of the time trace in which we're looking for the max response
[peak_max , idx_max] = max(interpol_m_neg(TIMEWINDOW));
ten_percent_max = 10*peak_max/100; %10% of the max response
ninety_percent_max = 90*peak_max/100; %90% of the max response

%finding the true datapoint that is closest to 10 and 90% max
% diff_10_percent = abs(ten_percent_max - interpol_m_neg(1:idx_max));  %where peak_max lies
diff_10_percent = abs(ten_percent_max - interpol_m_neg(1:idx_max));
diff_90_percent = abs(ninety_percent_max - interpol_m_neg(1:idx_max));
[~,idx_10] = min(diff_10_percent);
[~,idx_90] = min(diff_90_percent);
% still find better way to find the (interpolated) time of 10/90% max
closest_value_10 = interpol_m_neg(idx_10);
closest_time_10 = x(idx_10);
closest_value_90 = interpol_m_neg(idx_90);
closest_time_90 = x(idx_90);


%calculating time between 10% and 90% response
time_10to90 = closest_time_90 - closest_time_10;
delta_fly(ii) = time_10to90;
end


mean_time_10to90 = mean(delta_fly);
error_time_10to90 = std(delta_fly)/sqrt(size(delta_fly,1)); %S.E.M

%%
slobRNAi_mean = mean_time_10to90;
slobRNAi_error = error_time_10to90;
slobRNAi_deltafly = delta_fly;
% controlRNAi_mean = mean_time_10to90;
% controlRNAi_error = error_time_10to90;
% control_deltafly = delta_fly;

figure; hold on
bar([1:2],[controlRNAi_mean, slobRNAi_mean])
errorbar([1:2],[controlRNAi_mean, slobRNAi_mean], [controlRNAi_error, slobRNAi_error])
[H,P] = ttest2(control_deltafly, slobRNAi_deltafly)
xlim([0 3])

%%
%***********
% fits
%***********

%for 5s stimulus
%calculating exponential fit
% define the start point for fitting as the maximum of the mean trace
% fitStart = find(m_neg(1:40) == max(m_neg(1:40))); %is 9 and 12 for 2s and
% 5s traces for L2, but meaningless for sustained L3 responses. Hardcode to
% be 10
% FITSTART = 10; fitstart = FITSTART;


tau = zeros(1,size(cur_mat_neg,1));
for ii = 1:size(cur_mat_neg,1)
    fitstart = find(cur_mat_neg(ii,5:20) == max(cur_mat_neg(ii,5:20)))
    fitend = fitstart + 2*iRATE;
    [fitresult, gof] = createFit_ks(cur_t(fitstart:fitend), cur_mat_neg(ii,fitstart:fitend));
    temp = fitresult.b;
    tau(ii) = 1./temp;
    close
end
ATtau_ROImean = tau

%compare to the same fit for the mean of all flies trace
fitstart = find(m_neg(5:20) == max(m_neg(5:20))); %find max of trace between frames 5 and 20 
fitend = fitstart + 2*iRATE; %plus 2s
[fitresult, gof] = createFit_ks(cur_t(fitstart:fitend), m_neg(fitstart:fitend));
temp = fitresult.b;
tau = 1./temp;
close
ATtau_ROIFLYmean = tau

%compare to the same fit for the mean of all flies trace
tau = zeros(1,size(x_neg,1));
for ii = 1:size(x_neg,1)
    [fitresult, gof] = createFit_ks(cur_t(fitstart:fitend), x_neg(ii,fitstart:fitend));
    temp = fitresult.b;
    tau(ii) = 1./temp;
%     close
end
ATtau_FLYmean = tau


%saving as a variable
AXtau = tau
% ATtau=tau
% DEtau=tau

%% Plot responses of the individual flies
close all
a = unique(mTm9LexA.flyID)
for iPlot = 1:size(x_neg,1)
    figure 
    plot(x_neg(iPlot,:))
    ylim([-1 1.0])
    title(sprintf('Fly ID: %d',a (iPlot)))
end



