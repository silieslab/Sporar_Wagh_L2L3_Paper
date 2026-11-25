clc;
clear all;
close all;

% Single file analysis


i = 4;
file = ['/Users/ksporar/2p/150803ks_fly1/Image ' num2str(i)];


file = uigetdir;
% % do agai: 131209m_fly1: LDM009, 
% if i == 0
%     file = ['/Users/msilies/Fiala_2p/150512_MH56GCaMP6f_fly1/Image 'num2str(i)];
% elseif i < 10
%     file = ['/Users/msili?es/Desktop/CalciumImaging/130808m_fly5/Image' num2str(i)];
% elseif i < 100
%     file = ['/Users/msilies/Desktop/CalciumImaging/130808m_fly5/Image ' num2str(i)];
% end
disp(file);

% curDir = pwd;
% cd(file);
% d = dir('*pData.mat');
% load(d.name);
% out = strct;
% cd(curDir);

% clean_up_dir(file);
% out = read_roi_data(file);

curDir = pwd;cd(file)

m = dir('data_file*');

if(~isempty(m))

    load('data_file');
%     out.xml.datetime

    %out = ROI_tnxxl_analysis_LB2(out);
    out = ROI_gcamp_analysis(out, true); %true if you want to select ROIs
    out = FFFlash_res_display_1ch(out, 2);
%     show_fff_means(out);

    save_processed_data_1ch_eni(out);%

    d = dir('_stimulus_*');
    fid = fopen(d.name,'r');
    currline = fgetl(fid);
    ind = strfind(currline,'\');
    disp(sprintf('stimulus: %s',currline(ind(end)+1:end)));
    fclose(fid);

else
    m = dir('*pData.mat');
    load(m.name);
    out = FFFlash_res_display_1ch(strct,2);
    ind = strfind(out.fileloc,'/'); %ms: mac modified
    ind2 = strfind(file,'/'); %ms: mac modified
    out.fileloc = [file(1:ind2(end)) out.fileloc((ind(end)+1):end)];
    save_processed_data_1ch(out);
    
end