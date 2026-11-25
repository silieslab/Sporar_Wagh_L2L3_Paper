%% Analysis_05StepsON_OFF_marvin_plateau_response_ks.m
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

% CONSTANTS

ANALYZE_BY_REGION = false;% weather ROIs should be selected based on their layer in the lobula complex. 

% REGION = 'Lthree';
REGION = 'AT';
% REGION = 'DE';
% REGION = 'AX';
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


% Change this variable to your pData path
pdatapath='T:\Katja Sporar\MATLAB\Katja_pData';
% pdatapath='/Users/ksporar/Documents/MATLAB/Katja_pData';
addpath(pdatapath);
cd(pdatapath);


% % % % Change this variable to your pData path
% % % addpath(genpath('/Users/marvin.seifert/Documents/Marvin'))
% % % pdatapath='/Users/marvin.seifert/Documents/working_data/2p_Data';
% % % addpath(pdatapath);
% % % cd(pdatapath);
% % %Select the Name and Neuron type for the output file
% % %The data for the different steps will be saved independently
% % DataSave = ('L2_LexA_Control');
% % DataSavePath = ('/Users/marvin.seifert/Documents/working_data/FigureData');
% % Dataslash = '/';
wantplot = 1; %If you want plot of step HMH enter 1
% % % For the code
% % % addpath('W:\f.buschendorf\TP_code_Katja');

% fetch Information from Masterfoldersummary
database_select_samples_ks;

%% Processing Data 

% find matching pData files
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_L2_LexA_Control.*~i_moving.*(flyID~=23));
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6F_L221DhhGal4.*~i_moving.*(flyID>=386));
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6F_L3MH56Gal4.*~i_moving);
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_L3MH56Gal4_cross_to_w.*~i_moving.*(flyID>=340));
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_L3MH56Gal4_cross_to_w.*~i_moving);

%for the L3 dendrites - paper
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_L3MH56Gal4_cross_to_w.*~i_moving.*((flyID==965)|(flyID==964)|(flyID==963)|(flyID==961)|(flyID==959)|(flyID==956)));

%for L2 dendrites
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6F_L221DhhGal4_cross_to_w.*~i_moving.*((flyID==939)|(flyID==938)|(flyID==931)|(flyID==930)|(flyID==929)|(flyID==928)|(flyID==927)|(flyID==926)|(flyID==925)));

%for L2 AXONS
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6F_L221DhhGal4_cross_to_w.*~i_moving.*((flyID==932)|(flyID==933)|(flyID==936)|(flyID==937)|(flyID==940)|(flyID==941)|(flyID==942)));

%for L3 AXONS
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_L3MH56Gal4_cross_to_w.*~i_moving.*((flyID==948)|(flyID==949)|(flyID==951)|(flyID==952)|(flyID==953)|(flyID==954)|(flyID==955)|(flyID==957)|(flyID==958)|(flyID==960)|(flyID==962)));

%Plotting just the nice ones
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_L3MH56Gal4_cross_to_w.*~i_moving.*((flyID==344)|(flyID==437)|(flyID==438)|(flyID==443)|(flyID==444)|(flyID==446)));
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_L3MH56Gal4_cross_to_w.*~i_moving.*(flyID==344));


% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*(i_UASGCaMP6F_L3MH56Gal4 | i_UASGCaMP6f_L3MH56Gal4_cross_to_w).*~i_moving); %PAPER!!!

% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*(i_UASGCaMP6F_L3MH56Gal4 | i_UASGCaMP6f_L3MH56Gal4_cross_to_w).*~i_moving.*((flyID==408)|(flyID==409)|(flyID==410)|(flyID==412)|(flyID==413)|(flyID==414)|(flyID==436)|(flyID==437)|(flyID==438)|(flyID==444)|(flyID==445)|(flyID==446)));


% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*(i_UASGCaMP6F_L221DhhGal4 | i_UASGCaMP6F_L221DhhGal4_cross_to_w).*~i_moving.*(flyID~=400)); %paper

% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_L3MH56Gal4_cross_to_w_mars.*~i_moving);


%ND filters
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_L221DhhGal4_06.*~i_moving);
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_L3MH56Gal4_cross_to_w_06.*~i_moving);

% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6F_L3MH56Gal4.*~i_moving.*(flyID>=409));
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6F_L3MH56Gal4_06.*~i_moving.*(flyID>=409));

%shits
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_L3MH56Gal4_UASshits.*~i_moving);
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_L221DhhGal4_UASshits.*~i_moving);


%ort
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_UASort_UASGCaMP6f_L221DhhGal4_ort1_DfBSC809_Helen.*~i_moving.*(flyID~=528));
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_UASort_UASGCaMP6f_L221DhhGal4_ort1_DfBSC809_Helen.*~i_moving);
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_UASort_UASGCaMP6f_L30595Gal4_ort1_DfBSC809.*~i_moving);


%real ort rescue - controls
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_UASort_0595Gal4_ort1_plus.*~i_moving);
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_UASort_L221DhhGal4_ort1_plus_Helen.*~i_moving);
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


%NorpA controls
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_panR8_L2LexA_LexAopGCaMP6f.*~i_moving);
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_rh1NorpA_L2LexA_LexAopGCaMP6f.*~i_moving);

% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_panR8_L3QF_QUAS_GCaMP6f.*~i_moving);
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_rh1NorpA_L3QF_QUAS_GCaMP6f.*~i_moving);


%double ort erscue: L2 ans L3
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASort_UASGCaMP6f_L221DhhGal4_MH56Gal4_ort1_plus.*~i_moving);
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASort_UASGCaMP6f_L221DhhGal4_MH56Gal4_ort1_DfBSC809.*~i_moving);
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_L221DhhGal4_MH56Gal4_ort1_plus_DfBSC809.*~i_moving);



