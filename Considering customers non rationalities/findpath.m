function [re]=findpath(rs,x,seed)
    if isempty(intersect(find(rs(x,:)), seed))
        if sum(rs(x,:))==1
            re=findpath(rs,find(rs(x,:)==1),seed);
        else
            re=0;
        end
    else    
        re=1;
    end
end