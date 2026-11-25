function out = aggregate_mb_rperm_csl_MS(in)
%ms: aggregate_mb_rperm_csl_MS2 does not load centers, for weak and noisy
%imaging data, where RFs cannot be seen in single traces (such as 0595
%imaging)

% initially, just take all full periods by cell and trace...

DUR=1800; %ms: changed from 1350 for movebar_rperm to this, because the bar 
%takes no longer to cross (longer epoch). changed so that responses can decay completely. 

rats={zeros(length(in),DUR),zeros(length(in),DUR),zeros(length(in),DUR),zeros(length(in),DUR)};
%ms: changed length of rats for csl version

for ii=1:length(in)
    s=in(ii).istim;
    
    %s(1) = s(10); %ms: sometimes, first (couple) stim index is/are 0  and correct count starts on 2nd (or slightly later) index, take this one instead
    s(1) = s(find(s,1,'first')); %ms: replaces s(1) by the first non zero element
    for kk=1:length(s) %ms: set these other weird 0 values within an epoch to the value preceding it
        if s(kk)==0
           s(kk)=s(kk-1);
           disp(['fixed bug in istim of ' in(ii).name  ' index ' num2str(kk)]);
        end
    end
    
    %ch=find(diff(s)); %ms: was like this, but this gives last index of old
    ds = diff(s);
    ch=find(ds)+1; %+1 gives first index of new epoch
    ch=[ch(1:4)]; % ms: ignoring the first epoch, then keep 4 (1st stimulus of second round is same one than first of first round)

    epochs = s(ch);
    
    in(ii).iratio=in(ii).iratio/mean(in(ii).iratio); % normalize here.
    for jj=1:4 
        I = find(epochs==jj,1,'first');  %ms: find the right epoch (added for rperm)
        temp=in(ii).iratio(ch(I):ch(I)+DUR-1);
%         disp(mean(temp));
        temp(temp>1.6)=median(temp);
        temp(temp<0.6)=median(temp); 
        rats{jj}(ii,:)=temp/mean(temp); % and again for local changes...
    end
    neuron(ii)=in(ii).cell;
    flyID(ii)=in(ii).flyID;
    name{ii}=in(ii).name;
    center{ii}=in(ii).center; %ms: added for csl analysis
%     clear mr ms;
end

out.rats=rats;
out.neuron=neuron;
out.flyID=flyID;
out.name=name; 
out.center=center;