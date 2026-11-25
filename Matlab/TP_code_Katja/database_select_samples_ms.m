% script to read in database and make various categories...

[fname,datetime,frames,zdepth,tottime,stimbouts,locnum,...
    activecells,inverted,stimcode,quality,driver,...
    moving,layer,wavelength,flyID, responsivefly]...
    =textread('MASTER_foldersummary_Katja.txt',...
    '%s %s %f %f %f %f %f %s %f %s %f %s %f %s %f %f %f \r',...
    'headerlines',1,'delimiter','\t');
%MS: %s reads a white space or delimiter separated string, %f a floating-point value
% reads now string for layers

i_fff2s  = strcmpi('LocalCircle_2sec_220deg_0degAz_0degEl_Sequential_LumDec_LumInc',(stimcode)); 
i_fff5s  = strcmpi('LocalCircle_5sec_220deg_0degAz_0degEl_Sequential_LumDec_LumInc',(stimcode)); 

i_mb_luminc_20degs_5deg_8dir = strcmpi('DriftingStripe_LumInc_1period_20degPerSec_5deg_BlankRand_8Dir',(stimcode));
i_mb_lumdec_20degs_5deg_8dir = strcmpi('DriftingStripe_LumDec_1period_20degPerSec_5deg_BlankRand_8Dir',(stimcode));

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
i_Tm9LexAGCaMP6F_37C = strcmpi('Tm9LexAp65GCaMP6F_37C',driver);
i_Tm9LexAGCaMP6F_shits_37C = strcmpi('Tm9LexAp65GCaMP6F_UASshitsR_37C',driver);
i_Tm9LexAGCaMP6F_shits_37C_TM6B = strcmpi('Tm9LexAp65GCaMP6F_UASshitsR_TM6B_37C',driver);
i_Tm9LexAGCaMP6F_L1shits_37C = strcmpi('Tm9LexAp65GCaMP6F_L1c202ashitsR_37C',driver);
i_Tm9LexAGCaMP6F_L2shits_37C = strcmpi('Tm9LexAp65GCaMP6F_L221DhhshitsR_37C',driver);
i_Tm9LexAGCaMP6F_L3shits_37C = strcmpi('Tm9LexAp65GCaMP6F_L30595shitsR_37C',driver);
i_Tm9LexAGCaMP6F_L2L3shits_37C = strcmpi('Tm9LexAp65GCaMP6F_L221Dhh0595_shitsR_37C',driver);
i_Tm9LexAGCaMP6F_LL = strcmpi('Tm9LexAp65GCaMP6F_3d_LL',driver);
i_Tm9LexAGCaMP6F_LD = strcmpi('Tm9LexAp65GCaMP6F_3d_LD',driver);

i_Tm9LexAGCaMP6F_Kir2_1 = strcmpi('Tm9LexAlexAopGCaMP6f_UASKir2.1',driver);
i_Tm9LexAGCaMP6F_Kir2_1 = strcmpi('Tm9LexAlexAopGCaMP6f_UASKir2.1',driver);



i_T4T5GCaMP6F_Tm9LexA_shitsattP2 =  strcmpi('T4T5G4_UAS6F_Tm9LexA_lexAopshitsattP2', driver); 
i_T4T5GCaMP6F_Tm9LexA =  strcmpi('T4T5G4_UAS6F_Tm9LexA', driver); 
i_T4T5GCaMP6F_lexAopshitsattP2 =  strcmpi('T4T5G4_UAS6F_lexAopshitsattP2', driver); 


