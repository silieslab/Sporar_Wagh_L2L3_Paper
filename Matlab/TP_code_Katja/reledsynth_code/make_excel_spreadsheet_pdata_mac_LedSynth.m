function make_excel_spreadsheet_pdata_mac_LedSynth

[fname]=uigetdir;

currdir=pwd;
cd(fname);

d=dir('*pData.mat');

list = cell(length(d),7);
for i=1:length(d)
    x=load(d(i).name);
    list{i,1}=d(i).name;
%     list{i,2}=x.strct.xml.datetime;
    list{i,3}=x.strct.xml.frames;
%     list{i,4}=x.strct.xml.zdepth*10^6;
%     list{i,4}=x.strct.xml.zdepth;
    list{i,5}=x.strct.xml.frames/x.strct.xml.framerate;
% % % % % % %     ks: this is commented out now
% % % % % % %     temp = x.strct.ch3;
% % % % % % %     inds = find(diff(temp)~=0);
% % % % % % %     list{i,6} = length(find(x.strct.ch3(inds)==0))-1; %% number of full stimulus bouts
    if ~mod(i,25)
        disp(['Done with: ' d(i).name]);
    end
    if(isfield(x.strct,'stim_type'))
        list{i,7} = x.strct.stim_type;
    else
        list{i,7} = 'unknown';
    end
end


fid=fopen([fname '/foldersummary_ks.csv'],'w');
fprintf(fid,'filename, datetime, frames, zdepth, tottime, stimbouts, stimulus code, notes\n');
for i=1:size(list,1)
    a=list{i,1};
    b=list{i,2};
    c=num2str(list{i,3});
    d=num2str(list{i,4});
    e=num2str(list{i,5});
    f=num2str(list{i,6});
    g=list{i,7};
    fprintf(fid,'%s,',a);
    fprintf(fid,'%s,',b);
    fprintf(fid,'%s,',c);
    fprintf(fid,'%s,',d);
    fprintf(fid,'%s,',e);
    fprintf(fid,'%s,',f);
    fprintf(fid,'%s\n',g);
end
fclose(fid);