%Matthew Pecot
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_lexAopGCaMP6fp10attp5_16HO3lexA_lexAopmyrtdTOM_11164Gal4_plus.*~i_moving);
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_lexAopGCaMP6fp10attp5_16HO3lexA_lexAopmyrtdTOM_11164Gal4ermHA.*~i_moving);
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_lexAopGCaMP6fp10attp5_16HO3lexA_lexAopmyrtdTOM_11164Gal4_plus.*~i_moving);
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_lexAopGCaMP6fp10attp5_16HO3lexA_lexAopmyrtdTOM_11164Gal4ermHA.*~i_moving);
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_lexAopGCaMP6fp10attp5_16HO3lexA_lexAopmyrtdTOM_plus_plus.*~i_moving);
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_lexAopGCaMP6fp10attp5_16HO3lexA_lexAopmyrtdTOM_plus_plus.*~i_moving);

% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_lexAopGCaMP6fp10attp5_16HO3lexA_lexAopmyrtdTOM_plus_UASerm.*~i_moving);
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_lexAopGCaMP6fp10attp5_16HO3lexA_lexAopmyrtdTOM_11164Gal4ermHA.*~i_moving);


%Matt Pecot
%paper
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_lexAopGCaMP6fp10attp5_16HO3lexA_lexAopmyrtdTOM_plus_UASerm.*~i_moving);
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_lexAopGCaMP6fp10attp5_16HO3lexA_lexAopmyrtdTOM_11164Gal4ermHA.*~i_moving);
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_lexAopGCaMP6fp10attp5_16HO3lexA_lexAopmyrtdTOM_plus_plus.*~i_moving);
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_lexAopGCaMP6fp10attp5_16HO3lexA_lexAopmyrtdTOM_11164Gal4_plus.*~i_moving);





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
        h1 = plot_err_patch_v2(cur_t,m,e,color(ii,:),color(ii,:),'-',0);
        
        xlabel('time (s)');
        ylabel('dF/F - Calcium Signal');
%         ylim([-0.05 0.07]);
        ylim([-1 2]);
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
%% Evaluating the correlations between the same contrast differences - over ROIs
close all;
numROIs = size(crossing_rats,1);
num_steps = size(mean_val,1);
numFlies = length(unique(mTm9LexA.flyID));
% [x,m,e] = mean_cat_full(epochRats,2,cur_ROIs); %m=m
% cat = category (flyID)
% epochRat = max_data



mean_calciumStep = zeros(1,num_steps);
err_calciumStep = zeros(1,num_steps);

calciumStep_all = zeros(numROIs,num_steps);
% Search max-Signal per ROI and take the mean of all max's per ROI signals
for kk=1:num_steps
    
    %ks: defining the time where we look for the baseline
    baseline = crossing_rats(:,kk,round(0.4*end):round(0.5*end)); %8-10s for 2*10s step
    baseline = squeeze(baseline);
    %ks: defining the time where we look for the response
    response = crossing_rats(:,kk,round(0.9*end)+1:round(end)); %10-12s for 2*10s step
    response = squeeze(response);
    
    %test if you're looking for an increase or a decrease in calcium (for each trace):
    decreasingCa = nanmean(baseline,2) - nanmean(response,2) >= 0; %nanmean is the mean of X, computed after removing NaN values
    increasingCa = nanmean(squeeze(baseline),2) - nanmean(squeeze(response),2) < 0;
    
    calciumStep = zeros(numROIs,1);
    for ii = 1:numROIs
        if decreasingCa(ii)
            calciumStep(ii) = min(response(ii,:)) - mean(baseline(ii,:));  %mars: Probably wrong because the min vs. max is not necessary the value we are looking for!?
        elseif increasingCa(ii) %this is necessary, if there are NaNs, both logicals are 0
            calciumStep(ii) = max(response(ii,:)) - mean(baseline(ii,:));  %        
        else
            calciumStep(ii) = NaN;
        end
    end
    
    calciumStep_all(:,kk) = calciumStep;
    % take the mean of all steps
    mean_calciumStep(kk) = nanmean(calciumStep);
    % Standard error
    err_calciumStep(kk) = nanstd(calciumStep)/sqrt(length(calciumStep));
     str = strjoin(titles1(kk));
%     filename = [ DataSavePath, Dataslash, 'ROISave_', num2str(DataSave),str, '.mat' ];
    
    
    
%     save(filename,'calciumStep');   
    
end


% When does the full field get brighter?
% on_step = [1 1 1 0 1 1 1 0 0 1 1 0 0 0 1 0 0 0];
on_step = [1 1 1 1 0 1 1 1 0 0 1 1 0 0 0 1 0 0 0 0]; %ks: 20 steps (added 100% OFF --> 100% ON and 100% ON --> 100% OFF)
on_step = logical(on_step);
off_step = ~ on_step;



OFF100_OFF50 = calciumStep_all(:,1);
OFF100_grey = calciumStep_all(:,2);
OFF100_ON50 = calciumStep_all(:,3);
OFF100_ON100 = calciumStep_all(:,4);
OFF50_OFF100 = calciumStep_all(:,5);
OFF50_grey = calciumStep_all(:,6);
OFF50_ON50 = calciumStep_all(:,7);
OFF50_ON100 = calciumStep_all(:,8);
grey_OFF100 = calciumStep_all(:,9);
grey_OFF50 = calciumStep_all(:,10);
grey_ON50 = calciumStep_all(:,11);
grey_ON100 = calciumStep_all(:,12);
ON50_OFF100 = calciumStep_all(:,13);
ON50_OFF50 = calciumStep_all(:,14);
ON50_grey = calciumStep_all(:,15);
ON50_ON100 = calciumStep_all(:,16);
ON100_OFF100 = calciumStep_all(:,17);
ON100_OFF50 = calciumStep_all(:,18);
ON100_grey = calciumStep_all(:,19);
ON100_ON50 = calciumStep_all(:,20);

