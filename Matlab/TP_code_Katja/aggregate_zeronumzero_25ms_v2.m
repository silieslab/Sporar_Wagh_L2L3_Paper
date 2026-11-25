function out = aggregate_zeronumzero_25ms_v2_ms(in)

% This function works for Stimulus of kind
% "LocalCircle_ONgreyOFF_25ms_BG_2s_120deg_0degAz_0degEl_100_Con_0.5Lum",
% where there are 25ms stimuli and 2s break. Just 2 epochs exist.


% figure out how many epochs there are
s = in(1).istim;
n_epoch = sum(unique(s)>0);  %count number of unique epoch numbers but ignore 0


epochlength = zeros(length(in),1);
zeroInterleaveLength = zeros(length(in),1);
Combined_epochlength = zeros(length(in),1);
% loop over all of the stimuli to find the epochlength to be used:
for ii=1:length(in)
    s = in(ii).istim;
    indx = find(s); %every time the stim output file is non zero
    double_indx = find(diff(find(s))==1); % finding the ones where the stim is non zero for more one frame
    double_indx = indx(double_indx);
    s(double_indx+1) = 0;
    
    % finding the actual epochs
    ds = diff(s); 

    % begining of the epoch, ie when the stimulus steps back down to 0
    % (which is the interstimulus blank period)
    binds = find(ds<0)+1; % ignoring the first epoch, finding the beginning of the inter-epoch interval (0s in stim strace) 
    einds = find(ds>0)+1; % finding the beginning of the actual epochs
    
    % find out which is shorter so that subtraction works out
    len = min(length(binds),length(einds));
    
    % duration of the numbered epoch
    dinds = binds(1:len)-einds(1:len);
    %ms: automatically determine epoch duration
    epochlength(ii)=round(mean(dinds));
    
    % duration of the zero interleave epochs
    zinds = einds(2:len)- binds(1:len - 1);  
    zeroInterleaveLength(ii) = round(mean(zinds));

end

% duration of the numbered epochs '555555555' or '22222222' 
epoch_dur = round(mean(epochlength));% if frame rate was ~10Hz and using 1 sec StandingStripe this value should be around 10.
% This duration of the zero epochs '00000000' 
zero_dur = round(mean(zeroInterleaveLength)); % if frame rate was ~10Hz and using 1 sec StandingStripe this value should be around 10.

% full duration include preceding zero epoch, 'real' epoch and the follwing
% zero epoch
full_dur = zero_dur + epoch_dur + zero_dur;
stimstruct = zeros(full_dur,1);
stimstruct(zero_dur+1:zero_dur+epoch_dur) = 1; %filling in the ones


rats = zeros([length(in),n_epoch,full_dur]);
name = cell(length(in),1);


% extract the data as organized by epochs and store in for further processing
for ii=1:length(in)
    ii
    % remove baseline, normalizing data
    iratio = in(ii).iratio;
    iratio = iratio./mean(iratio) - 1;   
    
    
    s = in(ii).istim;
    indx = find(s); %every time the stim output file is non zero
    double_indx = find(diff(find(s))==1); % finding the ones where the stim is non zero for more one frame
    double_indx = indx(double_indx);
    s(double_indx+1) = 0;
    
    % finding the actual epochs
    ds = diff(s); 
%     ds = ds(1:end-full_dur); % clipping off  the last epoch
    
    % Arrays which save epoch beginnings for epoch 1 and 2
    inds_ep1 = find(ds>0 &  ds< 2 )+1; %ms: is the same as ds ==1
    inds_ep2 = find(ds>1)+1;%ms: is the same as ds==2

    for jj=1:n_epoch % number of epochs
        % beginning of epochs, choose epoch
        if(jj==1)
            bind = inds_ep1;
        else
            bind = inds_ep2;
        end
        
        %make variable to store the traces
        allEpochs = zeros(length(bind),full_dur);
        for mm = 1:length(bind)
            i_beginingOfTrace = bind(mm)- zero_dur;
            i_endOfTrace = bind(mm) + epoch_dur + zero_dur -1;
            
            if size(iratio,2)<i_endOfTrace
                continue;
            end
            
            % extract full part of the trace that we want, includes prior zero
            % period, the actuall epoch and following zero period
            allEpochs(mm,:) = iratio(i_beginingOfTrace:i_endOfTrace);

            temp = mean(allEpochs,1);
        end
        
        %maybe add back in a baseline subtraction here from the zero epoch
        %mean value, 
        %Check if this makes sense to do.  Another option would be to use
        %this baseline period to acutally calculate the dF/F
        temp = temp- mean(temp(1:zero_dur));
  
        rats(ii,jj,:) = temp;
    end
    name{ii}=in(ii).name;

end

% save values into out variable and return to function.
out.rats = rats;
out.neuron = [in.cell];
out.flyID = [in.flyID];
out.name = name;
out.stimstruct = stimstruct;

end
