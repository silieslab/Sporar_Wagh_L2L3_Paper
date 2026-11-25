clc;
clear all;
close all;

%x=load_data_set('E:\damon\new_TP_pdata\','110518*');
x=load_data_set('/Users/msilies/Fiala_2p/Katja_pData','150812ks_fly6*');
% x=load_data_set('/Users/Kunibert/CalciumImaging/MarionYvette_pData','141009m_fly5*');

angs = [0 pi pi/2 3*pi/2];
% mb_str = {'moving_single_bar_grid_rperm_csl_inv_wide'}; 
mb_str = {'DriftingStripe_LumDec_1period_20degPerSec_5deg_BlankRand_8Dir - Copy'}; 
% mb_str = {'moving_single_bar_grid_rperm_csl_inv_wide'}; 
% mb_str = {'moving_single_bar_grid_rperm_csl_md20_wide_inv_3contrasts'}; 
% mb_str = {'moving_single_bar_grid_rperm_csl_md20_wide'}; 


for ii = 1:length(x)
    if(strcmp(x{ii}.strct.stim_type,mb_str))
      
        
    %if length(x{ii}.strct.ratio == 1800) %ms, temp, 
    
    %ms: this is to reassign where the data is, I think I don't need this as long
    % as the processing has been done on my computer and I didn't move
    % around data
%         fileloc = x{ii}.strct.fileloc;
%         sinds = find(fileloc=='/');
%         fileloc(1:(sinds(4)-1)) = [];
%         fileloc = ['E:' fileloc];
%         x{ii}.strct.fileloc = fileloc;
       
        % temp patch because I don't have position information yet
%         %ms: can be commented out now, there is position information in the
%         %pdata file (x) now
%         curdir = pwd;
%         cd(fileloc);
%         d = dir('_stimulus_output*');
%         A = importdata(d.name);
%         fstimpos1 = zeros(A.data(end,7),1);
%         fstimpos2 = zeros(A.data(end,7),1);
%         for k = 1:(A.data(end,7))
%             cinds = find(A.data(:,7) == k);
%             if(~isempty(cinds))
%                 fstimpos1(k) = A.data(cinds(1),4);
%                 fstimpos2(k) = A.data(cinds(1),5);
%             else
%                 fstimpos1(k) = A.data(1,4);
%                 fstimpos2(k) = A.data(1,5);
%             end
%         end
%         cd(curdir);

        fstimpos1 = x{ii}.strct.fstimpos1;
        fstimpos2 = x{ii}.strct.fstimpos2;
        x{ii}.strct.fileloc
        s = x{ii}.strct.fstimval;
       
       %ms: sometimes, the fstimval is 0 - either at the beginning or in
       %the middle of an epoch, because a frame is missing in the stim
       %output file. these make epochs shorter than they are, get rid of
       %the zeros in there.
       s(1) = s(find(s,1,'first')); %ms: replaces s(1) by the first non zero element
 
       for kk=1:length(s) %ms: set these other weird 0 values within an epoch to the value preceding it
            if s(kk)==0
               s(kk)=s(kk-1);
               disp(['fixed bug in istim of ' x{ii}.strct.fileloc]);
            end
        end
        
        ds = diff(s);
        inds = find(ds~=0)+1; % ignoring the first epoch...
        
        epochs = s(inds); 
        t = [1:length(s)]/x{ii}.strct.xml.framerate;
        n_cells = size(x{ii}.strct.ratio,1);
        epoch_res = cell(n_cells,4);
        epoch_pos = cell(4);
        for jj = 1:4
            I = find(epochs==jj,1,'first');
            bind = inds(I);
            eind = inds(I+1)-1;
            for c = 1:n_cells
                epoch_res{c,jj} = x{ii}.strct.ratio(c,bind:eind)./mean(x{ii}.strct.ratio(c,bind:eind));
            end
            epoch_pos{jj} = fstimpos1(bind:eind);
        end
        centers = zeros(n_cells,2);
        for c = 1:n_cells
            real = 1;
            for jj = [1 3]
                cur_pos1 = epoch_pos{jj};
                cur_pos2 = fliplr(epoch_pos{jj+1}')';
                len = length(cur_pos1);
                figure(1);plot(epoch_res{c,jj});hold on;
                plot(fliplr(epoch_res{c,jj+1}),'k');
                if(jj==1)
                    title('x center');
                else
                    title('y center');
                end
                if(strcmp(input('real?','s'),'y'))
                    title('select RF center');
                    [v,dum] = ginput(1);
                    v = round(v);
                    if(jj == 1)
                        xc = (cur_pos1(v)+cur_pos2(len-v+1))/2;
                    else
                        yc = (cur_pos1(v)+cur_pos2(len-v+1))/2;
                    end
                else
                    real = 0;
                end
                close(1);
            end
            if(real==1)
                centers(c,:) = [xc; yc];
            else
                centers(c,:) = [500; 500];
            end
        end
        x{ii}.strct.centers = centers;
    end
end
   
for ii = 1:length(x)
    out = x{ii}.strct;
%     fileloc = x{ii}.strct.fileloc;
%     sinds = find(fileloc=='\');
%     fileloc(1:(sinds(4)-1)) = [];
%     fileloc = ['E:' fileloc];
%     out.fileloc = fileloc;
    save_processed_data_1ch_eni(out);
end

%% Match MB identified centers to other responses - use zdepth

% ms: modified from moving_bars_rperm_set_locations_MS_1ch
% now only uses one stim_type for matching, and excluded another stim type
% from matching. 
% Reason: if you independently picked RFs for two different moving bar
% stimuli, you don't want to overwrite, but only use one of those to match
% non-moving bar stimuli.

clc;
clear all;
close all;

x=load_data_set('/Users/Kunibert/CalciumImaging/MarionDaryl_pData','141125y_fly5*');
% x= load_data_set('/Users/Kunibert/CalciumImaging/MarionYvette_pData/','141009m_fly5*');

zdepth = zeros(length(x),1);

% stim_types = 'moving_single_bar_grid_rperm_csl_md20_wide_inv';
% %ms: exclude stimtypes where the RF center shouldn't be replaced
% stim_types_nogo = 'moving_single_bar_grid_rperm_csl_md20_wide';

stim_types = 'moving_single_bar_grid_rperm_csl_md20_wide_inv';
%ms: exclude stimtypes where the RF center shouldn't be replaced
% stim_types_nogo = 'moving_single_bar_grid_rperm_csl_md20_wide';
stim_types_nogo = 'moving_single_bar_grid_rperm_csl_md20_wide';


stims = cell(length(x),1);
for ii = 1:length(x)
    zdepth(ii) = x{ii}.strct.xml.zdepth;
    
    stims{ii} = x{ii}.strct.stim_type;
end

zdepth = zdepth*10^6; % in um
uzdepth = unique(zdepth);
for u = 1:length(uzdepth)
    
    inds = find(zdepth==uzdepth(u));
    temp_stims = stims(inds);
    i_mb = zeros(length(temp_stims),1);
    i_mb_not = zeros(length(temp_stims),1);

%     for j = 1:length(stim_types)
%         % temp - until I start using rperm_csl only
%         i_mb = i_mb + strcmpi(stim_types{j},temp_stims)
%     end
    
    % ms:one stim type to compare to
    i_mb = i_mb + strcmpi(stim_types,temp_stims);
    i_mb_not = i_mb_not + strcmpi(stim_types_nogo,temp_stims); %ms
    
    mb_ind = find(i_mb);
    mb_ind_not = find(i_mb_not); %ms
      
    % otherwise you are comparing to an empty array later if mb_ind_not
    % was not run- yf
    if (isempty(mb_ind_not))
            mb_ind_not=0;
    end
      
    if(~isempty(mb_ind))
        % make reference figures
        figure;
        FFFlash_res_display_1ch(x{inds(mb_ind)}.strct,2);close(1);
        figure;imshow(x{inds(mb_ind)}.strct.AV1,[]);
        for j = 1:length(inds)
            if(j ~= mb_ind & j ~= mb_ind_not) %ms: is not the mb index that we use for matching AND not the one that we excluded from matching
                figure;FFFlash_res_display_1ch(x{inds(j)}.strct,2);close (4);
                figure;imshow(x{inds(j)}.strct.AV1,[]);
                list = input('list correspondence indices:','s');
                nums = str2num(list);
                centers = zeros(length(nums),2);
                for n = 1:length(nums)
                    if(nums(n)==-1)
                        centers(n,:) = [500 500];
                    else
                        centers(n,:) = x{inds(mb_ind)}.strct.centers(nums(n),:);
                    end
                end
                x{inds(j)}.strct.centers = centers;
                x{inds(j)}.strct.cell_nums = nums;
                close([4 5 6]);
            end
        end
        close all;
    else
        for j = 1:length(inds)
            x{inds(j)}.strct.centers = -500 * ones(length(x{inds(j)}.strct.masks),2);
        end
    end
end

for ii = 1:length(x)
    out = x{ii}.strct;
%     fileloc = x{ii}.strct.fileloc;
%     sinds = find(fileloc=='\');
%     fileloc(1:(sinds(4)-1)) = [];
%     fileloc = ['E:' fileloc];
%     out.fileloc = fileloc;
    save_processed_data(out);
end
            