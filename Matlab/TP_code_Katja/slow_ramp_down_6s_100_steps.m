%% Analysis_05StepsON_OFF_marvin.m
clc;
clear all;
close all;

% CONSTANTS
ANALYZE_BY_REGION = true;% weather ROIs should be selected based on their layer in the lobula complex. 
REGION = 'AT';  % which group or layer of ROIs will be included in this plot
% AT=axon terminals; AX=axons; CB=cell bodies; DE=dendrites
% this region info is stored as a string in the variable 'layer'in the MASTER excel spreadsheet

if(ANALYZE_BY_REGION)
%     GENOTYPE_STRING = ['L2 >> GCaMP6f, region: ' REGION];
    GENOTYPE_STRING = ['L3 >> GCaMP6f, region: ' REGION];
%         GENOTYPE_STRING = ['lexAopGCaMP6fp10attp5 16HO3lexA,lexAopmyrtdTom 11-164Gal4 ermHA, region: ' REGION];
%     GENOTYPE_STRING = ['lexAopGCaMP6fp10attp5 16HO3lexA,lexAopmyrtdTom 11-164Gal4, region: ' REGION];
    if(strcmp(REGION,'AT'))
        COLOR_OF_PLOT = [0 .5 0];% GREEN
        COLOR_CLOUD =[.5 .7 .5];% GREEN
    elseif(strcmp(REGION,'AX'))
        COLOR_OF_PLOT = [1 0 0]; %RED
        COLOR_CLOUD = [1 .5 .5]; %RED cloud
    elseif(strcmp(REGION,'CB'))
        COLOR_OF_PLOT = [.7 .7 0];% YELLOW
        COLOR_CLOUD = [.9 .9 .5];%YELLOW cloud
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
f_Tm9LexA = find(i_slow_ramp_down_6s_100.*i_UASGCaMP6f_L3MH56Gal4_cross_to_w.*~i_moving.*((flyID==2071)|(flyID==2072)|(flyID==2073)|(flyID==2074)|(flyID==2076)|(flyID==2077)|(flyID==2078)));
% f_Tm9LexA  = find(i_slow_ramp_down_6s_100.*i_UASGCaMP6F_L221DhhGal4_cross_to_w.*~i_moving.*((flyID==2079)|(flyID==2080)|(flyID==2081)|(flyID==2082)|(flyID==2083)|(flyID==2084)|(flyID==2085)|(flyID==2086)|(flyID==2087)|(flyID==2088)));

% f_Tm9LexA = find(i_slow_ramp_down_500ms_100.*i_UASGCaMP6f_L3MH56Gal4_cross_to_w.*~i_moving.*((flyID==2047)|(flyID==2048)|(flyID==2049)|(flyID==2071)|(flyID==2072)|(flyID==2073)|(flyID==2074)|(flyID==2076)|(flyID==2077)|(flyID==2078)));
% f_Tm9LexA  = find(i_slow_ramp_down_500ms_100.*i_UASGCaMP6F_L221DhhGal4_cross_to_w.*~i_moving.*((flyID==2079)|(flyID==2080)|(flyID==2081)|(flyID==2082)|(flyID==2083)|(flyID==2084)|(flyID==2085)|(flyID==2086)|(flyID==2087)|(flyID==2088)));



% create structures by neuron
fTm9LexA = create_neuron_structure_all_ks(f_Tm9LexA);

if (ANALYZE_BY_REGION)
    xTm9LexA = load_neuron_data10Hz_byRegion(fTm9LexA,pdatapath, REGION);
else
    % interpolates at 10 Hz now...
    xTm9LexA = load_neuron_data10Hz_ks(fTm9LexA,pdatapath);
end


% This function groups the different interesting epoch combinations in a
% Matrix, stored in combination_storage
mTm9LexA = aggregate_slow_ramp_down_6s_100_steps(xTm9LexA); %taking 100ON as a baseline



%% Correlation
numROIs = size(mTm9LexA.rats,1);
iRATE = 10; %rate at which data are interpolated
% dur = size(mTm9LexA.rats,3);
STEPS = 100; %0 to 99


% start with all the data, keep the ones that are positively correlated
% with stimulus (by value Q)
cur_mat = mTm9LexA.rats-1;
cur_IDs = mTm9LexA.flyID;

