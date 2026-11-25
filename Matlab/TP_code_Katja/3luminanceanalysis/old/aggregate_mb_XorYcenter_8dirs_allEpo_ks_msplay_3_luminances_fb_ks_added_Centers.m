

function out = aggregate_mb_XorYcenter_8dirs_allEpo_ks_msplay_3_luminances_fb_ks_added_Centers(in)

% This function will sort the ratio signals into
% .rats[ROIs,EPOCHs,duration] -> [ROIs,24,110].
% The duration of one trace is (3 sec. grey + 5 sec. epoch + 3 sec. grey).
% It takes the mean over equal epochs, so if an epoch was shown more than
% once, the epochs signals are averaged. The std error of that mean is
% stored in .error.
% It normalizes the signal with a baseline taken from the last second of
% the grey epoch.


% epoch 0 = 3s grey -> luminance 0.5, contrast 0
% epoch 1, 7, 4, 10, 13, 19, 16, 22 -> luminance 0.5, contrast -0.5
% epoch 2, 8, 5, 11, 14, 20, 17, 23 -> luminance 0.25, contrast -1
% epoch 3, 9, 6, 12, 15, 21, 18, 24 -> luminance 1.0, contrast -0.5
        
%% Find epoch length

s = in(1).istim;
n_epoch = sum(unique(s)~=0); % without grey epoch
num_ROIS = length(in);

epochlength = zeros([1,num_ROIS]);

% Find the epochlength:
for ii=1:length(in)

    s = in(ii).istim;
    % finding the beginning and end of epochs
    ds = diff(s); 
    %inds = find(ds~=0)+1; % ignoring the first epoch...
    binds = find(ds>0)+1; % finding the beginning of the epoch
    einds = find(ds<0)+1; % finding the end of the epoch
    dinds = einds-binds(1:length(einds));
    
    grey_length = binds(2:length(einds))-einds(1:end-1); %30
    grey_length(ii) = round(mean(grey_length));
    
    %ms: automatically determine epoch duration
    epochlength(ii)=round(mean(dinds)); % 50
end

% Epoch durations
dur_grey = round(mean(grey_length(grey_length~=0)));

dur = round(mean(epochlength));
% A trace is one epoch with it's preceding and following grey epochs
full_dur = dur+2*dur_grey; 


rats = zeros([num_ROIS,n_epoch,full_dur]);
name = cell(num_ROIS,1);
error = zeros([num_ROIS,n_epoch,full_dur]);
centers = zeros(length(in),2);


%We wanna show only the period where we show present the moving bar
% full_dur = dur; 
% 
% 
% rats = zeros([num_ROIS,n_epoch,full_dur]);
% name = cell(num_ROIS,1);
% error = zeros([num_ROIS,n_epoch,full_dur]);
% centers = zeros(length(in),2);


%% Normalizing signal with baseline, separating epochs and sort them (and prev.
% proc. grey epoch) in matrices to obtain 3 matrices with each 8 epochs.

