clc;
clear all;
close all;

[fname]=uigetdir;
d=dir(fname);

for i = 3:length(d)
    if((d(i).isdir)&(d(i).name(1)~='z'))
        cd([fname '\' d(i).name]);
        e = dir('_stimulus_*');
        fid = fopen(e.name,'r');
        currline = fgetl(fid);
        fclose(fid);
        ind = strfind(currline,'\');
        e = dir('*_pData.mat');
        if(~isempty(e))
            load(e.name);
            strct.stim_type = currline((ind(end)+1):(end-5));
            pathroot = strct.fileloc;
            f=find((pathroot == '\') + (pathroot == '/'));
            f=f(end);
            pathroot = pathroot((f+1):end);
            save([pathroot '_pData.mat'],'strct');
        end
    end
end