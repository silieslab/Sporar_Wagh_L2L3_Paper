% script to read in database and make various categories...

[fname,datetime,frames,zdepth,tottime,stimbouts,locnum,...
    activecells,inverted,stimcode,quality,driver,...
    moving,layer,wavelength,flyID, responsivefly]...
    =textread('MASTER_foldersummary_Katja.txt',...
    '%s %s %f %f %f %f %f %s %f %s %f %s %f %s %f %f %f \r',...
    'headerlines',1,'delimiter','\t');
%MS: %s reads a white space or delimiter separated string, %f a floating-point value
% reads now string for layers


i_fff2s = strcmpi('LocalCircle_2sec_220deg_0degAz_0degEl_Sequential_LumDec_LumInc',(stimcode)); 
i_fff5s = strcmpi('LocalCircle_5sec_220deg_0degAz_0degEl_Sequential_LumDec_LumInc',(stimcode)); 
i_fff300ms = strcmpi('LocalCircle_300ms_220deg_0degAz_0degEl_Sequential_LumDec_LumInc',(stimcode));
i_fff60s = strcmpi('LocalCircle_60sec_220deg_0degAz_0degEl_Sequential_LumDec_LumInc - Copy',(stimcode));

i_fff2sONgrayOFF = strcmpi('LocalCircle_2sONgrayOFFgray_120deg_0degAz_0degEl_2Lum',(stimcode)); 
i_fff5sONgrayOFF = strcmpi('LocalCircle_5sONgrayOFFgray_120deg_0degAz_0degEl_2Lum',(stimcode)); 
i_fff_steps_2sONgrayOFF  = strcmpi('LocalCircle_0.1steps_2sONgrayOFFgray_120deg_0degAz_0degEl_2Lum-random',(stimcode)); 

% For 25ms added by Fabiola
i_fffOngrayOFF25ms = strcmpi('LocalCircle_ONgreyOFF_25ms_BG_2s_120deg_0degAz_0degEl_100_Con_0.5Lum', (stimcode));


%ONgreyOFF This are the new ONgreyOFF stimuli (correct contrast changes)
i_fff_01steps_2sONgrayOFF = strcmpi('LocalCircle_0.1steps_2sONgrayOFFgray_120deg_0degAz_0degEl_2Lum',(stimcode));
i_fff_01steps_5sONgrayOFF = strcmpi('LocalCircle_0.1steps_5sONgrayOFFgray_120deg_0degAz_0degEl_2Lum',(stimcode));
i_fff25msecONgrayOFF = strcmpi('LocalCircle_25ms_120deg_0degAz_0degEl_ONgrayOFFgray_2Lum',(stimcode)); 

i_fff2sONgrayOFF4sBG = strcmpi('LocalCircle_ONOFF_2s_BG_4s_120deg_0degAz_0degEl_100_Con_0.5Lum',(stimcode));
i_fff5sONgrayOFF10sBG = strcmpi('LocalCircle_ONOFF_5s_BG_10s_120deg_0degAz_0degEl_100_Con_0.5Lum',(stimcode));

i_fff_4sBG5sONgrayOFF = strcmpi('LocalCircle_0.1steps_4sBG_5sONgrayOFFgray_120deg_0degAz_0degEl_2Lum',(stimcode));

%0.5 steps
i_fff_05steps_10sONgrayOFF = strcmpi('LocalCircle_0.5steps_10s_randSteps_120deg_0degAz_0degEl_2Lum',(stimcode));


i_fff25msONgrayOFF4sBG = strcmpi('LocalCircle_ONgreyOFF_25ms_BG_2s_120deg_0degAz_0degEl_100_Con_0.5Lum',(stimcode));
i_fff300msONgrayOFF = strcmpi('LocalCircle_ONgreyOFF_300ms_BG_300ms_120deg_0degAz_0degEl_100_Con_0.5Lum',(stimcode));

i_fff30msONgrayOFF = strcmpi('LocalCircle_ONgreyOFF_30ms_BG_2s_120deg_0degAz_0degEl_100_Con_0.5Lum',(stimcode));



i_mb_luminc_20degs_5deg_8dir = strcmpi('DriftingStripe_LumInc_1period_20degPerSec_5deg_BlankRand_8Dir',(stimcode));
i_mb_lumdec_20degs_5deg_8dir = strcmpi('DriftingStripe_LumDec_1period_20degPerSec_5deg_BlankRand_8Dir',(stimcode));
i_mb_lumdec_20degs_5deg_8dir_copy = strcmpi('DriftingStripe_LumDec_1period_20degPerSec_5deg_BlankRand_8Dir - Copy',(stimcode));

i_mb_lumdec_20degs_10deg_8dir = strcmpi('DriftingStripe_LumDec_1period_20degPerSec_10deg_BlankRand_8Dir',(stimcode));
i_mb_luminc_20degs_10deg_8dir = strcmpi('DriftingStripe_LumInc_1period_20degPerSec_10deg_BlankRand_8Dir',(stimcode));

