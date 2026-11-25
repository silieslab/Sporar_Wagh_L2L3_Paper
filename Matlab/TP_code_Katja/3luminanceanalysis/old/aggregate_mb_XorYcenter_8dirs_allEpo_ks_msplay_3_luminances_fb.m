

function out = aggregate_mb_XorYcenter_8dirs_allEpo_ks_msplay_3_luminances_fb(in)

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