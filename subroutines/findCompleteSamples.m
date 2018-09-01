function [cleanFullTable,uIDs] = findCompleteSamples(myTable,useAntigens,useEntities)

for currAntigen = useAntigens % iterate 
    collectEntitySamples = false(size(myTable,1),1); % preallocate
    for currEntity = useEntities % iterate entities 
    collectEntitySamples = collectEntitySamples | ... % previous matches
        (strcmp(myTable.AG,currAntigen) & ...    % matching antigen
         strcmp(myTable.CL,currEntity));         % matching entity
    end
    lastMatches = myTable(collectEntitySamples,'ID');
    if strcmp(currAntigen,useAntigens{1}) % if first iteration
    fullSampleCollection = lastMatches;
    else % not the first iteration
    fullSampleCollection = innerjoin(fullSampleCollection,lastMatches);
    end    
end
disp([num2str(numel(fullSampleCollection)),' samples will be used']);
% re-create full table and remove undesired rows
cleanFullTable = innerjoin(myTable,fullSampleCollection);
keepme = false(size(cleanFullTable,1),1); % preallocate
for currAntigen = useAntigens % iterate through desired antigens
keepme = keepme | strcmp(cleanFullTable.AG,currAntigen);
end
% remove all rows for undesired antigens
cleanFullTable(~keepme,:) = [];
uIDs = unique(cleanFullTable.ID);
disp(['cleaned up results table, ',num2str(numel(uIDs)),' samples remaining']);

end