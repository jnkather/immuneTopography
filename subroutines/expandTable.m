% go back from a table that is
% 
% ID - CL - CD3_TU_CORE - CD3_MARG - CD8_TU_CORE - CD8_MARG
%
% to
%
% ID - CL - AG - TU_CORE - MARG
%

function newOutputTable = expandTable(myTable,useAntigens,useFields)

    allFields = fieldnames(myTable);
    kakb = any(contains(allFields,'KA'));
    
    count = 1; % count new table rows
    for i=1:size(myTable,1) % iterate all table rows
        currRow = myTable(i,:);
        currID = currRow.ID;
        currCL = currRow.CL;
        currK = currRow.K;
        if kakb % if there is a bivariate cluster information
            currKA = currRow.KA;
            currKB = currRow.KB;
        end
        currCLID = currRow.CLID;
        for j = 1:numel(useAntigens) % iterate all antigens
            
            % write the metadata to target table
            currAG = useAntigens{j};
            newTable(count).ID = currID;
            newTable(count).CL = currCL;
            newTable(count).CLID = currCLID;
            newTable(count).AG = currAG;
            newTable(count).K = currK;
             
            if kakb % if there is a bivariate cluster information
                newTable(count).KA = currKA;
                newTable(count).KB = currKB;
            end
            
            for k = 1:numel(useFields)
            currField = useFields{k};
            % write the data to target table
            targetColumn = find(contains(allFields,currAG) & ...
                contains(allFields,currField));
            newTable(count).(currField) = table2array(myTable(i,targetColumn));
            end
            
            count = count+1;
        end
    end
    
   newOutputTable = struct2table(newTable);
end