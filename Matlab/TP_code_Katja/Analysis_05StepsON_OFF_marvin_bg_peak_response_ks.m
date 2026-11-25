%% Analysis_05StepsON_OFF_marvin.m
% This script analyses Data from the Stimulus "LocalCircle_0.5steps_10s_randSteps_120deg_0degAz_0degEl_2Lum".
% It has 5 Epochs which vary in luminance (100% ON, 50% ON, grey, 50%OFF,100%OFF). 
% These Epochs are displayed one for 10 seconds, then switched randomly to 
% any other Epoch. Contrast difference between a (100 ON - 50 ON) and a 
% (grey - 50 OFF) switch might be the same and this is the question which 
% shall be examined here. Epochs are displayed randomly.
%
%
% Fabiola 8/2016
%
% The epochs are distributed as:
% 
% 0 : 100% OFF
% 1 : 50% OFF
% 2 : GREY
% 3 : 50% ON
% 4 : 100% ON

clear all;
close all;
clc;



%% CONSTANTS

ANALYZE_BY_REGION = true;% weather ROIs should be selected based on their layer in the lobula complex. 

% REGION = 'Lthree';
REGION = 'AT';
% REGION = 'Ltwo';

% AT=axon terminals; AX=axons; CB=cell bodies; DE=dendrites
% this region info is stored as a string in the variable 'layer'in the MASTER excel spreadsheet

if(ANALYZE_BY_REGION)

    GENOTYPE_STRING = ['L2 & L3 ort rescue, region: ' REGION];


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


pdatapath='/Users/ksporar/Documents/MATLAB/Katja_pData';
addpath(pdatapath);
% cd(pdatapath);
try
    cd(pdatapath);
catch error1
    error('Katja''s pData path not accesible')
end

% Run database 
database_select_samples_ks;

wantplot = 1; %If you want plot of step HMH enter 1
%% Processing Data 

% find matching pData files
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_L2_LexA_Control.*~i_moving.*(flyID~=23));
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6F_L221DhhGal4.*~i_moving.*(flyID>=386));
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6F_L3MH56Gal4.*~i_moving);
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_L3MH56Gal4_cross_to_w.*~i_moving.*(flyID>=340));
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_L3MH56Gal4_cross_to_w.*~i_moving);

%Plotting just the nice ones
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_L3MH56Gal4_cross_to_w.*~i_moving.*((flyID==344)|(flyID==437)|(flyID==438)|(flyID==443)|(flyID==444)|(flyID==446)));
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_L3MH56Gal4_cross_to_w.*~i_moving.*(flyID==344));

f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*(i_UASGCaMP6F_L221DhhGal4 | i_UASGCaMP6F_L221DhhGal4_cross_to_w).*~i_moving.*(flyID~=400)); %paper

% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*(i_UASGCaMP6F_L3MH56Gal4 | i_UASGCaMP6f_L3MH56Gal4_cross_to_w).*~i_moving); %paper

% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*(i_UASGCaMP6F_L3MH56Gal4 | i_UASGCaMP6f_L3MH56Gal4_cross_to_w).*~i_moving.*((flyID==408)|(flyID==409)|(flyID==410)|(flyID==412)|(flyID==413)|(flyID==414)|(flyID==436)|(flyID==437)|(flyID==438)|(flyID==444)|(flyID==445)|(flyID==446)));

% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_L3MH56Gal4_cross_to_w_mars.*~i_moving);


%ND filters - all flies
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_L221DhhGal4_06.*~i_moving);
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6F_L221DhhGal4_cross_to_w_06.*~i_moving.*(flyID~=400));
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_L3MH56Gal4_cross_to_w_06.*~i_moving);

% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6F_L3MH56Gal4.*~i_moving.*(flyID>=409));
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6F_L3MH56Gal4_06.*~i_moving.*(flyID>=409));