cur_t = [1:size(cur_mat,2)]/iRATE;

counter = 0; % starting counter value!


for ii = 1:size(mTm9LexA.rats,2) %100
    epochRats = cur_mat;
    [x,m,e] = mean_cat_full(epochRats,1,cur_IDs); %m=mean; e=std
    
    counter = counter + 1;
    
    stimulus = [1:100];
    
    %positive correlation with stimulus    
    Q = corr(stimulus',epochRats');
%     inds = find(Q>0.1);
%     inds = find(Q>=0.1);
    inds = find(Q>=0);
%     inds = find(Q>0.2);
    cur_mat_pos = epochRats(inds,:);
    cur_IDs_pos = cur_IDs(inds);
    %calculating means across flies
    [x_pos,m_pos,e_pos] = mean_cat_full(cur_mat_pos,1,cur_IDs_pos);
    %calculating the max for each trace
    max_pos = max(x_pos,[],2)-1;


    %negative correlation with stimulus
    Q = corr(stimulus',epochRats');
    inds = find(Q<-0.1);
%     inds = find(Q<-0);
%     inds = find(Q<-0.2);
    size(inds);
    cur_mat_neg = epochRats(inds,:);
    cur_IDs_neg = cur_IDs(inds);
    %calculating means across flies
    [x_neg,m_neg,e_neg] = mean_cat_full(cur_mat_neg,1,cur_IDs_neg);
    max_neg = max(x_neg,[],2)-1;
    
end
    


%% Making a plot with means and errors from all 100 epochs together 

THRESHOLD = 0;
fprintf('THRESHOLD for Signal sum: %d \n',THRESHOLD );

cur_mat = mTm9LexA.rats;
cur_IDs = mTm9LexA.flyID;

%calculating means across flies
[x_neg,m_neg,e_neg] = mean_cat_full(cur_mat_neg,1,cur_IDs_neg);

% When are we going from grey to OFF?
off_step = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];

for kk = 1:size(mTm9LexA.rats,2) %100
    traces = mTm9LexA.rats; %because mean_cat_full works only with 2 dimensions %taking all ROIs, the epoch we are on, full lenth (200)
%     [x,m,e] = mean_cat_full(traces,1,mTm9LexA.flyID); %m=mean; e=std
    [x,m,e] = mean_cat_full(cur_mat_pos,1,cur_IDs_pos); %m=mean; e=std POSITIVE CORR!!!
%     [x,m,e] = mean_cat_full(cur_mat_neg,1,cur_IDs_neg); %m=mean; e=std NEGATIVE CORR!!!

    calciumTrace = x;
    calciumTrace = squeeze(calciumTrace);
        
%     not_NaN_flies = size(x,1); % Fabi: would crash otherwise, we have only 8 flies (not 12) evaluated here !
%     
%     calciumResponse = zeros(not_NaN_flies,1);
%         for ii = 1:not_NaN_flies
%             calciumResponse(ii) = mean(calciumTrace(ii,:));
%         end

%     all_steps_all_means_flies(:,kk) = calciumResponse; %use this for statistics!
%     mean_calcium(kk) = mean(calciumResponse);
% 
%     err_calcium(kk) = std(calciumResponse,'omitnan')/sqrt(length(calciumResponse));

    mean_calciumTrace = mean(calciumTrace);
    err_calcium = std(calciumTrace,'omitnan')/sqrt(length(calciumTrace));
end
 


figure('Name',['All epochs']);
mROI = mean(calciumTrace,'omitnan');
eROI = std(calciumTrace,[],1,'omitnan')/sqrt(size(calciumTrace,1)); %S.E.M


colormap('lines');
plot_err_patch_v2(1:100,mROI,eROI,[0 0 1],[0.5 0.5 1]);


