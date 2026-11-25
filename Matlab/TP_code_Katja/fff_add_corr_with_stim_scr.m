%% Match FFF responses to other responses - use zdepth

% ms: modified from moving_bars_rperm_set_XorYcenters_8Dirs
% now only uses one stim_type for matching, and excluded another stim type
% from matching. 
% Reason: if you independently picked RFs for two different moving bar
% stimuli, you don't want to overwrite, but only use one of those to match
% non-moving bar stimuli.

clc;
clear all;
close all;

pdatapath='/Users/Kunibert/CalciumImaging/MarionDaryl_pData';
cd(pdatapath)

% x=load_data_set('/Users/Kunibert/CalciumImaging/MarionDaryl_pData','150819ks_fly3*');%141012m_fly1 was test fly
x=load_data_set('/Users/Kunibert/CalciumImaging/MarionDaryl_pData','150819ks_fly3*');%141012m_fly1 was test fly

zdepth = zeros(length(x),1);
stim_types = 'fullfieldcontrast_2s';

%ms: exclude the stimtypes you don't wanna match
stim_types_nogo = 'fullfieldcontrast_10s';

stims = cell(length(x),1);
for ii = 1:length(x)
    zdepth(ii) = x{ii}.strct.xml.zdepth;
    
    stims{ii} = x{ii}.strct.stim_type;
end

% just look at fff2s, calculate Q

