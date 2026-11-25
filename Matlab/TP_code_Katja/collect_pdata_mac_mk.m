function collect_pdata_mac_mk

[fname]=uigetdir;
d=dir(fname);
%pData_dir = 'C:\Documents and Settings\Limor\My Documents\damon\new_TP_pData\';
pData_dir = '/Users/msilies/Fiala_2p/Madhura_pData/'; 
%ms: structure with LDM (((/ fly folders)))

% num=0;
for i=3:length(d)
    if d(i).isdir
        cd([fname '/' d(i).name]);  %ms: z.B. .../110601m_fly1/LDM...
%         ind = strfind(fname,'/');
%         flyID = fname(ind(end)+1:end); %finds the flyID (e.g. 110601m_fly1) in the string
        e = dir('*_pData.mat');
        if(~isempty(e))
            copyfile(e.name,pData_dir);
        end
        cd ..
    end
end


