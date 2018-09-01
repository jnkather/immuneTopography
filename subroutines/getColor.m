
function myColVector = getColor(currData,colornorm)
   
    if currData <1, currData = 1; end
    if colornorm <1, colornorm = 1; end
    
    if ~isnan(currData)
        
    allColors = redblu(colornorm);
    myColVector = allColors(ceil(currData),:);
    
    else % if input is NaN, return white
        myColVector = [1 1 1];
    end
end

% hist(reshape(table2array(resuTable(contains(resuTable.AG,'CD3'),tC)),1,[]))