%% moving_bar_rperm_set_XorYcenters_8Dirs_driftingStripe_3luminances
% modified: moving_bar_rperm_set_XorYcenters_8Dirs_eni

% to get the center positions for the analysis of the explore_movebar_8Dirs_onePlot_3_luminances_fb

% stimulus: DriftingStripe_10deg_20degPerSek_8Directions_3luminances_darkOnBright_ks
% We have bars moving in 8 directions at three different luminances (25% on 75% - darkgrey bar on brightgrey BG; 0% on 50% - dark bar on grey BG; 50% on 100% - grey bar on bright BG).
% Between the bar presentations (5s) we have 3s of gray background. 
% dirs = [0,0,0,90,90,90,180,180,180,270,270,270,45,45,45,135,135,135,225,225,225,315,315,315] -> 24 epochs

% Katja May 2017

clc;
clear all;
close all;


% x=load_data_set('/Users/ksporar/Documents/MATLAB/Katja_pData','161220ks_fly4*');
x=load_data_set('/Users/ksporar/Documents/MATLAB/Katja_pData','170905ks_fly1*');


NUM_EPOCHS= 24; %we have 25 epochs, but the first one (0) is grey

mb_str = {'DriftingStripe_10deg_20degPerSek_8Directions_3luminances_darkOnBright_ks'}; 

for ii = 1:length(x)
    if(strcmp(x{ii}.strct.stim_type,mb_str))
        x{ii}.strct.stim_type


        fstimpos1 = x{ii}.strct.fstimpos1;
        fstimpos2 = x{ii}.strct.fstimpos2;
        x{ii}.strct.fileloc
        s = x{ii}.strct.fstimval;
       
        ds = diff(s);
        inds = find(ds>0)+1; % ignoring the first epoch... %epochstarts
        interepochstarts = find(ds<0)+1; 
        
        epochs = s(inds); 
        t = [1:length(s)]/x{ii}.strct.xml.framerate;
        n_cells = size(x{ii}.strct.ratio,1);
        epoch_res = cell(n_cells,NUM_EPOCHS);
        epoch_pos = cell(NUM_EPOCHS);
        for jj = 1:NUM_EPOCHS %24
            I = find(epochs==jj,1,'first'); %to deal with the random order  
            
            %I don' want to select the centers for all three luminances, but only for one! So, if epoch 1, also want 2 and 3
%             J = I+1;
%             K = I+2;
%             
%             I = [I J K];
            
            bind = inds(I); %beginning of the epoch
            eind = interepochstarts(I)-1;

            for c = 1:n_cells
                epoch_res{c,jj} = x{ii}.strct.ratio(c,bind:eind)./mean(x{ii}.strct.ratio(c,bind:eind));
            end
            epoch_pos{jj} = fstimpos1(bind:eind);
        end
        centers = zeros(n_cells,NUM_EPOCHS/2);
        for c = 1:n_cells
            centers(c,:) = 500;  % preset to default values-yf

            for jj = [1 4 13 16] %0 90 45 135
                cur_pos1 = epoch_pos{jj};

                len = length(cur_pos1);

                  figure(1);
                  inv_fstimpos2 = (epoch_pos{jj+6})*(-1);
                  plot(cur_pos1,epoch_res{c,jj});hold on;
                  plot(inv_fstimpos2,epoch_res{c,jj+6},'k')%fine

%                 if(jj==1)
%                     title('x center');
%                 elseif(jj==4)
%                     title('y center');
%                 elseif(jj==13)
%                     title('tilted_1');
%                 elseif (jj==16)
%                     title('tilted_2')
%                 elseif(jj==2)
%                     title('x center');
%                 elseif(jj==5)
%                     title('y center');
%                  elseif(jj==14)
%                     title('tilted_1');
%                 elseif (jj==17)
%                     title('tilted_2');
%                 elseif(jj==3)
%                     title('x center');
%                 elseif(jj==6)
%                     title('y center');
%                  elseif(jj==15)
%                     title('tilted_1');
%                 else
%                     title('tilted_2')   
%                 end

                if(jj==1)
                    title('x center');
                elseif(jj==4)
                    title('y center');
                elseif(jj==13)
                    title('tilted_1');
                elseif(jj==16)
                    title('tilted_2');
                end

                
                if(strcmp(input('real?','s'),'y'))
                    title('select RF center');
                    [v,dum] = ginput(1);  %input
                    v = round(v);
                    if(jj == 1)
                        xc = v;
                        centers(c,1) = xc;  % set X values to user input
                    elseif(jj == 4)
                        yc = v;
                        centers(c,2) = yc;  % set X values to user input
                    elseif (jj == 13)
                        tc_1 = v/sqrt(2); 
                        centers(c,3) = tc_1;  % set X values to user input
                    elseif (jj == 16)
                        tc_2 = v/sqrt(2);
                         centers(c,4) = tc_2;  % set X values to user input 
        
                