%I want to compare:
%OFF50 to OFF100 to:
[h1,p1] = ttest2(OFF50_OFF100,grey_OFF100)
[h2,p2] = ttest2(OFF50_OFF100,ON50_OFF100)
[h3,p3] = ttest2(OFF50_OFF100,ON100_OFF100)

%grey to OFF100 to:
[h4,p4] = ttest2(grey_OFF100,ON50_OFF100)
[h5,p5] = ttest2(grey_OFF100,ON100_OFF100)

%ON50 to OFF100 to:
[h6,p6] = ttest2(ON50_OFF100,ON100_OFF100)

%OFF50 to OFF100 to:
[h7,p7] = ttest2(OFF50_OFF100,ON50_OFF100)

%OFF50 to OFF100 to:
[h8,p8] = ttest2(OFF50_OFF100,ON100_OFF100)

%grey to OFF100 to:
[h9,p9] = ttest2(grey_OFF100,ON100_OFF100)


%%
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
ylim([-1 4]);
% ylim([-0.6 1.9]);
% ylim([-0.9 1.5]);

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
ylabel('dF/F - Calcium Signal');
hold off;

%% Evaluating the correlations between the same contrast differences - over flyIDs
close all;

num_steps = size(mean_val,1);
% [x,m,e] = mean_cat_full(epochRats,2,cur_ROIs); %m=m
% cat = category (flyID)
% epochRat = max_data


numFlies = length(unique(mTm9LexA.flyID));

mean_calciumStep = zeros(1,num_steps);
err_calciumStep = zeros(1,num_steps);
calciumStep_all = nan(numFlies,num_steps);

% Search max-Signal per ROI and take the mean of all max's per ROI signals
for kk=1:num_steps
    
    traces = squeeze(mTm9LexA.rats(negative_correlated,kk,:)); %because mean_cat_full works only with 2 dimensions %taking all ROIs, the epoch we are one, full lenth (200)
    [x,m,e] = mean_cat_full(traces,1,mTm9LexA.flyID(negative_correlated)); %m=mean; e=std

    %ks: defining the time where we look for the baseline
    baseline = x(:,round(0.4*end):round(0.5*end)); %8-10s for 2*10s step
%     baseline = squeeze(baseline);
    %ks: defining the time where we look for the response
%     response = x(:,round(0.8*end)+1:end); %10-12s for 2*10s step
    response = x(:,round(0.9*end)+1:round(end)); %10-12s for 2*10s step
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
%     for ii = 1:numFlies
%         if decreasingCa(ii);
%             calciumStep(ii) = min(response(ii,:)) - mean(baseline(ii,:));
%         elseif increasingCa(ii) %this is necessary, if there are NaNs, both logicals are 0
%             calciumStep(ii) = max(response(ii,:)) - mean(baseline(ii,:));  %        
%         else
%             calciumStep(ii) = NaN;
%         end
%     end
    for ii = 1:numFlies
        if decreasingCa(ii);
            calciumStep(ii) = min(response(ii,:)) - mean(baseline(ii,:));
        elseif increasingCa(ii) %this is necessary, if there are NaNs, both logicals are 0
            calciumStep(ii) = max(response(ii,:)) - mean(baseline(ii,:));  %        
        else
            calciumStep(ii) = NaN;
        end
    end
    
% % % % % % %     %Every step has a different number of flies so I want to pull them all
% % % % % % %     %together - not working
% yet?????????????????????????????????????????????????

        
    calciumStep_all(1:length(calciumStep),kk)=calciumStep;

    % take the mean off all steps
    mean_calciumStep(kk) = nanmean(calciumStep);
    % Standard error
    err_calciumStep(kk) = nanstd(calciumStep)/sqrt(length(calciumStep));
    %Save the Data for analysis
    str = strjoin(titles1(kk));
%     filename = [ DataSavePath,Dataslash,'FlySave_', num2str(DataSave),str, '.mat' ];
      
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
ylim([-4 4]);

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


%% T-test
OFF100_OFF50 = calciumStep_all(:,1);
OFF100_grey = calciumStep_all(:,2);
OFF100_ON50 = calciumStep_all(:,3);
OFF100_ON100 = calciumStep_all(:,4);
OFF50_OFF100 = calciumStep_all(:,5);
OFF50_grey = calciumStep_all(:,6);
OFF50_ON50 = calciumStep_all(:,7);
OFF50_ON100 = calciumStep_all(:,8);
grey_OFF100 = calciumStep_all(:,9);
grey_OFF50 = calciumStep_all(:,10);
grey_ON50 = calciumStep_all(:,11);
grey_ON100 = calciumStep_all(:,12);
ON50_OFF100 = calciumStep_all(:,13);
ON50_OFF50 = calciumStep_all(:,14);
ON50_grey = calciumStep_all(:,15);
ON50_ON100 = calciumStep_all(:,16);
ON100_OFF100 = calciumStep_all(:,17);
ON100_OFF50 = calciumStep_all(:,18);
ON100_grey = calciumStep_all(:,19);
ON100_ON50 = calciumStep_all(:,20);

%I want to compare:
%OFF50 to OFF100 to:
[h1,p1] = ttest2(OFF50_OFF100,grey_OFF100)
[h2,p2] = ttest2(OFF50_OFF100,ON50_OFF100)
[h3,p3] = ttest2(OFF50_OFF100,ON100_OFF100)