%% Scatter plot
step1 = calciumTrace(:,1); %epoch1
step2 = calciumTrace(:,2); 
step3 = calciumTrace(:,3); 
step4 = calciumTrace(:,4); 
step5 = calciumTrace(:,5); 
step6 = calciumTrace(:,6);
step7 = calciumTrace(:,7); 
step8 = calciumTrace(:,8); 
step9 = calciumTrace(:,9); 
step10 = calciumTrace(:,10);
step11 = calciumTrace(:,11);
step12 = calciumTrace(:,12); 
step13 = calciumTrace(:,13); 
step14 = calciumTrace(:,14); 
step15 = calciumTrace(:,15); 
step16 = calciumTrace(:,16);
step17 = calciumTrace(:,17); 
step18 = calciumTrace(:,18); 
step19 = calciumTrace(:,19); 
step20 = calciumTrace(:,20);
step21 = calciumTrace(:,21);
step22 = calciumTrace(:,22); 
step23 = calciumTrace(:,23); 
step24 = calciumTrace(:,24); 
step25 = calciumTrace(:,25); 
step26 = calciumTrace(:,26);
step27 = calciumTrace(:,27); 
step28 = calciumTrace(:,28); 
step29 = calciumTrace(:,29); 
step30 = calciumTrace(:,30);
step31 = calciumTrace(:,31);
step32 = calciumTrace(:,32); 
step33 = calciumTrace(:,33); 
step34 = calciumTrace(:,34); 
step35 = calciumTrace(:,35); 
step36 = calciumTrace(:,36);
step37 = calciumTrace(:,37); 
step38 = calciumTrace(:,38); 
step39 = calciumTrace(:,39); 
step40 = calciumTrace(:,40);
step41 = calciumTrace(:,41);
step42 = calciumTrace(:,42); 
step43 = calciumTrace(:,43); 
step44 = calciumTrace(:,44); 
step45 = calciumTrace(:,45); 
step46 = calciumTrace(:,46);
step47 = calciumTrace(:,47); 
step48 = calciumTrace(:,48); 
step49 = calciumTrace(:,49); 
step50 = calciumTrace(:,50);
step51 = calciumTrace(:,51);
step52 = calciumTrace(:,52); 
step53 = calciumTrace(:,53); 
step54 = calciumTrace(:,54); 
step55 = calciumTrace(:,55); 
step56 = calciumTrace(:,56);
step57 = calciumTrace(:,57); 
step58 = calciumTrace(:,58); 
step59 = calciumTrace(:,59); 
step60 = calciumTrace(:,60);
step61 = calciumTrace(:,61);
step62 = calciumTrace(:,62); 
step63 = calciumTrace(:,63); 
step64 = calciumTrace(:,64); 
step65 = calciumTrace(:,65); 
step66 = calciumTrace(:,66);
step67 = calciumTrace(:,67); 
step68 = calciumTrace(:,68); 
step69 = calciumTrace(:,69); 
step70 = calciumTrace(:,70);
step71 = calciumTrace(:,71);
step72 = calciumTrace(:,72); 
step73 = calciumTrace(:,73); 
step74 = calciumTrace(:,74); 
step75 = calciumTrace(:,75); 
step76 = calciumTrace(:,76);
step77 = calciumTrace(:,77); 
step78 = calciumTrace(:,78); 
step79 = calciumTrace(:,79); 
step80 = calciumTrace(:,80);
step81 = calciumTrace(:,81);
step82 = calciumTrace(:,82); 
step83 = calciumTrace(:,83); 
step84 = calciumTrace(:,84); 
step85 = calciumTrace(:,85); 
step86 = calciumTrace(:,86);
step87 = calciumTrace(:,87); 
step88 = calciumTrace(:,88); 
step89 = calciumTrace(:,89); 
step90 = calciumTrace(:,90);
step91 = calciumTrace(:,91);
step92 = calciumTrace(:,92); 
step93 = calciumTrace(:,93); 
step94 = calciumTrace(:,94); 
step95 = calciumTrace(:,95); 
step96 = calciumTrace(:,96);
step97 = calciumTrace(:,97); 
step98 = calciumTrace(:,98); 
step99 = calciumTrace(:,99); 
step100 = calciumTrace(:,100);

contrast = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100];

% b = [contrast;contrast;contrast;contrast;contrast;contrast;contrast;contrast;contrast;contrast]; %for L2 6s stimulus
b = [contrast;contrast;contrast;contrast;contrast;contrast;contrast]; %for L2 6s stimulus positive correlation
% b = [contrast;contrast;contrast;contrast;contrast;contrast;contrast;contrast;contrast;contrast]; %for L2 500 ms stimulus

