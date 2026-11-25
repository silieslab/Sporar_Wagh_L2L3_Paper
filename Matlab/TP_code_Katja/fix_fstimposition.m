clc;
clear all;
close all;

[fname]=uigetdir;
d=dir(fname);

for i = 3:length(d)
    if((d(i).isdir)&(d(i).name(1)~='z'))
        cd([fname '/' d(i).name]);
        e = dir('_stimulus_*');
        A = importdata(e.name);
%         fid = fopen(e.name,'r');
%         currline = fgetl(fid);
%         fclose(fid);
%         ind = strfind(currline,'\');
               
        fstimpos1 = zeros(A.data(end,8),1);
        fstimpos2 = zeros(A.data(end,8),1);
            
        for k = 1:(A.data(end,8))
            inds = find(A.data(:,8) == k);
            if(~isempty(inds))
%                 stimval = A.data(inds,4);
                %         stimvalcont = A.data(inds,3); %could add this if needed
                %         stimpos1 = A.data(inds,4);
                %         stimpos2 = A.data(inds,6);
                stimpos1 = A.data(inds,5); %ms, for jl type stimulus output files
                stimpos2 = A.data(inds,7); %ms, for jl type stimulus output files
%                 avrstimval(k) = mean(stimval);
%                 fstimval(k) = stimval(1);
                fstimpos1(k) = stimpos1(1);
                fstimpos2(k) = stimpos2(1);
            end
        end



        e = dir('*_pData.mat');
        if(~isempty(e))
            pdataname=e.name;
            load(pdataname)
%             load(e.name);
            strct.fstimpos1 = fstimpos1;
            strct.fstimpos2 = fstimpos2;
            
            pathroot = strct.fileloc;
%             f=find((pathroot == '\') + (pathroot == '/'));
%             f=f(end);
%             pathroot = pathroot((f+1):end);
%             save([pathroot '_pData.mat'],'strct');
            save([pathroot '/' pdataname],'strct');
        end
    end
end