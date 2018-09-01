% JN Kather, NCT Heidelberg, 2017-2018
% see separate LICENSE 
%
% This MATLAB script is associated with the following article
% "Topography of cancer-associated immune cells"
% Please refer to the article and the supplemntary material for a
% detailed description of the procedures. This is experimental software
% and should be used with caution.
% 
% this script loads a lastResuTable and converts it to a lastHeatmap
% which can then used for cluster analysis and further visualization

% caution: first, delete lastHeatmap.xlsx to prevent spillover

clear all, close all, format compact, clc
addpath('./subroutines/');
biva = true; % do bivariate heatmap analysis
doprint = false; % save results as hi res images
%% INITIALIZE
% load data and select tumor types and antigens that you want to look at
inputDataTable = './output_tables/lastResuTable_noNorm.xlsx'; %'lastResuTable_v2.xlsx';
myTable = readtable(inputDataTable);
useEntities = {'MEL','LUAD','LUSC','BLCA','HNSC','STAD','ESCA','COAD_PRI','COAD_MET','OV'};%{'MEL','LUAD','LUSC','BLCA','HNSC','STAD','ESCA','COAD_PRI','COAD_MET','OV'}; % 'LUAD','LUSC','STAD','COAD_PRI','BLCA','COAD_MET','HNSC','ESCA','OV','MEL'

allColors = hsv(36);
colorCount = 0;
removePieLabels = false; %if true, pie labels will not be added

allAG = {'CD3','CD8','Foxp3','PD1','CD68','CD163'}; %{'CD3','CD8','Foxp3','PD1','CD68','CD163'};
useFields = {'MARG_500_OUT'	'TU_CORE'}; % {'MARG_500_OUT'	'MARG_500_IN'	'TU_CORE'}
cutoffcount = 0;
for AG1 = allAG
    
    % plot pie
    useAntigen{1} = char(AG1);
   
    mycmap = redbluecmap(3);
    
    [cleanFullTable,uIDs] = findCompleteSamples(myTable,useAntigen,useEntities);
    mergedResultsTable = compressTable(cleanFullTable,uIDs,useFields,useAntigen);
    fullMatrix = table2array(mergedResultsTable(:,4:end));
    
    currMeas = fullMatrix;
    manGr = repmat({''},size(currMeas,1),1);
    XCol = 1;
    lastCutoff = median(currMeas(:));
    cutoffcount = cutoffcount+1;
    allCutoffLabels{cutoffcount} = char(AG1);
    allCutoffs(cutoffcount) = lastCutoff;
    
    
    disp(['the last cutoff for ',char(AG1),' is ',num2str(lastCutoff)]);
    mask.cold = currMeas(:,XCol)<=lastCutoff & currMeas(:,XCol+1)<=lastCutoff;
    mask.excl = currMeas(:,XCol)>lastCutoff & currMeas(:,XCol+1)<=lastCutoff;
    mask.hot = currMeas(:,XCol+1)>lastCutoff;
    manGr(mask.cold) = {'cold'};
    manGr(mask.excl) = {'excl'};
    manGr(mask.hot) = {'hot'};
    
    figure % go scatter
    hold on
    plot(log10([median(currMeas(:)) median(currMeas(:))]),log10([0.001 max(currMeas(:))]),'k-','LineWidth',1.5);
    plot(log10([0.001 max(currMeas(:))]),log10([median(currMeas(:)) median(currMeas(:))]),'k-','LineWidth',1.5);
   % plot([0 100],[0 100],'k-');
    %scatter(currMeas(:,1),currMeas(:,2),'filled');
    scatter(log10(currMeas(mask.hot,1)),log10(currMeas(mask.hot,2)),25,mycmap(3,:),'filled');
    scatter(log10(currMeas(mask.excl,1)),log10(currMeas(mask.excl,2)),25,[.5 .5 .5],'filled');
    scatter(log10(currMeas(mask.cold,1)),log10(currMeas(mask.cold,2)),25,mycmap(1,:),'filled');
    
    %axis([0 max(currMeas(:)) 0 max(currMeas(:))]);
    axis([-0.5 4 -0.5 4]);
    axis square 
    title([char(useAntigen),' corr ',num2str(round(corr(currMeas(:,1),currMeas(:,2)),2))]);
    set(gcf,'Color','w');
    currTitle = [char(useAntigen),'-SCATTR'];
    xlabel('cell density outside of tumor (cells/mm²)');
    ylabel('cell density in tumor (cells/mm²)');
    g = gca;
    g.XTick = 0:1:4;
    g.YTick = 0:1:4;
    g.XTickLabel = 10.^(g.XTick);
    g.YTickLabel = 10.^(g.YTick);
    
    if doprint
      print(gcf,['./output_figures/',currTitle,'.png'],'-dpng','-r450');
    print(gcf,['./output_figures/',currTitle,'.svg'],'-dsvg');
    drawnow
    end
    
    
    %% PIE for all tumor types
    figure % go pie
    pie(categorical(manGr),ones(numel(unique(manGr)),1))
    colormap redbluecmap
    currTitle = [char(useAntigen),'-PIE'];
    title(useAntigen);
    if doprint
    print(gcf,['./output_figures/',currTitle,'.png'],'-dpng','-r450');
    print(gcf,['./output_figures/',currTitle,'.svg'],'-dsvg');
    end
    % end plot pie
    
    %% PIE for each tumor type
    figure
    mycmap = redbluecmap;
    for en = 1:numel(useEntities)
        currEntity = useEntities{en};
        currMask = strcmp(mergedResultsTable.CL,useEntities{en});
        subplot(2,5,en)
        numCat = ones(numel(unique(manGr(currMask))),1);
        pp{en} = pie(categorical(manGr(currMask)),numCat);
        % override colors
        uniqueCats = unique(manGr(currMask));
        mycmap = nan(0,3);
        for uu=1:numel(uniqueCats)
            switch uniqueCats{uu} 
                case 'excl'
                    mycmap = [mycmap; [128,128,128]/255];
                case 'hot'
                    mycmap = [mycmap; [239,138,98]/255 ];
                case 'cold'
                    mycmap = [mycmap; [103,169,207]/255];
                otherwise
                    error('undefined category');
            end
        end
        
        for k = 1 : numel(numCat)
          % Create a color for this sector of the pie
          pieColorMap = mycmap(k,:);	% Color for this segment.
          % Apply the colors we just generated to the pie chart.
          set(pp{en}(k*2-1), 'FaceColor', pieColorMap);
        end
        % end override colors
        title(strrep(currEntity,'_','-'));
        % remove labels
        if removePieLabels
        ff = findall(pp{en},'Type','Text');
        set(ff,'String','');
        end
    end
    %colormap redbluecmap
    set(gcf,'Color','w');
    suptitle(useAntigen);
    drawnow
    currTitle = [char(useAntigen),'-ALL-PIES'];
    if doprint
    print(gcf,['./output_figures/',currTitle,'.png'],'-dpng','-r450');
    print(gcf,['./output_figures/',currTitle,'.svg'],'-dsvg');
    end
    
    
    if biva
    for AG2 = allAG
        
        disp([char(10),'starting BIVARIATE ANALYSIS FOR ',char(AG1),' VS ',char(AG2)]);

        colorCount = colorCount+1;
        if strcmp(AG1,AG2), continue, end 
        
        