% b = [contrast;contrast;contrast;contrast;contrast;contrast]; %for L3 6s stimulus negative correlation
% b = [contrast;contrast;contrast;contrast;contrast;contrast;contrast]; %for L3 6s stimulus
% b = [contrast;contrast;contrast;contrast;contrast;contrast;contrast;contrast;contrast;contrast]; %for L2 500 ms stimulus

x1 = b(:,1);
x2 = b(:,2);
x3 = b(:,3);
x4 = b(:,4);
x5 = b(:,5);
x6 = b(:,6);
x7 = b(:,7);
x8 = b(:,8);
x9 = b(:,9);
x10 = b(:,10);
x11 = b(:,11);
x12 = b(:,12);
x13 = b(:,13);
x14 = b(:,14);
x15 = b(:,15);
x16 = b(:,16);
x17 = b(:,17);
x18 = b(:,18);
x19 = b(:,19);
x20 = b(:,20);
x21 = b(:,21);
x22 = b(:,22);
x23 = b(:,23);
x24 = b(:,24);
x25 = b(:,25);
x26 = b(:,26);
x27 = b(:,27);
x28 = b(:,28);
x29 = b(:,29);
x30 = b(:,30);
x31 = b(:,31);
x32 = b(:,32);
x33 = b(:,33);
x34 = b(:,34);
x35 = b(:,35);
x36 = b(:,36);
x37 = b(:,37);
x38 = b(:,38);
x39 = b(:,39);
x40 = b(:,40);
x41 = b(:,41);
x42 = b(:,42);
x43 = b(:,43);
x44 = b(:,44);
x45 = b(:,45);
x46 = b(:,46);
x47 = b(:,47);
x48 = b(:,48);
x49 = b(:,49);
x50 = b(:,50);
x51 = b(:,51);
x52 = b(:,52);
x53 = b(:,53);
x54 = b(:,54);
x55 = b(:,55);
x56 = b(:,56);
x57 = b(:,57);
x58 = b(:,58);
x59 = b(:,59);
x60 = b(:,60);
x61 = b(:,61);
x62 = b(:,62);
x63 = b(:,63);
x64 = b(:,64);
x65 = b(:,65);
x66 = b(:,66);
x67 = b(:,67);
x68 = b(:,68);
x69 = b(:,69);
x70 = b(:,70);
x71 = b(:,71);
x72 = b(:,72);
x73 = b(:,73);
x74 = b(:,74);
x75 = b(:,75);
x76 = b(:,76);
x77 = b(:,77);
x78 = b(:,78);
x79 = b(:,79);
x80 = b(:,80);
x81 = b(:,81);
x82 = b(:,82);
x83 = b(:,83);
x84 = b(:,84);
x85 = b(:,85);
x86 = b(:,86);
x87 = b(:,87);
x88 = b(:,88);
x89 = b(:,89);
x90 = b(:,90);
x91 = b(:,91);
x92 = b(:,92);
x93 = b(:,93);
x94 = b(:,94);
x95 = b(:,95);
x96 = b(:,96);
x97 = b(:,97);
x98 = b(:,98);
x99 = b(:,99);
x100 = b(:,100);

%plot

