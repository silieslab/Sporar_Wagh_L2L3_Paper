function out=load_neuron_data10Hz_ms(in,locdir)

[fname,datetime,frames,zdepth,tottime,stimbouts,locnum,...
    activecells,inverted,stimcode,quality,driver,...
    moving,layer,wavelength,flyID, responsivefly]...
    =textread('MASTER_foldersummary_MarionDaryl.txt',...
    '%s %s %f %f %f %f %f %s %f %s %f %s %f %s %f %f %f \r',...
    'headerlines',1,'delimiter','\t');

currd=pwd;
cd(locdir);

count=1;
for ii=1:length(in)
    qq=in(ii).cell;
    ss=strcmpi(in(ii).name,fname);
    if exist(in(ii).name) * (qq>0)
        x=load(in(ii).name);
        if qq<=size(x.strct.dRatio,1)
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
            out(count).stim = x.strct.fstimval;
            out(count).raw_stim = x.strct.ch3;
            out(count).avrstimval = x.strct.avrstimval;    
            out(count).frame_nums = x.strct.frame_nums;
            fps=x.strct.xml.framerate;
            %ms: now: # frames / framerate makes timing vector
            out(count).t=[1:length(out(count).ratio)]/fps;
            %ms: new timing vector for interpolation at 10Hz (0.1), starts at ends with 0.5/fps shift 
            out(count).it=[0.5/fps:0.1:(length(out(count).ratio)+0.5)/fps];
            %ms: nearest neighbor interpolation (should maintain discrete values) of .stim (also at 10Hz now)
            %ms: also linearly extrapolates values outside .t
            out(count).istim=interp1(out(count).t,out(count).stim,out(count).it,'nearest','extrap');
            %ms: same for the ratio, only here we want linear interpolation
            out(count).iratio=interp1(out(count).t,out(count).ratio,out(count).it,'linear','extrap');
                
            % added stimpos and centers, ms
            if(isfield(x.strct,'fstimpos1'))
                out(count).ifstimpos1=interp1(out(count).t,x.strct.fstimpos1,out(count).it,'nearest','extrap');
                out(count).ifstimpos2=interp1(out(count).t,x.strct.fstimpos2,out(count).it,'nearest','extrap');    
            end
            
            if(isfield(x.strct,'centers'))
                out(count).center=x.strct.centers(qq,:);
            end

            if(isfield(x.strct,'cell_nums'))
                out(count).ref_cell_num = x.strct.cell_nums(qq);
            end
            
            count=count+1;
        else
            disp([in(ii).name ': cell out of bounds...']);
        end
    else
        disp([in(ii).name ' unfound -- skipping']);
    end
end

cd(currd);