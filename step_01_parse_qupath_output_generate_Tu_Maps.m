% JN Kather, NCT Heidelberg, 2017-2018
% see separate LICENSE 
%
% This MATLAB script is associated with the following article
% "Topography of cancer-associated immune cells"
% Please refer to the article and the supplemntary material for a
% detailed description of the procedures. This is experimental software
% and should be used with caution.
% 
% This function collects all raw cell counts for all images and creates
% lastResuTable and lastUResuTable. It will process all available antigens.
% 

% initialize
close all, clear all, clc
addpath('./subroutines/');
percentileLevels = 100;
doQuantileNormalize = false; % quantile normalization? default true

% read input data
inputResultsDir = './qupath_output_pancancer/'; 
allFiles = dir([inputResultsDir,'CL_*RESULT.txt']);
targetLines = {'TU_CORE','MARG_500_IN','MARG_500_OUT'}; 

% iterate through all files and merge all measurements
for i=1:numel(allFiles)
    currFname = allFiles(i).name;
    currData = readtable([inputResultsDir,currFname]);
    if isempty(currData) % there is no data
        warning('SKIPPING');
        continue
    end
    currROInames = (currData.Name);
    if ~any(currData.Positive_) % there are no pos. cells
        currPosCellDensity = zeros(size(currData.Positive_));
    else
    currPosCellDensity = currData.NumPositivePerMm_2;  % 
    end
    % parse name
    results(i).name = currFname;
    % find class
    startCL = strfind(currFname,'CL_');
    currFname = currFname((startCL(1)+3):end);
    endCL = strfind(currFname,'ID_');
    results(i).CL = currFname(1:(endCL(1)-2)); 
    % find ID
    startID = strfind(currFname,'ID_');
    currFname = currFname((startID(1)+3):end);
    endID = strfind(currFname,'_');
    % dirty workaround: if ID contains "UMM", then use the second
    % underscore as end
    if contains(currFname,'UMM')
        results(i).ID = currFname(1:(endID(2)-1));
    else
        results(i).ID = currFname(1:(endID(1)-1));
    end
    % find AG
    startAG = strfind(currFname,'AG_');
    currFname = currFname((startAG(1)+3):end);
    endAG = strfind(currFname,'_');
    results(i).AG = currFname(1:(endAG(1)-1));
    results(i).AG = strrep(results(i).AG,'FoxP3','Foxp3'); % manual replace
    
    % iterate 
    for j = 1:numel(targetLines)
        myMask = contains(currROInames,targetLines{j});
        if any(myMask)
            results(i).(char(targetLines{j})) = currPosCellDensity(myMask);
        else
            results(i).(char(targetLines{j})) = NaN;
        end
    end
end

% construct results table
resuTable = struct2table(results);

% remove empty rows
emptyRows = find(cellfun(@isempty,table2array(resuTable(:,1))));
warning(['found ', num2str(numel(emptyRows)), ' empty rows']);
resuTable(emptyRows,:) = [];

% convert resu table contents from cell to array
countsTable = array2table(cell2mat(table2array(resuTable(:,(end-(numel(targetLines)-1)):end))));
countsTable.Properties.VariableNames = resuTable.Properties.VariableNames((end-(numel(targetLines)-1)):end);
resuTableNew = resuTable(:,1:(end-(numel(targetLines))));

% replace original resu table
resuTable = [resuTableNew, countsTable];

% quantile-normalize
%resuTable = simplifyHiMedLoNormalize(resuTable,percentileLevels);
if doQuantileNormalize
resuTable = simplifyHiMedLo(resuTable,percentileLevels); 
end

% construct means table
utypes = unique(resuTable.CL);
uags = unique(resuTable.AG);
uResuTable = zeros(numel(utypes)*numel(uags),size(resuTable,2));
count = 1;
for i=1:numel(utypes) % iterate tissue types
    for j=1:numel(uags) % iterate antigens
        targetSamples = strcmp(resuTable.CL,utypes{i}) & strcmp(resuTable.AG,uags{j});
        myCurrData = table2array(resuTable(targetSamples,5:end));
        uResuTable(count,5:end) = mean((myCurrData),'omitnan');
        count = count+1;
    end
end
uResuTable = array2table(uResuTable);    
uResuTable.Properties.VariableNames = resuTable.Properties.VariableNames;

% write correct class
uResuTable.CL = repmat({'XXXX'},size(uResuTable.CL));
uResuTable.AG = repmat({'XXXX'},size(uResuTable.AG));
count = 1;
for i=1:numel(utypes) % iterate tissue types
    for j=1:numel(uags) % iterate antigens
        classVec{count} = char(utypes{i});  % class description
        agVec{count} = uags{j};             % antigen
        classCount{count} = num2str(sum(strcmp(resuTable.CL,classVec{count})&...
            strcmp(resuTable.AG,agVec{count})));   % sample number, N = ...
        count = count+1;
    end
end
uResuTable.CL = classVec';
uResuTable.name = uResuTable.CL; 
uResuTable.ID = classVec';
uResuTable.AG = agVec';
uResuTable.N = classCount';

writetable(resuTable,'./output_tables/lastResuTable_noNorm.xlsx');
writetable(uResuTable,'./output_tables/lastUResuTable_noNorm.xlsx');

sortMe = false;

if doQuantileNormalize
% visualize results
visualizeTuIM(resuTable,percentileLevels,sortMe);
suptitle('SAMPLES');

% visualize results
visualizeTuIM(uResuTable,percentileLevels,sortMe);
suptitle('MEANS');
end

