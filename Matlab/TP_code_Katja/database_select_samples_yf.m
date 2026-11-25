% script to read in database and make various categories...

[fname,datetime,frames,zdepth,tottime,stimbouts,locnum,...
    activecells,inverted,stimcode,quality,driver,...
    moving,layer,wavelength,flyID, responsivefly]...
    =textscan('MASTER_foldersummary_Katja.txt',...
    '%s %s %f %f %f %f %f %s %f %s %f %s %f %s %f %f %f \r',...
    'headerlines',1,'delimiter','\t');
%MS: %s reads a white space or delimiter separated string, %f a floating-point value
% reads now string for layers

%Standing Stripe stimuli either with dark or light bars 
%horizonal or vertical bars


% Full contrast version of the stimuli:
i_standingStripe_LumDec_Vert = strcmpi('StandingStripe_1sec_VerAx_5_7deg_LumDec_rand_USEFRUSTUM',(stimcode)); 
i_standingStripe_LumDec_Horiz = strcmpi('StandingStripe_1sec_HorizAx_5_5deg_LumDec_rand_USEFRUSTUM',(stimcode)); 

i_standingStripe_LumInc_Vert = strcmpi('StandingStripe_1sec_VerAx_5_7deg_LumInc_rand_USEFRUSTUM',(stimcode)); 
i_standingStripe_LumInc_Horiz = strcmpi('StandingStripe_1sec_HorizAx_5_5deg_LumInc_rand_USEFRUSTUM',(stimcode)); 



% lower contrast version of the stimuli:
i_standingStripe_LumDec_Vert_0_01 = strcmpi('StandingStripe_1sec_VerAx_5_7deg_Lum0.01Dec_rand_USEFRUSTUM',(stimcode)); 
i_standingStripe_LumDec_Vert_0_05 = strcmpi('StandingStripe_1sec_VerAx_5_7deg_Lum0.05Dec_rand_USEFRUSTUM',(stimcode)); 

% lower contrast version of the stimuli:
i_standingStripe_LumInc_Vert_0_01 = strcmpi('StandingStripe_1sec_VerAx_5_7deg_Lum0.01Inc_rand_USEFRUSTUM',(stimcode)); 
i_standingStripe_LumInc_Vert_0_05 = strcmpi('StandingStripe_1sec_VerAx_5_7deg_Lum0.05Inc_rand_USEFRUSTUM',(stimcode)); 


% Grey ON /Grey OFF stimuli (written by Luis)
i_standingStripe_LumDec_Horiz = strcmpi('StandingStripe_1sec_HorizAx_5_5deg_LumDec_rand_USEFRUSTUM',(stimcode)); 


i_fff2s  = strcmpi('LocalCircle_2sec_220deg_0degAz_0degEl_Sequential_LumDec_LumInc',(stimcode)); 
i_fff5s  = strcmpi('LocalCircle_5sec_220deg_0degAz_0degEl_Sequential_LumDec_LumInc',(stimcode)); 
i_fff300ms  = strcmpi('LocalCircle_300ms_220deg_0degAz_0degEl_Sequential_LumDec_LumInc',(stimcode));
i_fff60s  = strcmpi('LocalCircle_60sec_220deg_0degAz_0degEl_Sequential_LumDec_LumInc - Copy',(stimcode));

i_fff2sONgrayOFF  = strcmpi('LocalCircle_2sONgrayOFFgray_120deg_0degAz_0degEl_2Lum',(stimcode)); 
i_fff5sONgrayOFF  = strcmpi('LocalCircle_5sONgrayOFFgray_120deg_0degAz_0degEl_2Lum',(stimcode)); 
i_fff25msecONgrayOFF  = strcmpi('LocalCircle_25ms_120deg_0degAz_0degEl_ONgrayOFFgray_2Lum',(stimcode)); 
i_fff_steps_2sONgrayOFF  = strcmpi('LocalCircle_0.1steps_2sONgrayOFFgray_120deg_0degAz_0degEl_2Lum-random',(stimcode)); 

% Added by Fabiola for 25ms
i_fffOngrayOFF25ms = strcmpi('LocalCircle_ONgreyOFF_25ms_BG_2s_120deg_0degAz_0degEl_100_Con_0.5Lum', (stimcode));


i_mb_luminc_20degs_5deg_8dir = strcmpi('DriftingStripe_LumInc_1period_20degPerSec_5deg_BlankRand_8Dir',(stimcode));
i_mb_lumdec_20degs_5deg_8dir = strcmpi('DriftingStripe_LumDec_1period_20degPerSec_5deg_BlankRand_8Dir',(stimcode));
i_mb_lumdec_20degs_5deg_8dir_copy = strcmpi('DriftingStripe_LumDec_1period_20degPerSec_5deg_BlankRand_8Dir - Copy',(stimcode));

i_mb_lumdec_20degs_10deg_8dir = strcmpi('DriftingStripe_LumDec_1period_20degPerSec_10deg_BlankRand_8Dir',(stimcode));
i_mb_luminc_20degs_10deg_8dir = strcmpi('DriftingStripe_LumInc_1period_20degPerSec_10deg_BlankRand_8Dir',(stimcode));


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


% L2 vs L3
i_UASGCaMP6F_L221DhhGal4 = strcmpi('UASGCaMP6F_L221DhhGal4',driver);
i_UASGCaMP6F_L30595Gal4 = strcmpi('UASGCaMP6F_L30595Gal4',driver);
i_UASGCaMP6F_L3MH56Gal4 = strcmpi('UASGCaMP6F_L3MH56Gal4',driver);

% GCaMP3
i_UASGCaMP3_L221DhhGal4 = strcmpi('UASGCaMP3_L221DhhGal4',driver);
i_UASGCaMP3_L3MH56Gal4 = strcmpi('UASGCaMP3_L3MH56Gal4',driver);

% PTX experiment
i_UASGCaMP6F_L3MH56Gal4_PTX = strcmpi('UASGCaMP6F_L3MH56Gal4_PTX',driver);
i_UASGCaMP6F_L221DhhGal4_PTX = strcmpi('UASGCaMP6F_L221DhhGal4_PTX',driver);

% Presynaptic marker
i_UASsyp_L221DhhGal4 = strcmpi('UASsyp_L221DhhGal4',driver);
i_UASsyp_L30595Gal4 = strcmpi('UASsyp_L30595Gal4',driver);

% Postsynaptic marker
i_UAShomer_L221DhhGal4 = strcmpi('UAShomerGCaMP3_L221DhhGal4',driver);

% Vesicle release
i_UASsypGCaMP3_L3MH56Gal4 = strcmpi('UASsypGCaMP3_L3MH56Gal4',driver);

% Voltage sensors ASAP2
i_pJFRCASAP2s_L221DhhGal4 = strcmpi('pJFRCASAP2s_L221DhhGal4',driver);
i_pJFRCASAP2s_L30595Gal4 = strcmpi('pJFRCASAP2s_L30595Gal4',driver);
i_pJFRCASAP2s_L3MH56Gal4 = strcmpi('pJFRCASAP2s_L3MH56Gal4',driver);

i_pJFRCASAP2f_L221DhhGal4 = strcmpi('pJFRCASAP2f_L221DhhGal4',driver);
i_pJFRCASAP2f_L3MH56Gal4 = strcmpi('pJFRCASAP2f_L3MH56Gal4',driver);

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
