% JN Kather, NCT Heidelberg, 2017-2018
% see separate LICENSE 
%
% This MATLAB script is associated with the following article
% "Topography of cancer-associated immune cells"
% Please refer to the article and the supplemntary material for a
% detailed description of the procedures. This is experimental software
% and should be used with caution.
% 
% this script assumes that "step_03_visualize_heatmap" has been run before
% and its output is still in the workspace
clc
close all

clear paramSetName kCollect kkk
dosave = 0;
count = 0;

for sets ={[1:6],[1:3],[4:6]}%{[1:3],[1:6],[4:6],[10:12]}
currMeas = (measurements_clean(:,cell2mat(sets)));

for clust = {'gmdistribution','kmeans','linkage'} %'gmdistribution','kmeans','linkage'
for method = {'DaviesBouldin','CalinskiHarabasz','silhouette'} % 
for seed = 1:5
 rng(seed);   
% if (strcmp(char(method),'gap') || strcmp(char(method),'silhouette'))
%     for distanceMeas = {'sqEuclidean', 'Euclidean', 'cityblock', 'correlation'}
%         eva = evalclusters(currMeas,char(clust),method,'KList',[1:6],'Distance',char(distanceMeas));
%         count = count+1;
%         kCollect(count) = eva.OptimalK;
%         paramSetName{count} = strcat(char(clust),'_',char(method),'_',char(distanceMeas));
%     end
% else
        eva = evalclusters(currMeas,char(clust),method,'KList',[1:12]);
        count = count+1;
        kCollect(count) = eva.OptimalK;
        paramSetName{count} = strcat(char(clust),'_',char(method),'_',num2str(cell2mat(sets)));
        
        disp(num2str(count));
end
        
%figure
%plot(eva.InspectedK,eva.CriterionValues)

end
end
end

kCollect
table(paramSetName',kCollect')

figure
histogram(kCollect/numel(kCollect)*100,1:12)
axis square
xlabel('number of clusters');
ylabel(['percentage of optimization runs',10,'converging on this number']);
set(gcf,'Color','w');
currTitle = ['number clusters'];
if dosave
print(gcf,['./output_figures/',currTitle,'.png'],'-dpng','-r450');
print(gcf,['./output_figures/',currTitle,'.svg'],'-dsvg');
end

figure
subplot(1,2,1)
gscatter(measurements_clean(:,1),measurements_clean(:,2),inputData.CL,...
    lines(numel(unique(inputData.CL))));
axis equal tight
xlabel('margin'),ylabel('core');

subplot(1,2,2)
gscatter(measurements_clean(:,3),measurements_clean(:,4),inputData.CL,...
    lines(numel(unique(inputData.CL))));
axis equal tight
xlabel('margin'),ylabel('core');