%Standing stripes
% i_standingStripe_LumInc_Vert = strcmpi('StandingStripe_1sec_VerAx_5_5deg_LumInc_rand_Spacing2_USEFRUSTUM',(stimcode)); %use flyID after 160727ks_fly1 (corrected the stimulus)
% i_standingStripe_LumInc_Horiz = strcmpi('StandingStripe_1sec_HorizAx_5_5deg_LumInc_rand_Spacing2_USEFRUSTUM',(stimcode)); %use flyID ones after 160727ks_fly1 (corrected the stimulus)

i_StandingStripe_1s_XAxis_5degWide = strcmpi('StandingStripe_1s_XAxis_5degWide_2degSep_m1.0Con_rand_USEFRUSTUM',(stimcode));
i_StandingStripe_1s_YAxis_5degWide = strcmpi('StandingStripe_1s_YAxis_5degWide_2degSep_m1.0Con_rand_USEFRUSTUM',(stimcode));


%Drifting stripe - 3 luminances
i_DriftingStripe_3luminances = strcmpi('DriftingStripe_10deg_20degPerSek_8Directions_3luminances_darkOnBright_ks',(stimcode));
i_DriftingStripe_3luminances_new_contrast = strcmpi('DriftingStripe_10deg_20degPerSek_8Directions_3luminances_darkOnBright_ks_new_contrast',(stimcode));
i_DriftingEdge_3luminances = strcmpi('DriftingEDGE_10deg_20degPerSek_8Directions_3luminances_darkOnBright_ks',(stimcode));
i_DriftingEdge_3luminances_new_contrast = strcmpi('DriftingEDGE_10deg_20degPerSek_8Directions_3luminances_darkOnBright_ks_new_contrast',(stimcode));

%Drifting stripe - 3 luminances NEW Weber Contrast 171030ks
i_DriftingStripe_3luminances_new_WeberContrast = strcmpi('DriftingStripe_10deg_20degPerSek_8Directions_3luminances_darkOnBright_WeberContrast',(stimcode));
i_DriftingEDGE_3luminances_new_WeberContrast = strcmpi('DriftingEDGE_10deg_20degPerSek_8Directions_3luminances_darkOnBright_WeberContrast',(stimcode));

%Drifting edge, 4 dir
i_DriftingEdge_LumDecLumInc_4Dirs = strcmpi('DriftingEdge_LumDecLumInc_1period_20degPerSec_90deg_BlankRand_4Dirs',(stimcode));


%white noise 1min plus 5 steps 1s
i_whitenoise_5steps1s = strcmpi('LocalCircle_WhiteNoise_0.5steps_1s_randSteps_120deg_0degAz_0degEl_2Lum',(stimcode));


%LedSynth
i_MarkPoints_2s = strcmpi('mark_points_2s',(stimcode));
i_MarkPoints_200ms = strcmpi('mark_points_200ms',(stimcode));

%LedSynth: blue LED (number 08)
i_voltage_output_blue08_2s_fff = strcmpi('voltage_output_blue08_2s_fff',(stimcode));
i_voltage_output_blue08_5s_fff = strcmpi('voltage_output_blue08_5s_fff',(stimcode));
i_voltage_output_blue08_200ms_fff = strcmpi('voltage_output_blue08_200ms_fff',(stimcode));

%LedSynth: spectral (using 16 LEDs out of 20)
i_voltage_output_2s_spectral_fff = strcmpi('voltage_output_2s_spectral_fff',(stimcode));
i_voltage_output_200ms_spectral_fff = strcmpi('voltage_output_200ms_spectral_fff',(stimcode));


%LED for csChrimson
i_LED_2s_V018 = strcmpi('LED_2s_V018',(stimcode));
i_LED_2s_V0145 = strcmpi('LED_2s_V0145',(stimcode));


%gratings - 2 different luminances
i_grating1Weber05_075_BG075_05 = strcmpi('grating1Weber05_075_BG075_05',(stimcode));
i_grating2Weber025_075_BG075_25 = strcmpi('grating2Weber025_075_BG075_25',(stimcode));
i_grating3Weber04_075_BG075_25 = strcmpi('grating3Weber04_075_BG075_25',(stimcode));

%gratings with GREY - 2 different luminances
i_grey_grating1Weber05_075_BG075_05 = strcmpi('grey_grating1Weber05_075_BG075_05',(stimcode));
i_grey_grating2Weber025_075_BG075_25 = strcmpi('grey_grating2Weber025_075_BG075_25',(stimcode));
i_grey_grating3Weber04_075_BG075_25 = strcmpi('grey_grating3Weber04_075_BG075_25',(stimcode));


%grey 3min, ND0.6 12min
i_grey_3min_ND06_12min = strcmpi('grey_3min_ND06_12min',(stimcode));
i_ONO_100FF_3min_ND06_12min = strcmpi('ONOFF_3min_ND06_12min',(stimcode));
i_ONO_80FF_3min_ND06_12min = strcmpi('grey_LocalCircle_2s_FullContrast_220deg_0degAz_0degEl_Sequential_LumDec_LumInc',(stimcode));


