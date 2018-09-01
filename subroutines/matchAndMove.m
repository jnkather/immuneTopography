%clear all, close all,clc



% this script reads a list of samples with ID and type 
% then, based on an input folder, the samples are moved to an output folder
% that corresponds to the type
% also, the samples are renamed

function matchAndMove(inputIMpath,myAntigen,filterClass)

addpath('./subroutines/');
datatable = 'Sample_list_HIPO34.xlsx';
inputIMtype = '*.ndpi'; % svs AND ndpi
targetDir = 'D:/Kather-LOCAL/My_clean_raw_WSI_data/2018-HIPO34_CRC_HLM_SORTED/';

% read images
allImages.(myAntigen) = dir([inputIMpath,myAntigen,'/',inputIMtype]);
% read table 
myT = readtable(datatable);

sq = @(varargin) varargin;
currImageNameVec = sq(allImages.(myAntigen).name);
% find all images of target types and copy them
for currClass = filterClass
    currClass = char(currClass);
    mkdir([targetDir,currClass]);
    
    % find all items that match the current class
    matchingItems = contains(myT.abbr,currClass);
    matchingNames = myT.ID(matchingItems);
    
    % iterate through all items
    for currItem = matchingNames'
        currItem = char(currItem);
        currFile = contains(currImageNameVec,currItem);
        currentFileName = currImageNameVec(currFile);
        if isempty(currentFileName)
            disp([':-( could not match ',char(currItem)]);
        else
            try
            disp([':-) successfully matched ',char(currentFileName),...
                ' to class ',currClass]);
            catch % catch multiple matches error
                currentFileName
                error('error encountered. Probable reason: duplicate image.');
            end
            targetFilename = ['CL_',currClass, '_ID_',...
                currItem,'_AG_',myAntigen,'_code_',char(generateID(1,'shuffle'))];
            sourcePath = [inputIMpath,myAntigen,'/',char(currentFileName)];
            targetPath = [targetDir,currClass,'/',targetFilename,'.ndpi'];
            [status,message,messageId] = copyfile(sourcePath, targetPath);
            if ~status
                error(message)
            end
        end     
    end
end

end
    