%TAC meeting - using the same flies for no and 0.6 ND filter
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*(i_UASGCaMP6F_L3MH56Gal4_06 | i_UASGCaMP6f_L3MH56Gal4_cross_to_w_06).*~i_moving.*((flyID==409)|(flyID==410)|(flyID==411)|(flyID==412)|(flyID==413)|(flyID==414)|(flyID==415)|(flyID==416)|(flyID==436)|(flyID==437)|(flyID==438)|(flyID==442)|(flyID==443)|(flyID==444)|(flyID==445)|(flyID==446)|(flyID==451)|(flyID==452)|(flyID==453)|(flyID==454)|(flyID==455)|(flyID==456)|(flyID==457)));
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*(i_UASGCaMP6F_L3MH56Gal4 | i_UASGCaMP6f_L3MH56Gal4_cross_to_w).*~i_moving.*((flyID==409)|(flyID==410)|(flyID==411)|(flyID==412)|(flyID==413)|(flyID==414)|(flyID==415)|(flyID==416)|(flyID==436)|(flyID==437)|(flyID==438)|(flyID==442)|(flyID==443)|(flyID==444)|(flyID==445)|(flyID==446)|(flyID==451)|(flyID==452)|(flyID==453)|(flyID==454)|(flyID==455)|(flyID==456)|(flyID==457)));
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_L3MH56Gal4_cross_to_w_noND.*~i_moving);

% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*(i_UASGCaMP6f_L221DhhGal4_06 | i_UASGCaMP6F_L221DhhGal4_cross_to_w_06).*~i_moving.*(flyID~=400));
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*(i_UASGCaMP6F_L221DhhGal4 | i_UASGCaMP6F_L221DhhGal4_cross_to_w).*~i_moving.*(flyID~=400));

%shits
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_L3MH56Gal4_UASshits.*~i_moving);
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_L221DhhGal4_UASshits.*~i_moving);


%ort
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_UASort_UASGCaMP6f_L221DhhGal4_ort1_DfBSC809_Helen.*~i_moving.*(flyID~=528));
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_UASort_UASGCaMP6f_L221DhhGal4_ort1_DfBSC809_Helen.*~i_moving); %paper
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_UASort_UASGCaMP6f_L30595Gal4_ort1_DfBSC809.*~i_moving);  %paper


%real ort rescue - controls
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_UASort_0595Gal4_ort1_plus.*~i_moving);
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_UASort_L221DhhGal4_ort1_plus_Helen.*~i_moving); %paper
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_plus_0595Gal4_ort1_DfBSC809.*~i_moving);
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_plus_L221DhhGal4_ort1_DfBSC809_Helen.*~i_moving);

%UASFlagCFPbrp
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_L3MH56Gal4_UASFlagCFPbrp.*~i_moving);
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6F_L221DhhGal4_UASFlagCFPbrp.*~i_moving);

%ort overexpression
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6F_L221DhhGal4_UASort.*~i_moving);



%NorpA rescues
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_NorpA_Rh1NorpA_L2LexA_LexAopGCaMP6f.*~i_moving);
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_NorpA_Rh1NorpA_L3QF_QUAS_GCaMP6f.*~i_moving);

%Rh6
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_NorpA_Rh6NorpA_L2LexA_LexAopGCaMP6f.*~i_moving);

%NorpA rescues panR8
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_NorpA_panR8NorpA_L2LexA_LexAopGCaMP6f.*~i_moving);
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_NorpA_panR8NorpA_L3QF_QUAS_GCaMP6f.*~i_moving);

%NorpA rescues Rh1 + panR8
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_norpA_rh1_panR8_UASnorpA_L2LexA_LexAopGCaMP6f.*~i_moving);
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_norpA_rh1_panR8_UASnorpA_L3QF_QUAS_GCaMP6f.*~i_moving);

%NorpA controls
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_panR8_L2LexA_LexAopGCaMP6f.*~i_moving);
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_rh1NorpA_L2LexA_LexAopGCaMP6f.*~i_moving);

% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_panR8_L3QF_QUAS_GCaMP6f.*~i_moving);
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_rh1NorpA_L3QF_QUAS_GCaMP6f.*~i_moving);


%double ort erscue: L2 ans L3
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASort_UASGCaMP6f_L221DhhGal4_MH56Gal4_ort1_plus.*~i_moving);
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASort_UASGCaMP6f_L221DhhGal4_MH56Gal4_ort1_DfBSC809.*~i_moving);
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_L221DhhGal4_MH56Gal4_ort1_plus_DfBSC809.*~i_moving);