%Marvin's adaptation stimulus
i_FullField_OFF_2s_OFF_2s = strcmpi('FullField_OFF_2s_OFF_2s_1s_BG_15s_con_m25_lum_0d75to0_NonRand',(stimcode));
i_FullField_ON_3s_OFF_3s = strcmpi('FullField_OFF_2s_OFF_2s_1s_BG_15s_con_m25_lum_0d75to0_NonRand',(stimcode));

i_FullField_OFF_1s_OFF_1s = strcmpi('FullField_OFF_1s_OFF_1s_1s_BG_15s_con_m25_lum_0d75to0_NonRand',(stimcode));
i_FullField_OFF_10s_OFF_10s = strcmpi('FullField_OFF_10s_OFF_10s_1s_BG_15s_con_m25_lum_0d75to0_NonRand',(stimcode));


% Slow ramp down 100 steps
i_slow_ramp_down_500ms_100 = strcmpi('slow_ramp_down_500ms_100',(stimcode));
i_slow_ramp_down_6s_100 = strcmpi('slow_ramp_down_6s_100',(stimcode));
i_LocalCircle_5min_control_for_the_ramp = strcmpi('LocalCircle_5min_control_for_the_ramp',(stimcode));


% 30 s adapting step, then OFF step to the same luminance
i_Diff_Adapting_OFFstep_6s = strcmpi('Diff_Adapting_OFFstep_6s',(stimcode));


% i_me_20d4dir = strcmpi('movedges_20d_4dirs_rperm',stimcode);

i_15bouts = stimbouts>=15;
i_inverted = (inverted == 1);
i_moving = (moving == 1);
i_active = (quality ~= 0);
i_responsivefly = (responsivefly == 1);  %ms addition

%changed to read strings
% i_L4M2 = strcmpi('L4M2',layer);
% i_L4M4 = strcmpi('L4M4',layer);
i_lob1 = strcmpi('lob1',layer);


i_447 = (wavelength == 447);

i_Tm9LexAGCaMP6F = strcmpi('Tm9LexAp65GCaMP6F',driver);
% i_Tm9LexAGCaMP6F_37C = strcmpi('Tm9LexAp65GCaMP6F_37C',driver);
i_Tm9LexAGCaMP6F_shits_37C = strcmpi('Tm9LexAp65GCaMP6F_UASshitsR_37C',driver);
i_Tm9LexAGCaMP6F_shits_37C_TM6B = strcmpi('Tm9LexAp65GCaMP6F_UASshitsR_TM6B_37C',driver);
i_Tm9LexAGCaMP6F_shits_TM6B = strcmpi('Tm9LexAp65GCaMP6F_UASshitsR_TM6B',driver);
i_Tm9LexAGCaMP6F_L1shits_37C = strcmpi('Tm9LexAp65GCaMP6F_L1c202a_shitsR_37C',driver);
i_Tm9LexAGCaMP6F_L2shits_37C = strcmpi('Tm9LexAp65GCaMP6F_L221DhhshitsR_37C',driver);
i_Tm9LexAGCaMP6F_L3shits_37C = strcmpi('Tm9LexAp65GCaMP6F_L30595shitsR_37C',driver);
i_Tm9LexAGCaMP6F_L1L3shits_37C = strcmpi('Tm9LexAp65GCaMP6F_L1c202a0595_shitsR_37C',driver);
i_Tm9LexAGCaMP6F_L2L3shits_37C = strcmpi('Tm9LexAp65GCaMP6F_L221Dhh0595_shitsR_37C',driver);
i_Tm9LexAGCaMP6F_sensGal4shits_37C = strcmpi('Tm9LexAp65GCaMP6F_UASshitsR_sensGal4_37C',driver);
i_Tm9LexAGCaMP6F_sensGal4shits = strcmpi('Tm9LexAp65GCaMP6F_UASshitsR_sensGal4',driver);
% i_Tm9LexAGCaMP6F_LL = strcmpi('Tm9LexAp65GCaMP6F_3d_LL',driver);
% i_Tm9LexAGCaMP6F_LD = strcmpi('Tm9LexAp65GCaMP6F_3d_LD',driver);

i_Tm9LexAGCaMP6F_Kir2_1 = strcmpi('Tm9LexAlexAopGCaMP6f_UASKir2.1',driver);
i_Tm9LexAGCaMP6F_L1_Kir2_1 = strcmpi('Tm9LexAlexAopGCaMP6f_L1c202a_Kir2.1',driver);
i_Tm9LexAGCaMP6F_L1CHL_Kir2_1 = strcmpi('Tm9LexAlexAopGCaMP6f_L1CHL_Kir2.1',driver);
i_Tm9LexAGCaMP6F_L2_Kir2_1 = strcmpi('Tm9LexAlexAopGCaMP6f_L221Dhh_Kir2.1',driver);
i_Tm9LexAGCaMP6F_L3_Kir2_1 = strcmpi('Tm9LexAlexAopGCaMP6f_L10595_Kir2.1',driver);