%grey to OFF100 to:
[h4,p4] = ttest2(grey_OFF100,ON50_OFF100)
[h5,p5] = ttest2(grey_OFF100,ON100_OFF100)

%ON50 to OFF100 to:
[h6,p6] = ttest2(ON50_OFF100,ON100_OFF100)

%OFF50 to OFF100 to:
[h7,p7] = ttest2(OFF50_OFF100,ON50_OFF100)

%OFF50 to OFF100 to:
[h8,p8] = ttest2(OFF50_OFF100,ON100_OFF100)

%grey to OFF100 to:
[h9,p9] = ttest2(grey_OFF100,ON100_OFF100)


%L3: they are all stitistically not significant!

% p1 =
%     0.8874

% p2 =
%     0.4004

% p3 =
%     0.4269

% p4 =
%     0.2828

% p5 =
%     0.2919

% p6 =
%     0.9003

% p7 =
%     0.4004

% p8 =
%     0.4269

% p9 =
%     0.2919


%for L2: they are all stitistically not significant!

% p1 =
%     0.1727

% p2 =
%     0.3083

% p3 =
%     0.4461

% p4 =
%     0.5900

% p5 =
%     0.6635

% p6 =
%     0.9981

% p7 =
%     0.3083

% p8 =
%     0.4461

% p9 =
%     0.6635

%% Plot by category - 1 Step ---------------------------------------------
two_steps = [0 1 0 0 0 1 0 0 1 0 0 1 0 1 0 0 0 0 1 0 ];
three_steps = [0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 ];
four_steps =  [0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 ]; %ks added
% one_step = ~ two_steps & ~ three_steps;
one_step = ~ two_steps & ~ three_steps & ~ four_steps; %ks added

bar_1 = figure;
grid on;
y1 = mean_calciumStep(off_step & one_step);
%x1 = find(off_step & one_step);
x1 = ([2 6 10 14]);
e1 = err_calciumStep(off_step & one_step);

hold on;
w = 0.5;
bar(x1,y1,w,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.0);
errorbar(x1,y1,e1,'rx');

y2 = mean_calciumStep(find(on_step & one_step));
%x2 = find(on_step & one_step);
x2 = ([3 7 11 15]);
e2 = err_calciumStep(on_step & one_step);

bar(x2,y2,w,'FaceColor',[.5 .5 0],'EdgeColor',[.9 .9 0],'LineWidth',1.0);
errorbar(x2,y2,e2,'rx');
ylim([-1 1]);
% ylim([-0.6 1.9]);
% ylim([-0.9 1.5]);

legend({'OFF Step','Error','ON Ste'},'Location','northwest');
title('One Step - Signal strength');

ax = gca;
ax.XTick = sort([x1, x2]);
ax.XTickLabels = {'-100% -> -50%','-50% -> -100%',...
    '-50% -> GREY ','GREY -> -50%','GREY -> +50%',...
    '+50% -> GREY ','+50% -> +100%',...
    '+100% -> +50%'};
ax.XTickLabelRotation = 45;

hold off;

%% 2 Steps --------------------------------------------------------------
bar_2 = figure;
grid on;
y1 = mean_calciumStep(off_step & two_steps);
x1 = find(off_step & two_steps);
e1 = err_calciumStep(off_step &two_steps);

hold on;
w = 0.5;
bar(x1,y1,w,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.0);
errorbar(x1,y1,e1,'rx');

y2 = mean_calciumStep(find(on_step & two_steps));
x2 = find(on_step & two_steps);
e2 = err_calciumStep(on_step & two_steps);

bar(x2,y2,w,'FaceColor',[.5 .5 0],'EdgeColor',[.9 .9 0],'LineWidth',1.0);
errorbar(x2,y2,e2,'rx');
ylim([-1 1]);
% ylim([-0.6 1.9]);
% ylim([-0.9 1.5]);

legend({'OFF Step','Error','ON Step'},'Location','northwest');
title('Two Steps - Signal strength');

ax = gca;
ax.XTick = sort([x1, x2]);
ax.XTickLabels = {'-100% -> GREY',...
    '-50% -> +50%','GREY -> -100%', ...
     'GREY -> +100%','+50% -> -50%',...
    '+100% -> GREY ',...
    };
ax.XTickLabelRotation = 45;

hold off;
%% 3 Steps --------------------------------------------------------------

bar_3 = figure;
grid on;
y1 = mean_calciumStep(off_step & three_steps);
x1 = find(off_step & three_steps);
e1 = err_calciumStep(off_step & three_steps);

hold on;
w = 0.5;
bar(x1,y1,w,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.0);
errorbar(x1,y1,e1,'rx');

y2 = mean_calciumStep(find(on_step & three_steps));
x2 = find(on_step & three_steps);
e2 = err_calciumStep(on_step & three_steps);

bar(x2,y2,w,'FaceColor',[.5 .5 0],'EdgeColor',[.9 .9 0],'LineWidth',1.0);
errorbar(x2,y2,e2,'rx');
ylim([-0.6 1.5]);
% ylim([-0.6 1.9]);
% ylim([-0.9 1.5]);

legend({'OFF Step','Error','ON Step'},'Location','northwest');

title('Three Steps - Signal strength');

ax = gca;
ax.XTick = sort([x1, x2]);
ax.XTickLabels = {'-100% -> +50%','-50% -> +100%','+50% -> -100%','+100% -> -50%'};
ax.XTickLabelRotation = 45;

hold off;




 %% Normalized Evaluation of the correlations between the same contrast differences - over ROIs
close all;
numROIs = size(crossing_rats,1);
num_steps = size(mean_val,1);
% [x,m,e] = mean_cat_full(epochRats,2,cur_ROIs); %m=m
% cat = category (flyID)
% epochRat = max_data



