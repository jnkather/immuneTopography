function newOutputTable = writeKintoID(newOutputTable)
for i=1:size(newOutputTable,1) % write K into ID
    currID = char(table2array(newOutputTable(i,'ID')));
    currK = num2str(table2array(newOutputTable(i,'K')));
    newOutputTable(i,'ID') = cellstr(['K', currK, ' ', currID]); 
end
end