i_10to15min = locnum>10&locnum<15;
i_15to20min = locnum>15&locnum<20;
i_20to25min = locnum>20&locnum<25;
i_25to30min = locnum>25&locnum<30;
i_30to35min = locnum>30&locnum<35;

i_20to30min = locnum>20&locnum<30;
i_recovery = locnum>60;

% i_T4T5GCaMP6F_Tm9LexA_shitsattP2 =  strcmpi('T4T5G4_UAS6F_Tm9LexA_lexAopshitsattP2', driver); 
% i_T4T5GCaMP6F_Tm9LexA =  strcmpi('T4T5G4_UAS6F_Tm9LexA', driver); 
% i_T4T5GCaMP6F_lexAopshitsattP2 =  strcmpi('T4T5G4_UAS6F_lexAopshitsattP2', driver); 


% L2 / L3
i_UASGCaMP6F_L221DhhGal4 = strcmpi('UASGCaMP6F_L221DhhGal4',driver);
i_UASGCaMP6F_L30595Gal4 = strcmpi('UASGCaMP6F_L30595Gal4',driver);
i_UASGCaMP6F_L3MH56Gal4 = strcmpi('UASGCaMP6F_L3MH56Gal4',driver);

%UAS-GCaMP6f;L2[21Dhh-Gal4] or MH56-Gal4 x w+
i_UASGCaMP6f_L3MH56Gal4_cross_to_w = strcmpi('UASGCaMP6f_L3MH56Gal4_cross_to_w',driver);
i_UASGCaMP6F_L221DhhGal4_cross_to_w = strcmpi('UASGCaMP6F_L221DhhGal4_cross_to_w',driver);

i_UASGCaMP6f_L3MH56Gal4_cross_to_w_mars = strcmpi('UASGCaMP6f_L3MH56Gal4_cross_to_w_mars',driver);
i_UASGCaMP6F_L221DhhGal4_cross_to_w_mars = strcmpi('UASGCaMP6F_L221DhhGal4_cross_to_w_mars',driver);

% GCaMP3
i_UASGCaMP3_L221DhhGal4 = strcmpi('UASGCaMP3_L221DhhGal4',driver);
i_UASGCaMP3_L3MH56Gal4 = strcmpi('UASGCaMP3_L3MH56Gal4',driver);

% PTX experiment
i_UASGCaMP6F_L3MH56Gal4_PTX = strcmpi('UASGCaMP6F_L3MH56Gal4_PTX',driver);
i_UASGCaMP6F_L221DhhGal4_PTX = strcmpi('UASGCaMP6F_L221DhhGal4_PTX',driver);


% Presynaptic marker
i_UASsyp_L221DhhGal4 = strcmpi('UASsyp_L221DhhGal4',driver);
i_UASsyp_L3MH56Gal4 = strcmpi('UASsyp_L3MH56Gal4',driver);

% Postsynaptic marker
i_UAShomer_L221DhhGal4 = strcmpi('UAShomerGCaMP3_L221DhhGal4',driver);

% Vesicle release
i_UASsypPhTom_L3MH56Gal4 = strcmpi('UASsypPhTom_L3MH56Gal4',driver);


% Rh1
i_UASGCaMP6f_Rh1Gal4 = strcmpi('UASGCaMP6f_Rh1Gal4',driver);

% Voltage sensors ASAP2
i_pJFRCASAP2s_L221DhhGal4 = strcmpi('pJFRCASAP2s_L221DhhGal4',driver);
i_pJFRCASAP2s_L30595Gal4 = strcmpi('pJFRCASAP2s_L30595Gal4',driver);
i_pJFRCASAP2s_L3MH56Gal4 = strcmpi('pJFRCASAP2s_L3MH56Gal4',driver);

i_pJFRCASAP2f_L221DhhGal4 = strcmpi('pJFRCASAP2f_L221DhhGal4',driver);
i_pJFRCASAP2f_L3MH56Gal4 = strcmpi('pJFRCASAP2f_L3MH56Gal4',driver);

i_L3MH56Gal4_Asap2f = strcmpi('L3MH56Gal4_Asap2f',driver);
i_L221DhhGal4_Asap2f = strcmpi('L221DhhGal4_Asap2f',driver);

%current_120
i_L3MH56Gal4_Asap2f_current120 = strcmpi('L3MH56Gal4_Asap2f_current120',driver);
i_L221DhhGal4_Asap2f_current120 = strcmpi('L221DhhGal4_Asap2f_current120',driver);

i_UASGCaMP6f_L3MH56Gal4_cross_to_w_current120 = strcmpi('UASGCaMP6f_L3MH56Gal4_cross_to_w_current120',driver);


% Voltage sensors ASAP2 AXONS!!!
i_pJFRCASAP2s_L221DhhGal4_axons = strcmpi('pJFRCASAP2s_L221DhhGal4_axons',driver);

