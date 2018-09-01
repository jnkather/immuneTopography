% JN Kather 2018


function bivariate_heatmap_manual(mergedResultsTable,fullMatrix,useAntigens)

disp('will draw heatmap in bivariate_heatmap_manual');
load lastCutoffs % load cutoff values for all antigens. This file was created in heatmapNcluster_batch with biva = false

%'allCutoffLabels','allCutoffs'

% find the cutoff values for both antigens
median1 = allCutoffs(strcmp(allCutoffLabels,useAntigens{1}));
median2 = allCutoffs(strcmp(allCutoffLabels,useAntigens{2}));

XCol = 1
YCol = 3

count =0
figure
for currCl = {'MEL','LUAD','LUSC','BLCA','HNSC','STAD','ESCA','COAD_PRI','COAD_MET','OV'}
    

rowSel = contains(mergedResultsTable.CL,currCl);
currMeas = fullMatrix(rowSel,:);
manGr = repmat({''},size(currMeas,1),2);

manGr(currMeas(:,XCol)<=median1 & currMeas(:,XCol+1)<=median1,1) = {'cold'};
manGr(currMeas(:,XCol)>median1 & currMeas(:,XCol+1)<=median1,1) = {'excl'};
manGr(currMeas(:,XCol+1)>median1,1) = {'hot'};

manGr(currMeas(:,YCol)<=median2 & currMeas(:,YCol+1)<=median2,2) = {'cold'};
manGr(currMeas(:,YCol)>median2 & currMeas(:,YCol+1)<=median2,2) = {'excl'};
manGr(currMeas(:,YCol+1)>median2,2) = {'hot'};


count = count+1;
subplot(2,5,count)
tbl = table(manGr(:,1),manGr(:,2));
tbl.Properties.VariableNames = useAntigens;
h = heatmap(tbl,useAntigens{1},useAntigens{2});
h.YDisplayData = {'hot','excl','cold'};
h.XDisplayData = {'cold','excl','hot'};
h.ColorbarVisible = 'off';
h.Colormap = flipud(bone(size(h.Colormap,1)));
title(currCl);
end

%suptitle([useAntigens{1},' vs. ',useAntigens{2}]);
set(gcf,'Position',1000*[0.0475    0.2750    1.4780    0.50]);
set(gcf,'Color','w');
drawnow

end