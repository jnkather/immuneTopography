
function bivariate_heatmap_manual_allCL(fullMatrix,useAntigens,varargin)
% optional argument is the original data table. if this argument is passed,
% then the data will be saved.

disp('starting bivariate_heatmap_manual_allCL');
load lastCutoffs % load cutoff values for all antigens. This file was created in heatmapNcluster_batch with biva = false

%'allCutoffLabels','allCutoffs'

% find the cutoff values for both antigens
median1 = allCutoffs(strcmp(allCutoffLabels,useAntigens{1}));
median2 = allCutoffs(strcmp(allCutoffLabels,useAntigens{2}));

disp(['will use cutoff = ',num2str(median1),' for antigen = ',useAntigens{1}]);
disp(['will use cutoff = ',num2str(median2),' for antigen = ',useAntigens{2}]);

XCol = 1; % first column for data displayed on x axis of bivariate heatmap
YCol = 3; % first column for data displayed on y axis of bivariate heatmap

figure 
currMeas = fullMatrix;
manGr = repmat({''},size(currMeas,1),2);

manGr(currMeas(:,XCol)<=median1 & currMeas(:,XCol+1)<=median1,1) = {'cold'};
manGr(currMeas(:,XCol)>median1 & currMeas(:,XCol+1)<=median1,1) = {'excl'};
manGr(currMeas(:,XCol+1)>median1,1) = {'hot'};

manGr(currMeas(:,YCol)<=median2 & currMeas(:,YCol+1)<=median2,2) = {'cold'};
manGr(currMeas(:,YCol)>median2 & currMeas(:,YCol+1)<=median2,2) = {'excl'};
manGr(currMeas(:,YCol+1)>median2,2) = {'hot'};


tbl = table(manGr(:,1),manGr(:,2));
tbl.Properties.VariableNames = useAntigens;
h = heatmap(tbl,useAntigens{1},useAntigens{2});
h.YDisplayData = {'hot','excl','cold'};
h.XDisplayData = {'cold','excl','hot'};
h.ColorbarVisible = 'off';
h.Colormap = flipud(bone(size(h.Colormap,1)));
title('all entities');

%suptitle([useAntigens{1},' vs. ',useAntigens{2}]);
set(gcf,'Position',1000*[0.0475    0.2750    0.50    0.50]);
set(gcf,'Color','w');
drawnow

% optional: save
if nargin>2
    resultTable = [varargin{1}, tbl];
    writetable(resultTable,'lastPhenotypeTable_dachs.xlsx');
end

end