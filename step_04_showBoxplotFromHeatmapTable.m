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
clear all, close all, format compact, clc;
addpath('./subroutines/');
maxY = 2500;

% --------------------------
% program settings:
inputFileName = './output_tables/lastHeatmap.xlsx'; % input data file name 
targetColumnHeaders = {'CD8_MARG_500_OUT'	'CD8_MARG_500_IN'	'CD8_TU_CORE' ...
                       'CD163_MARG_500_OUT'	'CD163_MARG_500_IN'	'CD163_TU_CORE' }; %...
% --------------------------

myTable = readtable(inputFileName);

% get the columns of interest
columnSelector = getColumnSelector(myTable.Properties.VariableNames,targetColumnHeaders);  

% get the unique tumor types in the table OR manually select classes
uCL = {'COAD_PRI','COAD_MET','ESCA','STAD','LUSC','LUAD','OV','HNSC','BLCA','MEL'}; %unique(myTable.CL);

figure()

for i=1:numel(uCL)
    disp(['current class is ', char(uCL(i))]);
    rowSelector = strcmp(myTable.CL,uCL{i});
    
    targetSubTable = table2array(myTable(rowSelector,columnSelector));
    
    subplot(ceil(numel(uCL)/3),3,i)
    boxplot(targetSubTable);%,'Notch','on'); %,'PlotStyle','compact')
    targetColumnHeaders = strrep(targetColumnHeaders,'_MARG_500_OUT',',out');
    targetColumnHeaders = strrep(targetColumnHeaders,'_MARG_500_IN',',in');
    targetColumnHeaders = strrep(targetColumnHeaders,'_TU_CORE',',core');
    set(gca,'XTickLabel',targetColumnHeaders);
    set(gca,'XTickLabelRotation',0)
    set(gca,'FontSize',9);
    set(gcf,'Color','w');
    
    title(strrep(uCL{i},'_','-'));
    
    
    xx = axis();
    xx(3) = 0; xx(4) = maxY;
    axis(xx);
   % drawnow

end
 