%paper - Matt
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_lexAopGCaMP6fp10attp5_16HO3lexA_lexAopmyrtdTOM_plus_UASerm.*~i_moving);
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_lexAopGCaMP6fp10attp5_16HO3lexAo_lexAopmyrtdTOM_11164Gal4ermHA.*~i_moving);
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_lexAopGCaMP6fp10attp5_16HO3lexA_lexAopmyrtdTOM_plus_plus.*~i_moving);
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_lexAopGCaMP6fp10attp5_16HO3lexA_lexAopmyrtdTOM_11164Gal4_plus.*~i_moving);


%Matthew Pecot - L3 LOF
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_L3_ermMARCM_LOF.*~i_moving);
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_L3_MARCM_LOF_control.*~i_moving);

%Matthew Pecot - erm RNAi
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_L3MH56Gal4_UASshits_UASermRNAi.*~i_moving);

%ND filters plus LightCrafter current was set to 150 (normally it is 30)
%ND = 0
f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_L221DhhGal4_L2_150_ND0.*~i_moving);
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_MH56Gal4_L3_150_ND0.*~i_moving);

%ND = 0.6
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_L221DhhGal4_L2_150_ND06.*~i_moving);
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_MH56Gal4_L3_150_ND06.*~i_moving);

%ND = 1.3
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_L221DhhGal4_L2_150_ND13.*~i_moving);
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_MH56Gal4_L3_150_ND13.*~i_moving);


%RNAi paper
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_RNAi_Ih_L221DhhGal4_UASGCaMP6f.*~i_moving);
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_RNAi_Ih_MH56Gal4_UASGCaMP6f.*~i_moving);

% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_RNAi_Slob_L221DhhGal4_UASGCaMP6f.*~i_moving);
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_RNAi_Slob_MH56Gal4_UASGCaMP6f.*~i_moving);

% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_RNAi_Shawl_L221DhhGal4_UASGCaMP6f.*~i_moving);
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_RNAi_Shawl_MH56Gal4_UASGCaMP6f.*~i_moving);

% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_RNAi_HCl1_L221DhhGal4_UASGCaMP6f.*~i_moving);
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_RNAi_HCl1_MH56Gal4_UASGCaMP6f.*~i_moving);

% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_RNAi_Ace_L221DhhGal4_UASGCaMP6f.*~i_moving);
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_RNAi_Ace_MH56Gal4_UASGCaMP6f.*~i_moving);

% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_RNAi_btsz_L221DhhGal4_UASGCaMP6f.*~i_moving);
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_RNAi_btsz_MH56Gal4_UASGCaMP6f.*~i_moving);


% create structures by neuron
fTm9LexA = create_neuron_structure_all_ks(f_Tm9LexA);

% load all the data!
xTm9LexA = load_neuron_data10Hz_ks(fTm9LexA,pdatapath);

% This function groups the different interesting epoch combinations in a
% Matrix, stored in combination_storage
mTm9LexA = aggregate_05StepsON_OFF(xTm9LexA); %taking 100ON as a baseline
% mTm9LexA = aggregate_05StepsON_OFF_grey_baseline(xTm9LexA); %taking grey as a baseline


%% Correlation of Cells

numROIs = size(mTm9LexA.rats,1);
% There are 20 epochs which go from 0->1, 0->2 ...
from = [0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4];
to = [1,2,3,4,0,2,3,4,0,1,3,4,0,1,2,4,0,1,2,3];

step = to-from;
step(step<0) = 0; 
on_step = logical(step); 

negative_correlated = zeros(numROIs,1);
positive_correlated = zeros(numROIs,1);

% Check which cells are positively or negatively correlated
for ii=1:numROIs
    roi_rats = squeeze(mTm9LexA.rats(ii,:,:));
    
    % Mean signal over all On Steps or Off Steps
    mean_onStep = nanmean(roi_rats(on_step,:),1);
    mean_offStep = nanmean(roi_rats(~on_step,:),1);
   
    reaction_onStep = nanmean(mean_onStep(100:120))-nanmean(mean_onStep(80:100)); % if <0 then neg. correlated, if >0 then pos. correlated
    reaction_offStep = nanmean(mean_offStep(100:120))-nanmean(mean_offStep(80:100)); % if >0 then neg. correlated, if <0 then pos. correlated 
    
    if reaction_offStep < 0 && reaction_onStep > 0
       % positive correlated
       positive_correlated(ii)=1;
    elseif reaction_offStep > 0 && reaction_onStep < 0
        % negative correlated
        negative_correlated(ii)=1;
    else 
        % weird stuff, better drop this ROI
    end

