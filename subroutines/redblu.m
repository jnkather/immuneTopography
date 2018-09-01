function newmap = redblu(nlev)

newmap = ones(nlev,3);
midp = round(nlev/2);

% upper half
newmap(midp:end,1) = 1;
newmap(midp:end,2) = linspace(1,0,nlev-midp+1);
newmap(midp:end,3) = linspace(1,0,nlev-midp+1);

% lower half
newmap(1:midp,1) = linspace(0,1,midp);
newmap(1:midp,2) = linspace(0,1,midp);
newmap(1:midp,3) = 1;

end
