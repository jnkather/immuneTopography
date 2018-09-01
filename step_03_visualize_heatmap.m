% JN Kather, NCT Heidelberg, 2017-2018
% see separate LICENSE 
%
% This MATLAB script is associated with the following article
% "Topography of cancer-associated immune cells"
% Please refer to the article and the supplemntary material for a
% detailed description of the procedures. This is experimental software
% and should be used with caution.
% 

% initialize
clear all, close all, clc
addpath('./subroutines/');

% --------------------------
% program settings:
inputFileName = './output_tables/lastHeatmap.xlsx'; % input data file name 
idcol         = 3;             % column containing the ID for each sample
RowLow        = 1;             % number of the starting row
RowHigh       = 0;             % number of the last row, 0 = auto
Log10Mode     = true;          % true for logarithmic, false otherwise
SaveResult    = false;         % true to save resulting image
LabelsFontSize2D = 6.5;          % axis label font size in px for 2D plots
SetLineWidth = 1;              % line width in px
SetTitleFontSizeMultiplier= 2; % scaling factor for figure title font size
ImageResolution = '-r450';     % resolution in dpi, '-r300', '-r600' etc.
NormalizeEachCytokine = false; % normalize each column, default false
NormalizeEachSample = false;   % normalize each row, default false
% --------------------------

% read input data from excel table
inputData = readtable(inputFileName);

% extract measurements from the input table, assuming one title column
measurements_clean = table2array(inputData(:,4:end));

% --- added 2018-01-03 add tSNE
figure()
rng('default');
Y = tsne(measurements_clean);
gs = gscatter(Y(:,1),Y(:,2),inputData.CL,brewer2(10),'.',32);
axis square off
set(gcf,'Color','w')
set(legend,'Location','WestOutside')
drawnow



% FIGURE 01: plot heatmap
figure();
image(measurements_clean,'CDataMapping','scaled');
colormap parula;
colorbar();
axis equal tight;
set(gcf,'Color','w');
currImgHandle = gca;
currImgHandle.YTick = 1:size(inputData,1);
currImgHandle.YTickLabel = strrep(table2array(inputData(:,idcol)),'_','-');
currImgHandle.XTick = 1:size(measurements_clean,2);
currImgHandle.XTickLabel = strrep(fieldnames(inputData(:,4:end)),'_','-');
currImgHandle.XTickLabelRotation = 90;
currImgHandle.FontSize = LabelsFontSize2D;
currImgHandle.TitleFontSizeMultiplier = SetTitleFontSizeMultiplier;
title('log density')
if SaveResult
print(gcf,[inputFileName,'-RESULTS.png'],'-dpng',ImageResolution);
end


% FIGURE 03: plot hiearchical clustering dendrogram
% calculate pairwise distance
distanceM = pdist(measurements_clean);
% dendrogram (hierarchical clustering)
figure()
Ztree = linkage(measurements_clean,'average','seuclidean'); 
leafOrder = optimalleaforder(Ztree,distanceM);
dendrogram(Ztree,0,'Reorder',leafOrder);
currImgHandle = gca;
labelTexts = strrep(table2array(inputData(:,idcol)),'_','-');
currImgHandle.XTickLabel = labelTexts(leafOrder);
currImgHandle.XTickLabelRotation = 90;
currImgHandle.FontSize = LabelsFontSize2D;
currImgHandle.TitleFontSizeMultiplier = SetTitleFontSizeMultiplier;
title('distance between samples');
set(gcf,'Color','w');
for i=1:numel(currImgHandle.Children)
    currImgHandle.Children(i).LineWidth = SetLineWidth;
end
if SaveResult
print(gcf,[inputFileName,'-TREE.png'],'-dpng',ImageResolution);
end

% intermediate step
% re-sort measurements
auxMeasurementClean = measurements_clean;
auxMeasurementClean = auxMeasurementClean(leafOrder,:);
distanceMReorder = pdist(auxMeasurementClean);

% FIGURE 04: heatmap of pairwise distance, best order
figure()
image((squareform(distanceMReorder)),'CDataMapping','scaled');
colormap(flipud(hot(1000)));
title('pairwise distance between samples (best order)');
axis equal tight;
currImgHandle = gca;
currImgHandle.YTick = 1:size(inputData,1);
preYTickLabel = strrep(table2array(inputData(:,idcol)),'_','-');
currImgHandle.YTickLabel = preYTickLabel(leafOrder); 
currImgHandle.XTick = 1:size(inputData,1);
preXTickLabel = strrep(table2array(inputData(:,idcol)),'_','-');
currImgHandle.XTickLabel = preXTickLabel(leafOrder);
currImgHandle.XTickLabelRotation = 90;
currImgHandle.FontSize = LabelsFontSize2D;
currImgHandle.TitleFontSizeMultiplier = SetTitleFontSizeMultiplier;
set(gcf,'Color','w');
%colormap((hot()));
colorbar();
if SaveResult
print(gcf,[inputFileName,'-DISTANCE_BEST.png'],'-dpng',ImageResolution);
end

% FIGURE 05: plot pairwise distance, original order
figure()
image(log(squareform(distanceM)),'CDataMapping','scaled');
title('logarithmic pairwise distance between samples (original order)');
axis equal tight;
currImgHandle = gca;
currImgHandle.YTick = 1:size(inputData,1);
preYTickLabel = strrep(table2array(inputData(:,idcol)),'_','-');
currImgHandle.YTickLabel = preYTickLabel; 
currImgHandle.XTick = 1:size(inputData,1);
preXTickLabel = strrep(table2array(inputData(:,idcol)),'_','-');
currImgHandle.XTickLabel = preXTickLabel;
currImgHandle.XTickLabelRotation = 90;
currImgHandle.FontSize = LabelsFontSize2D;
currImgHandle.TitleFontSizeMultiplier = SetTitleFontSizeMultiplier;
set(gcf,'Color','w');
colormap((hot()));
colorbar();
if SaveResult
print(gcf,[inputFileName,'-DISTANCE_ORIG.png'],'-dpng',ImageResolution);
end
