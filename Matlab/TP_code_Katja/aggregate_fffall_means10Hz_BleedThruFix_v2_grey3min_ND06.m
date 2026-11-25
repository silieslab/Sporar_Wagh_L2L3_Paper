function out = aggregate_fffall_means10Hz_BleedThruFix_v2_grey3min_ND06(in)

% figure out how many epochs there are - we actually don' need this
s = in(1).istim;
n_epoch = sum(unique(s)>=0);  %we have 4 epochs

epochlengths = zeros(length(in),1);

for ii=1:length(in)
    s = in(ii).istim;

    % Find beginning indices
    ds = diff(s);
    b_inds = find(ds)+1;
    duration = zeros(1,length(b_inds));
    
    % Calculate epochduration (for all 4 epoch together) for this ROI
    for kk = 1:length(b_inds)-1
        duration(kk) = (4*b_inds(kk+1))-(4*b_inds(kk)); 
    end
    
    epochlengths(ii) = mode(duration); %3 seconds long epochs, I made it 12s long
end



dur = round(mean(epochlengths));% mean duration of the epoch

rats = zeros([length(in),n_epoch,dur]);
name = cell(length(in),1);