% MiMIC Cbp53E
i_Cbp53E_L221DhhGal4 = strcmpi('Cbp53E_L221DhhGal4',driver);

% T4/T5 zymnd
i_T4T5QFGCaMP6F_UASshitsR_37C = strcmpi('T4T5QFGCaMP6F_UASshitsR_37C',driver);
i_T4T5QFGCaMP6F_zymndGal4_37C = strcmpi('T4T5QFGCaMP6F_zymndGal4_37C',driver);
i_T4T5QFGCaMP6F_UASshitsR_zymndGal4_37C = strcmpi('T4T5QFGCaMP6F_UASshitsR_zymndGal4_37C',driver);

i_T4T5QFGCaMP6F_UASshitsR = strcmpi('T4T5QFGCaMP6F_UASshitsR',driver);
i_T4T5QFGCaMP6F_zymndGal4 = strcmpi('T4T5QFGCaMP6F_zymndGal4',driver);
i_T4T5QFGCaMP6F_UASshitsR_zymndGal4 = strcmpi('T4T5QFGCaMP6F_UASshitsR_zymndGal4',driver);

%RNAi
i_RNAi_Ih_L221DhhGal4_UASGCaMP6f = strcmpi('RNAi_Ih_L221DhhGal4_UASGCaMP6f',driver);
i_RNAi_Ih_MH56Gal4_UASGCaMP6f = strcmpi('RNAi_Ih_MH56Gal4_UASGCaMP6f',driver);
i_RNAi_Slob_L221DhhGal4_UASGCaMP6f = strcmpi('RNAi_Slob_L221DhhGal4_UASGCaMP6f',driver);
i_RNAi_Slob_MH56Gal4_UASGCaMP6f = strcmpi('RNAi_Slob_L3MH56Gal4_UASGCaMP6f',driver);
i_RNAi_Shawl_L221DhhGal4_UASGCaMP6f = strcmpi('UASGCaMP6F_L221DhhGal4_RNAi_Shawl',driver);
i_RNAi_Shawl_MH56Gal4_UASGCaMP6f = strcmpi('UASGCaMP6f_L3MH56Gal4_RNAi_Shawl',driver);
i_RNAi_HCl1_L221DhhGal4_UASGCaMP6f = strcmpi('UASGCaMP6F_L221DhhGal4_RNAi_HCl1',driver);
i_RNAi_HCl1_MH56Gal4_UASGCaMP6f = strcmpi('UASGCaMP6f_L3MH56Gal4_RNAi_HCl1',driver);
i_RNAi_Ace_L221DhhGal4_UASGCaMP6f = strcmpi('UASGCaMP6F_L221DhhGal4_RNAi_Ace',driver);
i_RNAi_Ace_MH56Gal4_UASGCaMP6f = strcmpi('UASGCaMP6f_L3MH56Gal4_RNAi_Ace',driver);
i_RNAi_btsz_L221DhhGal4_UASGCaMP6f = strcmpi('UASGCaMP6F_L221DhhGal4_RNAi_btsz',driver);
i_RNAi_btsz_MH56Gal4_UASGCaMP6f = strcmpi('UASGCaMP6f_L3MH56Gal4_RNAi_btsz',driver);


%ort rescue - only R7 & R8
i_UASort_UASGCaMP6f_0595Gal4_ort1_ort1 = strcmpi('UASort_UASGCaMP6f_0595Gal4_ort1_ort1',driver);
i_UASort_UASGCaMP6f_L221DhhGal4_ort1_ort1 = strcmpi('UASort_UASGCaMP6f_L221DhhGal4_ort1_ort1',driver);
%ort rescue - only R7 & R8 - control
i_UASGCaMP6f_plus_0595Gal4_ort1_ort1 = strcmpi('UASGCaMP6f_plus_0595Gal4_ort1_ort1',driver);

%real ort rescue
i_UASort_UASGCaMP6f_L30595Gal4_ort1_DfBSC809 = strcmpi('UASort_UASGCaMP6f_L30595Gal4_ort1_DfBSC809',driver);
i_UASort_UASGCaMP6f_L221DhhGal4_ort1_DfBSC809 = strcmpi('UASort_UASGCaMP6f_L221DhhGal4_ort1_DfBSC809',driver); %old
i_UASort_UASGCaMP6f_L221DhhGal4_ort1_DfBSC809_Helen = strcmpi('UASort_UASGCaMP6f_L221DhhGal4_ort1_DfBSC809_Helen',driver); %L2 ort flies from Helen


%real ort rescue - controls
i_UASGCaMP6f_UASort_0595Gal4_ort1_plus = strcmpi('UASGCaMP6f_UASort_0595Gal4_ort1_plus',driver); %no Df
i_UASGCaMP6f_UASort_L221DhhGal4_ort1_plus = strcmpi('UASGCaMP6f_UASort_L221DhhGal4_ort1_plus',driver); %no Df, old
i_UASGCaMP6f_UASort_L221DhhGal4_ort1_plus_Helen = strcmpi('UASGCaMP6f_UASort_L221DhhGal4_ort1_plus_Helen',driver); %L2 ort flies from Helen