for ii=1:num_ROIS
    
    % baseline for this neuron
    s = in(ii).istim;
    ds = diff(s); 
    einds = find(ds<0)+1; % finding the end of the epoch -> beginning of grey
    baseline = zeros([1,length(einds)-1]);
 
    % take last 3rd of grey epoch as baseline signal
    for ee=1:length(einds)-1
       grey_begin = einds(ee);
       grey_last_third_begin = grey_begin + round(dur_grey/3)*2;
       grey_end = grey_begin + dur_grey;
       last_third_signal = in(ii).iratio(grey_last_third_begin:grey_end);
       baseline(ee) = mean(last_third_signal);  
    end
    
    iratio = in(ii).iratio;    
    %iratio = iratio./mean(iratio) - 1; %this is how this was done before,
    %with temp = temp/mean(temp) or temp = temp/mean(temp(baseline)) below

    % normalize signal by baseline (last third of grey epoch 
    % -> this will probably contain only few responses) 
    % with baseline signal around 0
    iratio = iratio./mean(baseline)  -1;
    
    %% Find traces and sort them, merge them
    inds = find(ds>0)+1; % ignoring the first epoch 
    inds = inds(1:end-1);% ms: clipping of the last epoch, almost always too short
    
    % store grey+epoch+grey here before merging and passing to luminance
    % arrays
    all_epochs_signal = zeros([n_epoch,full_dur,length(inds)]);
    
    for kk=1:length(inds)
       current_epoch = s(inds(kk));
       trace_begin = inds(kk)-dur_grey;
       trace_end = inds(kk)+dur+dur_grey -1;
       all_epochs_signal(current_epoch,:,kk) = iratio(trace_begin:trace_end);
    end
    
    % Merge all signal traces from this ROI
    all_epochs_signal(all_epochs_signal == 0)= NaN;
    all_epochs_meanSignal = mean(all_epochs_signal,3,'omitnan');
    e = std(all_epochs_signal,0,3,'omitnan')/sqrt(size(all_epochs_signal,3));
    
    % store signal traces for later analysis
    for kk=1:n_epoch
        rats(ii,kk,:) = all_epochs_meanSignal(kk,:);
    end
    
    error(ii,:,:) = e;
    name{ii}=in(ii).name;
end

out.rats = rats;
out.neuron = [in.cell];
out.flyID = [in.flyID];
out.error = error;
out.name = name;





%% Normalizing signal with baseline, separating epochs and sort them (and prev.
% proc. grey epoch) in matrices to obtain 3 matrices with each 8 epochs.

for ii=1:num_ROIS % num_ROIS = length(in)
    
    % baseline for this neuron
    s = in(ii).istim;
    ds = diff(s); 
    einds = find(ds<0)+1; % finding the end of the epoch -> beginning of grey
    baseline = zeros([1,length(einds)-1]);
 
    % take last 3rd of grey epoch as baseline signal
    for ee=1:length(einds)-1
       grey_begin = einds(ee);
       grey_last_third_begin = grey_begin + round(dur_grey/3)*2;
       grey_end = grey_begin + dur_grey;
       last_third_signal = in(ii).iratio(grey_last_third_begin:grey_end);
       baseline(ee) = mean(last_third_signal);  
    end
    
    iratio = in(ii).iratio;    
    %iratio = iratio./mean(iratio) - 1; %this is how this was done before,
    %with temp = temp/mean(temp) or temp = temp/mean(temp(baseline)) below

    % normalize signal by baseline (last third of grey epoch 
    % -> this will probably contain only few responses) 
    % with baseline signal around 0
    iratio = iratio./mean(baseline)  -1;
    
    %% Find traces and sort them, merge them
    inds = find(ds>0)+1; % ignoring the first epoch 
    inds = inds(1:end-1);% ms: clipping of the last epoch, almost always too short
    
    pos = in(ii).ifstimpos1;
    epochs = s(inds);   
    % store grey+epoch+grey here before merging and passing to luminance
    % arrays
    all_epochs_signal = zeros([n_epoch,full_dur,length(inds)]);
    

    for jj = 1:n_epoch
        I = find(epochs==jj); %take all the epochs - NOT working
        bind = inds(I);
        
        for kk=1:length(inds)
           current_epoch = s(inds(kk));
           trace_begin = inds(kk)-dur_grey;
           trace_end = inds(kk)+dur+dur_grey -1;
           all_epochs_signal(current_epoch,:,kk) = iratio(trace_begin:trace_end);
           temp = mean(all_epochs_signal, 1); %ks added - correct?????
        end
    

        % use center position for alignment
        if(jj==1)%0
            if in(ii).center(1)~=500
                e1_ind = find(pos(bind:(bind+dur-1)) < in(ii).center(1),1,'last');
                temp = circshift(temp,[1 -e1_ind + floor(dur/2)]); % floor to round
            end
            %finds positions on one side of the RF center, circshifts
            %these + 1/2 of the whole trace --> RF is in middle
        elseif(jj==7)% 180 
            if in(ii).center(1)~=500
                e2_ind = dur-e1_ind+1;%create reverse of epoch 1
                temp = circshift(temp,[1 -e2_ind+floor(dur/2)]);
            end
        elseif(jj==4) %90  
            if in(ii).center(2)~=500
                e3_ind = find(pos(bind:(bind+dur-1))<in(ii).center(2),1,'last');
                temp = circshift(temp,[1 -e3_ind+floor(dur/2)]);
            end
        elseif(jj==10) %270  
            if in(ii).center(2)~=500
                e4_ind = dur-e3_ind+1;
                temp = circshift(temp,[1 -e4_ind+floor(dur/2)]);
            end
        elseif(jj==13) %45   
            if in(ii).center(3)~=500
