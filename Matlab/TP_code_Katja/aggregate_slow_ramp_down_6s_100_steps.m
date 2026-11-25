

function out = aggregate_slow_ramp_down_6s_100_steps(in)
% This function groups the different interesting epoch combinations in a
% Matrix.
% The epochs are distributed as:
% 
% 1 to 0.001 (or something like that)

s = in.istim;
n_epochs = length(unique(s));

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
    
    % Mode takes 'most common' value
    epochlengths(ii) = mode(duration);
end

epochlength = round(mean(epochlengths));

rats = zeros(length(in),n_epochs);



%% Baseline

for ii=1:length(in)

    iratio = in(ii).iratio;
    % Find epochs for 100% ON (this will be our baseline)
     is_100ON = (in(ii).istim == 0);
     epochlength_is_100ON = epochlength;
     begin = diff(is_100ON);
     e_inds100 = find(begin==-1)+1;
     b_inds100 = e_inds100-epochlength-1;
    % Sort 100ON repetitions into array (max. 5 times displayed - here it's 3)
    for mm = 1:length(b_inds100)
        % The time period
        ON100_signal(:,mm) = iratio(b_inds100(mm):e_inds100(mm));
    end

    % df/f
%     ON100_signal(ON100_signal == 0) = NaN;
%     baseline= nanmean(nanmean(ON100_signal)); %averaging over stimulus repititions
% 
%     iratio = iratio./baseline-1;
%     d_iratio = iratio;

    iratio = in(ii).iratio;
    iratio = iratio./mean(iratio) - 1;   
    d_iratio = iratio;  %took out polyfit correction
    

    %% 
    % Now sort those epoch ratios in matrix "rats", for each epoch
    s = in(ii).istim;
    ds = diff(s);
    e_inds = find(ds)+1;
%     b_inds = e_inds-epochlength-1;
    b_inds = e_inds-epochlength-1;

    
    mr=nan(1,n_epochs);
    
    
%     for jj = 1:n_epochs-1 %unique epochs
    for jj = 1:n_epochs %unique epochs
    % Find indices for each trace
    
    
    stims=rats;
    
%             for mm = 1:length(b_inds)
            
     mr(jj) = mean(iratio(b_inds(jj):b_inds(jj)+epochlength-1)); 
            
%             end
            

    end
    rats(ii,:)=mr; %averaging over stimulus repititions


    name{ii}=in(ii).name;    
end

    
neuron = [in.cell];
flyID = [in.flyID];

out.rats=rats;
out.stims=stims;
out.flyID=flyID;
out.name=name;
