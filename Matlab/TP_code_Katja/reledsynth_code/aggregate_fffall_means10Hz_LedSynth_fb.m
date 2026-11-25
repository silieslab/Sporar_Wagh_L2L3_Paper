function out = aggregate_fffall_means10Hz_LedSynth_fb(in)
% Aggregate function to analyse the LedSynth data
% modified aggregate_fffall_means10Hz_BleedThruFix_v2
% Katja, April 2017

% 2p settings: Marc points; the shutters are closed when the light is on. During these times, the fluorescence is zero, 
% so we are using these values to set a treshold and define the epochs.




%% For each ROI


dur_all = zeros(1,length(in));
acc_bind = cell(length(in),1)
threshold = zeros(1,length(in));

for ii=1:length(in)
in(ii).name
    % df/f, but recalculate later
     iratio = in(ii).iratio;
     iratio = iratio./mean(iratio) - 1;    
     
    % determine the treshold
    figure(1)
    plot(iratio);
    title('select treshold value');
    [~,v] = ginput(1)  %Graphical input from mouse to manually select the treshold; 
                         % use ~ when you're actually not interested in this variable, but you need it to get the second parameter.
    threshold(ii) = round(v,2); %round the number to two digits
    close(1); % close the figure after every ii?
    
    % calculate the duration of the stimulus presentation
    shutter_closed =  find(iratio < threshold(ii));
    shutter_open =  find(iratio > threshold(ii));
    d_shutter_closed = diff(shutter_closed);
    d_shutter_open = diff(shutter_open);
    
    % only keep the ones which are longer than 1, shutter closed
    last_shuttered_inds = find(d_shutter_closed > 1);
    last_frame_closed = shutter_closed(last_shuttered_inds);
    dur_full = diff(last_frame_closed); %duration of full epoch, incl. closed shutter following it
    bind = last_frame_closed+1;
    acc_bind{ii} = bind; % beginning of epoch
    
    %shutter open
    last_unshuttered_inds = find(d_shutter_open > 1);
    last_frame_open= shutter_open(last_unshuttered_inds);
    
    % Dirty fix. Sometimes very first "open" shutter is missed and 1st
    % epoch is missing
    if(last_frame_open(1) > 20)
        last_frame_open = [1 last_frame_open];
    end
    
    %find epoch length as difference between the two
    len = min(length(last_frame_closed),length(last_frame_open));  % find out which is shorter so that subtraction works out
    length_shutter_closed = last_frame_closed(1:len) - last_frame_open(1:len); % if the first action is "closing" we would have a negative length if we did not take abs()!!
                                                                                    % this happens, because sometimes the very first "open" (at index 1) is missed :
    len = min(length(dur_full),length(length_shutter_closed));
    dur = dur_full(1:len) - length_shutter_closed(1:len)

    
    % cut to the trace at the point where dur is shorter or longer than dur +/- 2 
    % where is dur bigger or smaller than dur
%     inds_to_cut = find(dur>=(mode_dur+2)|dur<=(mode_dur-2));
    inds_to_cut = find(dur>=(dur+2)|dur<=(dur-2));
    if ~isempty(inds_to_cut)
        dur(inds_to_cut) = [];
    end 

    dur_all(ii) = mode(dur); %to loop over all ii
    
end
    
epoch_dur = round(mean(dur_all)); % make it an integer...

name = cell(length(in),1);

LED_ORDER = [1:20 1:20 1:20 1:20 1:20];
n_runs = length(find(LED_ORDER==20));
num_LEDs = length(unique(LED_ORDER)); % number of "epochs"

rats=zeros(length(in),num_LEDs,epoch_dur);

%% Sort wavelengths into 'rats' matrix
% Reminder to me: baseline method 1 is shit

% For each ROI
for ii=1:length(in)
    
    mr=zeros(num_LEDs,epoch_dur,n_runs);
    
    % get beginning indices here for each ROI (ii)
    bind = acc_bind{ii};
    mr(mr == 0) = NaN;
    