i_UASGCaMP6f_plus_0595Gal4_ort1_DfBSC809 = strcmpi('UASGCaMP6f_plus_0595Gal4_ort1_DfBSC809',driver); %no UAS-ort
i_UASGCaMP6f_plus_L221DhhGal4_ort1_DfBSC809 = strcmpi('UASGCaMP6f_plus_L221DhhGal4_ort1_DfBSC809',driver); %no UAS-ort - check if really L2!!!!!!!
i_UASGCaMP6f_plus_L221DhhGal4_ort1_DfBSC809_Helen = strcmpi('UASGCaMP6f_plus_L221DhhGal4_ort1_DfBSC809_Helen',driver); %L2 ort flies from Helen

%ort rescue - double rescue L2 and L3
i_UASort_UASGCaMP6f_L221DhhGal4_MH56Gal4_ort1_plus = strcmpi('UASort_UASGCaMP6f_L221DhhGal4_MH56Gal4_ort1_plus',driver); %no Df
i_UASort_UASGCaMP6f_L221DhhGal4_MH56Gal4_ort1_DfBSC809 = strcmpi('UASort_UASGCaMP6f_L221DhhGal4_MH56Gal4_ort1_DfBSC809',driver); %rescue
i_UASGCaMP6f_L221DhhGal4_MH56Gal4_ort1_plus_DfBSC809 = strcmpi('UASGCaMP6f_L221DhhGal4_MH56Gal4_ort1_plus_DfBSC809',driver); %no Df


%for Matthew Pecot
i_lexAopGCaMP6fp10attp5_16HO3lexA_lexAopmyrtdTOM_11164Gal4_plus = strcmpi('lexAopGCaMP6fp10attp5_16HO3lexA_lexAopmyrtdTOM_11-164Gal4_plus',driver);
i_lexAopGCaMP6fp10attp5_16HO3lexA_lexAopmyrtdTOM_11164Gal4ermHA = strcmpi('lexAopGCaMP6fp10attp5_16HO3lexA_lexAopmyrtdTOM_11-164Gal4_ermHA',driver);
i_lexAopGCaMP6fp10attp5_16HO3lexA_lexAopmyrtdTOM_plus_plus = strcmpi('lexAopGCaMP6fp10attp5_16HO3lexA_lexAopmyrtdTOM_plus_plus',driver);
i_lexAopGCaMP6fp10attp5_16HO3lexA_lexAopmyrtdTOM_plus_UASerm = strcmpi('lexAopGCaMP6fp10attp5_16HO3lexA_lexAopmyrtdTOM_plus_UASerm',driver);

i_L3_ermMARCM_LOF = strcmpi('ermFRT40LexAopGCaMP6fp10_Gal80FRT4027605Flp_99Gal4UASR_79c23s6sRSCsmGFPvs21LexA',driver);
i_L3_MARCM_LOF_control = strcmpi('FRT40LexAopGCaMP6fp10_Gal80FRT4027605Flp_99Gal4UASR_79c23s6sRSCsmGFPvs21LexA',driver);

%dFezf RNAi
i_UASGCaMP6f_L3MH56Gal4_UASshits_UASermRNAi = strcmpi('UASGCaMP6f_L3MH56Gal4_UASshits_UASermRNAi',driver);



%L2 L3 shits
i_UASGCaMP6f_L3MH56Gal4_UASshits = strcmpi('UASGCaMP6f_L3MH56Gal4_UASshits',driver);
i_UASGCaMP6f_L221DhhGal4_UASshits = strcmpi('UASGCaMP6F_L221DhhGal4_UASshits',driver);

%L2 L3 shits recorded after submission
i_MH56Gal4_UASGCaMP6f_shits_37_new = strcmpi('MH56Gal4_UASGCaMP6f_shits_37_new',driver);
i_L221DhhGal4_UASGCaMP6f_shits_37_new = strcmpi('L221DhhGal4_UASGCaMP6f_shits_37_new',driver);
i_MH56Gal4_UASGCaMP6f_shits_new = strcmpi('MH56Gal4_UASGCaMP6f_shits_new',driver);
i_L221DhhGal4_UASGCaMP6f_shits_new = strcmpi('L221DhhGal4_UASGCaMP6f_shits_new',driver);


%ND filters
i_UASGCaMP6f_L3MH56Gal4_cross_to_w_06 = strcmpi('UASGCaMP6f_L3MH56Gal4_cross_to_w_06',driver); %ND 0.6
i_UASGCaMP6f_L3MH56Gal4_cross_to_w = strcmpi('UASGCaMP6f_L3MH56Gal4_cross_to_w',driver);
i_UASGCaMP6f_L3MH56Gal4_UASshits_06 = strcmpi('UASGCaMP6f_L3MH56Gal4_UASshits_06',driver);
i_UASGCaMP6F_L3MH56Gal4_06 = strcmpi('UASGCaMP6f_L3MH56Gal4_06',driver);

