% JN Kather NCT 2017

% TO DO: MANUALLY DEFINE GLOBAL MAX FOR OVERRIDE IN ALL FUNCTIONS


function visualizeTuIM(resuTable,percentileLevels,sortMe) % optional argument is sort
    
    if any(strcmp(fieldnames(resuTable),'N'))
        useN = true;
    else, useN=false; end

    numSamples = size(resuTable,1);
    uIDs = unique(resuTable.ID); % unique sample IDs
    uAGs = unique(resuTable.AG); % unique antigens
    
    % optional: sort UIds
    if sortMe
        disp('performing additional sort')
        switch sortMe
                case 'FAT_MARG_OUT'
                [~,ii] = sort(resuTable.FAT_MARG_OUT,'descend');
                uIDs = uIDs(ii);
                
            otherwise % sort alphabetically
                 uIDs = sort(uIDs);
        end
    end
    
    % find the target column IDs
    targetColumnHeaders = {'DISTANT_OUT',...
        'MARG_500_OUT',    'MARG_500_IN',    'TU_CORE',...
        'MARG_LUM',    'FAT_MARG_OUT', 'FAT_MARG_IN','FAT_CORE'};
    columnSelector = getColumnSelector(resuTable.Properties.VariableNames,targetColumnHeaders);
    
    Hspace = 14; Vspace = 12; figure(), hold on
    % draw a diagram for each data point
    
    for j = 1:numel(uAGs)
        
        % find maximum count for this antigen
        targetSamples = contains(resuTable.AG,uAGs{j});
        allDataArray = table2array(resuTable(targetSamples,columnSelector)); 
        
%         colornorm = ceil(max(allDataArray(:)));
%         
%         disp('_DEBUG VTI_')
%         ca1 = max(allDataArray(:))
%         ca2 = colornorm
%         disp('_END DEBUG VTI_')
        
        for i = 1:numel(uIDs)
        
            % find current line in table
            currLine = find(strcmp(resuTable.ID,uIDs(i)) & contains(resuTable.AG,uAGs(j)));
  
            if numel(currLine)>1
                currLine
                error(['error in sample ',...
                    char(uIDs(i)),' ',char(uAGs(j))]);
            end
            
            if ~isempty(currLine)
                
            currData = resuTable(currLine,columnSelector); % extract data
            if useN
            currTitle = [char(uIDs(i)),' ',char(uAGs(j)),10,' N=',char(table2array(resuTable(currLine,'N')))];
            else
            currTitle = [char(table2array(resuTable(currLine,'CL'))),10,char(uIDs(i)),' ',char(uAGs(j))];  
            end
            
            
            drawcircles(i*Hspace,j*Vspace,currData,currTitle,percentileLevels);
            else
                disp('missing data point, omitting...');
            end
        end
    end
    axis equal off
    set(gcf,'Color','w')
    colormap(parula(1024)), %colorbar
    
end
