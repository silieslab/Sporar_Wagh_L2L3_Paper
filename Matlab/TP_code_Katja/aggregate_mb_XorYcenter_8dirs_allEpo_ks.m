function out = aggregate_mb_XorYcenter_8dirs_allEpo_ks(in)
% % initially, just take all full periods by cell and trace...
% if(nargin<2) 
% dur = 180;
% end

n_epoch = 8; % horiz, inv horiz; vert, inv vert;
epochlength = zeros(length(in),1);

% baseline = [1:25 75:90]; %-8.5 to -6.5 ~ seconds, timing segment when mean trace will be used for dF/F calc

%added loop to find the epochlength:
for ii=1:length(in)

    s = in(ii).istim;
    % finding the actual epochs
    ds = diff(s); 
%     inds = find(ds~=0)+1; % ignoring the first epoch...
    binds = find(ds<0)+1; % ignoring the first epoch, finding the beginning of the epoch
    einds = find(ds>0)+1; % finding the beginning of the inter-epoch interval (0s in stim strace) 
    dinds = binds-einds(1:length(binds));
%     dinds = diff(inds);
    
    %ms: automatically determine epoch duration
    epochlength(ii)=round(mean(dinds));
end

%keyboard

dur = round(mean(epochlength));% 90; %ms, dur is no longer an input

rats = zeros([length(in),n_epoch,dur]);
name = cell(length(in),1);


onscreen = zeros(length(in),n_epoch/2); %yf: changed to be flexible for all n # of dirs
onscreen_X = zeros(length(in),1);
onscreen_Y = zeros(length(in),1);
centers = zeros(length(in),2);


for ii=1:length(in)
    
    % remove baseline
    iratio = in(ii).iratio;
    
    iratio = iratio./mean(iratio) - 1;
%     p = polyfit(in(ii).it,iratio,4);
%     pol = polyval(p,in(ii).it);
%     d_iratio = iratio - pol + 1;
%     
    d_iratio = iratio;  %took out polyfit correction
    
    s = in(ii).istim;

    % finding the actual epochs
    ds = diff(s);
    inds = find(ds>0)+1; % ignoring the first epoch...
    inds = inds(1:end-1); %ms: clipping of the last epoch, almost always too short
    
    epochs = s(inds);
    
    pos = in(ii).ifstimpos1;
    for jj=1:8 % 8dirs 
        
%         I = find(epochs==jj,1,'first');
        I = find(epochs==jj); %ms: take all the epochs
        bind = inds(I);
        
        allEpochs = zeros(length(bind),dur);
        for mm = 1:length(bind)
            allEpochs(mm,:) = d_iratio(bind(mm):(bind(mm)+dur-1));
            temp = mean(allEpochs,1);
        end
        
        % getting ride of motion artifacts
        %ms, yf: maybe comment this out...
% % % %         bad_inds = length(find((temp > 7.5)|(temp <- 5)));
%         temp(temp > 7.5) = median(temp);
%         temp(temp < -5) = median(temp);

%         temp = temp/mean(temp(baseline)); % dF/F from starting portion of trace-yf 11/2013
        temp = temp/mean(temp);
        
        
          
% % % % % % % % % %         % use center position for alignment
% % % % % % % % % %         if(jj==1)%0
% % % % % % % % % % %             xc=curpos1(v)
% % % % % % % % % %             if in(ii).center(1)~=500
% % % % % % % % % %                 e1_ind = find(pos(bind:(bind+dur-1)) < in(ii).center(1),1,'first')-1;
% % % % % % % % % %                 temp = circshift(temp,[1 -e1_ind + floor(dur/2)]); % floor to round
% % % % % % % % % %             end
% % % % % % % % % %             %temp = circshift(temp,[1 -e1_ind + (dur/2)]);
% % % % % % % % % %             %finds positions on one side of the RF center, circshifts
% % % % % % % % % %             %these + 1/2 of the whole trace --> RF is in middle 
% % % % % % % % % %         elseif(jj==2)% 180
% % % % % % % % % %             if in(ii).center(1)~=500
% % % % % % % % % %                 e2_ind = dur-e1_ind+1;%create reverse of epoch 1
% % % % % % % % % %                 temp = circshift(temp,[1 -e2_ind+floor(dur/2)]);
% % % % % % % % % %             end
% % % % % % % % % %         elseif(jj==3) %90
% % % % % % % % % %             if in(ii).center(2)~=500
% % % % % % % % % %                 e3_ind = find(pos(bind:(bind+dur-1))<in(ii).center(2),1,'first')-1;
% % % % % % % % % %                 temp = circshift(temp,[1 -e3_ind+floor(dur/2)]);
% % % % % % % % % %             end
% % % % % % % % % %         elseif(jj==4) %270
% % % % % % % % % %             if in(ii).center(2)~=500
% % % % % % % % % %                 e4_ind = dur-e3_ind+1;
% % % % % % % % % %                 temp = circshift(temp,[1 -e4_ind+floor(dur/2)]);
% % % % % % % % % %             end
% % % % % % % % % %         end
% % % % % % % % % %         
% % % % % % % % % %         
% % % % % % % % % %         % NEW ANGLES ADDED for 8Dirs - yf 
% % % % % % % % % %         if(jj==5) %45*
% % % % % % % % % %             if in(ii).center(3)~=500
% % % % % % % % % %                 e5_ind = find(pos(bind:(bind+dur-1)) < in(ii).center(3),1,'first')-1;
% % % % % % % % % %                 temp = circshift(temp,[1 -e5_ind+floor(dur/2)]);
% % % % % % % % % %             end
% % % % % % % % % %         elseif (jj == 7) %225
% % % % % % % % % %             if in(ii).center(3)~=500
% % % % % % % % % %                 e7_ind = dur-e5_ind+1;%create reverse of epoch 5
% % % % % % % % % %                 temp = circshift(temp,[1 -e7_ind+floor(dur/2)]);
% % % % % % % % % %             end
% % % % % % % % % %         elseif(jj == 6) %135
% % % % % % % % % %             if in(ii).center(4)~=500
% % % % % % % % % %                 e6_ind = find(pos(bind:(bind+dur-1))<in(ii).center(4),1,'first')-1;
% % % % % % % % % %                 temp = circshift(temp,[1 -e6_ind+floor(dur/2)]);
% % % % % % % % % %             end
% % % % % % % % % %         elseif (jj == 8) % 315
% % % % % % % % % %             if in(ii).center(4)~=500
% % % % % % % % % %                 e8_ind = dur-e6_ind+1; %create reverse of epoch 6
% % % % % % % % % %                 temp = circshift(temp,[1 -e8_ind+floor(dur/2)]);
% % % % % % % % % %             end
% % % % % % % % % %         end
 
          
        rats(ii,jj,:) = temp;
    end
    name{ii}=in(ii).name;

    
    
    for centerJ=1:4%length(n_epoch/2)
        % on-screen center for this onscreen direction? -yf
        if(in(ii).center(centerJ)>=-45)&&(in(ii).center(centerJ)<=45)
%             if(bad_inds<10)
                onscreen(ii,centerJ) = 1;
%             end
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
    centers(ii,3) = in(ii).center(3);
    centers(ii,4) = in(ii).center(4);
end

out.rats = rats;
out.neuron = [in.cell];
out.flyID = [in.flyID];
out.name = name;
out.onscreen= onscreen;
% out.onscreen_X = onscreen_X;
% out.onscreen_Y = onscreen_Y;

out.centers = centers;