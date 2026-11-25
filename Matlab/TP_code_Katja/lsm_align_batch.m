function lsm_align_batch

[fname]=uigetdir; % displays a modal dialog box showing the folders that are inside the current working directory
e=dir(fname); % dir lists the files and folders in the MATLAB? current folder
numberOfFolders = length(e)





% Process all image files in these folders.
% num=0;
for i=3:numberOfFolders


    if e(i).isdir
        if e(i).name(1)=='I';
        %if dir('I*') %is the first letter an I
            cd([fname '/' e(i).name]);  %ms: z.B. .../110601m_fly1/LDM...
            
            lsm_align_single_ms

        
        cd ..
        end
    end
end




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