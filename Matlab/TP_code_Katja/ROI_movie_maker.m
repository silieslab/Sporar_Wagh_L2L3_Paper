
function ROI_movie_maker(datafile, dataStruct,movieFrameSize,startFrame)
% ********************************************************************
% ********************************************************************
% ********************************************************************
%            Makes videos of ROI responses and imaging frames 
% ********************************************************************
% ********************************************************************
% ********************************************************************

%% 
% Get the image frames and ROI information
images = datafile.ch1a;
stimulus = datafile.fstimval;
responses = [dataStruct.dRatio];
maskData = dataStruct.masks;
nMasks = length(maskData);
% Movie properties
movieFilename = 'Gif';
movieFormat = 'mp4';
profile = 'MPEG-4';
[saveName, savePath] = uiputfile('*.mp4', 'Choose name and path to save video');
cd(savePath)
writerObj = VideoWriter(saveName, profile);
writerObj.FrameRate = 30;
frameRate = 10;

open(writerObj);

if nargin == 2
    movieFrameSize = 200
    startFrame = 150
elseif nargin == 3
    startFrame = 150
end
hFig = figure;
% Make movie
for iFrame = startFrame : 1 : movieFrameSize
    % Plotting current frame
    subplot(6,6,[1:4 7:10 13:16])
    
    if exist('datafile.xml.linesperframe') && exist('datafile.xml.pixperline')
        CMask = zeros(datafile.xml.linesperframe, datafile.xml.pixperline, 3); % Luis 13.11.2015
    else
        CMask = zeros(str2double(datafile.xml.linesPerFrame), str2double(datafile.xml.pixelsPerLine), 3);
    end

    % Generating a colormap for Masks
%     cm = colormap('lines');
    cm1 = ('g');
    cm2 = ('b');

    % Creating colored masks
%     for i = 1:nMasks
%         curColor = cm(i,:);
%         curMask = cat(3,curColor(1).*flipud(maskData{i}),curColor(2).*flipud(maskData{i}),curColor(3).*flipud(maskData{i}));
%         CMask = CMask + curMask;
%     end

    for i = 1:(nMasks - 6);
        curColor = cm1(i,:);
        curMask = cat(3,curColor(1).*flipud(maskData{i}),curColor(2).*flipud(maskData{i}),curColor(3).*flipud(maskData{i}));
        CMask = CMask + curMask;
    end
    
    for i = 11:nMasks;
        curColor = cm2(i,:);
        curMask = cat(3,curColor(1).*flipud(maskData{i}),curColor(2).*flipud(maskData{i}),curColor(3).*flipud(maskData{i}));
        CMask = CMask + curMask;
    end
    
    
    imageROI = imagesc(squeeze(images(:, :, iFrame)));
    colormap('gray');
    hold on;
    h = imagesc(flipud(CMask));
    set(h,'AlphaData',0.2);
    title(sprintf('Time: %.2f s',(iFrame+1-startFrame)/frameRate) )
    set(gca,'xticklabel',[])
    set(gca,'yticklabel',[])
    % Plotting current stimulus
    subplot(6,6,[5:6 11:12 17:18])
    currStim = stimulus(iFrame);
    stimImage = zeros(1,1,3);
    if currStim == 1
        
        stimImage(:,:,:) = 1;
        
    elseif currStim ==0
        stimImage(:,:,:) = 0;
        
    end
    
    imagesc(stimImage);
    set(gca,'xticklabel',[])
    set(gca,'yticklabel',[])
    set(gca,'linewidth',4)
    title('Stimulus Screen')
    % Plotting ROI traces
    subplot(6,6,[19:36])
    plot(responses(:,startFrame:iFrame)')
    xlim([0 movieFrameSize-startFrame])
    niceaxes;
    set(gca,'xticklabel',[])
    set(gca,'yticklabel',[])
    xlabel('Time')
    ylabel('ROI signal')
    
    ylim([0 max(max(responses))])
    set(gca,'linewidth',2)
    frame = getframe(hFig);
    writeVideo(writerObj, frame);
end
close(writerObj);
close(gcf)