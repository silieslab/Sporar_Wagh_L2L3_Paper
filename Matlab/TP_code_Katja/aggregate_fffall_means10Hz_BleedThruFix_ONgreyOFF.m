function out = aggregate_fffall_means10Hz_BleedThruFix_ONgreyOFF(in)


n_epoch = 11; 
epochlength = zeros(length(in),1);

% loop to find the epochlength:
for ii=1:length(in)

    s = in(ii).istim;
    % finding the beginning and end of epochs
    ds = diff(s); 
    
% %     %ms: the following part was for a stimulus where there is an epoch '0'between all stimuli 
% %     binds = find(ds<0)+1; % ignoring the first epoch, finding the beginning of the epoch
% %     einds = find(ds>0)+1; % finding the beginning of the inter-epoch interval (0s in stim strace) 
% %     dinds = binds-einds(1:length(binds));
% %     epochlength(ii)=round(mean(dinds));
    inds = find(ds)+1;
    epochlength(ii)=round(mean(diff(inds)));

end

dur = round(mean(epochlength)) % mean duration of the epoch

rats = zeros([length(in),n_epoch,dur]);
stims= zeros([length(in),n_epoch,dur]);
name = cell(length(in),1);

% keyboard

for ii=1:length(in)
    
    iratio = in(ii).iratio;    
    iratio = iratio./mean(iratio) - 1;
    s = in(ii).istim;

    % finding the epochs
    ds = diff(s);
    inds = find(ds)+1; % ignoring the first epoch...
% %     inds = find(ds>0)+1; % ignoring the first epoch...
    inds = inds(1:end-1); %ms: clipping of the last epoch, almost always too short
    
    epochs = s(inds);
    
    pos = in(ii).ifstimpos1;
    
    for jj=1:n_epoch % 11 epochs
%         I = find(epochs==jj);
        I = find(epochs==(jj-1)); %ms: actual epochs go from 0-10, not 1-11
        bind = inds(I);
    
        allEpochs = zeros(length(bind),dur);
        for mm = 1:length(bind)
            allEpochs(mm,:) = iratio(bind(mm):(bind(mm)+dur-1));
            temp = mean(allEpochs,1);
        end
        rats(ii,jj,:) = temp;
    end
    name{ii}=in(ii).name;    

end


neuron = [in.cell];
flyID = [in.flyID];

out.rats=rats;
% out.stims=stims;
out.neuron=neuron;
out.flyID=flyID;
out.name=name;