%      if positive_correlated(ii)
%         figure(ii);
%         hold on
%         plot(mean_onStep);
%         plot(mean_offStep,'g');
%         
%         title(['ROI No ',num2str(ii)])
%         
%         legend('On Step','Off Step')
%         %     % Plot with error bars - just to check Sometimes only 3 steps out of 10
%         %     % possible were recorded
%         %
%         %     %[x,m,e] = mean_cat_full(roi_rats(step,:),1,mTm9LexA.flyID); %m=mean; e=std
%         %     %h1 = plot_err_patch_v2(cur_t,m,e,[0 0 1],[0.8 0.8 1]);
%         hold off
%      end
end

% Array stores 'true' (1) if this ROI is negatively correlated
negative_correlated = logical(negative_correlated);
% Array stores 'true' (1) if this ROI is positively correlated
positive_correlated = logical(positive_correlated);
%% Printing ALL Traces

THRESHOLD = 0;
fprintf('THRESHOLD for Signal sum: %d \n',THRESHOLD );

% take a mean of all assigned values, ignore 0
%crossing_rats = mTm9LexA.rats; % Take all ROIs
crossing_rats = mTm9LexA.rats(negative_correlated,:,:); % Take only negative corelated ROIs
crossing_rats(crossing_rats==0) = NaN;

% Mean over all ROI's
mean_val = squeeze(nanmean(crossing_rats,1));


% Watch over 20 seconds period
cur_t = linspace(0,20,length(mean_val(1,:)))';

plots = size(mTm9LexA.rats,2);
titles = {'-100% -> -50%','-100% -> GREY','-100% -> +50%','100% OFF -> 100% On','-50% -> -100%', '-50% -> GREY','-50% -> +50%',...
    '-50% -> +100% ','GREY -> -100%','GREY -> -50%' ,'GREY -> +50%', ...
    'GREY -> +100%','+50 -> -100%', '+50% -> -50%','+50% -> GREY',...
    '+50% -> +100%','100% ON --> 100% OFF','+100% -> -50% ','+100% -> GREY ',...
    '+100% -> +50%'};
titles1 = {'MHMF','MHG','MHF','MHH','MFMH', 'MFG','MFF',...
    'MFH','GMH','GMF' ,'GF', ...
    'GH','FMH', 'FMF','FG',...
    'FH','HMH','HMF','HG',...
    'HF'};
% Just those which crossed threshold:
% % cur_ROIs = mTm9LexA.flyID;
% cur_mat = crossing_rats;

color = varycolor(20);

for ii = 1:plots
    
    if abs(sum(mean_val(ii,:))) > THRESHOLD
        fprintf('Signal sum %d: %d \n',ii,abs(sum(mean_val(:,ii))));
        figure(ii);
        hold on;
        
        epochRats = squeeze(crossing_rats(:,ii,:));
        [x,m,e] = mean_cat_full(epochRats,1,mTm9LexA.flyID); %m=mean; e=std
        h1 = plot_err_patch_v2(cur_t,m,e,color(ii,:),color(ii,:),'-',0.2);
%         h1 = plot_err_patch_v2(cur_t,m,e,[0 0 1],[0.8 0.8 1]); %ks
        
        xlabel('time (s)');
        ylabel('dF/F - Calcium Signal');
%         ylim([-0.05 0.07]);
        ylim([-1 4]);
        niceaxes;
        title(titles(ii));
        
        legend(h1,sprintf('N = %d ( %d )',size(x,1),size(epochRats,1)),... %ks added
        'location','northeast');
        
        line([0 20],[0 0],'color',[0 0 0]);
        line([0 10 10 20],[0.05 0.05 0.07 0.07],'color',[0 0 0]);
  
%         hold off;
    else
        fprintf('Case %d did not cross THRESHOLD (%s).\n',ii,titles{ii});
    end