mean_calciumStep = zeros(1,num_steps);
err_calciumStep = zeros(1,num_steps);



% Search max-Signal per ROI and take the mean of all max's per ROI signalsd
for kk=1:num_steps
    
    %ks: defining the time where we look for the baseline
    baseline = crossing_rats(:,kk,round(0.4*end):round(0.5*end)); %8-10s for 2*10s step
    baseline = squeeze(baseline);
    %ks: defining the time where we look for the response
    response = crossing_rats(:,kk,round(0.9*end)+1:round(end)); %10-12s for 2*10s step
    response = squeeze(response);
    
    %test if you're looking for an increase or a decrease in calcium (for each trace):
    decreasingCa = nanmean(baseline,2) - nanmean(response,2) >= 0; %nanmean is the mean of X, computed after removing NaN values
    increasingCa = nanmean(squeeze(baseline),2) - nanmean(squeeze(response),2) < 0;
    
    calciumStep = zeros(numROIs,1);
    for ii = 1:numROIs
        if decreasingCa(ii)
            calciumStep(ii) =  min(baseline(ii,:)) - mean(response(ii,:));  %mars: Probably wrong because the min vs. max is not necessary the value we are looking for!?
        elseif increasingCa(ii) %this is necessary, if there are NaNs, both logicals are 0
            calciumStep(ii) =  max(baseline(ii,:)) - mean(response(ii,:));  %        
        else
            calciumStep(ii) = NaN;
        end
    end
    
    % take the mean of all steps
    mean_calciumStep(kk) = nanmean(calciumStep);
%     filename = [ DataSavePath, Dataslash, 'ROISaveNormalized', num2str(DataSave), '.mat' ];
%     save(filename,'calciumStep')
    % Standard error
    err_calciumStep(kk) = nanstd(calciumStep)/sqrt(length(calciumStep));
       
    
end


% When does the full field get brighter?
% on_step = [1 1 1 0 1 1 1 0 0 1 1 0 0 0 1 0 0 0];
on_step = [1 1 1 1 0 1 1 1 0 0 1 1 0 0 0 1 0 0 0 0]; %ks: 20 steps (added 100% OFF --> 100% ON and 100% ON --> 100% OFF)
on_step = logical(on_step);
off_step = ~ on_step;


%% Normalization
Norm = min(mean_calciumStep(off_step));
mean_calciumStep(off_step) =(mean_calciumStep(off_step))/Norm;
Norm = max(mean_calciumStep(on_step));
mean_calciumStep(on_step) = -(mean_calciumStep(on_step)/Norm);

%%
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
ylim([-1.5 1.5]);
% ylim([-0.6 1.9]);
% ylim([-0.9 1.5]);

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
ylabel('dF/F - Calcium Signal');
hold off;


if wantplot == 1
%     kk=17;
    kk=1:num_steps
    traces = squeeze(mTm9LexA.rats(negative_correlated,kk,:)); %because mean_cat_full works only with 2 dimensions %taking all ROIs, the epoch we are one, full lenth (200)
    [x,m,e] = mean_cat_full(traces,1,mTm9LexA.flyID(negative_correlated)); %m=mean; e=std
   
    
    
    %ks: defining the time where we look for the baseline
    baseline = x(:,round(0.4*end):round(0.5*end)); %8-10s for 2*10s step
%     baseline = squeeze(baseline);
    %ks: defining the time where we look for the response
    response = x(:,round(0.9*end)+1:round(end)); %10-12s for 2*10s step
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
            calciumStep(ii) = min(response(ii,:)) - mean(baseline(ii,:));
        elseif increasingCa(ii) %this is necessary, if there are NaNs, both logicals are 0
            calciumStep(ii) = max(response(ii,:)) - mean(baseline(ii,:));  %        
        else
            calciumStep(ii) = NaN;
        end
    end
    
    % take the mean off all steps
    mean_calciumStep(kk) = nanmean(calciumStep);
    % Standard error
    err_calciumStep(kk) = nanstd(calciumStep)/sqrt(length(calciumStep));
   
%plot Step 100 - -100    
figure;
for ii=1:size(x,1);
plot(x(ii,:));
hold on
end
    


end




%% Evaluating the correlations between the same contrast differences - over flyIDs
close all;

num_steps = size(mean_val,1);
% [x,m,e] = mean_cat_full(epochRats,2,cur_ROIs); %m=m
% cat = category (flyID)
% epochRat = max_data


numFlies = length(unique(mTm9LexA.flyID));

mean_calciumStep = zeros(1,num_steps);
err_calciumStep = zeros(1,num_steps);



% Search max-Signal per ROI and take the mean of all max's per ROI signals
for kk=1:num_steps
    
    traces = squeeze(mTm9LexA.rats(negative_correlated,kk,:)); %because mean_cat_full works only with 2 dimensions %taking all ROIs, the epoch we are one, full lenth (200)
    [x,m,e] = mean_cat_full(traces,1,mTm9LexA.flyID(negative_correlated)); %m=mean; e=std
   
    
    
    %ks: defining the time where we look for the baseline
    baseline = x(:,round(0.4*end):round(0.5*end)); %8-10s for 2*10s step
%     baseline = squeeze(baseline);
    %ks: defining the time where we look for the response
%     response = x(:,round(0.8*end)+1:end); %10-12s for 2*10s step
    response = x(:,round(0.9*end)+1:round(end)); %10-12s for 2*10s step
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
            calciumStep(ii) = min(response(ii,:)) - mean(baseline(ii,:));
        elseif increasingCa(ii) %this is necessary, if there are NaNs, both logicals are 0
            calciumStep(ii) = max(response(ii,:)) - mean(baseline(ii,:));  %        
        else
            calciumStep(ii) = NaN;
        end
    end
    
