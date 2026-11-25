function out = aggregate_mb_XorYcenter_4dirs_allEpo_v2EDGES(in)
% % initially, just take all full periods by cell and trace...
% if(nargin<2) 
% dur = 180;
% end


%EDGES_BAR_POS_OFFSET The recording bar position for the edges stimulus: moving_edges_20d_4dirs_rperm
% runs from 183.3896  to -296.1072 "degs"
% This asymmetry in the angles stored as position of the bar values breaks
% the alinement code when you try to aline the trace based on the measured
% center for that ROI.  This is because it uses the location within the
% list of bar locations 183.3896  to -296.1072 as the index for the shift
% operation.  The shift operation of the bar moving the oposite direction
% (ie 0 and 180  or 90 and 270, will not be shifted the same amount if
% this index was not solved for on a symmetric stimlulus.  To solve this
% problem we add 56.5 to the position value so that it runs from 
%  ~239.8 to - 239.6
EDGES_BAR_POS_OFFSET = 56.5;

n_epoch = 4; % horiz, inv horiz; vert, inv vert; 
epochlength = zeros(length(in),1);

%added loop to find the epochlength:
for ii=1:length(in)
    
    %dealing with some error in stimulus output file, where epochs are not
    %1,2,3 or 4, but 0
    s = in(ii).istim;
    % patch - remove incidental zeros
    fginds = find(s~=0,1,'first'); % istim often start with zero's 
    s(1:(fginds-1)) = s(fginds); % replace zeros at beginning with first non zero element  ???? WHY???
    zinds = find(s==0); %find all the other elements that are zero. indices!
    if(~isempty(zinds))
        if(zinds(1)==1) %if the first element is a zero-element (how can this be?, didn't we just fix this?)
            zinds = zinds(2:end);
            s(1) = s(2);
        end
    end
    for z = 1:length(zinds)
        s(zinds(z)) = s(zinds(z)-1); %throughout stim vector, replace zeros with previous element
    end
    % finding the actual epochs
    ds = diff(s);
    inds = find(ds~=0)+1; % ignoring the first epoch...
    dinds = diff(inds);
    
    %ms: automatically determine epoch duration
    epochlength(ii)=round(mean(dinds));
end

dur = round(mean(epochlength));% 90; %ms, dur is no longer an input
% baseline = [1:25   epochlength(end)-26:epochlength(end)-2]; % timing segment when mean trace will be used for dF/F calc
baseline = [1:25] %   epochlength(end)-26:epochlength(end)-2]; % timing segment when mean trace will be used for dF/F calc

rats = zeros([length(in),n_epoch,dur]);
name = cell(length(in),1);
onscreen = zeros(length(in),n_epoch/2); %yf: changed to be flexible for all n # of dirs
% onscreen_X = zeros(length(in),1);
% onscreen_Y = zeros(length(in),1);
centers = zeros(length(in),2);


for ii=1:length(in)
    
    % remove baseline
    idSignal1 = in(ii).iratio;
    
    idSignal1 = idSignal1./mean(idSignal1) - 1;
    p = polyfit(in(ii).it,idSignal1,4);
    pol = polyval(p,in(ii).it);
    d_Signal1 = idSignal1 - pol + 1;
    
    %d_iratio = iratio;  %helen took out polyfit correction
    
    %dealing with some error in stimulus output file, where epochs are not
    %1,2,3 or 4, but 0
    s = in(ii).istim;
    % patch - remove incidental zeros
    fginds = find(s~=0,1,'first'); % istim often start with zero's 
    s(1:(fginds-1)) = s(fginds); % replace zeros at beginning with first non zero element
    zinds = find(s==0); %find all the other elements that are zero. indices!
    if(~isempty(zinds))
        if(zinds(1)==1) %if the first element is a zero-element (how can this be?, didn't we just fix this?)
            zinds = zinds(2:end);
            s(1) = s(2);
        end
    end
    for z = 1:length(zinds)
        s(zinds(z)) = s(zinds(z)-1); %throughout stim vector, replace zeros with previous element
    end
    
    % finding the actual epochs
    ds = diff(s);
    inds = find(ds~=0)+1; % ignoring the first epoch...
    %inds = [1 inds]; %ms: TEMP adding the first epoch.
    
    inds = inds(1:end-1); %ms: clipping of the last epoch, almost always too short
    % Handling a bug in fstimval
    dinds = diff(inds);
    if(~isempty(find(dinds==1)))
        bad_inds = find(dinds==1);
        inds(bad_inds:(bad_inds+1)) = [];
    end
    epochs = s(inds);
    
    pos = in(ii).ifstimpos1;
    pos = pos + EDGES_BAR_POS_OFFSET;  % fixed asymetry in the edges stimlulus presentations to make center alinement work-yf
    
    for jj=1:4 % *dirs now-yf
        
        %         I = find(epochs==jj,1,'first');
        I = find(epochs==jj); %ms: take all the epochs
        bind = inds(I);
        
        allEpochs = zeros(length(bind),dur);
        for mm = 1:length(bind)
            allEpochs(mm,:) = d_Signal1(bind(mm):(bind(mm)+dur-1));
        end
        temp = mean(allEpochs,1);
        
        
        % getting ride of motion artifacts
        %ms, yf: maybe comment this out...
        bad_inds = length(find((temp > 7.5)|(temp <- 5)));
        %         temp(temp > 7.5) = median(temp);
        %         temp(temp < -5) = median(temp);
        
        temp = temp/mean(temp(baseline)); % dF/F from starting portion of trace-yf 11/2013
        %temp = temp/mean(temp);
        
        %convert allEpochs to dF/F
        allEpochs_temp = allEpochs ./ (mean(temp(baseline)));
        
        
        %yf: helps for debugging to check if there is a data set missing centers
        %yf: comment out later to save time
        %             in(ii).name
        %             in(ii).center(1)
        
        
        
         ii;jj        %use center position for alignment
                if(jj==1)%0
        %             xc=curpos1(v)
                    if in(ii).center(1)~=500
                        e1_ind = find(pos(bind:(bind+dur-1)) < in(ii).center(1),1,'first')-1; %ms: finds the last index (!) before the stim hit the RF
                        temp = circshift(temp,[1 -e1_ind + floor(dur/2)]); % floor to round
                        allEpochs_temp = circshift(allEpochs_temp,[1 -e1_ind + floor(dur/2)]); % floor to round
                        
                    end
                    %temp = circshift(temp,[1 -e1_ind + (dur/2)]);
                    %finds positions on one side of the RF center, circshifts
                    %these + 1/2 of the whole trace --> RF is in middle
                elseif(jj==2)% 180
                    if in(ii).center(1)~=500
                        e2_ind = dur-e1_ind+1;%create reverse of epoch 1
                        temp = circshift(temp,[1 -e2_ind+floor(dur/2)]);
                        
                        allEpochs_temp = circshift(allEpochs_temp,[1 -e2_ind+floor(dur/2)]);
                       
                    end
                elseif(jj==3) %90
                    if in(ii).center(2)~=500
                        e3_ind = find(pos(bind:(bind+dur-1))<in(ii).center(2),1,'first')-1;
                        temp = circshift(temp,[1 -e3_ind+floor(dur/2)]);
                        
                        allEpochs_temp = circshift(allEpochs_temp,[1 -e3_ind+floor(dur/2)]);
                    end
                elseif(jj==4) %270
                    if in(ii).center(2)~=500
                        e4_ind = dur-e3_ind+1;
                        temp = circshift(temp,[1 -e4_ind+floor(dur/2)]);
                        
                        allEpochs_temp = circshift(allEpochs_temp,[1 -e4_ind+floor(dur/2)]);
                    end
                end
%         
  
%         % NEW ANGLES ADDED for 8Dirs - yf 
%         if(jj==5) %45*
%             if in(ii).center(3)~=500
%                 e5_ind = find(pos(bind:(bind+dur-1)) < in(ii).center(3),1,'first')-1;
%                 temp = circshift(temp,[1 -e5_ind+floor(dur/2)]);
%             end
%         elseif (jj == 7) %225
%             if in(ii).center(3)~=500
%                 e7_ind = dur-e5_ind+1;%create reverse of epoch 5
%                 temp = circshift(temp,[1 -e7_ind+floor(dur/2)]);
%             end
%         elseif(jj == 6) %135
%             if in(ii).center(4)~=500
%                 e6_ind = find(pos(bind:(bind+dur-1))<in(ii).center(4),1,'first')-1;
%                 temp = circshift(temp,[1 -e6_ind+floor(dur/2)]);
%             end
%         elseif (jj == 8) % 315
%             if in(ii).center(4)~=500
%                 e8_ind = dur-e6_ind+1; %create reverse of epoch 6
%                 temp = circshift(temp,[1 -e8_ind+floor(dur/2)]);
%             end
%         end
 
          
        rats(ii,jj,:) = temp;
        % store allEpoch values in a cell
        allEpochsRats{ii, jj} = allEpochs_temp;
    end
    name{ii}=in(ii).name;

    
    
    for centerJ=1:2%length(n_epoch/2)
        % on-screen center for this onscreen direction? -yf
        if(in(ii).center(centerJ)>=-45)&&(in(ii).center(centerJ)<=45)
            if(bad_inds<10)
                onscreen(ii,centerJ) = 1;
            end
        end
        
    end
    
%     
%     % on-screen center for X? -yf
%     if(in(ii).center(1)>=-45)&&(in(ii).center(1)<=45)
%         if(bad_inds<10)
%             onscreen(ii,1) = 1;
%         end
%     end
%     % on-screen center for Y? -yf
%     if(in(ii).center(2)>=-45)&&(in(ii).center(2)<=45)
%         if(bad_inds<10)
%             onscreen(ii,2) = 1;
%         end
%     end
%     
%     
%     
    
    % yf: now four centers for this 8dir stimulus 
    centers(ii,1) = in(ii).center(1);
    centers(ii,2) = in(ii).center(2);
%     centers(ii,3) = in(ii).center(3);
%     centers(ii,4) = in(ii).center(4);
end

out.rats = rats;
out.allEpochsRats = allEpochsRats; % so we can see individual epoch traces for plotting
out.neuron = [in.cell];
out.flyID = [in.flyID];
out.name = name;
out.onscreen= onscreen;
% out.onscreen_X = onscreen_X;
% out.onscreen_Y = onscreen_Y;

out.centers = centers;