hold on
scatter(x1,step1);
scatter(x2,step2);
scatter(x3,step3);
scatter(x4,step4);
scatter(x5,step5);
scatter(x6,step6);
scatter(x7,step7);
scatter(x8,step8);
scatter(x9,step9);
scatter(x10,step10);
scatter(x11,step11);
scatter(x12,step12);
scatter(x13,step13);
scatter(x14,step14);
scatter(x15,step15);
scatter(x16,step16);
scatter(x17,step17);
scatter(x18,step18);
scatter(x19,step19);
scatter(x20,step20);
scatter(x21,step21);
scatter(x22,step22);
scatter(x23,step23);
scatter(x24,step24);
scatter(x25,step25);
scatter(x26,step26);
scatter(x27,step27);
scatter(x28,step28);
scatter(x29,step29);
scatter(x30,step30);
scatter(x31,step31);
scatter(x32,step32);
scatter(x33,step33);
scatter(x34,step34);
scatter(x35,step35);
scatter(x36,step36);
scatter(x37,step37);
scatter(x38,step38);
scatter(x39,step39);
scatter(x40,step40);
scatter(x41,step41);
scatter(x42,step42);
scatter(x43,step43);
scatter(x44,step44);
scatter(x45,step45);
scatter(x46,step46);
scatter(x47,step47);
scatter(x48,step48);
scatter(x49,step49);
scatter(x50,step50);
scatter(x51,step51);
scatter(x52,step52);
scatter(x53,step53);
scatter(x54,step54);
scatter(x55,step55);
scatter(x56,step56);
scatter(x57,step57);
scatter(x58,step58);
scatter(x59,step59);
scatter(x60,step60);
scatter(x61,step61);
scatter(x62,step62);
scatter(x63,step63);
scatter(x64,step64);
scatter(x65,step65);
scatter(x66,step66);
scatter(x67,step67);
scatter(x68,step68);
scatter(x69,step69);
scatter(x70,step70);
scatter(x71,step71);
scatter(x72,step72);
scatter(x73,step73);
scatter(x74,step74);
scatter(x75,step75);
scatter(x76,step76);
scatter(x77,step77);
scatter(x78,step78);
scatter(x79,step79);
scatter(x80,step80);
scatter(x81,step81);
scatter(x82,step82);
scatter(x83,step83);
scatter(x84,step84);
scatter(x85,step85);
scatter(x86,step86);
scatter(x87,step87);
scatter(x88,step88);
scatter(x89,step89);
scatter(x90,step90);
scatter(x91,step91);
scatter(x92,step92);
scatter(x93,step93);
scatter(x94,step94);
scatter(x95,step95);
scatter(x96,step96);
scatter(x97,step97);
scatter(x98,step98);
scatter(x99,step99);
scatter(x100,step100);

mean_step1 = mean(step1);
mean_step2 = mean(step2);
mean_step3 = mean(step3);
mean_step4 = mean(step4);
mean_step5 = mean(step5);
mean_step6 = mean(step6);
mean_step7 = mean(step7);
mean_step8 = mean(step8);
mean_step9 = mean(step9);
mean_step10 = mean(step10);
mean_step11 = mean(step11);
mean_step12 = mean(step12);
mean_step13 = mean(step13);
mean_step14 = mean(step14);
mean_step15 = mean(step15);
mean_step16 = mean(step16);
mean_step17 = mean(step17);
mean_step18 = mean(step18);
mean_step19 = mean(step19);
mean_step20 = mean(step20);
mean_step21 = mean(step21);
mean_step22 = mean(step22);
mean_step23 = mean(step23);
mean_step24 = mean(step24);
mean_step25 = mean(step25);
mean_step26 = mean(step26);
mean_step27 = mean(step27);
mean_step28 = mean(step28);
mean_step29 = mean(step29);
mean_step30 = mean(step30);
mean_step31 = mean(step31);
mean_step32 = mean(step32);
mean_step33 = mean(step33);
mean_step34 = mean(step34);
mean_step35 = mean(step35);
mean_step36 = mean(step36);
mean_step37 = mean(step37);
mean_step38 = mean(step38);
mean_step39 = mean(step39);
mean_step40 = mean(step40);
mean_step41 = mean(step41);
mean_step42 = mean(step42);
mean_step43 = mean(step43);
mean_step44 = mean(step44);
mean_step45 = mean(step45);
mean_step46 = mean(step46);
mean_step47 = mean(step47);
mean_step48 = mean(step48);
mean_step49 = mean(step49);
mean_step50 = mean(step50);
mean_step51 = mean(step51);
mean_step52 = mean(step52);
mean_step53 = mean(step53);
mean_step54 = mean(step54);
mean_step55 = mean(step55);
mean_step56 = mean(step56);
mean_step57 = mean(step57);
mean_step58 = mean(step58);
mean_step59 = mean(step59);
mean_step60 = mean(step60);
mean_step61 = mean(step61);
mean_step62 = mean(step62);
mean_step63 = mean(step63);
mean_step64 = mean(step64);
mean_step65 = mean(step65);
mean_step66 = mean(step66);
mean_step67 = mean(step67);
mean_step68 = mean(step68);
mean_step69 = mean(step69);
mean_step70 = mean(step70);
mean_step71 = mean(step71);
mean_step72 = mean(step72);
mean_step73 = mean(step73);
mean_step74 = mean(step74);
mean_step75 = mean(step75);
mean_step76 = mean(step76);
mean_step77 = mean(step77);
mean_step78 = mean(step78);
mean_step79 = mean(step79);
mean_step80 = mean(step80);
mean_step81 = mean(step81);
mean_step82 = mean(step82);
mean_step83 = mean(step83);
mean_step84 = mean(step84);
mean_step85 = mean(step85);
mean_step86 = mean(step86);
mean_step87 = mean(step87);
mean_step88 = mean(step88);
mean_step89 = mean(step89);
mean_step90 = mean(step90);
mean_step91 = mean(step91);
mean_step92 = mean(step92);
mean_step93 = mean(step93);
mean_step94 = mean(step94);
mean_step95 = mean(step95);
mean_step96 = mean(step96);
mean_step97 = mean(step97);
mean_step98 = mean(step98);
mean_step99 = mean(step99);
mean_step100 = mean(step100);

