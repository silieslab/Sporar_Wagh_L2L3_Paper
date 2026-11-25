%% Batch alignment of two-photon time series.
% This script performs the alignment of all selected folders for a given
% experimental day for a given experimental fly.
%% Clean workspace.
close all;
clear all;

% Set MATLAB path.
addpath(genpath('/Users/ksporar/Documents/MATLAB/TP_code_Katja'))
%% Choose folders to analyze.
% Get the fly folder to analyze.
flyFolder = uigetdir;
% Get the imaging folders for the experiments on the given fly on the desired
% date, i.e., imaging files inside flyFolder.
flyContents = dir([flyFolder filesep 'I*']);
imagingFolders = flyContents([flyContents.isdir]);

%% Process all images in the selected folder.
for iImagingFolder = 1: 2%length(imagingFolders)
    cd(fullfile(flyFolder, imagingFolders(iImagingFolder).name));
    lsm_align_single_ms_lr     
    cd ..
end

%%


allSubFolders = genpath(fname); % Get list of all subfolders.
remain = allSubFolders; % Parse into a cell array. Scan through them separating them.
listOfFolderNames = {}; %
while true
	[singleSubFolder, remain] = strtok(remain, ';');
	if isempty(singleSubFolder)
		break;
	end
	listOfFolderNames = [listOfFolderNames singleSubFolder];
end
numberOfFolders = length(e)