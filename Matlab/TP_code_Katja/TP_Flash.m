%% Loading data
close all, clear all
% addr = 'C:\Data Processing\Behavioral Analysis\eni-data-analysis\Two Photon Analysis\Data';
addr = '/Users/ksporar/2p/160109ks_fly1/Image 1692';
% addr = 'Z:\Vision Research\Data Processing\Walking Behavioral Analysis\eni-data-analysis\Two Photon Analysis';
fileName = [addr '\data_file.mat'];
load(fileName);

imAligned = out.ch1a;
stim = out.fstimval;

[m, n, t] = size(imAligned); % image size

%% checking image
% sig = zeros(t,1); % vector for average signal
figure
for k=1:t
%     sig(t) = sum(sum(imAligned(:,:,t)))/(m*n);
    imagesc(imAligned(:,:,k));
%     colormap(redblue)
    pause(0.01)
end

%% creating pattern matrix
idx = out.fstimval;
pos = ceil(out.fstimpos1) + 50; % convert to pos in image
idxPat = unique(idx);
time = [0; find(diff(out.fstimval)); t];

pat = zeros(m,m,t);
count = 1;
nShift = 0;
for k=1:length(time)-1
    for i=time(k)+1:time(k+1)
%         count = i;
        switch idx(count)
            case 0                
                pat(:,:,count) = fxMakingFlash(m,m,idx(count));
            case 1
                pat(:,:,count) = fxMakingFlash(m,m,idx(count));                     
        end
        count = count + 1;        
    end
    nShift = 0;
end

 %%   
 % create the video writer
writerObj = VideoWriter(['stimulusFlash' '.avi']);

% open the video writer
open(writerObj);
 for k=1:t
% figure,
    subplot(4,1,[1 2])
    imagesc(pat(:,:,k));    
%     axis equal
    pause(0.001)
    set(gca, 'color', [0.1 .1 .1])
    caxis([0,2])
    colormap(bone);
    subplot(4,1,[3 4])
    imagesc(imAligned(:,:,k));
%     axis tight
    frame = getframe(gcf);
    writeVideo(writerObj,frame);
 end
close(writerObj);

