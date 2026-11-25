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
% addpath('Z:\f.buschendorf\TP_code_Katja');

x=load_data_set('/Users/ksporar/Documents/MATLAB/Katja_pData','171211ks_fly7*');
% x=load_data_set('Z:\#Common\forFabiola\3_luminances\new_171011ks\pdata','170925ks_fly2_Image 1_pData*');


NUM_EPOCHS= 24; %we have 25 epochs, but the first one (0) is grey

% mb_str = {'DriftingStripe_10deg_20degPerSek_8Directions_3luminances_darkOnBright_ks'};
% mb_str = {'DriftingEDGE_10deg_20degPerSek_8Directions_3luminances_darkOnBright_WeberContrast'};
mb_str = {'DriftingStripe_10deg_20degPerSek_8Directions_3luminances_darkOnBright_WeberContrast'};




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
        epoch_res = cell(n_cells,NUM_EPOCHS); % signal normalized per cell
        epoch_pos = cell(NUM_EPOCHS,1); % position of stimulus
        for jj = 1:NUM_EPOCHS %24
            % epochs: epochs shown in random sequence, find first index
            % where epochs == jj
            I = find(epochs==jj,1,'first'); %to deal with the random order
            
            %I don' want to select the centers for all three luminances, but only for one! So, if epoch 1, also want 2 and 3
            %             J = I+1;
            %             K = I+2;
            %
            %             I = [I J K];
            
            bind = inds(I); %first beginning of the epoch jj
            eind = interepochstarts(I)-1;
            
            for c = 1:n_cells
                % normalize signal for every cell
                epoch_res{c,jj} = x{ii}.strct.ratio(c,bind:eind)./mean(x{ii}.strct.ratio(c,bind:eind));
            end
            % position of stimulus during this epoch
            epoch_pos{jj} = fstimpos1(bind:eind);
        end
        % Center for every cell and epoch
        centers = zeros(n_cells,NUM_EPOCHS);
        for c = 1:n_cells
            centers(c,:) = 500;  % preset to default values-yf
            
            for jj = [1 4 13 16] %0 90 45 135
                str = ['Dataset=',num2str(ii),', cell=',num2str(c),', epoch=',num2str(jj)];
                disp(str)
                cur_pos1 = epoch_pos{jj}; % load positions from this epoch
                
                len = length(cur_pos1);
                
                % Plot this epochs' signal and the reverse stimulus (e.g.
                % 90? and 270?)
                figure(1);
                inv_fstimpos2 = (epoch_pos{jj+6})*(-1); % Not sure if -1 is correct -> this inverts signal trace
                plot(cur_pos1,epoch_res{c,jj});
                hold on;
                plot(inv_fstimpos2,epoch_res{c,jj+6},'k')%fine
                ylim([0 2.5])
                xlim([-50 50])
                
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
                    [v,dum] = ginput(1);  %input v=0
                    v = round(v);
                    %centers(c,:) = [xc; yc];
                    if(jj == 1)
                        xc = v;
                        centers(c,jj) = xc;  % set X values to user input
                        centers(c,jj+1) = xc;
                        centers(c,jj+2) = xc;
                        centers(c,jj+6) = xc;
                        centers(c,jj+7) = xc;
                        centers(c,jj+8) = xc;
                    elseif(jj == 4)
                        yc = v;
                        centers(c,jj) = yc;  % set X values to user input
                        centers(c,jj+1) = yc;
                        centers(c,jj+2) = yc;
                        centers(c,jj+6) = yc;
                        centers(c,jj+7) = yc;
                        centers(c,jj+8) = yc;
                    elseif (jj == 13)
                        tc_1 = v/sqrt(2);
                        centers(c,jj) = tc_1;  % set X values to user input
                        centers(c,jj+1) = tc_1;
                        centers(c,jj+2) = tc_1;
                        centers(c,jj+6) = tc_1;
                        centers(c,jj+7) = tc_1;
                        centers(c,jj+8) = tc_1;
                    elseif (jj == 16)
                        tc_2 = v/sqrt(2);
                        centers(c,jj) = tc_2;  % set X values to user input
                        centers(c,jj+1) = tc_2;
                        centers(c,jj+2) = tc_2;
                        centers(c,jj+6) = tc_2;
                        centers(c,jj+7) = tc_2;
                        centers(c,jj+8) = tc_2;
                    end
                else
                    %                 real = 0;
                    %                 centers(c,:) = [500; 500];
                end
                close(1);
            end
        end
        x{ii}.strct.centers = centers;
    end
end

for ii = 1:length(x)

    % Added only for Fabi PC
%     x{ii}.strct.fileloc = 'Z:\#Common\forFabiola\3_luminances\new_171011ks\pdata_new'
    
    out = x{ii}.strct;
    save_processed_data_1ch_eni(out);
    
end



