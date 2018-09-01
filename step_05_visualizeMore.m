% JN Kather, NCT Heidelberg, 2017-2018
% see separate LICENSE 
%
% This MATLAB script is associated with the following article
% "Topography of cancer-associated immune cells"
% Please refer to the article and the supplemntary material for a
% detailed description of the procedures. This is experimental software
% and should be used with caution.
% 
clear all, close all, clc
addpath('./subroutines/');

inputFileName = './output_tables/lastHeatmap.xlsx';
inputTable = readtable(inputFileName);
X = table2array(inputTable(:,4:end));
warning('Hard coded columns! Check size of X');
size(X)

useAntigens = {'CD3'};%{'CD68','CD163','CD3','CD8','Foxp3'};
useFields = {'MARG_500_OUT'	 'MARG_500_IN'	'TU_CORE'}; %
optimalK = 4;

%warning('log mode on');
%X = log2(X);

myLabels = table2array(inputTable(:,'CLID'));
myCat = categorical(table2array(inputTable(:,'CL')));
% % visualize with tsne
% rng('default')
% ydata = tsne(X);
% figure()
% scatter(ydata(:,1),ydata(:,2),100,myCat,'filled')
% colormap(lines(numel(myCat)))
% axis off
% set(gcf,'Color','w')

% perform k-means clustering and find the correct number of clusters
rng('default')
[clusterData_MEAN,clusterData_STD,myIdx] = clusterMyData(X,'K-means',optimalK);
%[clusterData_MEAN,clusterData_STD,myIdx] = clusterMyData(X,'hierarchical_cutoff',optimalK);

% merge K into table
outputTable = inputTable;
outputTable.K = myIdx;
% separate rows again so that table can be visualized
newOutputTable = expandTable(outputTable,useAntigens,useFields);
newOutputTable = sortrows(newOutputTable,'K');
newOutputTable = writeKintoID(newOutputTable);

% show the immune pattern behind each cluster
percentileLevels =  max(X(:));
%visualizeTuIM(newOutputTable,percentileLevels,'re-sort')

% merge all clusters
[KoutputTable, pies, uniqueClasses, allK] = simplifybyK(newOutputTable);
%visualizeTuIM(KoutputTable,percentileLevels,false)
lastPie = visualizePies(uniqueClasses,pies,allK);


% visualize with tsne
for exag = [10]
figure()
rng('default');
warning('warning: hard coded columns here');
Y = tsne(table2array(newOutputTable(:,6:end)),'Exaggeration',exag);
gs = gscatter(Y(:,1),Y(:,2),newOutputTable.K,brewer2(10),'.',32);
axis square off
set(gcf,'Color','w')
set(legend,'Location','WestOutside')

title(num2str(exag))
drawnow
end