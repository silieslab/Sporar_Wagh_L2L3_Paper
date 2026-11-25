function save_processed_data(in);


fileloc = in.fileloc;

% %marion to daryl conversion
% sinds = find(fileloc=='/');
% fileloc(sinds)='\';
% fileloc(1:(sinds(3)-1)) = [];
% fileloc = ['C:' fileloc];
% x{ii}.strct.fileloc = fileloc;


% %daryl to marion conversion
% sinds = find(fileloc=='\');
% fileloc(sinds)='/';
% fileloc(1:(sinds(1)-1)) = [];
% fileloc = ['/Users/Kunibert' fileloc];
% in.fileloc = fileloc;

curDir = pwd;

cd(in.fileloc);

strct=in;
if(isfield(in,'ch1'))
    strct = rmfield(strct,'ch1');
    strct = rmfield(strct,'ch1a');
    strct = rmfield(strct,'ch2');
    strct = rmfield(strct,'ch2a');
end

pathroot=in.fileloc;
f=find((pathroot == '\') + (pathroot == '/'));
f=f(end);
pathroot = pathroot((f+1):end); 

save([pathroot '_pData.mat'],'strct');

cd(curDir);