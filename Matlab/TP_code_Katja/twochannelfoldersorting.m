
%% 

%% this code takes raw data and creates image folders for batch alignment
% and further analysis

%% Clean workspace.
 close all;
 clear all;

% Set MATLAB path.
addpath(genpath('/Users/ksporar/Documents/MATLAB/TP_code_Katja'))



%% Choose folders to analyze.
% Get genotype folder to arrange.
addpath('/Users/ksporar/Documents/MATLAB/TP_code_Katja');
% addpath(genpath('C:\Users\s.molinaobando\2p\jf_rawdata'))

cd 'C:\Users\s.molinaobando\2p\jf_rawdata'

genotypes = dir ('G_*')
genotypes = {genotypes.name}
%genotypes = genotypes('G_*')
% Mi1GCaMP6ftdtom
% TM1GCaMP6ftdtom

count=0

for gen = genotypes 
   loc = strcat( 'C:\Users\s.molinaobando\2p\jf_rawdata\',gen,'\');
   cd(loc{1})  
   flyfolders= dir('*_jv*')
   flyfolders= {flyfolders.name}
%    for n = 1:size(flyfolders,1)
%        mkdir (
   for i = flyfolders;
      flyloc = strcat(loc{1},i,'\')
      cd(flyloc{1})
      tseriesfolders= dir('TSeries*')
      stimulusfolder=dir('*stim*')
      tseriesfolders= {tseriesfolders.name}
      stimulusfolder={stimulusfolder.name}
      for n = 1:length(tseriesfolders)
          nn=int2str(n)
          image=strcat('Image',nn)
%           mkdir (sprintf('Image%d',n));
          mkdir (image);
          imagedir=strcat(flyloc,image,'\')        
          actualtseries=tseriesfolders{n}
          actualtseriesdir=strcat(flyloc,actualtseries,'\')
%           actualtseriesdir= actualtseriesdir{1};
          cd (actualtseriesdir{1})
          tiffiles=dir('*.tif')
          tiffiles={tiffiles.name}
          metadata=imfinfo(tiffiles{length(tiffiles)})
          timetif=strsplit(metadata.DateTime)
          timetif=strsplit(timetif{2})
          timetif=strsplit(timetif{1},':')
          abtimetif=str2num(timetif{1}).*3600+str2num(timetif{2}).*60+str2num(timetif{3})
%           cd(imagedir{1})
          imagedir=imagedir{1}
          imagetseriesdir=strcat(imagedir,actualtseries)
          actualtseriesdir= actualtseriesdir{1};
          copyfile (actualtseriesdir,imagetseriesdir)
          stimulidir=strcat(flyloc,stimulusfolder{1},'\')
          cd(stimulidir{1})
          stimfiles=dir('*stim*')
          stimfilesdate={stimfiles.date}
          stimfilesnames={stimfiles.name}
%           stimdates=zeros(length(stimfiles),1)
          for k=1:size(stimfiles,1)
              time=strsplit(stimfilesdate{k},' ')
              time=strsplit(time{2},':')
              absttime=(str2num(time{1}).*3600+str2num(time{2}).*60+str2num(time{3}))
              if (absttime>=(abtimetif-10)) && (absttime<=(abtimetif+10))
                  filestdir=strcat(stimulidir,stimfilesnames{k},'\')
                  copyfile (filestdir{1},imagedir)
              end
          end      

      end
   end
end

%% choose files from ch1 and put them in a folder located in jf_data





% to put stimuli


%% choose files from ch2 and put them in a folder located in jf_data

%% put stimulus plus channel folders in an image folder