%                 e5_ind = find(pos(bind:(bind+dur-1)) < in(ii).center(3),1,'first')-1;
                 e5_ind = find(pos(bind:(bind+dur-1)) < in(ii).center(3),1,'last');
               temp = circshift(temp,[1 -e5_ind+floor(dur/2)]);
            end
        elseif (jj == 19) %225  
           if in(ii).center(3)~=500
                e7_ind = dur-e5_ind+1;%create reverse of epoch 5
                temp = circshift(temp,[1 -e7_ind+floor(dur/2)]);
           end
        elseif(jj == 16) %135   
            if in(ii).center(4)~=500
%                 e6_ind = find(pos(bind:(bind+dur-1))<in(ii).center(4),1,'first')-1;
                e6_ind = find(pos(bind:(bind+dur-1))<in(ii).center(4),1,'last');
                temp = circshift(temp,[1 -e6_ind+floor(dur/2)]);
            end
        elseif (jj == 22) % 315 
            if in(ii).center(4)~=500
                e8_ind = dur-e6_ind+1; %create reverse of epoch 6
                temp = circshift(temp,[1 -e8_ind+floor(dur/2)]);
            end
            
            
            
            
            
        elseif(jj==2)%0
            if in(ii).center(5)~=500
                e9_ind = find(pos(bind:(bind+dur-1)) < in(ii).center(5),1,'last');
                temp = circshift(temp,[1 -e9_ind + floor(dur/2)]); % floor to round
            end
        elseif(jj==8)% 180 
            if in(ii).center(5)~=500
                e10_ind = dur-e9_ind+1;
                temp = circshift(temp,[1 -e10_ind+floor(dur/2)]);
            end
        elseif(jj==5) %90  
            if in(ii).center(6)~=500
                e11_ind = find(pos(bind:(bind+dur-1))<in(ii).center(6),1,'last');
                temp = circshift(temp,[1 -e11_ind+floor(dur/2)]);
            end
        elseif(jj==11) %270  
            if in(ii).center(6)~=500
                e12_ind = dur-e11_ind+1;
                temp = circshift(temp,[1 -e12_ind+floor(dur/2)]);
            end
        elseif(jj==14) %45   
            if in(ii).center(7)~=500
                 e13_ind = find(pos(bind:(bind+dur-1)) < in(ii).center(7),1,'last');
               temp = circshift(temp,[1 -e13_ind+floor(dur/2)]);
            end
        elseif (jj == 20) %225  
           if in(ii).center(7)~=500
                e15_ind = dur-e13_ind+1;
                temp = circshift(temp,[1 -e15_ind+floor(dur/2)]);
           end
        elseif(jj == 17) %135   
            if in(ii).center(8)~=500
                e14_ind = find(pos(bind:(bind+dur-1))<in(ii).center(8),1,'last');
                temp = circshift(temp,[1 -e14_ind+floor(dur/2)]);
            end
        elseif (jj == 23) % 315 
            if in(ii).center(8)~=500
                e16_ind = dur-e14_ind+1;
                temp = circshift(temp,[1 -e16_ind+floor(dur/2)]);
            end
            
            
            
            
        elseif(jj==3)%0
            if in(ii).center(9)~=500
                e17_ind = find(pos(bind:(bind+dur-1)) < in(ii).center(9),1,'last');
                temp = circshift(temp,[1 -e17_ind + floor(dur/2)]); % floor to round
            end
        elseif(jj==9)% 180 
            if in(ii).center(9)~=500
                e18_ind = dur-e17_ind+1;
                temp = circshift(temp,[1 -e18_ind+floor(dur/2)]);
            end
        elseif(jj==6) %90  
            if in(ii).center(10)~=500
                e19_ind = find(pos(bind:(bind+dur-1))<in(ii).center(10),1,'last');
                temp = circshift(temp,[1 -e19_ind+floor(dur/2)]);
            end
        elseif(jj==12) %270  
            if in(ii).center(10)~=500
                e20_ind = dur-e19_ind+1;
                temp = circshift(temp,[1 -e20_ind+floor(dur/2)]);
            end
        elseif(jj==15) %45   
            if in(ii).center(11)~=500
                 e21_ind = find(pos(bind:(bind+dur-1)) < in(ii).center(11),1,'last');
               temp = circshift(temp,[1 -e21_ind+floor(dur/2)]);
            end
        elseif (jj == 21) %225  
           if in(ii).center(11)~=500
                e23_ind = dur-e21_ind+1;
                temp = circshift(temp,[1 -e23_ind+floor(dur/2)]);
           end
        elseif(jj == 18) %135   
            if in(ii).center(12)~=500
                e22_ind = find(pos(bind:(bind+dur-1))<in(ii).center(12),1,'last');
                temp = circshift(temp,[1 -e22_ind+floor(dur/2)]);
            end
        else %(jj == 24) % 315 
            if in(ii).center(12)~=500
                e24_ind = dur-e22_ind+1; 
                temp = circshift(temp,[1 -e24_ind+floor(dur/2)]);
            end  
        end
        
          
        rats(ii,jj,:) = temp;
    end
    name{ii}=in(ii).name;

    
    
    for centerJ=1:12%length(n_epoch/2)
        % on-screen center for this onscreen direction? -yf
        if(in(ii).center(centerJ)>=-50)&&(in(ii).center(centerJ)<=50)