i_UASGCaMP6f_L3MH56Gal4_cross_to_w_noND = strcmpi('UASGCaMP6f_L3MH56Gal4_cross_to_w_noND',driver);
i_UASGCaMP6f_L3MH56Gal4_cross_to_w_ND01 = strcmpi('UASGCaMP6f_L3MH56Gal4_cross_to_w_ND01',driver);
i_UASGCaMP6f_L3MH56Gal4_cross_to_w_ND03 = strcmpi('UASGCaMP6f_L3MH56Gal4_cross_to_w_ND03',driver);
i_UASGCaMP6f_L3MH56Gal4_cross_to_w_ND06 = strcmpi('UASGCaMP6f_L3MH56Gal4_cross_to_w_ND06',driver);
i_UASGCaMP6f_L3MH56Gal4_cross_to_w_ND1 = strcmpi('UASGCaMP6f_L3MH56Gal4_cross_to_w_ND1',driver);


%UAS-shits - pre-incubated at 37C
i_UASGCaMP6f_L3MH56Gal4_cross_to_w_06_37C = strcmpi('UASGCaMP6f_L3MH56Gal4_cross_to_w_06_37C',driver);


i_UASGCaMP6f_L221DhhGal4_06 = strcmpi('UASGCaMP6F_L221DhhGal4_06',driver);
i_UASGCaMP6F_L221DhhGal4_cross_to_w_06 = strcmpi('UASGCaMP6F_L221DhhGal4_cross_to_w_06',driver);


%Overexpression (candidates)
i_UASGCaMP6F_L221DhhGal4_UASbtsz = strcmpi('UASGCaMP6F_L221DhhGal4_UASbtsz',driver);


%T4/T5 imaging, L3 silencing
% i_T4T5QF_QUASGCaMP6f_UASshits_MH56Gal4_38preincubated = strcmpi('T4T5QF_QUASGCaMP6f_UASshits_MH56Gal4_38preincubated',driver);
% i_T4T5QF_QUASGCaMP6f_UASshits_wcontrol_38preincubated = strcmpi('T4T5QF_QUASGCaMP6f_UASshits_wcontrol_38preincubated',driver);

i_T4T5LexA_LexAopGCaMP6m_UASshits_control = strcmpi('T4T5lexA_lexAopGCaMP6m_UASshits_control',driver);
i_T4T5LexA_LexAopGCaMP6m_UASshits_MH56Gal4 = strcmpi('T4T5lexA_lexAopGCaMP6m_UASshits_MH56Gal4',driver);
i_T4T5LexA_LexAopGCaMP6m_UASshits_L221DhhGal4 = strcmpi('T4T5lexA_lexAopGCaMP6m_UASshits_L221DhhGal4',driver);
i_T4T5lexA_lexAopGCaMP6m_UASshits_0595Gal4 = strcmpi('T4T5lexA_lexAopGCaMP6m_UASshits_0595Gal4',driver);


%R8
i_UASGCaMP6f_sensFlp_act_CD2_Gal4_R8 = strcmpi('UASGCaMP6f_sensFlp_act_CD2_Gal4_R8',driver); %UASGCaMP6f
i_UASGCaMP6m_sensFlp_act_CD2_Gal4_R8 = strcmpi('UASGCaMP6m_sensFlp_act_CD2_Gal4_R8',driver); %UASGCaMP6m


%UASFlagCFPbrp
i_UASGCaMP6f_L3MH56Gal4_UASFlagCFPbrp = strcmpi('UASGCaMP6f_L3MH56Gal4_UASFlagCFPbrp',driver); 
i_UASGCaMP6F_L221DhhGal4_UASFlagCFPbrp = strcmpi('UASGCaMP6F_L221DhhGal4_UASFlagCFPbrp',driver); 

%ort overexpression
i_UASGCaMP6F_L221DhhGal4_UASort = strcmpi('UASGCaMP6F_L221DhhGal4_UASort',driver); 


%NinaE-Gal4; UAS-GCaMP6m
i_NinaEGCaMP6m = strcmpi('NinaEGCaMP6m',driver); 

%LedSynth; with ND01
i_UASGCaMP6f_L3MH56Gal4_cross_to_w_ND1 = strcmpi('UASGCaMP6f_L3MH56Gal4_cross_to_w_ND1',driver); 
i_UASGCaMP6F_L221DhhGal4_cross_to_w_ND1 = strcmpi('UASGCaMP6F_L221DhhGal4_cross_to_w_ND1',driver); 

% ROI selection on a non-aligned images (because sometimes it aligned them really weirdly) - LedSynth
i_UASGCaMP6f_L3MH56Gal4_cross_to_w_ND1_notaligned = strcmpi('UASGCaMP6f_L3MH56Gal4_cross_to_w_ND1_notaligned',driver); 
i_UASGCaMP6F_L221DhhGal4_cross_to_w_ND1_notaligned = strcmpi('UASGCaMP6F_L221DhhGal4_cross_to_w_ND1_notaligned',driver); 

