function  lsm_align_single_ms

% modified from lsm_align_and_norm_ms, to run within a batch script that
% doesn't call individual Image folders, but a full flyID.

% function  lsm_align_and_norm_ms(filename)
% function  lsm_align_and_norm(filename, ref, pre_stim )

%% Luis test
addpath(genpath('/Users/ksporar/Documents/MATLAB/TP_code_Katja'))
[fname]=uigetdir; % displays a modal dialog box showing the folders that are inside the current working directory
e=dir(fname); % dir lists the files and folders in the MATLAB? current folder
numberOfFolders = length(e)
cd([fname '/' e(1).name]);
%%


%ms: prompt for an image folder
[fname]=pwd; % Luis commented out.
e=dir(fname);
cd(fname);
out.fileloc = fname;
ind = strfind(out.fileloc,'/'); %Find the pattern / in string out.fileloc.
out.dataID = out.fileloc(ind(end-1)+1:(ind(end)-1));

% Luis test
cd(uigetdir)
%%
% % % % % num=0;
% % % % % for i=3:length(e)
% % % % % %     if ((e(i).isdir)&&(e(i).name(1)=='I'))
% % % % %     if ((e(i).name(1)=='I'))
% % % % %         out.fileloc = [fname '/' e(i).name]
% % % % % %         basename = [fname '/' e(i).name];
% % % % % %         cd(basename);
% % % % % %         out.fileloc = basename;
% % % % %     end
% % % % % end

%ms: find the .lsm file 
d=dir('*.lsm');
% filename = [fname '/' d.name]
filename = [d.name];

% If there is no .lsm file then look for .xml file.
if isempty(filename)
    folder = dir('*.xml');
    filename = [folder.name];
    filetype = 'xml';
else
    filetype = 'lsm';
end

   
%% Extract information from imaging file

switch filetype
    case 'lsm'
        [lsminf, scanInfo, ~] = lsminfo(filename);
        imagingInfo = lsminf;
    case 'xml'
        [imagingInfo, scanInfo] = getXmlInfo(filename);
end

%% Information of stimulus time series.

% Number of images.
nImages = numel(imagingInfo.stimulusFrames); % Number of frames.
% Image depth in bits.
imageDepth = scanInfo.bitDepth;% Bit depth.
% Image size in number of pixels.
height = scanInfo.linesPerFrame;% lines per frame.
width = scanInfo.pixelsPerLine;% pixels per line.