%             if(bad_inds<10)
                onscreen(ii,centerJ) = 1;
%             end
        end
        
    end
     
    
    % Four centers for this 8dir stimulus 
    centers(ii,1) = in(ii).center(1);
    centers(ii,2) = in(ii).center(2);
    centers(ii,3) = in(ii).center(3);
    centers(ii,4) = in(ii).center(4);
    centers(ii,5) = in(ii).center(5);
    centers(ii,6) = in(ii).center(6);
    centers(ii,7) = in(ii).center(7);
    centers(ii,8) = in(ii).center(8);
    centers(ii,9) = in(ii).center(9);
    centers(ii,10) = in(ii).center(10);
    centers(ii,11) = in(ii).center(11);
    centers(ii,12) = in(ii).center(12);
    
    
    % Merge all signal traces from this ROI
    all_epochs_signal(all_epochs_signal == 0)= NaN;
    all_epochs_meanSignal = mean(all_epochs_signal,3,'omitnan');
    e = std(all_epochs_signal,0,3,'omitnan')/sqrt(size(all_epochs_signal,3));
    
    % store signal traces for later analysis
    for kk=1:n_epoch
        rats(ii,kk,:) = all_epochs_meanSignal(kk,:);
    end
    
    error(ii,:,:) = e;
    name{ii}=in(ii).name;
end

out.rats = rats;
out.neuron = [in.cell];
out.flyID = [in.flyID];
out.error = error;
out.name = name;
out.onscreen= onscreen;