%         calciumStep_all(kk,:) = calciumStep; %NOT WORKING!!!!

    
    % take the mean off all steps
    mean_calciumStep(kk) = nanmean(calciumStep);
    % Standard error
    err_calciumStep(kk) = nanstd(calciumStep)/sqrt(length(calciumStep));
    %Save the Data for analysis
    str = strjoin(titles1(kk));
%     filename = [ DataSavePath,Dataslash,'FlySave_', num2str(DataSave),str, '.mat' ];
    
    
    
%     save(filename,'calciumStep');
    
end


% When does the full field get brighter?
on_step = [1 1 1 1 0 1 1 1 0 0 1 1 0 0 0 1 0 0 0 0];
on_step = logical(on_step);
off_step = ~ on_step;

%% Normalization
Norm = max(mean_calciumStep(off_step));
mean_calciumStep(off_step) =(mean_calciumStep(off_step))/Norm;
Norm = min(mean_calciumStep(on_step));
mean_calciumStep(on_step) = -(mean_calciumStep(on_step)/Norm);


%%
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
ylim([-1.5 1.5]);
% ylim([-0.6 1.9]);
% ylim([-0.9 1.5]);

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
ylabel('dF/F - Calcium Signal');
hold off;


calciumStep_all = nan(numFlies,num_steps);

if wantplot == 1
%     kk=17;
kk=1:num_steps
    traces = squeeze(mTm9LexA.rats(negative_correlated,kk,:)); %because mean_cat_full works only with 2 dimensions %taking all ROIs, the epoch we are one, full lenth (200)
    [x,m,e] = mean_cat_full(traces,1,mTm9LexA.flyID(negative_correlated)); %m=mean; e=std
   
    
    
    %ks: defining the time where we look for the baseline
    baseline = x(:,round(0.4*end):round(0.5*end)); %8-10s for 2*10s step
%     baseline = squeeze(baseline);
    %ks: defining the time where we look for the response
    response = x(:,round(0.5*end)+1:round(0.6*end)); %10-12s for 2*10s step
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
            calciumStep(ii) = min(response(ii,:)) - mean(baseline(ii,:));
        elseif increasingCa(ii) %this is necessary, if there are NaNs, both logicals are 0
            calciumStep(ii) = max(response(ii,:)) - mean(baseline(ii,:));  %        
        else
            calciumStep(ii) = NaN;
        end
    end
    
    calciumStep_all(1:length(calciumStep),kk)=calciumStep;

        
    % take the mean off all steps
    mean_calciumStep(kk) = nanmean(calciumStep);
    % Standard error
    err_calciumStep(kk) = nanstd(calciumStep)/sqrt(length(calciumStep));
   
%plot Step 100 - -100    
figure;
for ii=1:size(x,1);
plot(x(ii,:));
hold on
end
end

% T-test for normalized flyIDs
OFF100_OFF50 = calciumStep_all(:,1);
OFF100_grey = calciumStep_all(:,2);
OFF100_ON50 = calciumStep_all(:,3);
OFF100_ON100 = calciumStep_all(:,4);
OFF50_OFF100 = calciumStep_all(:,5);
OFF50_grey = calciumStep_all(:,6);
OFF50_ON50 = calciumStep_all(:,7);
OFF50_ON100 = calciumStep_all(:,8);
grey_OFF100 = calciumStep_all(:,9);
grey_OFF50 = calciumStep_all(:,10);
grey_ON50 = calciumStep_all(:,11);
grey_ON100 = calciumStep_all(:,12);
ON50_OFF100 = calciumStep_all(:,13);
ON50_OFF50 = calciumStep_all(:,14);
ON50_grey = calciumStep_all(:,15);
ON50_ON100 = calciumStep_all(:,16);
ON100_OFF100 = calciumStep_all(:,17);
ON100_OFF50 = calciumStep_all(:,18);
ON100_grey = calciumStep_all(:,19);
ON100_ON50 = calciumStep_all(:,20);

%I want to compare:
%OFF50 to OFF100 to:
[h1,p1] = ttest2(OFF50_OFF100,grey_OFF100)
[h2,p2] = ttest2(OFF50_OFF100,ON50_OFF100)
[h3,p3] = ttest2(OFF50_OFF100,ON100_OFF100)

%grey to OFF100 to:
[h4,p4] = ttest2(grey_OFF100,ON50_OFF100)
[h5,p5] = ttest2(grey_OFF100,ON100_OFF100)

%ON50 to OFF100 to:
[h6,p6] = ttest2(ON50_OFF100,ON100_OFF100)

%OFF50 to OFF100 to:
[h7,p7] = ttest2(OFF50_OFF100,ON50_OFF100)

%OFF50 to OFF100 to:
[h8,p8] = ttest2(OFF50_OFF100,ON100_OFF100)

%grey to OFF100 to:
[h9,p9] = ttest2(grey_OFF100,ON100_OFF100)




%% Is there a statistically significant difference between them?
% titles = {'-100% -> -50%','-100% -> GREY','-100% -> +50%','100% OFF -> 100% On','-50% -> -100%', '-50% -> GREY','-50% -> +50%',...
%     '-50% -> +100% ','GREY -> -100%','GREY -> -50%' ,'GREY -> +50%', ...
%     'GREY -> +100%','+50 -> -100%', '+50% -> -50%','+50% -> GREY',...
%     '+50% -> +100%','100% ON --> 100% OFF','+100% -> -50% ','+100% -> GREY ',...
%     '+100% -> +50%'};