useAntigens = {char(AG1),char(AG2)} ;% 'CD3','CD8','Foxp3','PD1','CD68','CD163'

%% PREPARE DATA


% find all samples that belong to target class and have all target antigens
[cleanFullTable,uIDs] = findCompleteSamples(myTable,useAntigens,useEntities);

% reformat table so that each sample is one row
mergedResultsTable = compressTable(cleanFullTable,uIDs,useFields,useAntigens);

% show naked heatmap
fullMatrix = table2array(mergedResultsTable(:,4:end));
figure()
imagesc(fullMatrix');
colormap hot
colorbar
axis equal off
set(gcf,'Color','w')

bivariate_heatmap_manual_allCL(fullMatrix,useAntigens) % this is for all tumor types together
currTitle = ['heatmap_all_',useAntigens{1},'-vs-',useAntigens{2}];

if doprint
print(gcf,['./output_figures/',currTitle,'.png'],'-dpng','-r450');
print(gcf,['./output_figures/',currTitle,'.svg'],'-dsvg');
end

bivariate_heatmap_manual(mergedResultsTable,fullMatrix,useAntigens); % this is for each tumor entity separately
currTitle = ['heatmap_',useAntigens{1},'-vs-',useAntigens{2}];

if doprint
print(gcf,['./output_figures/',currTitle,'.png'],'-dpng','-r450');
print(gcf,['./output_figures/',currTitle,'.svg'],'-dsvg');
end

% there are lots of windows!
%close all

    end
    end
end


% save cutoff values
save('lastCutoffs.mat','allCutoffLabels','allCutoffs')