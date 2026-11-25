%% 
clear all
close all
clc

genotype='T4_T5_GMR59E08lexA';
%genotype='T4_T5_GMR79D04Gal4';

Figuretitle=(['T4 & T5 Responses,  Line: ', genotype]);
LAYERS=['A','B','C','D']


for i=1:4     

LAYER=LAYERS(i);
load(['/Users/mhennin2/Documents/DataAnalysis/Data/',genotype,'/LP',LAYERS(i)], 'mL2f', 'mmL2f', 'smL2f','mod_t','L2_mb','fL2_mb','f_mb_L2','aL2', 'onscreen')


if(strcmp(LAYER,'A'))
        mL2f_A=mL2f;
        mmL2f_A=mmL2f;
        smL2f_A=smL2f;
        mod_t_A=mod_t; 
        L2_mb_A=L2_mb;
        fL2_mb_A=fL2_mb;
        f_mb_L2_A=f_mb_L2;
        aL2_A=aL2;
        onscreen_A=onscreen;

elseif(strcmp(LAYER,'B'))
        mL2f_B=mL2f;
        mmL2f_B=mmL2f;
        smL2f_B=smL2f;
        mod_t_B=mod_t;
        L2_mb_B=L2_mb;
        fL2_mb_B=fL2_mb;
        f_mb_L2_B=f_mb_L2;
        aL2_B=aL2;
        onscreen_B=onscreen;
        
elseif(strcmp(LAYER,'C'))
        mL2f_C=mL2f;
        mmL2f_C=mmL2f;
        smL2f_C=smL2f;
        mod_t_C=mod_t;
        L2_mb_C=L2_mb;
        fL2_mb_C=fL2_mb;
        f_mb_L2_C=f_mb_L2;
        aL2_C=aL2;
        onscreen_C=onscreen;
else
        mL2f_D=mL2f;
        mmL2f_D=mmL2f;
        smL2f_D=smL2f;
        mod_t_D=mod_t;
        L2_mb_D=L2_mb;
        fL2_mb_D=fL2_mb;
        f_mb_L2_D=f_mb_L2;
        aL2_D=aL2;
        onscreen_D=onscreen;
end

end 



%PolarPlot
PP=figure('Color', [1 1 1])