OFF100_OFF50 = calciumStep_all(:,1);
OFF100_grey = calciumStep_all(:,2);
OFF100_ON50 = calciumStep_all(:,3);
OFF100_ON100 = calciumStep_all(:,4);
OFF50_OFF100 = calciumStep_all(:,5);
OFF50_grey = calciumStep_all(:,6);
OFF50_ON50 = calciumStep_all(:,7);
OFF50_ON100 = calciumStep_all(:,8);
grey_OFF100 = calciumStep_all(:,9);
grey_OFF50 = calciumStep_all(:,10);
grey_ON50 = calciumStep_all(:,11);
grey_ON100 = calciumStep_all(:,12);
ON50_OFF100 = calciumStep_all(:,13);
ON50_OFF50 = calciumStep_all(:,14);
ON50_grey = calciumStep_all(:,15);
ON50_ON100 = calciumStep_all(:,16);
ON100_OFF100 = calciumStep_all(:,17);
ON100_OFF50 = calciumStep_all(:,18);
ON100_grey = calciumStep_all(:,19);
ON100_ON50 = calciumStep_all(:,20);

%I want to compare:
%OFF50 to OFF100 to:
[h1,p1] = ttest2(OFF50_OFF100,grey_OFF100)
[h2,p2] = ttest2(OFF50_OFF100,ON50_OFF100)
[h3,p3] = ttest2(OFF50_OFF100,ON100_OFF100)

%grey to OFF100 to:
[h4,p4] = ttest2(grey_OFF100,ON50_OFF100)
[h5,p5] = ttest2(grey_OFF100,ON100_OFF100)

%ON50 to OFF100 to:
[h6,p6] = ttest2(ON50_OFF100,ON100_OFF100)

%OFF50 to OFF100 to:
[h7,p7] = ttest2(OFF50_OFF100,ON50_OFF100)

%OFF50 to OFF100 to:
[h8,p8] = ttest2(OFF50_OFF100,ON100_OFF100)

%grey to OFF100 to:
[h9,p9] = ttest2(grey_OFF100,ON100_OFF100)




%% End at a certain luminance (by katja)--------------------------------------------------------------

close all;

num_steps = size(mean_val,1);
% [x,m,e] = mean_cat_full(epochRats,2,cur_ROIs); %m=m
% cat = category (flyID)
% epochRat = max_data

numROIs = size(crossing_rats,1);

mean_calcium = zeros(1,num_steps);
err_calcium = zeros(1,num_steps);


% Search max-Signal per ROI and take the mean of all max's per ROI signals
for kk=1:num_steps
    %ks: defining the time where we look for the end calcium response
%     mean_response = crossing_rats(:,kk,end/2:round(end*0.6)); 
%     mean_response = crossing_rats(:,kk,round(0.5*end):end); 
    mean_response = crossing_rats(:,kk,round(0.8*end):end); 
    mean_response = squeeze(mean_response);

    calcium = nanmean(mean_response,2) %nanmean is the mean of X, computed after removing NaN values
    
    % take the mean of all steps
    mean_calcium(kk) = mean(calcium,'omitnan');
    % Standard error
    err_calcium(kk) = std(calcium,'omitnan')/sqrt(length(calcium))
       
    
end



OFF_100 = [0 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0];
OFF_50 = [1 0 0 0 0 0 0 0 0 1 0 0 0 1 0 0 0 1 0 0];
grey = [0 1 0 0 0 1 0 0 0 0 0 0 0 0 1 0 0 0 1 0]; 
ON_50 = [0 0 1 0 0 0 1 0 0 0 1 0 0 0 0 0 0 0 0 1];
ON_100 = [0 0 0 1 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0 0];
OFF_100 = logical(OFF_100);
OFF_50 = logical(OFF_50);
grey = logical(grey);
ON_50 = logical(ON_50);
ON_100 = logical(ON_100);

THRESHOLD = 0;
fprintf('THRESHOLD for Signal sum: %d \n',THRESHOLD );

% take a mean of all assigned values, ignore 0
crossing_rats = mTm9LexA.rats;
crossing_rats(crossing_rats==0) = NaN;

% Mean over all ROI's
mean_val = squeeze(mean(crossing_rats,1,'omitnan'));

plots = size(mTm9LexA.rats,2);
titles = {'100% OFF --> 50% OFF';'100% OFF --> GREY'; '100% OFF --> 50% ON';'100% OFF --> 100% ON';'50% OFF --> 100% OFF';...
    '50% OFF --> GREY ';'50% OFF --> 50% ON';'50% OFF --> 100% ON' ;'GREY --> 100% OFF'; ...
    'GREY --> 50% OFF ';' GREY --> 50% ON'; ' GREY --> 100% ON ';'50% ON --> 100% OFF';'50% ON --> 50% OFF';...
    ' 50% ON --> GREY ';'50% ON --> 100% ON ';'100% ON --> 100% OFF';'100% ON --> 50% OFF';' 100% ON --> GREY ';...
    ' 100% ON --> 50% ON'};

% Watch over 20 seconds period
cur_t = linspace(0,20,length(mean_val(1,:)))';


bar_1 = figure;
grid on;
y1 = mean_calcium(OFF_100);
x1 = find(OFF_100);
e1 = err_calcium(OFF_100);

hold on;
w = 0.5;
bar(x1,y1,w,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.0);
errorbar(x1,y1,e1,'rx');




y2 = mean_calcium(find(OFF_50));
x2 = find(OFF_50);
e2 = err_calcium(OFF_50);

bar(x2,y2,w,'FaceColor',[.5 .5 0],'EdgeColor',[.9 .9 0],'LineWidth',1.0);
errorbar(x2,y2,e2,'rx');
ylim([-0.6 1]);



