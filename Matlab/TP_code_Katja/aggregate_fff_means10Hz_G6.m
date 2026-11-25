function out = aggregate_fff_means10Hz_G6(in)

% initially, just take all full periods by cell and trace...

rats=zeros(length(in),40);
stims=rats;

mr=zeros(100,40);
ms=zeros(100,40);
mot_counts = zeros(length(in),1);
name = cell(length(in),1);
bad_inds = zeros(length(in),1);
for ii=1:length(in)
%     for ii = 1:52:1000
        s=in(ii).istim;
        s1=s(find(s,1));
        xi=find(diff(s(1:end-40))<0); % trigger on going to dark...
        iratio = in(ii).iratio;
        iratio = iratio./mean(iratio) - 1;
        p = polyfit(in(ii).it,iratio,4);
        pol = polyval(p,in(ii).it);
        d_iratio = iratio - pol + 1;
%         figure;plot(iratio+1);hold on;plot(d_iratio,'k');
% %         plot(pol+1,'r');
%         if(~strcmp(input('OK?','s'),'y'))
%             bad_inds(ii) = 1;
%         end
        close all;
%     end
    for jj=1:length(xi)
        temp = d_iratio(xi(jj):xi(jj)+39)/median(d_iratio(xi(jj):xi(jj)+39));
%         mot_counts(ii) = mot_counts(ii) + sum(temp>1.75) + sum(temp<0.5);
%         temp(temp>1.75)=median(d_iratio(xi(jj):xi(jj)+39)); % replace these--cases of moving %ms: tn-xxl
%         temp(temp<0.5)=median(d_iratio(xi(jj):xi(jj)+39)); 
        mot_counts(ii) = mot_counts(ii) + sum(temp>3.75) + sum(temp<-3.5);
        temp(temp>3.75)=median(d_iratio(xi(jj):xi(jj)+39)); % replace these--cases of moving %ms: GCaMP6
        temp(temp<-3.5)=median(d_iratio(xi(jj):xi(jj)+39)); 
        mr(jj,:)=temp/mean(temp);
        
        temp=in(ii).istim(xi(jj):xi(jj)+39);
        temp=temp-min(temp); temp=temp/(max(temp));
        ms(jj,:)=temp;
    end
    rats(ii,:)=mean(mr(1:length(xi),:),1);
    stims(ii,:)=mean(ms(1:length(xi),:),1);
%     neuron(ii)=in(ii).cell;
%     flyID(ii)=in(ii).flyID;
    name{ii}=in(ii).name;
%     center{ii}=in(ii).center; %ms added
%     clear mr ms;
end
neuron = [in.cell];
flyID = [in.flyID];

out.rats=rats;
out.stims=stims;
out.neuron=neuron;
out.flyID=flyID;
out.name=name;
% out.center=center; %ms added
out.index=mean(rats(:,1:20),2)-mean(rats(:,21:40),2);
ratvar=(var(rats(:,1:20),[],2)/20+var(rats(:,21:40),[],2)/20).^.5; % approx 20 samples in each mean...
out.index_z=out.index./ratvar;

% Identify neurons with an inverse response
% Rdiff=mean(rats(:,1:200),2)-mean(rats(:,201:400),2);
f_norm=find(out.index_z>0.5);
f_inv=find(out.index_z<-0.5);

ufly = unique(flyID);
meanbyfly_inv = zeros(length(ufly),40);
meanbyfly_norm = zeros(length(ufly),40);
inv_inds = zeros(length(ufly),1);
norm_inds = zeros(length(ufly),1);
for ii=1:length(ufly)
    f=find((flyID==ufly(ii))&(mot_counts'<15)&(bad_inds'==0));
    ff=intersect(f_norm,f);
%     f=find(mot_counts<15);
%     ff=intersect(ff,f);
    if(~isempty(ff))
        meanbyfly_norm(ii,:)=mean(rats(ff,:),1);
        norm_inds(ii) = 1;
    else
        disp('empty');
    end
    ff=intersect(f_inv,f);
    if(~isempty(ff))
        meanbyfly_inv(ii,:)=mean(rats(ff,:),1);
        inv_inds(ii) = 1;
    end
    %ms: add a metric for all cells, not split into "normal" and "inverted"
    %ms: somewhat redundant, same as out.rats
    meanbyfly_all(ii,:)=mean(rats(f,:),1); %ms: unbiased, all cells
end

meanbyfly_norm = meanbyfly_norm(norm_inds==1,:);
meanbyfly_inv = meanbyfly_inv(inv_inds==1,:);

allm_norm=mean(meanbyfly_norm,1);
alle_norm=std(meanbyfly_norm,[],1)/sqrt(sum(norm_inds));

allm_inv=mean(meanbyfly_inv,1);
alle_inv=std(meanbyfly_inv,[],1)/sqrt(sum(inv_inds));

allm_all=mean(meanbyfly_all,1);%ms
alle_all=std(meanbyfly_all,[],1)/sqrt(sum(norm_inds)); %ms: what does [] do here?

%means only across cells (by fly), not across flies yet
out.meanbyfly_norm=meanbyfly_norm;
out.meanbyfly_inv=meanbyfly_inv;
out.meanbyfly_all=meanbyfly_all;%ms: added
%mean and sem across flies
out.allm_norm=allm_norm;
out.allm_inv=allm_inv;
out.allm_all=allm_all; %ms: added
out.alle_norm=alle_norm;
out.alle_inv=alle_inv;
out.alle_all=alle_all; %ms: added

out.norm_rats=rats(f_norm,:);
out.inv_rats=rats(f_inv,:);
out.all_rats=rats;
out.mot_counts = mot_counts;