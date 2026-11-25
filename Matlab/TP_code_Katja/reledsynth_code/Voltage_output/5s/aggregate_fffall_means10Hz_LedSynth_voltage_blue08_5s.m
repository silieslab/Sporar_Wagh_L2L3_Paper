function out = aggregate_fffall_means10Hz_LedSynth_voltage_blue08_5s(in)
% Aggregate function to analyse the LedSynth data recorded with voltage ouput
% modified aggregate_fffall_means10Hz_BleedThruFix_v2
% Katja, September 2017

% 2p settings: voltage output - imaging also during the LED presentation; presenting only blue LED (number 08), flashes long 2s, 5s or 200ms.
% 2p computer is sending signal to the LedSynth and LedSynth responds with a flash (and doesn't send any signal back to the 2p computer)

%% For each ROI + check the traces


%define stimulus trace first
S_one = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ]; %OFF ON OFF (length(stimulus_trace) = 100)
% S = [S_one S_one S_one S_one S_one];
S = [S_one S_one S_one S_one];


xi = find(diff(S)<0)+1; %OFF step
% n_runs = length(find(xi)); %just to check if we have 12 repetitions of the stimulus

epochlength = mean(diff(xi));
epoch_dur = epochlength*1.3;
name = cell(length(in),1);
rats=zeros(length(in),epoch_dur);
stims=zeros(length(in),epoch_dur);

for ii=1:length(in)
    in(ii).name
    
    
    
    
    % signal next, df/f
    iratio = in(ii).iratio;
    iratio = iratio./mean(iratio) - 1;
        
    iratio = iratio(1:length(S)); %I want the iration to be as long as my number of the S repetitions (I've recorded longer than the number of the stiumulus repetitions)

    maxlag = length(S_one);
    [y,lags] = xcov(S',iratio',maxlag,'coeff');
    [V,I] = max(y);
    iratio_shifted = circshift(iratio',lags(I))';%change to iratio after checking if iratio has the correct dimension / size
    
    %trial averaging
    allReps = zeros(length(xi),epoch_dur);
    for mm = 1:length(xi)-1
        allReps(mm,:) = iratio_shifted(xi(mm):(xi(mm)+epoch_dur-1));
        temp = mean(allReps,1);

    end
    
    rats(ii,:)=temp;
    stims(ii,:)=S(1:epoch_dur); %stupid, because hard coded, but works
end


neuron = [in.cell];
flyID = [in.flyID];

out.rats=rats;
out.stims=stims;
out.neuron=neuron;
out.flyID=flyID;
out.name=name;
end



