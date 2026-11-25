

function out = aggregate_mb_XorYcenter_8dirs_allEpo_3lum_added_Centers(in)

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
centers = zeros(length(in),2);


%We wanna show only the period where we show present the moving bar
% full_dur = dur; 
% 
% 

%% Normalizing signal with baseline, separating epochs and sort them (and prev.
% proc. grey epoch) in matrices to obtain 3 matrices with each 8 epochs.

% % % % for ii=1:num_ROIS
% % % %     % baseline for this neuron
% % % %     s = in(ii).istim;
% % % %     ds = diff(s); 
% % % %     einds = find(ds<0)+1; % finding the end of the epoch -> beginning of grey
% % % %     baseline = zeros([1,length(einds)-1]);                                              % MS: WHY IS THE BASELINE LENGTH BASED ON THE NUMBER OF EPOCHS? >> because you're just storing the mean value - acutally an integer
% % % %  
% % % %     % take last 3rd of grey epoch as baseline signal
% % % %     for ee=1:length(einds)-1
% % % %        grey_begin = einds(ee);
% % % %        grey_last_third_begin = grey_begin + round(dur_grey/3)*2;
% % % %        grey_end = grey_begin + dur_grey;                                        % MS: Should get a -1 to not hit the first frame of the bar presentation (in fact it's ending on the same index than your inds (start indices) below
% % % %        last_third_signal = in(ii).iratio(grey_last_third_begin:grey_end);
% % % %        baseline(ee) = mean(last_third_signal);  
% % % %     end
% % % %     
% % % %     iratio = in(ii).iratio;    
% % % %     %iratio = iratio./mean(iratio) - 1; %this is how this was done before,
% % % %     %with temp = temp/mean(temp) or temp = temp/mean(temp(baseline)) below
% % % % 
% % % %     % normalize signal by baseline (last third of grey epoch 
% % % %     % -> this will probably contain only few responses) 
% % % %     % with baseline signal around 0
% % % %     iratio = iratio./mean(baseline)  -1;                                        % MS: baseline is the mean of all last thirds of all epoch presentations. Is this what you meant to do? and then, should the way to calculate this, be to just store the full traces and get the mean of these traces and not of indivudal values?
% % % %     
% % % %     %% Find traces and sort them, merge them
% % % %     inds = find(ds>0)+1; % ignoring the first epoch 
% % % %     inds = inds(1:end-1);% ms: clipping of the last epoch, almost always too short
% % % %     
% % % %     % store grey+epoch+grey here before merging and passing to luminance
% % % %     % arrays
% % % %     all_epochs_signal = zeros([n_epoch,full_dur,length(inds)]);
% % % %     
% % % %     for kk=1:length(inds)
% % % %        current_epoch = s(inds(kk));
% % % %        trace_begin = inds(kk)-dur_grey;
% % % %        trace_end = inds(kk)+dur+dur_grey -1;
% % % %        all_epochs_signal(current_epoch,:,kk) = iratio(trace_begin:trace_end);           %ms:  trace including the previous grey epoch and the subsequent grey epoch
% % % %     end
% % % %     
% % % %     % Merge all signal traces from this ROI
% % % %                                                                                    %ms: different way of doing trial averaging
% % % %     all_epochs_signal(all_epochs_signal == 0)= NaN;
% % % % % % % %     all_epochs_meanSignal = mean(all_epochs_signal,3,'omitnan');            %ms: in my Matlab version, 'omitnan' is not an option in the mean function??
% % % %     all_epochs_meanSignal = nanmean(all_epochs_signal,3); 
% % % %     figure
% % % %     plot(all_epochs_meanSignal')
% % % % 
% % % %     % store signal traces for later analysis
% % % %     for kk=1:n_epoch
% % % %         rats(ii,kk,:) = all_epochs_meanSignal(kk,:);
% % % %     end
% % % %     
% % % %     name{ii}=in(ii).name;
% % % % end
% % % % 
% % % % out.rats = rats;
% % % % out.neuron = [in.cell];
% % % % out.flyID = [in.flyID];
% % % % out.name = name;


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
       grey_end = grey_begin + dur_grey-1;
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
        I = find(epochs==jj); %find all the epoch indices for a given epoch
        bind = inds(I); %find the indices for these in the trace
        
        %trial averaging
        for mm=1:length(bind)
           trace_begin = bind(mm)-dur_grey;
           trace_end = bind(mm)+dur+dur_grey-1;
           allEpochs(mm,:) = iratio(trace_begin:trace_end);
           temp = mean(allEpochs, 1);
        end
        
        

        % use center position for alignment
        if(jj==1|jj==2|jj==3)%0
            if in(ii).center(jj)~=500
                e1_ind = find(pos(bind:(bind+dur-1)) < in(ii).center(jj),1,'last'); % look into last 1 nonzero objects
                temp = circshift(temp,[1 -e1_ind + floor(dur/2)]); % floor to round
            end
            %finds positions on one side of the RF center, circshifts
            %these + 1/2 of the whole trace --> RF is in middle
        elseif(jj==7|jj==8|jj==9)% 180 
            if in(ii).center(jj)~=500
                e2_ind = dur-e1_ind+1;%create reverse of epoch 1
                temp = circshift(temp,[1 -e2_ind+floor(dur/2)]);
            end
        elseif(jj==4|jj==5|jj==6) %90  
            if in(ii).center(jj)~=500
                e3_ind = find(pos(bind:(bind+dur-1))<in(ii).center(jj),1,'last');
                temp = circshift(temp,[1 -e3_ind+floor(dur/2)]);
            end
        elseif(jj==10|jj==11|jj==12) %270  
            if in(ii).center(jj)~=500
                e4_ind = dur-e3_ind+1;
                temp = circshift(temp,[1 -e4_ind+floor(dur/2)]);
            end
        elseif(jj==13|jj==14|jj==15) %45   
            if in(ii).center(jj)~=500
%                 e5_ind = find(pos(bind:(bind+dur-1)) < in(ii).center(3),1,'first')-1;
                 e5_ind = find(pos(bind:(bind+dur-1)) < in(ii).center(jj),1,'last');
               temp = circshift(temp,[1 -e5_ind+floor(dur/2)]);
            end
        elseif (jj == 19|jj==20|jj==21) %225  
           if in(ii).center(jj)~=500
                e7_ind = dur-e5_ind+1;%create reverse of epoch 5
                temp = circshift(temp,[1 -e7_ind+floor(dur/2)]);
           end
        elseif(jj == 16|jj==17|jj==18) %135   
            if in(ii).center(jj)~=500
%                 e6_ind = find(pos(bind:(bind+dur-1))<in(ii).center(4),1,'first')-1;
                e6_ind = find(pos(bind:(bind+dur-1))<in(ii).center(jj),1,'last');
                temp = circshift(temp,[1 -e6_ind+floor(dur/2)]);
            end
        elseif (jj == 22|jj==23|jj==24) % 315 
            if in(ii).center(jj)~=500
                e8_ind = dur-e6_ind+1; %create reverse of epoch 6
                temp = circshift(temp,[1 -e8_ind+floor(dur/2)]);
            end
        end

          
        rats(ii,jj,:) = temp;
    end
    
    
      
    for centerJ=1:24%length(n_epoch)
        % on-screen center for this onscreen direction? -yf
        if(in(ii).center(centerJ)>=-50)&&(in(ii).center(centerJ)<=50)
%             if(bad_inds<10)
                onscreen(ii,centerJ) = 1;
%             end
        end
        
    end
     
    
    % Four centers for this 8dir stimulus 
   % centers(ii,1) = in(ii).center(1);
   % centers(ii,2) = in(ii).center(2);
   % centers(ii,3) = in(ii).center(3);
   % centers(ii,4) = in(ii).center(4);
    

    

    name{ii}=in(ii).name;
end

%  for ii=1:size(rats,1)
%         figure
%         plot(squeeze(rats(ii,:,:))')
%  end
    
 
 
out.rats = rats;
out.neuron = [in.cell];
out.flyID = [in.flyID];
out.name = name;
out.onscreen= onscreen;