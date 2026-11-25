function out = aggregate_gratings_two_luminances(in)
%aggregate function for the script: grating_two_luminances.

% figure out how many epochs there are
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



%% For each ROI
for ii=1:length(in)

    % df/f
    iratio = in(ii).iratio;
    iratio = iratio./mean(iratio) - 1;   
    
%     s = in(ii).istim;
    s = in(ii).istim + 1
    
    % finding the actual epochs    
    ds = diff(s);
    inds = find(ds)+1; %ks: finding epochs (everything that is not zero - e.g. -1 4 3 -2 ...)
    inds = inds(1:end-1); %clipping of the last epoch, almost always too short
        
    epochs = s(inds);
    uepochs = unique(epochs);
    
    for jj=1;
        currepoch = uepochs(jj);
        I = find(epochs==currepoch); %ms: take all the epochs
        bind = inds(I);

        %make variable to store the traces
        allEpochs = zeros(length(bind),dur);
        for mm = 1:(length(bind)-1);
            allEpochs(mm,:) = iratio(bind(mm):(bind(mm)+dur-1));
            temp = mean(allEpochs,1); %trial averaging (one ROI, mean of all the repititions of one epoch)
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




%% To split the into individual epochs
    
% % figure out how many epochs there are
% s = in(1).istim;
% n_epoch = sum(unique(s)>=0);  %we have 4 epochs
% 
% epochlengths = zeros(length(in),1);
% 
% 
% for ii=1:length(in)
%     s = in(ii).istim;
%     
%     % Find beginning indices
%     ds = diff(s);
%     b_inds = find(ds)+1;
%     duration = zeros(1,length(b_inds));
%     
%     % Calculate each epochduration for this ROI
%     for kk = 1:length(b_inds)-1
%         duration(kk) = b_inds(kk+1)-b_inds(kk);
%     end
%     
%     % Don't take the mean, because sometimes the same epoch is displayed
%     % twice, so the epochlength seems to be double. Mode takes 'most
%     % common' value
%     epochlengths(ii) = mode(duration); %3 seconds long epochs
% end
% 
% dur = round(mean(epochlengths));% mean duration of the epoch
% 
% 
% rats = zeros([length(in),n_epoch,dur]);
% name = cell(length(in),1);
% 
% 
% 
% %% For each ROI
% for ii=1:length(in)
% 
%     % df/f
%     iratio = in(ii).iratio;
%     iratio = iratio./mean(iratio) - 1;   
%     
%     s = in(ii).istim;
%     
%     % finding the actual epochs    
%     ds = diff(s);
%     inds = find(ds)+1; %ks: finding epochs (everything that is not zero - e.g. -1 4 3 -2 ...)
%     inds = inds(1:end-1); %ms: clipping of the last epoch, almost always too short
%         
%     epochs = s(inds);
%     uepochs = unique(epochs);
%     
%     for jj=1:n_epoch % number of epochs
%         currepoch = uepochs(jj);
%         I = find(epochs==currepoch); %ms: take all the epochs
%         bind = inds(I);
%         
%         %make variable to store the traces
%         allEpochs = zeros(length(bind),dur);
%         for mm = 1:length(bind)
%             allEpochs(mm,:) = iratio(bind(mm):(bind(mm)+dur-1));
%             temp = mean(allEpochs,1);%trial averaging (one ROI, mean of all the repititions of one epoch)
%         end
%   
%         rats(ii,jj,:) = temp;
%     end
%     name{ii}=in(ii).name;
% 
% end
%   
% 
% 
% % save values into out variable and return to function.
% out.rats = rats;
% out.neuron = [in.cell];
% out.flyID = [in.flyID];
% out.name = name;
% % out.stimstruct = stimstruct;