%% Define output file.
% Remove extension from filename.
nameNoExt = regexp(filename, ['.' filetype], 'split');
% Create filename for aligned images, with TIFF format.
alignedFile = [nameNoExt{1}, '_aligned.tif'];
% Save time stamps.
timeStampsFile = [nameNoExt{1} '_times.mat'];
% Extract the time stamps.
stimulusFrames = [imagingInfo.stimulusFrames{:}];
% Compute mean frame duration from relative frame times. 
relativeFrameTimes = {stimulusFrames(:).relativeTime};
relativeFrameTimes = str2double(relativeFrameTimes');
relFrameLength = mean(diff(relativeFrameTimes));
% Compute mean frame duration from relative frame times. 
absoluteFrameTimes = {stimulusFrames(:).relativeTime};
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
        imageArray = tiffread(filename,1:2:2*nImages);
    case 'xml'
        imagesFolder = regexp(filename, ['.' filetype], 'split');
        cd(imagesFolder{1});
        pathToFile = ['/Users/ksporar/2p/151028ks_fly1/Image 427/' ...
                      'TSeries-10282015-1006-427/' ...
                      'TSeries-10282015-1006-427_Cycle00001_Ch2_000001.ome.tif'];
   
        % Construct a Bio-Formats reader decorated with the Memoizer wrapper
        r = loci.formats.Memoizer(bfGetReader(), 0);
        % Initialize the reader with an input file to cache the reader
        r.setId(pathToFile);
        % Close reader
        r.close()
        % If the reader has been cached in the call above, re-initializing the
        % reader will use the memo file and complete much faster especially for
        % large data
        r.setId(pathToFile);
        % Perform additional work
        for iImage = 1 : nImages
            % Get the file name of the i-th image in the time series.
            iImageFile = imagingInfo.stimulusFrames{iImage}.fileName; 
            % Get the reader for the i-th image in the time series.
            iReader = bfGetReader(iImageFile);
            % Get the number of planes in the current image.
            nPlanes = iReader.getImageCount;
            % Store all the nPlanes in the image array imageArray, it will
            % have dimensions nPixelsX x nPixelsY x nFrames x nPlanes.
            for jPlane = 1: nPlanes;
                imageArray(:, :, iImage, jPlane) = bfGetPlane(iReader, jPlane);
            end
        end
        % Close the reader
        r.close()
    otherwise
        error(['Unrecognized file type: ' filetype])
end

%% Perform alignment.
ref_stack = zeros(height,width,30);
for ii = 1:30
    ref_stack(:,:,ii)=imageArray(ii).data;
end
ref = max(ref_stack, [], 3);
% ref = uint8(ref);

% read reference image
% im = tiffread(filename, ref*2-1);
% f = im2double(im.data);
f = imageArray.data;


I = zeros(height*width, nImages);
for j = 1:nImages
    g = im2double(imageArray(j).data);
    [output, Greg] = dftregistration(fft2(g),fft2(f),1);
    deltar = output(1,3);
    deltac = output(1,4);
    phase = output(1,2);
    Nr = ifftshift(-fix(height/2):ceil(height/2)-1);
    Nc = ifftshift(-fix(width/2):ceil(width/2)-1);
    [Nc, Nr] = meshgrid(Nc,Nr);
    g_reg = ifft2(fft2(g).*exp(1i*2*pi*(deltar*Nr/height+deltac*Nc/width))).*exp(-1i*phase);
    g_reg = uint8(g_reg*2^imageDepth);
    if j==1
        imwrite(g_reg, alignedFile);
    else
        imwrite(g_reg, alignedFile, 'WriteMode', 'append');
    end
    
    % ms let's try this: put g_reg into a matrix and keep this in matlab
    % format
    unregIm(:,:,j) = g;
    regIm(:,:,j) = (g_reg);
   
    
    % median filter - needed for normalization
    fm = medfilt2(g_reg, [5 5]);
    I(:,j) = reshape(fm, height*width,1)+1;
end

%ms: could also use filtered Image Sequence:
ImSeq = reshape(I,[height,width,nImages]);
% out.ch1a = ImSeq;

%store unaligned image in output
out.ch1 = im2double(unregIm);

%store aligned image in output
out.ch1a = im2double(regIm);


%% Write to out.xml the info in scanInfo struct.
out.xml = scanInfo;
% read stimulus_output file and add stimulus information to out 
% (taken from read_roi_data_all_1ch_mac or clean_up_dir2 within) 

%imaging information from reading lsm file goes here.
%         out.xml.datetime = out.xml.datetime{1}(1:(ind{1}));

%% Rename frametime, frame rate, and z depth for subsequent scripts.
out.xml.frametime = framePeriod; %framePeriod
%         temp = xml_read_1ch(d(2).name,'DimensionDescription DimID="T"',3);
%         out.xml.framerate = 1/temp;
out.xml.framerate = 1/framePeriod; 
      
%         out.xml.zdepth = temp;
out.xml.zdepth = scanInfo.positionCurrent.ZAxis; % positionCurrent.zAxis.

%% Commented out.
% out.xml.yPos = scanInfo.SAMPLE_0Y; % positionCurrent.yAxis.
% out.xml.xPos = scanInfo.SAMPLE_0X; % positionCurrent.xAxis.
% 
% 
% %         temp = xml_read_1ch(d(2).name,'Voxel-Width',2);
% %         out.xml.xres = temp/1000;
% out.xml.xres = imagingInfo.VoxelSizeX; % micronsPerPixel.XAxis
% %         
% %         temp = xml_read_1ch(d(2).name,'Voxel-Height',2);
% %         out.xml.yres = temp/1000;
% out.xml.yres = imagingInfo.VoxelSizeY; % micronsPerPixel.YAxis
% 
%         
% %         temp = xml_read_1ch(d(2).name,'Zoom',2);
% %         out.xml.zoom = temp;
% out.xml.zoom = scanInfo.ZOOM_X; % Optical zoom.
% 
% out.xml.rotation = scanInfo.ROTATION; % rotation.
% out.xml.PMT1Gain = scanInfo.DETECTOR_GAIN; % 
% out.xml.PMT2Gain = scanInfo.DETECTOR_GAIN; % 
% 
% out.xml.bitrate = scanInfo.BITS_PER_SAMPLE; %bit depth.
% out.xml.wavelength = scanInfo.WAVELENGTH;%laseWavelength.
% out.xml.laserpower = scanInfo.POWER;%laserPower
% out.xml.objective = scanInfo.ENTRY_OBJECTIVE;%objectiveLens.
% 
% %         temp=xml_read_1ch(d(2).name,'Scan Speed',2);
% %         out.xml.scanper = temp;
% %         
% 
%         
% out.xml.pixperline = imagingInfo.DimensionX;%pixels per line.
%         
% %         temp = xml_read_1ch(d(2).name,'Format-Height',2);
% %         out.xml.linesperframe = temp;
% out.xml.linesperframe = imagingInfo.DimensionY;% lines per frame.
%         
% %         temp = xml_read_1ch(d(2).name,'<FrameCount>',1);
% %         temp = temp{1};
% %         bind = strfind(temp,' ');
% %         out.xml.frames = str2num(temp(bind(end-1):bind(end)));
% out.xml.frames = imagingInfo.TIMESTACKSIZE;% number of images. 
% 
% % %         temp = xml_read_1ch(d(1).name,'<Dwell_Time>',0);
% %         out.xml.dwellt = (1/out.xml.scanper)*10^6/out.xml.pixperline; % temp!




%% Process stimulus file.

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
%ms, 150922, hopefully just temporarily,
%to fix problem with stimulus output file (skipping of frame counts), after
%testing the Bruker system

% %finding all the transitions, getting rid of one frame long ones
inds = find(diff(A.data(:,8)));
bad_inds = (diff(inds)==1);
inds(bad_inds)=[];
%using these to continuously count up
corr_stimvals = zeros(size(A.data,1),1);
for ii=1:length(inds)-1
    for jj=inds(ii):inds(ii+1)-1
        corr_stimvals(jj)=ii;
    end
end
%filling in the last one
for ii=length(inds)
    for jj=inds(ii):size(A.data,1)
        corr_stimvals(jj)=ii;
    end
end
A.data(:,8)=corr_stimvals;
%******************************************************************

%find average value of stimulus for each imaging frame
avrstimval = zeros(A.data(end,8),1); % 8s were all 7
fstimval = zeros(A.data(end,8),1);
fstimpos1 = zeros(A.data(end,8),1);
fstimpos2 = zeros(A.data(end,8),1);
for k = 1:(A.data(end,8))
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
    end
end

save('stim','ch3','avrstimval','fstimval','frame_nums','stim_type','fstimpos1','fstimpos2');


% load('stim');
out.ch3 = ch3;
out.avrstimval = avrstimval;
out.fstimval = fstimval;
out.frame_nums = frame_nums;
out.stim_type = stim_type;
out.fstimpos1 = fstimpos1;
out.fstimpos2 = fstimpos2;
        
        
% % % % % %                 out.ch1a = zeros(out.xml.linesperframe,out.xml.pixperline,out.xml.frames,'uint16');
% % % % % % %         out.ch2a = zeros(out.xml.linesperframe,out.xml.pixperline,out.xml.frames,'uint16');
% % % % % %         %strs = {'CH1_aligned','CH2_tocoords'};
% % % % % %         strs = {'Ch1_aligned','Ch2_tocoords'};
% % % % % %         for j = 1%:2
% % % % % %             d=dir(sprintf('*%s.tif',strs{j}));
% % % % % %             if (length(d)==1)
% % % % % %                 for k = 1:out.xml.frames
% % % % % %                     str = sprintf('out.ch%da(:,:,k)=imread(d.name,k);',j);
% % % % % %                     eval(str);
% % % % % %                 end
% % % % % %             else
% % % % % %                 disp(['error in file set ' out.fileloc ' channel ' num2str(j)]);
% % % % % %             end
% % % % % %         end

        save('data_file','out');

        cd ..
%% play with aligned and non-aligned image sequences
% make movie of aligned image series and play

% %make movie of raw data
% n=num_img;
% for j=1:n
%     image(im(j).data)
%     N(j) = getframe;
% end
% % % movie(N)
% % movie2avi(N,'original_image')
% % 
% % %make movie of aligned data before filtering
% n=num_img;
% for j=1:n
%     imagesc(squeeze(regIm(:,:,j)))
%     M(j) = getframe;
% end
% % movie(M)
% movie2avi(N,'aligned_noFilter')
% 
% 
% %make movie of aligned data after median filtering
% n=num_img;
% for j=1:n
%     imagesc(squeeze(ImSeq(:,:,j)))
%     K(j) = getframe;
% end
% % movie(M)
% movie2avi(K,'aligned_and_medfilt2')

%% code from original function that claculates dF/Fs and creates another tiff that displays that
%relies on some prestim image that we typically don't record.



% % deltaF/F0
% Inorm = I;
% for k=1:nr*nc
%     I0(k) = mean(Inorm(k,1:round(pre_stim/fr)));
%     Inorm(k,:) = 100*(Inorm(k,:)-I0(k))/I0(k);
% end
% Imax = max(max(Inorm));
% Imin = min(min(Inorm));
% 
% % save normalized images
% output_file = [s{1}, '_aligned_norm.tif'];
% imwrite(uint8(reshape(I0, nr, nc)), output_file);
% for j=1:num_img
%     imwrite(uint8(reshape(Inorm(:,j), nr, nc)), output_file, 'WriteMode', 'append');
% end
% 
% end
% 
