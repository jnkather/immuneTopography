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
%% INITIALIZE
% load data and select tumor types and antigens that you want to look at
inputDataTable = './output_tables/lastResuTable_noNorm.xlsx';
myTable = readtable(inputDataTable);
useEntities = {'LUAD','LUSC','STAD','COAD_PRI','BLCA','COAD_MET','HNSC','ESCA','OV','MEL'}; 
useAntigens = { 'CD3','CD8','PD1','Foxp3','CD68','CD163'} ;%
useFields = {'MARG_500_OUT'	'MARG_500_IN' 'TU_CORE' }; %

%% PREPARE DATA

% find all samples that belong to target class and have all target antigens
[cleanFullTable,uIDs] = findCompleteSamples(myTable,useAntigens,useEntities);

% reformat table so that each sample is one row
mergedResultsTable = compressTable(cleanFullTable,uIDs,useFields,useAntigens);

writetable(mergedResultsTable,'./output_tables/lastHeatmap.xlsx');
disp('saved results')

% show naked heatmap
fullMatrix = table2array(mergedResultsTable(:,4:end));
figure()
imagesc(fullMatrix');
colormap hot
colorbar
axis equal off
set(gcf,'Color','w')