end
% %% Evaluating the correlations between the same contrast differences - over ROIs
% close all;
% numROIs = size(crossing_rats,1);
% num_steps = size(mean_val,1);
% numFlies = length(unique(mTm9LexA.flyID));
% % [x,m,e] = mean_cat_full(epochRats,2,cur_ROIs); %m=m
% % cat = category (flyID)
% % epochRat = max_data
% 
% 
% 
% mean_calciumStep = zeros(1,num_steps);
% err_calciumStep = zeros(1,num_steps);
% 
% 
% % Search max-Signal per ROI and take the mean of all max's per ROI signals
% for kk=1:num_steps
%     
%     %ks: defining the time where we look for the baseline
%     baseline = crossing_rats(:,kk,round(0.4*end):round(0.5*end)); %8-10s for 2*10s step
%     baseline = squeeze(baseline);
%     %ks: defining the time where we look for the response
%     response = crossing_rats(:,kk,round(0.9*end)+1:round(end)); %10-12s for 2*10s step
%     response = squeeze(response);
%     
%     %test if you're looking for an increase or a decrease in calcium (for each trace):
%     decreasingCa = nanmean(baseline,2) - nanmean(response,2) >= 0; %nanmean is the mean of X, computed after removing NaN values
%     increasingCa = nanmean(squeeze(baseline),2) - nanmean(squeeze(response),2) < 0;
%     
%     calciumStep = zeros(numROIs,1);
%     for ii = 1:numROIs
%         if decreasingCa(ii)
%             calciumStep(ii) = min(response(ii,:)) - mean(baseline(ii,:));  %mars: Probably wrong because the min vs. max is not necessary the value we are looking for!?
%         elseif increasingCa(ii) %this is necessary, if there are NaNs, both logicals are 0
%             calciumStep(ii) = max(response(ii,:)) - mean(baseline(ii,:));  %        
%         else
%             calciumStep(ii) = NaN;
%         end
%     end
%     
%     
%     % take the mean of all steps
%     mean_calciumStep(kk) = nanmean(calciumStep);
%     % Standard error
%     err_calciumStep(kk) = nanstd(calciumStep)/sqrt(length(calciumStep));
%      str = strjoin(titles1(kk));
% %     filename = [ DataSavePath, Dataslash, 'ROISave_', num2str(DataSave),str, '.mat' ];
%     
%     
%     
% %     save(filename,'calciumStep');   
%     
% end
% 
% 
% % When does the full field get brighter?
% % on_step = [1 1 1 0 1 1 1 0 0 1 1 0 0 0 1 0 0 0];
% on_step = [1 1 1 1 0 1 1 1 0 0 1 1 0 0 0 1 0 0 0 0]; %ks: 20 steps (added 100% OFF --> 100% ON and 100% ON --> 100% OFF)
% on_step = logical(on_step);
% off_step = ~ on_step;
% 
% 
% %%
% % Plot ALL steps-------------------------------------------------
% bar_all = figure;
% grid on;
% 
% % Plot the data only for OFF steps
% y1 = mean_calciumStep(off_step); %ks
% x1 = find(off_step);
% e1 = err_calciumStep(off_step);
% 
% hold on;
% bar(x1,y1,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.0);
% errorbar(x1,y1,e1,'rx');
% 
% % Plot the data only for ON steps
% y2 = mean_calciumStep(on_step); %ks
% x2 = find(on_step);
% e2 = err_calciumStep(on_step);
% 
% bar(x2,y2,'FaceColor',[.5 .5 0],'EdgeColor',[.9 .9 0],'LineWidth',1.0);
% legend({'OFF Step','Error','ON Step'},'Location','northwest');
% errorbar(x2,y2,e2,'rx');
% ylim([-1 4]);
% % ylim([-0.6 1.9]);
% % ylim([-0.9 1.5]);
% 
% title('All Steps - Signal strength');
% 
% % Add titles
% ax = gca;
% ax.XTick = 1:20;
% ax.XTickLabels = {'-100% -> -50%','-100% -> GREY','-100% -> +50%','100% OFF -> 100% On','-50% -> -100%', '-50% -> GREY','-50% -> +50%',...
%     '-50% -> +100% ','GREY -> -100%','GREY -> -50%' ,'GREY -> +50%', ...
%     'GREY -> +100%','+50 -> -100%', '+50% -> -50%','+50% -> GREY',...
%     '+50% -> +100%','100% ON --> 100% OFF','+100% -> -50% ','+100% -> GREY ',...
%     '+100% -> +50%'};
% ax.XTickLabelRotation = 45;
% ylabel('dF/F - Calcium Signal');
% hold off;

%% Evaluating the correlations between the same contrast differences - over flyIDs
% BG: Changed it to plot plateaue compared to baseline and not the previous
% step. Also changed calculation of SEM so that the flies that are NaN are
% not included in the division.

close all;