for i=1:4 %four Layers
LAYERS=['A','B','C','D']
tuningPdirPFly=mean(eval(['mL2f_',LAYERS(i)]),3); %tuning (strength or response) per direction and per fly
mtuningPdir=mean(tuningPdirPFly,2)
stuningPdir=std(tuningPdirPFly')/sqrt(length(tuningPdirPFly))

mtuningPdir=mtuningPdir+min(mtuningPdir)*-1;

onedeg=2*pi/360; %in rad 


%theta=[0, 45, 90, 135, 180, 225, 270, 315,0]; assignment of mov directions
%is weird 

theta=[90, 45, 0, 315, 270, 225, 180, 135, 90];
theta=theta*onedeg;
rho=[mtuningPdir;mtuningPdir(1)]';
Color=['b','g','r','y'];    
PPp=polar(theta,rho,Color(i))
set(PPp,'LineWidth', 1.5)
%set(PPp,'FontSize',24)
hold on 


end 
 
L1=['Layer A: (N flies = ', num2str(length(unique(aL2_A.flyID(onscreen_A)))), ',  N ROIs = ' num2str(sum(onscreen_A)) ')'];
L2=['Layer B: (N flies = ', num2str(length(unique(aL2_B.flyID(onscreen_B)))), ',  N ROIs = ' num2str(sum(onscreen_B)) ')'];
L3=['Layer C: (N flies = ', num2str(length(unique(aL2_C.flyID(onscreen_C)))), ',  N ROIs = ' num2str(sum(onscreen_C)) ')'];
L4=['Layer D: (N flies = ', num2str(length(unique(aL2_D.flyID(onscreen_D)))), ',  N ROIs = ' num2str(sum(onscreen_D)) ')'];

legend(L1,L2,L3, L4)
title('Direction tuning T4/T5')
set(gca,'YTickLabel','')
set(gca,'FontSize',13)


%% Plot the standard error for Polar Plot 

for i=1:4 %four Layers
LAYERS=['A','B','C','D']
tuningPdirPFly=mean(eval(['mL2f_',LAYERS(i)]),3); %tuning (strength or response) per direction and per fly
mtuningPdir=mean(tuningPdirPFly,2)
stuningPdir=std(tuningPdirPFly')/sqrt(length(tuningPdirPFly))

mtuningPdir=mtuningPdir+min(mtuningPdir)*-1;

onedeg=2*pi/360; %in rad 


%theta=[0, 45, 90, 135, 180, 225, 270, 315,0]; assignment of mov directions
%is weird 

theta=[90, 45, 0, 315, 270, 225, 180, 135, 90];
theta=theta*onedeg;
rho=[mtuningPdir;mtuningPdir(1)]';
Color=['b','g','r','y'];    
 
PolarPlot_std

end 


%% 
% Plot the mean across flies again but each subplot containing all
% responses for one direction of movement 


MAF=figure('Color', [1 1 1])

title(Figuretitle)


spacer_counter=1; 

        COLOR_OF_PLOT = [0,0.5,0; 1,0,0;0.7,0.7,0;0,0,1];
        COLOR_CLOUD =[0.5,0.7,0.5;1,0.5,0.5;0.9,0.9,0.5;0.5,0.5,1];

TRACE_OFFSET_PLOT = 2; % spacing in dF/F between the traces for the 4 directions

for i= 1:4 % 4 DIRS_TO_PLOT  
    
    subplot(2,2,i)

   for ii=1:4 %4Layers)
       
       
     mmL2f=eval(['mmL2f_',LAYERS(ii)]); 
     smL2f=eval(['smL2f_',LAYERS(ii)]); 
     mod_t=eval(['mod_t_',LAYERS(ii)]); 
     
     range=(1:length(mod_t));
       
    plot_err_patch_v2(mod_t(range), TRACE_OFFSET_PLOT*spacer_counter -1 + mmL2f(i,range)-mean(mmL2f(ii,range)),smL2f(ii,range),COLOR_OF_PLOT(ii,:),COLOR_CLOUD(ii,:));

    line([mod_t(range(1)) mod_t(range(end))],[TRACE_OFFSET_PLOT*spacer_counter-1  TRACE_OFFSET_PLOT*spacer_counter-1],...
        'color',[0 0 0],'LineStyle','--');
    
    spacer_counter = spacer_counter + 1; % counter for plot spacing
   
   end
   
   YTickLabel=[];
   xlabel('time (sec)');
   ylabel('response (dF/F)');
   niceaxes;
end




%%


%***********************************************
%  4 DIRECTION PLOTS - by fly
%***********************************************
% plot mean across fly means
figure('Color',[1 1 1]); 

        COLOR_OF_PLOT = [0,0,1;0,0.5,0; 1,0,0;0.7,0.7,0];
        COLOR_CLOUD =[0.5,0.5,1;0.5,0.7,0.5;1,0.5,0.5;0.9,0.9,0.5];
LAYERS=['A','B','C','D']

TRACE_OFFSET_PLOT = 2; 

spacer_counter=1;  % since I changed the order, now we need a counter for spacing on the plot -yf

dirs = [0 45 90 135 180 225 270 315];

ind_dirs = dirs(1:2:7); % mh, to plot cardinal directions

for i=1:4 % four Layers
    subplot(2, 2, i)
    title(['Layer: ',LAYERS(i)])
     mmL2f=eval(['mmL2f_',LAYERS(i)]); 
     smL2f=eval(['smL2f_',LAYERS(i)]); 
     mod_t=eval(['mod_t_',LAYERS(i)]); 
    range=1:length(mod_t);
    
    spacer_counter=1;  % since I changed the order, now we need a counter for spacing on the plot -yf

for ii= 1:4  %DIRS_TO_PLOT   % changed to plot the degrees in order-yf
    dirtoplot=(1:2:7);
    d=dirtoplot(ii);
    
     
    plot_err_patch_v2(mod_t(range), TRACE_OFFSET_PLOT*spacer_counter -1 + mmL2f(d,range)-mean(mmL2f(d,range)),smL2f(d,range),COLOR_OF_PLOT(i,:),COLOR_CLOUD(i,:));

    line([mod_t(range(1)) mod_t(range(end))],[TRACE_OFFSET_PLOT*spacer_counter-1  TRACE_OFFSET_PLOT*spacer_counter-1],...
        'color',[0 0 0],'LineStyle','--');
%         line([mod_t(range(1)) mod_t(range(end))],[mean(mmL2f(ii,range))+TRACE_OFFSET_PLOT*spacer_counter-1 mean(mmL2f(ii,range))+TRACE_OFFSET_PLOT*spacer_counter-1],...
%         'color',[0 0 0],'LineStyle','--');
    %text(0.5+mod_t(range(1)),0.25 + TRACE_OFFSET_PLOT*spacer_counter-0.,num2str(dirs(d)));
   
    
    spacer_counter = spacer_counter + 1; % counter for plot spacing
   
   
end

 xlabel('time (sec)');
 set(gca,'YTickLabel',[])
 ylabel('response (dF/F)');

 niceaxes;

end 



    
    





    


