function lastPie = visualizePies(uniqueClasses,pies,allK)

for i=1:numel(uniqueClasses)
    uniqueClasses{i} = strrep(uniqueClasses{i},'_',char(10));
end

allPies = pies{1};
for i=2:numel(pies)
   allPies = allPies+pies{i};
end

figure()
% plot total cohort
pie(allPies,uniqueClasses);
myCmap = pink(numel(allPies));
colormap(myCmap);
title(['all samples',newline,'N = ',num2str(sum(allPies))]);
set(gcf,'Color','w');

if numel(pies)==9
    sp1 = 3; sp2 = 3; 
else
    sp1 = 1; sp2 = numel(pies);
end

figure()
for i=1:numel(pies)
   subplot(sp1,sp2,i);
   currData = pies{i};
   currData(currData==0) = 0.0001;
   currClasses = uniqueClasses;
   currClasses(currData==0.0001) = {' '};
   lastPie = pie(currData,currClasses);
   myCmap = pink(numel(pies{i}));
   %myCmap(pies{i}==0,:) = [];
   colormap(myCmap);
   title(['cluster ',num2str(allK(i)),10,'N = ',num2str(sum(pies{i}))]);
end
set(gcf,'Color','w');

end