y3= mean_calcium(find(grey));
x3 = find(grey);
e3 = err_calcium(grey);

bar(x3,y3,w,'FaceColor',[.1 .5 0],'EdgeColor',[.2 .9 .9],'LineWidth',1.0);
errorbar(x3,y3,e3,'rx');
ylim([-0.6 1]);




y4= mean_calcium(find(ON_50));
x4 = find(ON_50);
e4 = err_calcium(ON_50);

bar(x4,y4,w,'FaceColor',[.8 .5 0],'EdgeColor',[.7 .9 .9],'LineWidth',1.0);
errorbar(x4,y4,e4,'rx');
ylim([-0.6 1]);



y5= mean_calcium(find(ON_100));
x5 = find(ON_100);
e5 = err_calcium(ON_100);

bar(x5,y5,w,'FaceColor',[.9 .8 0],'EdgeColor',[.9 .9 .9],'LineWidth',1.0);
errorbar(x5,y5,e5,'rx');
ylim([-0.6 1]);


legend({'OFF_100','OFF_50','grey','ON_50','ON_100'},'Location','northwest');%???
title('max response - coming to the same luminance');

ax = gca;
ax.XTick = sort([x1, x2, x3, x4, x5]);
ax.XTickLabels = {'OFF_100','OFF_50','grey','ON_50','ON_100'};
ax.XTickLabelRotation = 45;

hold off;

figure
plot(contrast, means_all,'k','Linewidth',4)
box off
ylim([-0.5 1]);
% xlim([-100:50:100])

%% End at certain luminance (by fabiola) (let Katja's part run before, for now)----------

bar_2 = figure;
hold on;

% Take the mean of the mean here, I think that's okay
% First mean: Over ROIs, Second mean: over 

mean_calcium_OFF_100 = mean(y1);
mean_calcium_OFF_50 = mean(y2);
mean_calcium_grey = mean(y3);
mean_calcium_ON_50 = mean(y4);
mean_calcium_ON_100 = mean(y5);

error_calcium_OFF_100 = mean(e1);
error_calcium_OFF_50 = mean(e2);
error_calcium_grey = mean(e3);
error_calcium_ON_50 = mean(e4);
error_calcium_ON_100 = mean(e5);

bar(1,mean_calcium_OFF_100,w,'FaceColor',[0 .5 .5],'EdgeColor',[.9 .9 .9],'LineWidth',1.0);
errorbar(1,mean_calcium_OFF_100,error_calcium_OFF_100,'rx');

bar(2,mean_calcium_OFF_50,w,'FaceColor',[.5 .5 0],'EdgeColor',[.9 .9 .9],'LineWidth',1.0);
errorbar(2,mean_calcium_OFF_50,error_calcium_OFF_50,'rx');

bar(3,mean_calcium_grey,w,'FaceColor',[.1 .5 0],'EdgeColor',[.9 .9 .9],'LineWidth',1.0);
errorbar(3,mean_calcium_grey,error_calcium_grey,'rx');

bar(4,mean_calcium_ON_50,w,'FaceColor',[.8 .5 0],'EdgeColor',[.9 .9 .9],'LineWidth',1.0);
errorbar(4,mean_calcium_ON_50,error_calcium_ON_50,'rx');

bar(5,mean_calcium_ON_100,w,'FaceColor',[.9 .8 0],'EdgeColor',[.9 .9 .9],'LineWidth',1.0);
errorbar(5,mean_calcium_ON_100,error_calcium_ON_100,'rx');


title('max response - coming to the same luminance');


ax = gca;
ax.XTick = 1:5;
ax.XTickLabels = {'OFF 100%','OFF 50%','grey','ON 50%','ON 100%'};
ax.XTickLabelRotation = 45;


means_all = [mean_calcium_OFF_100 mean_calcium_OFF_50 mean_calcium_grey mean_calcium_ON_50 mean_calcium_ON_100];
%contrast = [-100 -50 0 +50 +100]


% plot(1:5, means_all,'k','Linewidth',4) - this is just a line connecting the peaks
box off
% ylim([-0.5 2.0]); %for L2
% ylim([-0.5 3.0]);
ylim([-0.5 4.0]);
% ylim([-0.5 0.5]); %for L2 ort, L2 NorpA

%ks: fitting an exponential functionf
ax = gca;
ax.FontSize = 20;
set(gca, ...
 'Box'         , 'off'     , ...
 'TickDir'     , 'out'     , ...
 'TickLength'  , [.02 .02] , ...
 'XMinorTick'  , 'on'      , ...
 'YMinorTick'  , 'on'      , ...
 'YGrid'       , 'on'      , ...
 'XColor'      , [.2 .2 .2], ...
 'YColor'      , [.2 .2 .2], ...
 'YTick'       , -0.5:0.5:3, ...
 'LineWidth'   , 1         );
hold on;

[fitresult,gof,h] = createFitFFF (1:5,means_all);
set(h, 'LineWidth', 2,...
   'Color'       , 'k');
ylabel ('df/F(maximal luminance)');
text(4.5,0.1,[num2str(fitresult.a),'exp^(',num2str(fitresult.b),'*x)']);


% ylim([-0.5 4.0]);
hold off;

%% Playing
a = [12 234 3456 23 45 23 45 33] %8
b = [5 8 46 4567 3 3 45 578 765 23 11 12 13 14 15]; %15
c = [11 212 31 41 15]; %5

d = [12 234 3456 23 45 23 45 33] %8

e = [1 23 345 2 4 2 4 3] %8

f = [2 34 456 3 5 3 5 3] %8


znj = [d; e; f];

znj = [d' e' f']


bleh = zeros(3,length(b)); %3 rows, 15 columns
for kk = a2
    bleh = a2(1:length(a2))
end











