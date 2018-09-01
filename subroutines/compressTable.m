function mergedResultsTable = compressTable(cleanFullTable,uIDs,useFields,useAntigens)

allHeaders = fieldnames(cleanFullTable);
for i=1:numel(uIDs) % iterate sample IDs
    currID = uIDs{i};
    mergedResults(i).ID = currID;
    currentClassRow = find(strcmp(cleanFullTable.ID,currID),1);
    currCL = table2array(cleanFullTable(currentClassRow,'CL'));
    mergedResults(i).CL = currCL;
    mergedResults(i).CLID = strcat(currCL,'_',currID);
    for j=1:numel(useAntigens)  % iterate antigens
        currAG = useAntigens{j};
        currentSourceRow = strcmp(cleanFullTable.ID,currID) &...
                           contains(cleanFullTable.AG,currAG);
        for k=1:numel(useFields) % iterate fields (tumor compartment)
            currField = useFields{k};
            currentSourceCol = strcmp(allHeaders,currField);
            newTitle = strcat(char(currAG),'_',char(currField));
            mergedResults(i).(newTitle) = table2array(cleanFullTable(currentSourceRow,currentSourceCol));
        end
    end
    disp(['finished sample ',num2str(i),' of ',num2str(numel(uIDs))]);
end
mergedResultsTable = struct2table(mergedResults);
mergedResultsTable = sortrows(mergedResultsTable,{'CLID'});

end