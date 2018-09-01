function drawcircles(xbase,ybase,colordata,mytitle,colornorm)
 
% define drawing function
rct = @(pp,cc,ee,cv,lw) rectangle('Position',[pp(1)+xbase,pp(2)+ybase,pp(3),pp(4)],'Curvature',cv,...
    'LineStyle',char(ee),'EdgeColor','k','FaceColor',cc,'LineWidth',lw);

if any(contains(fieldnames(colordata),'DISTANT_OUT'))
    myColr(1,:) = getColor(colordata.DISTANT_OUT,colornorm);
    %disp('plotting background');
else
    myColr(1,:) = [1 1 1]; % use white background
    %disp('using white background');
end

if ~any(contains(fieldnames(colordata),'MARG_500_IN'))
    colordata.MARG_500_IN = colordata.TU_CORE;
    warning('replaced MARG IN by TU CORE - press any key to continue');
   % pause
end

% prepare colors
myColr(2,:) = getColor(colordata.MARG_500_OUT,colornorm);   % outer margin
myColr(3,:) = getColor(colordata.MARG_500_IN,colornorm);   % inner margin
myColr(4,:) = getColor(colordata.TU_CORE,colornorm);   % core

% prepare hard-coded circle positions
numdraw = 4; 
pos(1,:) = [-3.5 -3.5 7 7];       myCurv(1,:)=[0 0];         myEdge{1}  = 'none'; % outside
pos(2,:) = [-3.4 -3.4 6.8 6.8];   myCurv(2,:)=[1 1];                 myEdge{2}  = 'none'; % outer margin
pos(3,:) = [-2.5 -2.5 5 5];       myCurv(3,:)=[1 1];     myEdge{3}  = '-'; % inner margin
pos(4,:) = [-1.6 -1.6 3.2 3.2 ];  myCurv(4,:)=[1 1];           myEdge{4}  = 'none'; % core

% draw all circles
for i=1:numdraw
    rct(pos(i,:),myColr(i,:),myEdge(i),myCurv(i,:),1.8);
end

if any(contains(fieldnames(colordata),'MARG_LUM')) && ~isnan(colordata.MARG_LUM) % add luminal compartiment on top
    pos(5,:) = [-2.5 1.5 5 2 ];  myCurv(5,:)=[.8 .8];     myEdge{5}  = 'none';  
    myColr(5,:) = getColor(colordata.MARG_LUM,colornorm);   % core
    i = 5; rct(pos(i,:),myColr(i,:),myEdge(i),myCurv(i,:),1);
end

% add title
text(xbase,ybase+4,strrep(mytitle,'_','-'),...
    'VerticalAlignment','bottom','HorizontalAlignment','center',...
    'FontSize',8,'FontWeight','normal');

if any(contains(fieldnames(colordata),'FAT_CORE')) && ~isnan(colordata.FAT_CORE) % FAT MODE -> add fat
    disp('drawing fat on top');
    posF(1,:) = [-3.5 -4 7 0.5];       myCurvF(1,:)=[0 0];         myEdgeF{1}  = 'none'; % fat margin out
    posF(2,:) = [-3.5 -4.5 7 0.5];       myCurvF(2,:)=[0 0];         myEdgeF{2}  = 'none'; % fat margin in
    posF(3,:) = [-3.5 -5.5 7 1];       myCurvF(3,:)=[0 0];         myEdgeF{3}  = 'none'; % fat core
    
    % prepare fat colors
    myColrF(1,:) = getColor(colordata.FAT_MARG_OUT,colornorm);   % outer margin
    myColrF(2,:) = getColor(colordata.FAT_MARG_IN,colornorm);   % inner margin
    myColrF(3,:) = getColor(colordata.FAT_CORE,colornorm);   % core

    numdraw = 3;
    for i=1:numdraw
    rct(posF(i,:),myColrF(i,:),myEdgeF(i),myCurvF(i,:),1.8);
    end    
end
    
end