plot(mean_calciumTrace, 'k-')

% xaxis_bright_to_gray = [x1(1), x2(1), x3(1), x4(1), x5(1), x6(1), x7(1), x8(1), x9(1), x10(1) x11(1), x12(1), x13(1), x14(1), x15(1), x16(1), x17(1), x18(1), x19(1), x20(1) x21(1), x22(1), x23(1), x24(1), x25(1), x26(1), x27(1), x28(1), x29(1), x30(1) x31(1), x32(1), x33(1), x34(1), x35(1), x36(1), x37(1), x38(1), x39(1), x40(1) x41(1), x42(1), x43(1), x44(1), x45(1), x46(1), x47(1), x48(1), x49(1), x50(1) x51(1), x52(1), x53(1), x54(1), x55(1), x56(1), x57(1), x58(1), x59(1), x60(1) x61(1), x62(1), x63(1), x64(1), x65(1), x66(1), x67(1), x68(1), x69(1), x70(1) x71(1), x72(1), x73(1), x74(1), x75(1), x76(1), x77(1), x78(1), x79(1), x80(1) x81(1), x82(1), x83(1), x84(1), x85(1), x86(1), x87(1), x88(1), x89(1), x90(1) x91(1), x92(1), x93(1), x94(1), x95(1), x96(1), x97(1), x98(1), x99(1), x100(1)];
% 
% mean_traces = [mean_step1 mean_step2 mean_step3 mean_step4 mean_step5 mean_step6 mean_step7 mean_step8 mean_step9 mean_step10 mean_step11 mean_step12 mean_step13 mean_step14 mean_step15 mean_step16 mean_step17 mean_step18 mean_step19 mean_step20 mean_step21 mean_step22 mean_step23 mean_step24 mean_step25 mean_step26 mean_step27 mean_step28 mean_step29 mean_step30 mean_step31 mean_step32 mean_step33 mean_step34 mean_step35 mean_step36 mean_step37 mean_step38 mean_step39 mean_step40 mean_step41 mean_step42 mean_step43 mean_step44 mean_step45 mean_step46 mean_step47 mean_step48 mean_step49 mean_step50 ...
%     mean_step51 mean_step52 mean_step53 mean_step54 mean_step55 mean_step56 mean_step57 mean_step58 mean_step59 mean_step60 mean_step61 mean_step62 mean_step63 mean_step64 mean_step65 mean_step66 mean_step67 mean_step68 mean_step69 mean_step70 mean_step71 mean_step72 mean_step73 mean_step74 mean_step75 mean_step76 mean_step77 mean_step78 mean_step79 mean_step80 mean_step81 mean_step82 mean_step83 mean_step84 mean_step85 mean_step86 mean_step87 mean_step88 mean_step89 mean_step90 mean_step91 mean_step92 mean_step93 mean_step94 mean_step95 mean_step96 mean_step97 mean_step98 mean_step99 mean_step100];
% 
% hold on
% plot(xaxis_bright_to_gray,mean_traces, 'k-')


