function out = aggregate_05StepsON_OFF_response_at_the_end_ks(in)

% The epochs are distributed as:
% 
% 0 : 100% OFF
% 1 : 50% OFF
% 2 : GREY
% 3 : 50% ON
% 4 : 100% ON

% % figure out how many epochs there are
s = in(1).istim;
n_epoch = length(unique(s));
% n_epoch = 5

fprintf(' \n Remember: \n 0 : 100%% OFF \n 1 : 50%% OFF \n 2 : GREY \n 3 : 50%% ON \n 4 : 100%% ON \n\n');

%figure out epochlength
epochlengths = zeros(1,length(in));

for ii=1:length(in)
    s = in(ii).istim;
    
    % Find beginning indices
    ds = diff(s);
    b_inds = find(ds)+1;
    duration = zeros(1,length(b_inds));
    
    % Calculate each epochduration for this ROI
    for kk =1:length(b_inds)-1
        duration(kk) = b_inds(kk+1)-b_inds(kk);
    end
    
    % Don't take the mean, because sometimes the same epoch is displayed
    % twice, so the epochlength seems to be double. Mode takes 'most
    % common' value
    epochlengths(ii) = mode(duration);
end

dur = round(mean(epochlengths));% mean duration of the epoch


rats = zeros([length(in),n_epoch,dur]);
name = cell(length(in),1);

                         
%% For each ROI
for ii=1:length(in)

    % df/f
    iratio = in(ii).iratio;
    iratio = iratio./mean(iratio) - 1;   
    
    s = in(ii).istim;
    
    % finding the actual epochs    
    ds = diff(s);
    inds = find(ds)+1; %ks: finding epochs (everything that is not zero - e.g. -1 4 3 -2 ...)
    inds = inds(1:end-1); %ms: clipping of the last epoch, almost always too short
        
    epochs = s(inds);
    uepochs = unique(epochs);
    %sortedepochs = []...
    
    for jj=1:n_epoch % number of epochs
        currepoch = uepochs(jj);
        % currepoch = sortedpoch(jj)
        I = find(epochs==currepoch); %ms: take all the epochs
        bind = inds(I);
        
        %make variable to store the traces
        allEpochs = zeros(length(bind),dur);
        for mm = 1:length(bind)
            allEpochs(mm,:) = iratio(bind(mm):(bind(mm)+dur-1));
            temp = mean(allEpochs,1);%trial averaging (one ROI, mean of all the repititions of one epoch)
        end
  
        rats(ii,jj,:) = temp;
    end
    name{ii}=in(ii).name;

end
  


% save values into out variable and return to function.
out.rats = rats;
out.neuron = [in.cell];
out.flyID = [in.flyID];
out.name = name;
% out.stimstruct = stimstruct;

end

