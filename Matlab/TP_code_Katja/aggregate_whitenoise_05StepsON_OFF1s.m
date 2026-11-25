

function out = aggregate_whitenoise_05StepsON_OFF1s(in)
% This function groups the different interesting epoch combinations in a
% Matrix.
% The epochs are distributed as:
% 
% 0 : white noise
% 1 : 100% OFF
% 2 : 50% OFF
% 3 : GREY
% 4 : 50% ON
% 5 : 100% ON

% all interesting epoch-combinations (20 out of 25 possible ones)
% I will ignore the first epoch (white noise, only for the adaptation; we might use it for calculating the mean fluorescence)
% N_EPOCHS = 18;
N_EPOCHS = 20; %ks added: 100% OFF --> 100% ON and 100% ON --> 100% OFF

fprintf(' \n Remember: \n 1 : 100%% OFF \n 2 : 50%% OFF \n 3 : GREY \n 4 : 50%% ON \n 5 : 100%% ON \n\n');

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

epochlength = round(mean(epochlengths));

% For each ROI (length(in)) the average of
% all interesting combinations (18 out of 25 possible ones) ( e.g. first is
% (0-1).)
% During the duration of 2 epochs (approx. 200)
rats = zeros(length(in),N_EPOCHS,2*epochlength);

                         

%% For each ROI
for ii=1:length(in)

    % df/f
    iratio = in(ii).iratio;
    iratio = iratio./mean(iratio) - 1;   
    d_iratio = iratio;
    
    % Now sort those epoch ratios in matrix "rats", for each epoch-combination 
    s = in(ii).istim;
    ds = diff(s);
    
    % Find indices for each trace
    % Problem: some combinations are left over (the ones which happen AFTER
    % a double-epoch was presented)
    b_inds = find(ds)+1;
    e_inds = b_inds+2*epochlength-1; % -1 because we want to go 'till the END
                                     % of the 2nd epoch.
   % OR:
%     % Find indices for each trace
%     % Problem: indices shifted
%     b_inds = find(ds)+1-epochlength;% find also the beginnings
%                                     % for double-displayed epochs
%     b_inds = [b_inds(2:end) b_inds(end)+epochlength]; 
%     e_inds = b_inds+2*epochlength-1; % -1 because we want to go 'till the END
%                                      % of the 2nd epoch.
%                                    
%       

    % Assign an identifying number to each epoch-combination in this ROI 
    % this is just an easier way to identify a combination using switch()
    for kk=1:length(b_inds) 
       % the last epochs might not be displayed fully, then jump out
       if(e_inds(kk) > length(s))
           continue
       end

       pairs(kk) = cantor(s(b_inds(kk)),s(e_inds(kk)));
    end
    
    % Store all examined pairs of this ROI in temp (approx 50)
    num_pairs = round(length(in(1).istim)/epochlength*2);
    temp = zeros(num_pairs,N_EPOCHS,2*epochlength);
    
    for jj=1:length(pairs)
        
        % If end of data is reached, jump out of loop.
        if(jj > numel(e_inds) || e_inds(jj) > length(d_iratio))
            continue;
        end
        
        b_ind = b_inds(jj);
        e_ind = e_inds(jj);
         
        % Check for interesting combinations. Combinations like (1,1) or (0,4)
        % are not interesting.
        switch pairs(jj)
            case cantor(1,2)% 100% OFF --> 50% OFF
                temp(jj,1,:)=d_iratio(b_ind:e_ind)';
            case cantor(1,3)% 100% OFF --> GREY
                temp(jj,2,:)=d_iratio(b_ind:e_ind)';
            case cantor(1,4)% 100% OFF --> 50% ON
                temp(jj,3,:)=d_iratio(b_ind:e_ind)';
            case cantor(1,5)% 100% OFF --> 100% ON
                temp(jj,4,:)=d_iratio(b_ind:e_ind)'; %ks added
            case cantor(2,1)% 50% OFF --> 100% OFF
                temp(jj,5,:)=d_iratio(b_ind:e_ind)';
            case cantor(2,3)% 50% OFF --> GREY
                temp(jj,6,:)=d_iratio(b_ind:e_ind)';
            case cantor(2,4)% 50% OFF --> 50% ON
                temp(jj,7,:)=d_iratio(b_ind:e_ind)';
            case cantor(2,5)% 50% OFF --> 100% ON
                temp(jj,8,:)=d_iratio(b_ind:e_ind)';
            case cantor(3,1)% GREY --> 100% OFF 
                temp(jj,9,:)=d_iratio(b_ind:e_ind)';
            case cantor(3,2)% GREY --> 50% OFF
                temp(jj,10,:)=d_iratio(b_ind:e_ind)';
            case cantor(3,4)% GREY --> 50% ON
                temp(jj,11,:)=d_iratio(b_ind:e_ind)';
            case cantor(3,5)% GREY --> 100% ON
                temp(jj,12,:)=d_iratio(b_ind:e_ind)';
            case cantor(4,1)% 50% ON --> 100% OFF
                temp(jj,13,:)=d_iratio(b_ind:e_ind)';
            case cantor(4,2)% 50% ON --> 50% OFF
                temp(jj,14,:)=d_iratio(b_ind:e_ind)';
            case cantor(4,3)% 50% ON --> GREY
                temp(jj,15,:)=d_iratio(b_ind:e_ind)';
            case cantor(4,5)% 50% ON --> 100% ON
                temp(jj,16,:)=d_iratio(b_ind:e_ind)';
            case cantor(5,1)% 100% ON --> 100% OFF
                temp(jj,17,:)=d_iratio(b_ind:e_ind)'; %ks added  
            case cantor(5,2)% 100% ON --> 50% OFF
                temp(jj,18,:)=d_iratio(b_ind:e_ind)';    
            case cantor(5,3)% 100% ON --> GREY
                temp(jj,19,:)=d_iratio(b_ind:e_ind)';
            case cantor(5,4)% 100% ON --> 50% ON
                temp(jj,20,:)=d_iratio(b_ind:e_ind)';

            otherwise
                fprintf('No matching found for epoch combination (%d %d). Not interested? \n', cantorX(pairs(jj)),cantorY(pairs(jj)));
        end
    end
    
    temp(temp == 0) = NaN;
    rats(ii,:,:) = mean(temp,1,'omitnan');
    name{ii}=in(ii).name;
end   

% No baseline substraction
out.rats = rats;
out.neuron = [in.cell];
out.flyID = [in.flyID];
out.name = name;
