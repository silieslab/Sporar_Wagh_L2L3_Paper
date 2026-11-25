function out = load_data_set(rootdir,rootstr)

currdir=pwd;
cd(rootdir);
d=dir(rootstr);
for i=1:length(d)
    out{i}=load(d(i).name);
end
cd(currdir);

for i=1:length(out)
    disp(['strct ' num2str(i) ' = ' num2str(size(out{i}.strct.dRatio,2)) ' frames']);
end