
function  IDs = generateID(numID,seed)
    
    % generates one of eight million possible IDs based on three words from
    % a list
    
    % read data
    myList = table2cell(readtable('dictionary.txt'));
    % random number generator
    rng(seed);
    
    for i=1:numID
        IDs{i} = [char(myList(ceil(rand()*numel(myList)))),'-',...
                  char(myList(ceil(rand()*numel(myList))))];
        IDs{i} = strrep(IDs{i},' ','');
    end
    
    IDs = IDs';
    
end