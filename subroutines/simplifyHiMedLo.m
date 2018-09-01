function resuTable = simplifyHiMedLo(resuTable,simplifyLevels)
    warning('simplifying results table into percentiles');
    
    % find the target column IDs
    targetColumnHeaders = {'DISTANT_OUT',...
        'MARG_500_OUT',    'MARG_500_IN',    'TU_CORE',...
        'MARG_LUM',    'FAT_MARG_OUT', 'FAT_MARG_IN','FAT_CORE'};
    columnSelector = getColumnSelector(resuTable.Properties.VariableNames,targetColumnHeaders);

    % find all antigens 
    allAntigens = unique(resuTable.AG);
    
    % iterate all antigens and quantile-normalize each antigen
    for i=1:numel(allAntigens)
        currAntigen = allAntigens{i};
        matchingRows = contains(resuTable.AG,currAntigen);
        disp(['found ',num2str(sum(matchingRows)),' rows for antigen ',...
            char(currAntigen)]);
        x = table2array(resuTable(matchingRows,columnSelector));
        xn = nan(size(x));
        % take the quantiles
        for k = fliplr(1:simplifyLevels) % from top to bottom percentiles
            currThresh = quantile(x(:),k/simplifyLevels);
            currFilt = (x<=currThresh) & ~isnan(x);
            xn(currFilt) = k;
        end
        % write back to resuTable
        resuTable(matchingRows,columnSelector) = array2table(xn);         
    end
      
end