%% What is the calcium difference between the 5th epoch and the last one (100)? Plotting and statistics

step5 = calciumTrace(:,5); 
step100 = calciumTrace(:,100); 
% 
% err_calc_5 = err_calcium(:,5);
% err_calc_100 = err_calcium(:,100);
% 
% x5 = b(:,5);
% x100 = b(:,100);

big_step = [1];
big_step = logical(big_step);

NUM_STEPS = 1;


for kk =1:NUM_STEPS
    traces = mTm9LexA.rats; %because mean_cat_full works only with 2 dimensions %taking all ROIs, the epoch we are on, full lenth (200)
%     [x,m,e] = mean_cat_full(traces,1,mTm9LexA.flyID); %m=mean; e=std
    [x,m,e] = mean_cat_full(cur_mat_pos,1,cur_IDs_pos); %m=mean; e=std

    calciumTrace = x;
    calciumTrace = squeeze(calciumTrace);
    
    if big_step(kk)
        calciumTrace = calciumTrace;
    end

    
    not_NaN_flies = size(x,1); % Fabi: would crash otherwise, we have only 8 flies (not 12) evaluated here !
    
    calciumStep = zeros(not_NaN_flies,1);
%     calciumStep = mean(calciumTrace(:,100)) - mean(calciumTrace(:,5));
    calciumStep = calciumTrace(:,100) - calciumTrace(:,5); %abs because L2 goes into minus
%     calciumStep = abs(calciumTrace(:,100)) - abs(calciumTrace(:,5)); %abs because L2 goes into minus
    err_calcium = std(calciumStep,'omitnan')/sqrt(length(calciumStep));

end


% Plotting
bar_all = figure;
grid on;

y1 = calciumStep(big_step);
x1 = find(big_step);
e1 = err_calcium(big_step);

hold on;
% bar(x1,y1,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.0);
bar(x1,y1,'FaceColor',[0 1 1]);
errorbar(x1,y1,e1,'rx');

title('max response');

% Add titles
ax = gca;
ax.XTick = 1:length(off_step);
ax.XTickLabels = {'step 5 --> step 100'};
ax.XTickLabelRotation = 45;
ylabel('max (OFF) peak') ;

hold off;



%% Statistics: is the calcium signal difference between step 5 and step 100 the same as at for the control step (5 min fff)

% % Student t-test
% 
% step1 = all_steps_all_means_flies(:,1);
% step2 = all_steps_all_means_flies(:,2);
% 
% 
% %grey to 100OFF vs 100ON to grey
% [h,p,ci,stats] = ttest2(step1,step2);
% p_step1 = p
% h_step1 = h
% stats_step1 = stats


% drag the saved data to load them OR:
% 
% load('/Users/ksporar/Documents/MATLAB/TP_code_Katja/L3_calciumStep_ramp_control.mat') %named 
% load('/Users/ksporar/Documents/MATLAB/TP_code_Katja/L3_calciumStep_ramp.mat')

% load('/Users/ksporar/Documents/MATLAB/TP_code_Katja/L2_calciumStep_ramp_control.mat') %named 
% load('/Users/ksporar/Documents/MATLAB/TP_code_Katja/L2_calciumStep_ramp.mat')

L3_control_response = b;
L3_ramp_response = a;

L3_control = L3_control_response(:,1);
L3_ramp = L3_ramp_response(:,1);

% [h1,p1] = ttest2(L3_control,L3_ramp)
[h,p,ci,stats] = ttest2(L3_control,L3_ramp)

%For L3 with NO CORRELATION - comparing to L3 responses to the control stimulus taking mean trace for the plateau, p = 0.3560
%For L3 with correlation, p = 0.1244



L2_control_response = b;
L2_ramp_response = a;

L2_control = L2_control_response(:,1);
L2_ramp = L2_ramp_response(:,1);

% [h1,p1] = ttest2(L3_control,L3_ramp)
[h,p,ci,stats] = ttest2(L2_control,L2_ramp)

%POSITIVE CORRELATION and comparing to L3 responses to the control stimulus taking mean trace for the plateau: For L2, p = 4.2342e-05
%NO correlation - taking mean trace for the plateau - p = 0.7316












