function out = aggregate_fffall_means10Hz_LedSynth(in)
% Aggregate function to analyse the LedSynth data
% modified aggregate_fffall_means10Hz_BleedThruFix_v2
% Katja, April 2017

% 2p settings: Marc points; the shutters are closed when the light is on. During these times, the fluorescence is zero, 
% so we are using these values to set a treshold and define the epochs.




%% For each ROI


dur_all = zeros(1,length(in));
acc_bind = cell(length(in),1)
for ii=1:length(in)
in(ii).name
    % df/f
    iratio = in(ii).iratio;
    iratio = iratio./mean(iratio) - 1;   
    
    % determine the treshold
    figure(1)
    plot(iratio);
    title('select treshold value');
    [~,v] = ginput(1)  %Graphical input from mouse to manually select the treshold; 
                         % use ~ when you're actually not interested in this variable, but you need it to get the second parameter.
    threshold = round(v,2); %round the number to two digits
    close(1); % close the figure after every ii
    
    % calculate the duration of the stimulus presentation
    shutter_closed =  find(iratio < threshold);
    shutter_open =  find(iratio > threshold);
    d_shutter_closed = diff(shutter_closed);
    d_shutter_open = diff(shutter_open);
    
    % only keep the ones which are longer than 1, shutter closed
    last_shuttered_inds = find(d_shutter_closed > 1);
    last_frame_closed = shutter_closed(last_shuttered_inds);
    dur_full = diff(last_frame_closed); %duration of full epoch, incl. closed shutter following it
    bind = last_frame_closed+1;
    acc_bind{ii} = bind;
    
    %shutter open
    last_unshuttered_inds = find(d_shutter_open > 1);
    last_frame_open= shutter_open(last_unshuttered_inds);
    
    %find epoch length as difference between the two
    len = min(length(last_frame_closed),length(last_frame_open));  % find out which is shorter so that subtraction works out
    length_shutter_closed = last_frame_closed(1:len) - last_frame_open(1:len); 
    
    len = min(length(dur_full),length(length_shutter_closed));
    dur = dur_full(1:len) - length_shutter_closed(1:len)
    
 
    
    % cut to the trace at the point where dur is shorter or longer than dur +/- 2 
    % where is dur bigger or smaller than dur
%     inds_to_cut = find(dur>=(mode_dur+2)|dur<=(mode_dur-2));
    if ~isempty(inds_to_cut)
        dur(inds_to_cut) = [];
    end
    
% % % %         %make mean over all the repetitions
% % % %         allEpochs = zeros(length(inds_to_keep),dur);
% % % %         for jj = 1:length(inds_to_keep)
% % % %             allEpochs(jj,:) = iratio(inds_to_keep(jj):(inds_to_keep(jj)+dur-1)); %?
% % % %             temp = mean(allEpochs,1);%trial averaging (one ROI, mean of all the repititions of one epoch)
% % % %         end
% % % %       
% % % %     rats(ii,jj,:) = temp;    

    dur_all(ii) = mode(dur); %to loop over all ii
    
end
    
epoch_dur = round(mean(dur_all)); % make it an integer...

    
rats=zeros(length(in),epoch_dur);
stims=rats;

mr=zeros(length(in),epoch_dur);
ms=zeros(length(in),epoch_dur);
name = cell(length(in),1);

for ii=1:length(in)

    % df/f
    iratio = in(ii).iratio;
    iratio = iratio./mean(iratio) - 1;   
  
    %somehow get binds here for each ROI (ii) 
    
    for jj=1:length(bind)
        temp = iratio(bind(jj):bind(jj)+epoch_dur-1);
        
        mr(jj,:)=temp;
        
%         temp=in(ii).istim(xi(jj):xi(jj)+dur-1);
        temp=temp-min(temp); 
        temp=temp/(max(temp));
        ms(jj,:)=temp;
    end
    rats(ii,:)=mean(mr(1:length(inds_to_keep),:),1); %averaging over stimulus repititions - we do not wanna do that as we presented the flies differnet LEDs! Have to hard code it!
    stims(ii,:)=mean(ms(1:length(inds_to_keep),:),1);
%     neuron(ii)=in(ii).cell;
%     flyID(ii)=in(ii).flyID;
    name{ii}=in(ii).name;
%     center{ii}=in(ii).center; %ms added
%     clear mr ms;
end



neuron = [in.cell];
flyID = [in.flyID];

out.rats=rats;
out.neuron=neuron;
out.flyID=flyID;
out.name=name;
% out.center=center; %ms added


