function out=load_neuron_data10Hz_byRegion_LedSynth(in,locdir, regionTypeWanted)

[fname,datetime,frames,zdepth,tottime,stimbouts,locnum,...
    activecells,inverted,stimcode,quality,driver,...
    moving,layer,wavelength,flyID, responsivefly]...
    =textread('MASTER_foldersummary_Katja.txt',...
    '%s %s %f %f %f %f %f %s %f %s %f %s %f %s %f %f %f \r',...
    'headerlines',1,'delimiter','\t');

if(nargin<3)
    % lobula plate layer 1
    regionTypeWanted= 'AT'; % AT=axon terminals; A=axons; CB=cell bodies; C=chiasm
end


currd=pwd;
cd(locdir);

count=1;
for ii=1:length(in)  % all the presentations of the correct stimulus by ROI
    ii
    qq=in(ii).cell;  % which ROI 'cell' we are currently on...
    ss=strcmpi(in(ii).name,fname);  % logical that tells you which LDM out of all of them we are currently on. 
    if exist(in(ii).name) * (qq>0)
        x=load(in(ii).name);  % open that data file
        
        currRegionInfo=layer{ss};
        % now use this info to determine if the current "cell" value stored
        % in qq matches any of the numbers that follow the "layer type" that
        % we want  ie LPA 3 4 6 7....
        % only record data if so....
        str_i_region=strfind(currRegionInfo, regionTypeWanted); % gives you the first location of regionTypeWanted in currRegionInfo

        if(~isempty(str_i_region))        

            str_start=  str_i_region + length(regionTypeWanted)-1;
            i=str_start; % index one before where the numbers will start
            
            while(true)  
                i=i+1;
                
                if(isletter(currRegionInfo(i))) % a letter denotes next region "label tag"
                    break;
                end
                
                if(i==length(currRegionInfo)) % end of the region string
                    i=i+1; % this is the last number so step one more to get the indexing to include it....
                    break;
                end
                
            end
            %yf: numbers of the ROI's that we want the data from
            regionsToUse=str2num(currRegionInfo(str_start+1:i-1));
            
            
            if qq<=size(x.strct.dRatio,1) && sum(regionsToUse==qq)
                % if this ROI is within the 'regionToUse' list of number of ROIs recorded
                % and if this ROI was listed within the wanted region of the
                % brain...
                out(count).stimcode=stimcode{ss};
                out(count).quality=quality(ss);
                out(count).driver=driver{ss};
                out(count).layer=layer(ss);
                out(count).wavelength=wavelength(ss);
                out(count).flyID=flyID(ss);
                out(count).name=in(ii).name;
                out(count).cell=in(ii).cell;
                out(count).xml=x.strct.xml;
                out(count).ratio=x.strct.dRatio(qq,:);
%                 out(count).stim = x.strct.fstimval; %ks
%                 out(count).raw_stim = x.strct.ch3; %ks
%                 out(count).avrstimval = x.strct.avrstimval; %ks
%                 out(count).frame_nums = x.strct.frame_nums; %ks
                fps=x.strct.xml.framerate;
                %ms: now: # frames / framerate makes timing vector
                out(count).t=[1:length(out(count).ratio)]/fps;
                %ms: new timing vector for interpolation at 10Hz (0.1), starts at ends with 0.5/fps shift
                out(count).it=[0.5/fps:0.1:(length(out(count).ratio)+0.5)/fps];
                %ms: nearest neighbor interpolation (should maintain discrete values) of .stim (also at 10Hz now)
                %ms: also linearly extrapolates values outside .t
                
                %out(count).t
                %count
                
%                 out(count).istim=interp1(out(count).t,out(count).stim,out(count).it,'nearest','extrap'); %ks
%                 out(count).iavrstim=interp1(out(count).t,out(count).avrstimval,out(count).it,'nearest','extrap'); %ks
                
                %ms: same for the ratio, only here we want linear interpolation
                out(count).iratio=interp1(out(count).t,out(count).ratio,out(count).it,'linear','extrap');
                
                
                % added stimpos and centers  interpl is based on the length of out.t here, why not out.it? -yf 5/21/13
                if(isfield(x.strct,'fstimpos1'))
                    out(count).ifstimpos1=interp1(out(count).t,x.strct.fstimpos1,out(count).it,'nearest','extrap');
                    out(count).ifstimpos2=interp1(out(count).t,x.strct.fstimpos2,out(count).it,'nearest','extrap');
                    
                end
                
                if(isfield(x.strct,'centers'))
                %if(isfield(x.strct,'centers') && isempty(x.strct.centers))
                    out(count).center=x.strct.centers(qq,:);
                end
                
                if(isfield(x.strct,'barResponse'))
                    out(count).barResponse=x.strct.barResponse(qq);
                end
                
                if(isfield(x.strct,'cell_nums'))
                    out(count).ref_cell_num = x.strct.cell_nums(qq);
                end
                count=count+1;
            end
        else
%             disp([in(ii).name ': this cell out of bounds...or not used']);
        end
        
    else
        disp([in(ii).name ' unfound -- skipping']);
    end
end

cd(currd);