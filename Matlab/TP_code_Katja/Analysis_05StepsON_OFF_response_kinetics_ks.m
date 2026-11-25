%% Analysis_05StepsON_OFF_response_kinetics_ks.m
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


% pdatapath='/Users/ksporar/Documents/MATLAB/Katja_pData';
pdatapath='T:\Katja Sporar\MATLAB\Katja_pData';
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

% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*(i_UASGCaMP6F_L221DhhGal4 | i_UASGCaMP6F_L221DhhGal4_cross_to_w).*~i_moving.*(flyID~=400)); %paper

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
% f_Tm9LexA  = find(i_fff_05steps_10sONgrayOFF.*i_UASort_UASGCaMP6f_L221DhhGal4_ort1_DfBSC809_Helen.*~i_moving);
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
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_lexAopGCaMP6fp10attp5_16HO3lexA_lexAopmyrtdTOM_11164Gal4ermHA.*~i_moving);
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_lexAopGCaMP6fp10attp5_16HO3lexA_lexAopmyrtdTOM_plus_plus.*~i_moving);
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_lexAopGCaMP6fp10attp5_16HO3lexA_lexAopmyrtdTOM_11164Gal4_plus.*~i_moving);


%Matthew Pecot - L3 LOF
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_L3_ermMARCM_LOF.*~i_moving);
f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_L3_MARCM_LOF_control.*~i_moving);

%Matthew Pecot - erm RNAi
% f_Tm9LexA = find(i_fff_05steps_10sONgrayOFF.*i_UASGCaMP6f_L3MH56Gal4_UASshits_UASermRNAi.*~i_moving);


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
        ylim([-1 3]);
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
    response = x(:,round(0.9*end)+1:round(end)); %18-20s for 2*10s step
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
ylim([-0.5 3]);
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


%%
for kk=1:num_steps
    
    traces = squeeze(mTm9LexA.rats(negative_correlated,kk,:)); %because mean_cat_full works only with 2 dimensions %taking all ROIs, the epoch we are one, full lenth (200)
    [x,m,e] = mean_cat_full(traces,1,mTm9LexA.flyID(negative_correlated)); %m=mean; e=std
    

    
    %ks: defining the time where we look for the baseline
    baseline = x(:,round(0.4*end):round(0.5*end)); %8-10s for 2*10s step
    %ks: defining the time where we look for the response
    response = x(:,round(0.5*end)+1:round(0.6*end)); %10-12s for 2*10s step
    %ks: defining the time where we look for the plateau
    plateau = x(:,round(0.9*end)+1:round(end)); %18-20s for 2*10s step


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
            maxStep(ii) = max(response(ii,:));
            meanBaseline(ii) = mean(baseline(ii,:));
            meanPlateau(ii) = mean(plateau(ii,:));
            calciumStep(ii) = max(response(ii,:)) - mean(baseline(ii,:));
            calciumStep_Baseline(ii) = max(plateau(ii,:)) - mean(baseline(ii,:));
    end
    
    
    mean_calciumStep = nanmean(calciumStep);
    err_calciumStep = nanstd(calciumStep)/sqrt(length(calciumStep));

    mean_maxStep = nanmean(maxStep);
    err_maxStep = nanstd(maxStep)/sqrt(length(maxStep));

    mean_meanBaseline = nanmean(meanBaseline);
    err_meanBaseline = nanstd(meanBaseline)/sqrt(length(meanBaseline));

    mean_meanPlateau = nanmean(meanPlateau);
    err_meanPlateau = nanstd(meanPlateau)/sqrt(length(meanPlateau));

    mean_calciumStep_Baseline = nanmean(calciumStep_Baseline);
    err_calciumStep_Baseline = nanstd(calciumStep_Baseline)/sqrt(length(calciumStep_Baseline));


    % Plot the data for the STEP
    y1 = mean_calciumStep; %ks
    x1 = 1;
    e1 = err_calciumStep;


    % Plot the data only for the MAX
    y2 = mean_maxStep; %ks
    x2 = 3;
    e2 = err_maxStep;


    % Plot the data only for the BASELINE
    y3 = mean_meanBaseline; %ks
    x3 = 5;
    e3 = err_meanBaseline;


    % Plot the data only for the PLATEAU
    y4 = mean_meanPlateau; %ks
    x4 = 7;
    e4 = err_meanPlateau;



    % Plot the data only for the PLATEAU
    y5 = mean_calciumStep_Baseline; %ks
    x5 = 9;
    e5 = err_calciumStep_Baseline;


    % At Which percent of the max response do we end at?
    % y2: max response
    % y4: plateau
    plateau_percent = (y4*100) / y2

    %taking into on account the calcium signal from before (so the calcium change)
    % y1: mean_calciumStep
    % y5: mean_calciumStep_Baseline
    plateau_percent_from_baseline = (y5*100) / y1



end