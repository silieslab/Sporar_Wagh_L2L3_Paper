function out = aggregate_01stepsONgreyOFF_response_at_the_end_ks(in)
% This function groups the different interesting epoch combinations in a
% Matrix.
% The epochs are distributed as:
% 
% 0 : grey
% 1 : 100% OFF
% 2 : 80% OFF
% 3 : 60% OFF
% 4 : 40% OFF
% 5 : 20% OFF
% 6 : 20% ON
% 7 : 40% ON
% 8 : 60% ON
% 9 : 80% ON
% 10 : 100% ON


% % figure out how many epochs there are
s = in(1).istim;
n_epoch = length(unique(s));

fprintf(' \n Remember: \n 0 : grey \n 1 : 100%% OFF \n 2 : 80%% OFF \n 3 : 60%% OFF \n 4 : 40%% OFF \n 5 : 20%% OFF \n 6 : 20%% ON \n 7 : 40%% ON \n 8 : 60%% ON \n 9 : 80%% ON \n 10 : 100%% ON \n\n');

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
        duration(kk) = b_inds(kk+1)-b_inds(kk); %epochs (1-10) are 5s, grey (0) is 10s long!
        
%         if (duration>60)
%             duration = (b_inds(kk+1)-b_inds(kk))/2
%         elseif (duration<60)
%             duration = b_inds(kk+1)-b_inds(kk)
%         end 
        
    end
    
    % Don't take the mean, because sometimes the same epoch is displayed
    % twice, so the epochlength seems to be double. Mode takes 'most
    % common' value; if equal, then it takes the smallest value.
    epochlengths(ii) = mode(duration);

end

% dur = round(mean(epochlengths)); %mean duration of the epoch
dur = round(mode(epochlengths)); %most common duration of the epoch


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
    uepochs = unique(epochs); %this already sorts them from 1 to 10
%     sortedepochs = [1 2 3 4 5 0 6 7 8 9 10]
    
    for jj=1:n_epoch % number of epochs
        currepoch = uepochs(jj);
%         currepoch = sortedpoch(jj)
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