for jj = 1:size(x,2)
    temp_stim = x{jj}.strct.stim_type;
    if strcmpi(stim_types,temp_stim)
        
        in = x{jj}.strct;
        clear Q Qmean
        for kk = 1:size(in.ratio,1)  %for each cell that has seen the same fff
            
            %supersimple. just take the whole traces and correlate with
            %each other
            stim=in.fstimval;
            ratio = in.ratio(kk,:);
            ratio = ratio./mean(ratio) - 1;
            Q(kk) = corr(ratio',stim);
            
            %more sophisticated. look for epochlength and average repeated
            %epochs before correlating
            stim=in.fstimval;
            inds = find(diff(stim)<0)+1; %trigger on going to dark
            inds = inds(1:end-1);
            epochlength = round(mean(diff(inds)));
            ratio = in.ratio(kk,:);
            ratio = ratio./mean(ratio) - 1;
            
            clear mr ms
            for ll=1:length(inds)
                temp = ratio(inds(ll):inds(ll)+epochlength);    %/median(d_iratio(xi(jj):xi(jj)+39));
                mr(ll,:)=temp/mean(temp);  % mean across repeated epochs
        
                temp=stim(inds(ll):inds(ll)+epochlength);
                temp=temp-min(temp); temp=temp/(max(temp));
                ms(ll,:)=temp;      % mean across repeated epochs for stimulus
            end
            meanratio = mean(mr);
            meanstim = mean(ms);
            Qmean(kk) = corr(meanstim',meanratio');            
            
        end
         % use Q for now (correlation of the whole trace with the whole stim trace)
         % and save this to pdata
         
%         in.fffcorr = Q;
        x{jj}.strct.fffcorr = Q;
        
    else    
    end
end

%save fffcorr to pdata
for jj = 1:size(x,2)
    out = x{jj}.strct;
    
%     save_processed_data_1ch(out);
    save_processed_data_2pdata_1ch(out);
end



% % % % % % % 
% % % % % % % %another attempt, hijacking the full fff figures script
% % % % % % % for jj = 1:size(x,2)
% % % % % % %     temp_stim = x{jj}.strct.stim_type
% % % % % % %     if strcmpi(stim_types,temp_stim)
% % % % % % %        
% % % % % % %         fTm9LexA = x{jj}.strct
% % % % % % % %         % create structures by neuron
% % % % % % % %         fTm9LexA = create_neuron_structure_all_ms(f_fff_Tm9LexA);
% % % % % % %         % load all the data!
% % % % % % %         xTm9LexA = load_neuron_data10Hz_ms(fTm9LexA,pdatapath);
% % % % % % % 
% % % % % % %         
% % % % % % %         
% % % % % % %         
% % % % % % %         mTm9LexA = aggregate_fff_means10Hz_G6(xTm9LexA)
% % % % % % %     else
% % % % % % %     end
% % % % % % % end


%% match other cells to this, using the matching code that we also use for move_bar
% (could also just use the cell_nums from there, but would then limit the
% data to cells that have also seen the moving bar stimulus (which actually
% should be most)


clc;
clear all;
close all;

pdatapath='/Users/Kunibert/CalciumImaging/MarionDaryl_pData';
cd(pdatapath)

x=load_data_set('/Users/Kunibert/CalciumImaging/MarionDaryl_pData','150819ks_fly3*');

zdepth = zeros(length(x),1);
stim_types = 'fullfieldcontrast_2s';

%ms: exclude the stimtypes you don't wanna match
stim_types_nogo = 'fullfieldcontrast_10s';

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
    i_fff = zeros(length(temp_stims),1);
    i_fff_not = zeros(length(temp_stims),1);
    
    % ms:one stim type to compare to
    i_fff = i_fff + strcmpi(stim_types,temp_stims);
    i_fff_not = i_fff_not + strcmpi(stim_types_nogo,temp_stims); %ms
    
    fff_ind = find(i_fff);
    fff_ind_not = find(i_fff_not); %ms
    
    % otherwise you are comparing to an empty array later if fff_ind_not
    % was not run- yf
    if (isempty(fff_ind_not))
            fff_ind_not=0;
    end
    
    if(~isempty(fff_ind))
        % make reference figures
        figure;
        FFFlash_res_display_1ch(x{inds(fff_ind)}.strct,2);close(1);
        figure;imshow(x{inds(fff_ind)}.strct.AV1,[]);
        for j = 1:length(inds)
            j
%             temp_stims(j);
            
            %if((j ~= fff_ind) & j ~= fff_ind_not %ms: is not the fff index that we use for matching AND not the one that we excluded from matching
            if((j ~= fff_ind) && (sum(j == fff_ind_not) == 0))% 
                
                figure;FFFlash_res_display_1ch(x{inds(j)}.strct,2);close (4);
                figure;imshow(x{inds(j)}.strct.AV1,[]);
                list = input('list correspondence indices:','s');
                nums = str2num(list);
                %don't need the part that sets centers here, it's fff, need
                %correlation values instead
%                 centers = zeros(length(nums),4);
%                 for n = 1:length(nums)
%                     if(nums(n)==-1)
%                         fffcorr(n,:) = [100 100 100 100];
%                     else
%                         centers(n,:) = x{inds(fff_ind)}.strct.centers(nums(n),:);
%                     end
%                 end
%                 x{inds(j)}.strct.centers = centers;
                fffcorr = zeros(length(nums),1);
                for n = 1:length(nums)
                    if(nums(n)==-1)
                        fffcorr(n) = 100; %use this if there is no corresponding cell
                    else
                        fffcorr(n) = x{inds(fff_ind)}.strct.fffcorr(nums(n));
                    end
                end
                x{inds(j)}.strct.fffcorr = fffcorr;
                x{inds(j)}.strct.fff_nums = nums; %call the corresponding cells fff_nums (instead of cell_nums)
                
                close([4 5 6]);
            end
        end
        close all;
    else
%         for j = 1:length(inds)
%             x{inds(j)}.strct.centers = -500 * ones(length(x{inds(j)}.strct.masks),2);
%         end
    end
end




for ii = 1:length(x)
    out = x{ii}.strct;
%     fileloc = x{ii}.strct.fileloc;
%     sinds = find(fileloc=='\');
%     fileloc(1:(sinds(4)-1)) = [];
%     fileloc = ['E:' fileloc];
%     out.fileloc = fileloc;

%only deal with pdata, don't wanna reload analyzed flies
    save_processed_data_2pdata_1ch(out);
%     save_processed_data_1ch(out);

end
            