% old version    
%     % df/f
%     % Take mean of whole trace with open shutter (= actual signal) as a
%     % baseline
%     iratio = in(ii).iratio;
%     iratio2 = iratio./mean(iratio) - 1; 
%     shutter_open =  iratio2 > threshold(ii); 
%     
%     iratio = iratio./mean(iratio(shutter_open)) - 1; 
  
    
    %% Baseline
    iratio = in(ii).iratio;
    
    % Find epochs for red LED
    inds = find(LED_ORDER == 20);
    inds(find(inds>length(bind)))=[]; %delete unused inds
    bind_individual_LED = bind(inds); %times this LED was active & recorded
    
    red_signal = zeros(epoch_dur,n_runs);
    % Sort red LED's epoch repetitions into array (max. 5 times displayed - here it's 3)
    for mm = 1:length(bind_individual_LED)
        
        % The time period where shutter was opened for red LED (dur = 20)
        red_signal(:,mm) = iratio(bind_individual_LED(mm):bind_individual_LED(mm)+epoch_dur-1);
    end
    
    % df/f
    red_signal(red_signal == 0) = NaN;
    baseline= nanmean(nanmean(red_signal)); %averaging over stimulus repititions

    iratio = iratio./baseline-1;
    %%
    
    % Sort by LED type
    for jj = 1:num_LEDs
        % Find epochs for this LED
        inds = find(LED_ORDER == jj);
        inds(find(inds>length(bind)))=[]; %delete unused inds
        bind_individual_LED = bind(inds); %times this LED was active & recorded
        
        % Sort this LED's epoch repetitions into array (max. 5 times displayed - here it's 3)
        for mm = 1:length(bind_individual_LED)
            
            % The time period where shutter was opened for this LED (dur = 20)
            mr(jj,:,mm) = iratio(bind_individual_LED(mm):bind_individual_LED(mm)+epoch_dur-1); 
            
            %         temp=temp-min(temp);
            %         temp=temp/(max(temp));
            %         ms(jj,:)=temp;
        end
        
        rats(ii,jj,:)=mean(mr(jj,:,:),3,'omitnan'); %averaging over stimulus repititions
    end
    
    


    
    %We have 20 LEDs and the order is all the time the same (1-20). We want
    %to average over the same LED presentation (usually the same LED is presented ~3x in one imaging sequence)
   
%     LED_stimulus = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70]
% % %     LED_1 = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0]
% % %     LED_2 = [0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0] 
% % %     LED_3 = [0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0] 
% % %     LED_4 = [0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0] 
% % %     LED_5 = [0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0] 
% % %     LED_6 = [0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0] 
% % %     LED_7 = [0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0] 
% % %     LED_8 = [0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0] 
% % %     LED_9 = [0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0] 
% % %     LED_10 = [0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1]
% % %     LED_11 = [0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
% % %     LED_12 = [0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]    
% % %     LED_13 = [0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]  
% % %     LED_14 = [0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 
% % %     LED_15 = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
% % %     LED_16 = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0]  
% % %     LED_17 = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0]  
% % %     LED_18 = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0]  
% % %     LED_19 = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0]
% % %     LED_20 = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0]
   

%     neuron(ii)=in(ii).cell;
%     flyID(ii)=in(ii).flyID;
    name{ii}=in(ii).name;
%    center{ii}=in(ii).center; %ms added

end

% %% Test plots
% for ii=1:length(in)
%     for kk=1:num_LEDs        
%        fig = figure;
%        fig.Name = strcat('ROI #', num2str(ii),' Led #', num2str(kk));
%        plot(squeeze(rats(ii,kk,:)))
%        ylim([-0.2 0.5])
%        xlim([0 20])
%     end
% end

%% 
fprintf(' \n Remember: \n LED 1:367nm \n LED 2:373nm \n LED 3:385nm \n LED 4:405nm \n LED 5:420nmF \n LED 6:439nm \n LED 7:451nm \n LED 8:469nm \n LED 9:??nm \n LED 10:500nm  \n LED 11:518nm \n LED 12:530nm \n LED 13:554nmF \n LED 14:573nm \n LED 15:590nm \n LED 16:626nm \n LED 17:651nm \n LED 18:660nm \n LED 19:672nm \n LED 20:682nm  \n\n');    
neuron = [in.cell];
flyID = [in.flyID];

out.rats=rats;
out.neuron=neuron;
out.flyID=flyID;
out.name=name;
% out.center=center; %ms added


