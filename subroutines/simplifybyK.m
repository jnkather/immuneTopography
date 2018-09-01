% JN Kather 2017
%
% take a table, select all rows with same K, then take the mean and
% return a table with one row per K
%

function [KoutputTable, pies, uniqueClasses, allK] = simplifybyK(myTable)

allK = unique(myTable.K)';
uAG = unique(myTable.AG)';

% get the columns of interest
targetColumnHeaders = {'MARG_500_OUT'	'MARG_500_IN'	'TU_CORE'};
origVarNames = myTable.Properties.VariableNames;
columnSelector = getColumnSelector(origVarNames,targetColumnHeaders);  
targetColumns = find(columnSelector);
uniqueClasses = unique(myTable.CL);

rowCount = 1; pieCount = 1;
for i=allK % iterate through all clusters (K)
    selectrK = (myTable.K == i);
 
    for currAG = uAG% iterate through all antigens (AG)
        % copy properties from myTable to KoutputTable
        KoutputTable(rowCount).ID = ['cluster K=',num2str(i)];
        KoutputTable(rowCount).AG = char(currAG);
        
        selectrAG = strcmp(myTable.AG,currAG);
        % gather data for all columns and take the median
        for j = targetColumns
            KoutputTable(rowCount).CL = ['all entities, N=',...
                num2str(sum(selectrK&selectrAG))]; 
            KoutputTable(rowCount).(origVarNames{j}) = median(table2array(...
                myTable(selectrK&selectrAG,j)));
        end
        rowCount= rowCount+1;
    end
    
    % prepare pie chart data for current k
    % use the last antigen selectrAG
    for cc = 1:numel(uniqueClasses)
       currPie(cc) = sum(selectrK & selectrAG & strcmp(myTable.CL,uniqueClasses{cc}));
    end
    pies{pieCount} = currPie;
    pieCount = pieCount+1;
    
end

KoutputTable = struct2table(KoutputTable);

end