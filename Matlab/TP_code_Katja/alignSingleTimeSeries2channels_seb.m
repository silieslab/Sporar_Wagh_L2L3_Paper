function alignSingleTimeSeries2channels_seb(dirPath, wantMovie, alignment)
    
    if nargin < 2
        wantMovie = false;
    end
    
    cd(dirPath)
    out.fileloc = dirPath;
    % [~, flyID] = fileparts(fileparts(dirPath));
    [~, name,ext] = fileparts(fileparts(dirPath)); % Seb's file naming
    flyID = [name ext]; % Seb's file naming
   out.dataID = flyID;

    %%

    %ms: find the .lsm file 
    d=dir('*.lsm');
    % filename = [fname '/' d.name]
    filename = [d.name];

    % If there is no .lsm file then look for .xml file.
    if isempty(filename)
        folder = dir('*.xml');
        filename = [folder.name];
        if isempty(filename)
            xmlDir = dir('T*');
            xmlDirName = xmlDir([xmlDir.isdir]).name;
            cd(xmlDirName)
            folder = dir('*.xml');
            filename = [folder.name];
            filetype = 'xml';
        else
            filetype = 'xml';
        end
    else    
        filetype = 'lsm';
    end
    
    %% Extract information from imaging file

    switch filetype
        case 'lsm'
            [lsminf, scanInfo, ~] = lsminfo(filename);
            imagingInfo = lsminf;
        case 'xml'
            [imagingInfo, scanInfo] = getXmlInfo2channels(filename); %Seb: new function for 2channels 
    end

    %% Information of stimulus time series.

    % Number of images.
    nImages = numel(imagingInfo.stimulusFrames{1}); % Number of frames.
    % Image depth in bits.
    imageDepth = str2double(scanInfo.bitDepth);% Bit depth.
    % Image size in number of pixels.
    height = str2double(scanInfo.linesPerFrame);% lines per frame.
    width = str2double(scanInfo.pixelsPerLine);% pixels per line.

    %% Define output file.
    % Remove extension from filename.
    nameNoExt = regexp(filename, ['.' filetype], 'split');
    % Create filename for aligned images, with TIFF format.
    alignedFile = [nameNoExt{1}, '_aligned.tif'];
    % Save time stamps.
    timeStampsFile = [nameNoExt{1} '_times.mat'];
    % Extract the time stamps.
    stimulusFrames = [imagingInfo.stimulusFrames{1,1}{:}];
    % Compute mean frame duration from relative frame times. 
    relativeFrameTimes = {stimulusFrames(:).relativeTime};
    relativeFrameTimes = str2double(relativeFrameTimes');
    relFrameLength = mean(diff(relativeFrameTimes));
    % Compute mean frame duration from absolut frame times. 
    absoluteFrameTimes = {stimulusFrames(:).absoluteTime};
    absoluteFrameTimes = str2double(absoluteFrameTimes');
    absFrameLength = mean(diff(absoluteFrameTimes));
    % Frame duration from microscope settings.
    framePeriod = str2double(scanInfo.framePeriod);
    % Time stamps, relative or absolute?.
    ts = relativeFrameTimes;
    % ts = imagingInfo.TimeStamps.TimeStamps;
    save(timeStampsFile, 'ts');
    % fr = mean(diff(ts));

    %% Read tiff time series.

    % Read the reference frames.
    switch filetype
        case 'lsm'
            imageArray = tiffread(filename,1: 2: 2 * nImages);
        case 'xml'
            imageArray = readTwoPhotonTimeSeries2channels(filename, imagingInfo);
            imageArray_Baseline = readTwoPhotonTimeSeries_Baseline2channels(filename, imagingInfo);
        otherwise
            error(['Unrecognized file type: ' filetype])
    end

    %% Perform alignment.
    % Create reference stack, using the first 30 frames.
    numberOfChannels = 2;
    framesForReference = 30; % Seb: You can increase HERE the number of frames to see the imgage much better if the signal is too low
     
    for iChannel = 1:numberOfChannels % Seb: for 2Channel Recordings (e.a, green and red channel)
        
        refStack = zeros(height, width, framesForReference);
        switch filetype
            case 'lsm'
                for iFrame = 1: framesForReference
                    refStack(:, :, iFrame) = imageArray(iFrame).data;
                end
                % Maximum intensity projection of reference stack.
                refFrame = max(refStack, [], 3);
                ref = uint8(refFrame);
                % Read reference image.
                im = tiffread(filename, refFrame*2-1);
                refFrame = im2double(im.data);
            case 'xml'
                for iFrame = 1: framesForReference % Seb: Its is 30 frames. It can be changed.
                    refStack(:, :, iFrame) = imageArray(:, :, iFrame,iChannel);
                end
                % Maximum intensity projection of reference stack.
                refFrame = max(refStack, [], 3);
            otherwise
                error(['Unrecognized file type: ' filetype])        
        end
    
    
    % Perform alignment based on maximizing image crosscorrelation in the Fourier space.
    
        if alignment
            in1 = cat(3,imageArray, imageArray_Baseline);
            in2 = refFrame;
            in3 = filetype;
            in4 = alignedFile;
            in5 = iChannel;
          

            [out1, out2, out3] = fourierCrossCorrelAlignment2Channels(in1, in2, in3, in4,in5);

            registeredImages = out1(:,:,1:nImages);
            unregisteredImages = out2(:,:,1:nImages);
            medianFilteredImages = out3(:,:,1:nImages);
            BaselineRegImages= out1(:,:,nImages+1:end);
            
            if iChannel == 1 % Storing info for Channel 1 (e.a, red channel)

                % Store unaligned image in output.
                out.ch1 = im2double(unregisteredImages);
                % Store aligned image in output.
                out.ch1a = im2double(registeredImages);
                % Store aligned filtered image in output.
                out.ch1b = medianFilteredImages;
                % Store aligned BaseLine images (mh)
                out.ch1BaseLine = im2double(BaselineRegImages);
            else % Seb Storing info for Channel 2 (e.a, green channel)
                out.ch2 = im2double(unregisteredImages);
                % Store aligned image in output.
                out.ch2a = im2double(registeredImages);
                % Store aligned filtered image in output.
                out.ch2b = medianFilteredImages;
                % Store aligned BaseLine images (mh)
                out.ch2BaseLine = im2double(BaselineRegImages);
            end
                
        else
            out1 = uint16(cat(3,imageArray, imageArray_Baseline));
            notalignedImages = out1(:,:,1:nImages,iChannel);
            BaselineRegImages= out1(:,:,nImages+1:end,iChannel);
            
            if iChannel == 1 % Storing info for Channel 1 (e.a, red channel)
                % Store notaligned image in output.
                out.ch1a = im2double(notalignedImages);
                % Store aligned BaseLine images (mh)
                out.ch1BaseLine = im2double(BaselineRegImages);
            else  % Seb Storing info for Channel 2 (e.a, green channel)
                % Store notaligned image in output.
                out.ch2a = im2double(notalignedImages);
                % Store aligned BaseLine images (mh)
                out.ch2BaseLine = im2double(BaselineRegImages);
            end
               
            
        end
    end
    
    
        

    %% Write to out.xml the info in scanInfo struct.
    out.xml = scanInfo;
    out.xml.frames = nImages;
    % Rename frametime, frame rate, and z depth for subsequent scripts.
    out.xml.frametime = framePeriod;
    out.xml.framerate = 1/framePeriod; 
%     out.xml.zdepth = str2double(scanInfo.positionCurrent.ZAxis); 
    out.xml.zdepth = str2double(scanInfo.positionCurrent.Z); %after z piezo installation
    
    %store absoluteFrameTimes for use in later analysis
    out.xml.absoluteFrameTimes = absoluteFrameTimes;
    
    %store relativeFrameTimes for use in later analysis
    out.xml.relativeFrameTimes = relativeFrameTimes;

    %% Process stimulus file.
    cd ..
    d = dir('_stimulus_output*');
    A = importdata(d.name);
    ch3 = A.data(:,4); %was 3
    frame_nums = A.data(:,8); %was 7

    fid=fopen(d.name,'r');
    currline=fgetl(fid);
    ind = strfind(currline,'\');
    stim_type = currline(ind(end)+1:end-5);
    fclose(fid);

    %**********************************************************
%     %ms, 150922, hopefully just temporarily,
%     %to fix problem with stimulus output file (skipping of frame counts),
%     %after testing the Bruker system
% 
%     % %finding all the transitions, getting rid of one frame long ones
%     inds = find(diff(A.data(:,8)));
%     bad_inds = (diff(inds)==1);
%     inds(bad_inds)=[];
%     %using these to continuously count up
%     corr_stimvals = zeros(size(A.data,1),1);
%     for iFrame=1:length(inds)-1
%         for jj=inds(iFrame):inds(iFrame+1)-1
%             corr_stimvals(jj)=iFrame;
%         end
%     end
%     %filling in the last one
%     for iFrame=length(inds)
%         for jj=inds(iFrame):size(A.data,1)
%             corr_stimvals(jj)=iFrame;
%         end
%     end
%     A.data(:,8)=corr_stimvals;
    %******************************************************************


    stimTimes = A.data(:,2); % Luis.
    out.stimTimes = stimTimes; % store the recorded timing of each stimulus record
    
    % commented out so that for faster imaging we don't miss frames
    %validStimFrames = verifyStimulusFrames(frame_nums, stimTimes, ts);%check this out, Marion and Yvette
    nValidStimFrames = nImages; %How many total frames actually imaged
    
    % Find average value of stimulus for each imaging frame.
    avrstimval = zeros(nValidStimFrames,1); % 8s were all 7
    fstimval = zeros(nValidStimFrames,1);
    fstimpos1 = zeros(nValidStimFrames,1);
    fstimpos2 = zeros(nValidStimFrames,1);

    
    firstEntry = A.data(1,8);
     
    for k = firstEntry:nValidStimFrames
        inds = find(A.data(:,8) == k);
        if(~isempty(inds))
            stimval = A.data(inds,4);
    %         stimvalcont = A.data(inds,3); %could add this if needed
    %         stimpos1 = A.data(inds,4);
    %         stimpos2 = A.data(inds,6);
            stimpos1 = A.data(inds,5); %ms, for jl type stimulus output files
            stimpos2 = A.data(inds,7); %ms, for jl type stimulus output files
            avrstimval(k) = mean(stimval);
            fstimval(k) = stimval(1);
            fstimpos1(k) = stimpos1(1);
            fstimpos2(k) = stimpos2(1);
            last_k_withStimEntries = k;
            
        %if scanning is faster than stimulus, use stimulus info of previous
        %frame that was written (last_k_withStimEntries):
        elseif(isempty(inds)) 
            inds = find(A.data(:,8) == last_k_withStimEntries); 
            stimval = A.data(inds,4);
    %         stimvalcont = A.data(inds,3); %could add this if needed
    %         stimpos1 = A.data(inds,4);
    %         stimpos2 = A.data(inds,6);
            stimpos1 = A.data(inds,5); %ms, for jl type stimulus output files
            stimpos2 = A.data(inds,7); %ms, for jl type stimulus output files
            avrstimval(k) = mean(stimval);
            fstimval(k) = stimval(1);
            fstimpos1(k) = stimpos1(1);
            fstimpos2(k) = stimpos2(1);
        end
    end
    
    for k = 1:firstEntry-1
            avrstimval(k) = avrstimval(firstEntry);
            fstimval(k) = fstimval(firstEntry);
            fstimpos1(k) = fstimpos1(firstEntry);
            fstimpos2(k) = fstimpos2(firstEntry);
    end
    

    save('stim', 'ch3', 'avrstimval', 'fstimval', 'frame_nums', ...
         'stim_type', 'fstimpos1', 'fstimpos2', 'stimTimes');

    out.ch3 = ch3;
    out.avrstimval = avrstimval;
    out.fstimval = fstimval;
    out.frame_nums = frame_nums;
    out.stim_type = stim_type;
    out.fstimpos1 = fstimpos1;
    out.fstimpos2 = fstimpos2;

%     save('data_file.mat', 'out');
    save('data_file.mat', 'out', '-v7.3'); %save big files as well

    %% Make movie for Bruker images.
    if wantMovie
        % Raw data movie.
%         makeTimeSeriesMovie(imageArray, 'original_series', 'mp4');
        % Aligned unfiltered data movie.
        if alignment
            makeTimeSeriesMovie(registeredImages, ...
                            'aligned_unfiltered_series_16bit', 'mp4');
        % Aligned median-filtered data movie.
%         makeTimeSeriesMovie(medianFilteredImages, ...
%                             'aligned_medianFiltered_series', 'mp4');
        else
            makeTimeSeriesMovie(notalignedImages, ...
                            'notaligned_unfiltered_series_16bit', 'mp4');
        end
            
    end
end