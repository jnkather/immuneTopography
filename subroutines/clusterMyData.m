% JN Kather, NCT Heidelberg 2017
% clusters immune cell map data
% called by visualizeMore.m

function [clusterData_MEAN,clusterData_STD,myIdx] = clusterMyData(X,method,optimalK)

switch method
    case 'K-means'
        ks = 1:11;
        
        for k=ks % iterate through all possible values for k
        idx{k} = kmeans(X,k,'Distance','cityblock','Display','final','Replicates',100);
        figure
        [cursil,~] = silhouette(X,idx{k},'cityblock');
        h = gca;
        h.Children.EdgeColor = [.8 .8 1];
        xlabel 'Silhouette Value'
        ylabel 'Cluster'
        disp(['for k=',num2str(k),', the mean silhouette value is ',num2str(mean(cursil))]);
        warning('WARNING: IGNORING NAN');
        allSil(k) = median(cursil,'omitnan');
        end

        % plot silhouette values by k
        figure()
        bar(ks,allSil)
        ylabel('MEDIAN silhouette value from kmeans')
        xlabel('k')
        set(gcf,'Color','w')
        axis auto
       
        myIdx = idx{optimalK}; %use optimal k for final clustering


    case 'hierarchical_cutoff'
%         size(X)
%         YP = pdist(X,'euclidean'); 
%         size(YP)
        Ztree = linkage(X,'average','seuclidean'); 
        myIdx = cluster(Ztree, 'Cutoff', optimalK, 'criterion', 'distance');
        
        unique(myIdx)
        %pause
       
    otherwise
        error('invalid method');
        
end
        
for i=1:max(myIdx)
    clusterData_MEAN(i,:) = round(mean(2.^X(myIdx==i,:)));
    clusterData_STD(i,:) = round(std(2.^X(myIdx==i,:)));
end
clusterData_MEAN

end