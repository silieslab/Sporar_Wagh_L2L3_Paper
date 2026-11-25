%% Loading data
close all, clear all
% addr = 'C:\Data Processing\Behavioral Analysis\eni-data-analysis\Two Photon Analysis\Data';
% addr = '/Users/ksporar/2p/160109ks_fly1/Image 1692';
addr = uigetdir;
fileName = [addr '/data_file.mat'];
load(fileName);

imAligned = out.ch1a;
stim = out.fstimval;

[m, n, t] = size(imAligned); % image size

 %% checking image
% % sig = zeros(t,1); % vector for average signal
% figure
% for k=1:t
% %     sig(t) = sum(sum(imAligned(:,:,t)))/(m*n);
%     imagesc(imAligned(:,:,k));
% %     colormap(redblue)
%     pause(0.01)
% end

%% creating pattern matrix
idx = out.fstimval;
pos = ceil(out.fstimpos1) + max(out.fstimpos1); % normalizing pos, convert to pos in image
idxPat = unique(idx);
time = [0; find(diff(out.fstimval)); t];

d = 10; % the width of the bar stimulus
pat = zeros(m,m,t);
count = 1;
nShift = 0;
for k=1:length(time)-1
    for i=time(k)+1:time(k+1)
%         count = i;
        switch idx(count)
            case 0                
                pat(:,:,count) = fxMakingStripe(m,m,d,idx(count),'n');
            case 1
                dum = (pos(count) - pos(count-1));
                if dum>0
                    nShift = nShift + dum;
                end
                
                pat(:,:,count) = ...
                    ShiftMatrix(fxMakingStripe(m,m,d,idx(count),'u'),...
                    nShift,'u',0);
                
            case 2
                dum = (pos(count) - pos(count-1));
                if dum>0
                    nShift = nShift + 2*dum ;
                end
%                 r=100;
                r = m;
                if nShift >r
                    pat(:,:,count) = ...
                        ShiftMatrix(fxMakingStripe(m,m,d,idx(count),'l'),...
                        nShift-r,'l',0);
                else
                    pat(:,:,count) = ...
                        ShiftMatrix(fxMakingStripe(m,m,d,idx(count),'r'),...
                        -nShift+r,'r',0);                
                end                              
                
            case 3
                dum = (pos(count) - pos(count-1));
                if dum>0
                    nShift = nShift + dum;
                end
                
                pat(:,:,count) = ...
                    ShiftMatrix(fxMakingStripe(m,m,d,idx(count),'l'),...
                    nShift,'l',0);
                
            case 4
                dum = (pos(count) - pos(count-1));
                if dum>0
                    nShift = nShift + 2*dum;
                end
                r=m;
                if nShift > r
                    pat(:,:,count) = ...
                        ShiftMatrix(fxMakingStripe(m,m,d,idx(count),'l'),...
                        nShift-r,'l',0);
                else
                    pat(:,:,count) = ...
                        ShiftMatrix(fxMakingStripe(m,m,d,idx(count),'r'),...
                        -nShift+r,'r',0);                
                end
                    
            case 5
                dum = (pos(count) - pos(count-1));
                if dum>0
                    nShift = nShift + dum;
                end
                pat(:,:,count) = ...
                    ShiftMatrix(fxMakingStripe(m,m,d,idx(count),'d'),...
                    nShift,'d',0);
                
            case 6     
                dum = (pos(count) - pos(count-1));
                if dum>0
                    nShift = nShift + 2*dum;
                end

%                 r = 60;
                r = m;
%                 for count = 291:383
                if nShift >r
                    pat(:,:,count) = ...
                        ShiftMatrix(fxMakingStripe(m,m,d,idx(count),'r'),...
                        nShift-r,'r',0);
                else
                    pat(:,:,count) = ...
                        ShiftMatrix(fxMakingStripe(m,m,d,idx(count),'l'),...
                        -nShift+r,'l',0);                
                end
%                 end
%                 nShift = 0;

            case 7
               dum = (pos(count) - pos(count-1));
                if dum>0
                    nShift = nShift + dum;
                end
                pat(:,:,count) = ...
                    ShiftMatrix(fxMakingStripe(m,m,d,idx(count),'r'),...
                    nShift,'r',0);                
                
            case 8
                dum = (pos(count) - pos(count-1));
                if dum>0
                    nShift = nShift + 2*dum ;
                end
%                 r = 100;
                r = m;
                if nShift >r
                    pat(:,:,count) = ...
                        ShiftMatrix(fxMakingStripe(m,m,d,idx(count),'r'),...
                        nShift-r,'r',0);
                else
                    pat(:,:,count) = ...
                        ShiftMatrix(fxMakingStripe(m,m,d,idx(count),'l'),...
                        -nShift+r,'l',0);                
                end
        end
        count = count + 1;        
    end
    nShift = 0;
end

 %%   
 % create the video writer
writerObj = VideoWriter(['stimulusMovingBar' '.avi']);

% open the video writer
open(writerObj);
 for k=1:t
% figure,
    subplot(4,1,[1 2])
    imagesc(pat(:,:,k));
    axis equal
    set(gca, 'color', [0.1 .1 .1])
    pause(0.001)
    colormap(bone);
    subplot(4,1,[3 4])
    imagesc(imAligned(:,:,k));
    axis tight
    frame = getframe(gcf);
    writeVideo(writerObj,frame);
 end
close(writerObj);

