% JN Kather, NCT, 2017
%
% for a table: get a mask to the columns that contain the target headers

function columnSelector = getColumnSelector(ColumnHeaders,targetColumnHeaders)  
% preallocate target column selector
    columnSelector = zeros(1,numel(ColumnHeaders));
    % find the indices of the target columns
    for i=1:numel(targetColumnHeaders)
        columnSelector = columnSelector |...
            contains(ColumnHeaders,targetColumnHeaders{i});
    end
end