%                 if(strcmp(input('real?','s'),'y'))
%                     title('select RF center');
%                     [v,dum] = ginput(1)  %input
%                     v = round(v);
%                     if(jj == 1)    %0,180,90,270,45,135,225,315 old
% %                         xc = (cur_pos1(v)+cur_pos2(len-v+1))/2;
%                         xc = v;
%                         centers(c,1) = xc;  % set X values to user input
%                     elseif(jj == 4)
% %                         yc = (cur_pos1(v)+cur_pos2(len-v+1))/2;
%                         yc = v;
%                         centers(c,2) = yc;  % set X values to user input
%                     elseif (jj == 13)
% %                         tc_1 = (cur_pos1(v)+cur_pos2(len-v+1))/2;
%                         tc_1 = v/sqrt(2); % also cosd(45)*v;
%                         centers(c,3) = tc_1;  % set X values to user input
%                     elseif (jj == 16)
% %                         tc_2 = (cur_pos1(v)+cur_pos2(len-v+1))/2;
%                         tc_2 = v/sqrt(2); % also cosd(45)*v;
%                          centers(c,4) = tc_2;  % set X values to user input
%                     elseif(jj == 2)    %0,180,90,270,45,135,225,315 old
% %                         xc = (cur_pos1(v)+cur_pos2(len-v+1))/2;
%                         xc = v;
%                         centers(c,5) = xc;  % set X values to user input
%                     elseif(jj == 5)
% %                         yc = (cur_pos1(v)+cur_pos2(len-v+1))/2;
%                         yc = v;
%                         centers(c,6) = yc;  % set X values to user input
%                     elseif (jj == 14)
% %                         tc_1 = (cur_pos1(v)+cur_pos2(len-v+1))/2;
%                         tc_1 = v/sqrt(2); % also cosd(45)*v;
%                         centers(c,7) = tc_1;  % set X values to user input
%                     elseif (jj == 17)
% %                         tc_2 = (cur_pos1(v)+cur_pos2(len-v+1))/2;
%                         tc_2 = v/sqrt(2); % also cosd(45)*v;
%                          centers(c,8) = tc_2;  % set X values to user input     
%                     elseif(jj == 3)    %0,180,90,270,45,135,225,315 old
% %                         xc = (cur_pos1(v)+cur_pos2(len-v+1))/2;
%                         xc = v;
%                         centers(c,9) = xc;  % set X values to user input
%                     elseif(jj == 6)
% %                         yc = (cur_pos1(v)+cur_pos2(len-v+1))/2;
%                         yc = v;
%                         centers(c,10) = yc;  % set X values to user input
%                     elseif (jj == 15)
% %                         tc_1 = (cur_pos1(v)+cur_pos2(len-v+1))/2;
%                         tc_1 = v/sqrt(2); % also cosd(45)*v;
%                         centers(c,11) = tc_1;  % set X values to user input
%                     elseif (jj == 18)
% %                         tc_2 = (cur_pos1(v)+cur_pos2(len-v+1))/2;
%                         tc_2 = v/sqrt(2); % also cosd(45)*v;
%                          centers(c,12) = tc_2;  % set X values to user input     
%                          
                         
                    end
                else
%                     real = 0;
                end
                close(1);
            end
%             if(real==1)
%                 centers(c,:) = [xc; yc];
%             else
%                 centers(c,:) = [500; 500];
%             end
        end
        x{ii}.strct.centers = centers;
    end
end

for ii = 1:length(x)
    out = x{ii}.strct;
    save_processed_data_1ch_eni(out);

end



            