%NorpA rescues
i_NorpA_Rh1NorpA_L2LexA_LexAopGCaMP6f = strcmpi('NorpA_Rh1NorpA_L2LexA_LexAopGCaMP6f',driver); 
i_NorpA_Rh6NorpA_L2LexA_LexAopGCaMP6f = strcmpi('NorpA_Rh6NorpA_L2LexA_LexAopGCaMP6f',driver); 
i_NorpA_panR8NorpA_L2LexA_LexAopGCaMP6f = strcmpi('NorpA_panR8NorpA_L2LexA_LexAopGCaMP6f',driver);
i_norpA_rh1_panR8_UASnorpA_L2LexA_LexAopGCaMP6f = strcmpi('norpA_rh1_panR8_UASnorpA_L2LexA_LexAopGCaMP6f',driver); 


i_NorpA_Rh1NorpA_L3QF_QUAS_GCaMP6f = strcmpi('NorpA_Rh1NorpA_L3QF_QUAS_GCaMP6f',driver);
i_NorpA_Rh6NorpA_L3QF_QUAS_GCaMP6f = strcmpi('NorpA_Rh6NorpA_L3QF_QUAS_GCaMP6f',driver);
i_NorpA_panR8NorpA_L3QF_QUAS_GCaMP6f = strcmpi('NorpA_panR8NorpA_L3QF_QUAS_GCaMP6f',driver);
i_norpA_rh1_panR8_UASnorpA_L3QF_QUAS_GCaMP6f = strcmpi('norpA_rh1_panR8_UASnorpA_L3QF_QUAS_GCaMP6f',driver); 


%Controls
i_panR8_L2LexA_LexAopGCaMP6f = strcmpi('panR8_L2LexA_LexAopGCaMP6f',driver); 
i_norpA_UASnorpA_L2LexA_LexAopGCaMP6f = strcmpi('norpA_UASnorpA_L2LexA_LexAopGCaMP6f',driver);
i_rh1NorpA_L2LexA_LexAopGCaMP6f = strcmpi('rh1NorpA_L2LexA_LexAopGCaMP6f',driver);

i_norpA_UASnorpA_L3QF_QUAS_GCaMP6f = strcmpi('norpA_UASnorpA_L3QF_QUAS_GCaMP6f',driver);
i_panR8_L3QF_QUAS_GCaMP6f = strcmpi('panR8_L3QF_QUAS_GCaMP6f',driver);
i_rh1NorpA_L3QF_QUAS_GCaMP6f = strcmpi('rh1NorpA_L3QF_QUAS_GCaMP6f',driver);


%L2 and L3 csChrimson
i_NorpA_L3_GCaMP6f_csChrimson = strcmpi('NorpA_L3_GCaMP6f_csChrimson',driver);
i_NorpA_L2_GCaMP6f_csChrimson = strcmpi('NorpA_L2_GCaMP6f_csChrimson',driver);

%L2 and L3 csChrimson - control no retinal in the food
i_NorpA_L3_GCaMP6f_csChrimson_noRetinal = strcmpi('NorpA_L3_GCaMP6f_csChrimson_noRetinal',driver);
i_NorpA_L2_GCaMP6f_csChrimson_noRetinal = strcmpi('NorpA_L2_GCaMP6f_csChrimson_noRetinal',driver);

%L2 and L3 csChrimson - control no Chrimson
i_NorpA_L3_GCaMP6f = strcmpi('NorpA_L3_GCaMP6f',driver);

%current 150 - for the ND filters experiment
i_UASGCaMP6f_MH56Gal4_L3_150_ND0 = strcmpi('UASGCaMP6f_L221DhhGal4_MH56Gal4_L3_150_ND0',driver);
i_UASGCaMP6f_MH56Gal4_L3_150_ND06 = strcmpi('UASGCaMP6f_L221DhhGal4_MH56Gal4_L3_150_ND06',driver);
i_UASGCaMP6f_MH56Gal4_L3_150_ND13 = strcmpi('UASGCaMP6f_L221DhhGal4_MH56Gal4_L3_150_ND13',driver);

i_UASGCaMP6f_L221DhhGal4_L2_150_ND0 = strcmpi('UASGCaMP6f_L221DhhGal4_MH56Gal4_L2_150_ND0',driver);
i_UASGCaMP6f_L221DhhGal4_L2_150_ND06 = strcmpi('UASGCaMP6f_L221DhhGal4_MH56Gal4_L2_150_ND06',driver);
i_UASGCaMP6f_L221DhhGal4_L2_150_ND13 = strcmpi('UASGCaMP6f_L221DhhGal4_MH56Gal4_L2_150_ND13',driver);

% GCaMP3 in mitochondria
i_UASGCaMP6F_L221DhhGal4_UAS4mt_GCaMP3 = strcmpi('UASGCaMP6F_L221DhhGal4_UAS4mt_GCaMP3',driver);

