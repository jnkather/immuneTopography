function cmapout = brewer2(numC)

hexout = {'#a6cee3','#1f78b4','#b2df8a','#33a02c','#fb9a99','#e31a1c','#fdbf6f','#ff7f00','#cab2d6','#6a3d9a'};
 
%hexout = {'#8dd3c7','#ffffb3','#bebada','#fb8072','#80b1d3','#fdb462','#b3de69','#fccde5','#d9d9d9','#bc80bd'};
for i=1:numC
   
    currColInd = mod(i-1,numel(hexout))+1;
    cmapout(i,:) = hex2rgb(hexout{currColInd});

end

cmapout = cmapout(1:numC,:);

end