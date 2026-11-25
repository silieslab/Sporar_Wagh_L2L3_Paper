%% Loading data
close all, clear all
% addr = 'C:\Data Processing\Behavioral Analysis\eni-data-analysis\Two Photon Analysis\Data';
addr = '/Users/ksporar/2p/171127ks_fly2/Image 2';
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
pos = ceil(out.fstimpos1) + max(out.fstimpos1); % normalizing pos, convert to pos in image
idxPat = unique(idx);
time = [0; find(diff(out.fstimval)); t];

patDim = max(pos);
pat = zeros(patDim,patDim,t);
count = 1;
nShift = 0;
type = 'on';
for k=1:t           
    pat(:,:,k) = ...
    fxMakingEdge(patDim,patDim,idx(k),pos(k),type);      
end



 %%   
 % create the video writer
writerObj = VideoWriter(['stimulusOnEdge' '.avi']);

% open the video writer
open(writerObj);
 for k=1:t
% figure,
    subplot(4,1,[1 2])
    imagesc(pat(:,:,k));
    caxis([0,2])
    set(gca, 'color', [0.1 .1 .1])
    axis equal
    pause(0.001)
    colormap(bone);
    subplot(4,1,[3 4])
    imagesc(imAligned(:,:,k));
    axis tight
    frame = getframe(gcf);
    writeVideo(writerObj,frame);
 end
close(writerObj);