num_steps = size(mean_val,1);
% [x,m,e] = mean_cat_full(epochRats,2,cur_ROIs); %m=m
% cat = category (flyID)
% epochRat = max_data


numFlies = length(unique(mTm9LexA.flyID));

mean_calciumStep = zeros(1,num_steps);
err_calciumStep = zeros(1,num_steps);
all_step_samples = {};


% Search max-Signal per ROI and take the mean of all max's per ROI signals
for kk=1:num_steps
    
    traces = squeeze(mTm9LexA.rats(negative_correlated,kk,:)); %because mean_cat_full works only with 2 dimensions %taking all ROIs, the epoch we are one, full lenth (200)
    [x,m,e] = mean_cat_full(traces,1,mTm9LexA.flyID(negative_correlated)); %m=mean; e=std
   
    
    
    %ks: defining the time where we look for the baseline
    baseline = x(:,round(0.4*end):round(0.5*end)); %8-10s for 2*10s step
%     baseline = squeeze(baseline);
    %ks: defining the time where we look for the response
%     response = x(:,round(0.8*end)+1:end); %10-12s for 2*10s step
    response = x(:,round(0.5*end)+1:round(0.6*end)); %18-20s for 2*10s step
%     response = squeeze(response);
    
    %test if you're looking for an increase or an decrease in calcium (for each trace):
    %decreasingCa=zeros(numFlies,1); 
    %increasingCa=zeros(numFlies,1);

    decreasingCa = nanmean(baseline,2) - nanmean(response,2) >= 0; %nanmean is the mean of X, computed after removing NaN values
    increasingCa = nanmean(squeeze(baseline),2) - nanmean(squeeze(response),2) < 0;
    
    %for pp=1:length(decreasingCaI)
    %   decreasingCa(pp)= decreasingCaI(pp);
    %   increasingCa(pp)= increasingCaI(pp);
   % end
    numFlies=size(x,1);%mars Added to prevent crash when number of flies does not equal number of Ca. traces. 
    calciumStep = zeros(numFlies,1);
    for ii = 1:numFlies
        if decreasingCa(ii);
            calciumStep(ii) = mean(response(ii,:));
        elseif increasingCa(ii) %this is necessary, if there are NaNs, both logicals are 0
            calciumStep(ii) = mean(response(ii,:));  %        
        else
            calciumStep(ii) = NaN;
        end
    end
    
% % %     calciumStep_all(:,kk) = calciumStep;
    
    % take the mean off all steps
    mean_calciumStep(kk) = nanmean(calciumStep);
    % Standard error
    err_calciumStep(kk) = nanstd(calciumStep)/sqrt(length(~isnan(calciumStep)));
    %Save the Data for analysis
    str = strjoin(titles1(kk));
%     filename = [ DataSavePath,Dataslash,'FlySave_', num2str(DataSave),str, '.mat' ];
    
    all_step_samples{kk} = calciumStep;
    
%     save(filename,'calciumStep');
    
end


% When does the full field get brighter?
on_step = [1 1 1 1 0 1 1 1 0 0 1 1 0 0 0 1 0 0 0 0];
on_step = logical(on_step);
off_step = ~ on_step;



% Plot ALL steps-------------------------------------------------
bar_all = figure;
grid on;

% Plot the data only for OFF steps
y1 = mean_calciumStep(off_step); %ks
x1 = find(off_step);
e1 = err_calciumStep(off_step);

hold on;
bar(x1,y1,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.0);
errorbar(x1,y1,e1,'rx');

% Plot the data only for ON steps
y2 = mean_calciumStep(on_step); %ks
x2 = find(on_step);
e2 = err_calciumStep(on_step);

bar(x2,y2,'FaceColor',[.5 .5 0],'EdgeColor',[.9 .9 0],'LineWidth',1.0);
legend({'OFF Step','Error','ON Step'},'Location','northwest');
errorbar(x2,y2,e2,'rx');
ylim([-0.5 5.5]);
% ylim([-0.5 3.5]);
% ylim([-0.5 1.5]);

title('All Steps - Signal strength');

% Add titles
ax = gca;
ax.XTick = 1:20;
ax.XTickLabels = {'-100% -> -50%','-100% -> GREY','-100% -> +50%','100% OFF -> 100% On','-50% -> -100%', '-50% -> GREY','-50% -> +50%',...
    '-50% -> +100% ','GREY -> -100%','GREY -> -50%' ,'GREY -> +50%', ...
    'GREY -> +100%','+50 -> -100%', '+50% -> -50%','+50% -> GREY',...
    '+50% -> +100%','100% ON --> 100% OFF','+100% -> -50% ','+100% -> GREY ',...
    '+100% -> +50%'};
ax.XTickLabelRotation = 45;

hold off;

%% End at a certain luminance (by katja)--------------------------------------------------------------
% BG: Changed it to plot fly means and errors
close all;

num_steps = size(mean_val,1);
% [x,m,e] = mean_cat_full(epochRats,2,cur_ROIs); %m=m
% cat = category (flyID)
% epochRat = max_data

numROIs = size(crossing_rats,1);

mean_calcium = zeros(1,num_steps);
err_calcium = zeros(1,num_steps);

ON100_grey = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0];
ON50_50OFF = [0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0];
grey_100OFF = [0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0];

steps_50percent = [0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 0];


ON100_grey = logical(ON100_grey);
ON50_50OFF = logical(ON50_50OFF);
grey_100OFF = logical(grey_100OFF);

steps_50percent = logical(steps_50percent);



THRESHOLD = 0;
fprintf('THRESHOLD for Signal sum: %d \n',THRESHOLD );

% take a mean of all assigned values, ignore 0
crossing_rats = mTm9LexA.rats;
crossing_rats(crossing_rats==0) = NaN;

% Mean over all ROI's
mean_val = squeeze(mean(crossing_rats,1,'omitnan'));

plots = size(mTm9LexA.rats,2);
titles = {'ON100_grey';'ON50_50OFF'; 'grey_100OFF'};

% Watch over 20 seconds period
cur_t = linspace(0,20,length(mean_val(1,:)))';


bar_1 = figure;
grid on;
y1 = mean_calciumStep(ON100_grey);
x1 = find(ON100_grey);
e1 = err_calciumStep(ON100_grey);

hold on;
w = 0.5;
bar(x1,y1,w,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.0);
errorbar(x1,y1,e1,'rx');



y2 = mean_calciumStep(find(ON50_50OFF));
x2 = find(ON50_50OFF);
e2 = err_calciumStep(ON50_50OFF);

bar(x2,y2,w,'FaceColor',[.5 .5 0],'EdgeColor',[.9 .9 0],'LineWidth',1.0);
errorbar(x2,y2,e2,'rx');
ylim([-0.6 1]);



y3= mean_calciumStep(find(grey_100OFF));
x3 = find(grey_100OFF);
e3 = err_calciumStep(grey_100OFF);

bar(x3,y3,w,'FaceColor',[.1 .5 0],'EdgeColor',[.2 .9 .9],'LineWidth',1.0);
errorbar(x3,y3,e3,'rx');
ylim([-0.6 2]);


y4= mean_calciumStep(find(steps_50percent));
x4 = find(steps_50percent);
e4 = err_calciumStep(steps_50percent);


legend({'ON100_grey','ON50_50OFF','grey_100OFF'},'Location','northwest');%???
title('max response - coming to the same luminance');

ax = gca;
ax.XTick = sort([x1, x2, x3]);
ax.XTickLabels = {'ON100_grey','ON50_50OFF','grey_100OFF'};
ax.XTickLabelRotation = 45;

hold off;
% 
% figure
% plot(contrast, means_all,'k','Linewidth',4)
% box off
% ylim([-0.5 1]);
% xlim([-100:50:100])

%% End at certain luminance (by fabiola) (let Katja's part run before, for now)----------

% bar_2 = figure;
% hold on;
% 
% % Take the mean of the mean here, I think that's okay
% % First mean: Over ROIs, Second mean: over 
% 
% mean_calcium_ON100_grey = mean(y1);
% mean_calcium_ON50_50OFF = mean(y2);
% mean_calcium_grey_100OFF = mean(y3);
% 
% error_calcium_ON100_grey = mean(e1);
% error_calcium_ON50_50OFF = mean(e2);
% error_calcium_grey_100OFF = mean(e3);
% 
% 
% bar(1,mean_calcium_ON100_grey,w,'FaceColor',[0 .5 .5],'EdgeColor',[.9 .9 .9],'LineWidth',1.0);
% errorbar(1,mean_calcium_ON100_grey,error_calcium_ON100_grey,'rx');
% 
% bar(2,mean_calcium_ON50_50OFF,w,'FaceColor',[.5 .5 0],'EdgeColor',[.9 .9 .9],'LineWidth',1.0);
% errorbar(2,mean_calcium_ON50_50OFF,error_calcium_ON50_50OFF,'rx');
% 
% bar(3,mean_calcium_grey_100OFF,w,'FaceColor',[.1 .5 0],'EdgeColor',[.9 .9 .9],'LineWidth',1.0);
% errorbar(3,mean_calcium_grey_100OFF,error_calcium_grey_100OFF,'rx');
% 
% title('max response - coming to the same luminance');
% 
% 
% ax = gca;
% ax.XTick = 1:5;
% ax.XTickLabels = {'ON100_grey','ON50_50OFF','grey_100OFF'};
% ax.XTickLabelRotation = 45;
% 
% 
% means_all = [mean_calcium_ON100_grey mean_calcium_ON50_50OFF mean_calcium_grey_100OFF];
% %contrast = [-100 -50 0 +50 +100]
% 
% 
% % plot(1:5, means_all,'k','Linewidth',4) - this is just a line connecting the peaks
% box off
% % ylim([-0.5 2.0]); %for L2
% ylim([-0.5 4.0]);
% % ylim([-0.5 0.5]); %for L2 ort, L2 NorpA
% 
% %ks: fitting an exponential functionf
% ax = gca;
% ax.FontSize = 20;
% set(gca, ...
%  'Box'         , 'off'     , ...
%  'TickDir'     , 'out'     , ...
%  'TickLength'  , [.02 .02] , ...
%  'XMinorTick'  , 'on'      , ...
%  'YMinorTick'  , 'on'      , ...
%  'YGrid'       , 'on'      , ...
%  'XColor'      , [.2 .2 .2], ...
%  'YColor'      , [.2 .2 .2], ...
%  'YTick'       , -0.5:0.5:4, ...
%  'LineWidth'   , 1         );
% hold on;
% 
% % [fitresult,gof,h] = createFitFFF (1:5,means_all);
% % set(h, 'LineWidth', 2,...
% %    'Color'       , 'k');
% % ylabel ('df/F(baseline)');
% % text(4.5,0.1,[num2str(fitresult.a),'exp^(',num2str(fitresult.b),'*x)']);
% 
% 
% % ylim([-0.5 4.0]);
% hold off;

%% ANOVA by BG - 100% OFF


steps_50percent_all_samples = all_step_samples(steps_50percent);

anovaVector = [];
groupVector = [];

for iAnovaPrep = 1:length(steps_50percent_all_samples)
    anovaVector = [anovaVector steps_50percent_all_samples{iAnovaPrep}'];
    groupVector = [groupVector zeros(length(steps_50percent_all_samples{iAnovaPrep}),1)'+iAnovaPrep];
    
end
 %prepare for ANOVA 


[p,tbl,stats] = anova1(anovaVector,groupVector);

pause
[results,means] = multcompare(stats,'CType','bonferroni')
results(end)



%%


steps_50percent_all_samples_ND06 = all_step_samples(steps_50percent);

anovaVector = [];
groupVector = [];

for iAnovaPrep = 1:length(steps_50percent_all_samples_ND06)
    anovaVector = [anovaVector steps_50percent_all_samples_ND06{iAnovaPrep}'];
    groupVector = [groupVector zeros(length(steps_50percent_all_samples_ND06{iAnovaPrep}),1)'+iAnovaPrep];
    
end
 %prepare for ANOVA 


[p,tbl,stats] = anova1(anovaVector,groupVector);

pause
[results,means] = multcompare(stats,'CType','bonferroni')
results(end)

%%


steps_50percent_all_samples_ND13 = all_step_samples(steps_50percent);

anovaVector = [];
groupVector = [];

for iAnovaPrep = 1:length(steps_50percent_all_samples_ND13)
    anovaVector = [anovaVector steps_50percent_all_samples_ND13{iAnovaPrep}'];
    groupVector = [groupVector zeros(length(steps_50percent_all_samples_ND13{iAnovaPrep}),1)'+iAnovaPrep];
    
end
 %prepare for ANOVA 


[p,tbl,stats] = anova1(anovaVector,groupVector);

pause
[results,means] = multcompare(stats,'CType','bonferroni')
results(end)



