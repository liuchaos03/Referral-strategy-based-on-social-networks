function subGC=getsubGC(G,N)
subG={};
[L,R]=find(G>0);
Gone=zeros(length(G));
for i=1:length(L)
    Gone(L(i),R(i))=1;
end
%×ª»¯ÎªÍøÂç
g=graph(Gone);
[T,pred] = minspantree(g);        % %In order to improve the efficiency of the algorithm, 
L=T.Edges.EndNodes;              % we simplify GN algorithm
Gsimp=zeros(length(G));
for i=1:length(L)
    Gsimp(L(i,1),L(i,2))=1;
end
Gsimp=Gsimp+Gsimp';
key=1;len=0;
limit=0;select=0;
while len<N 
        [L,R]=find(triu(Gsimp,0)>0);
        if isempty(L)
            break
        end
        i=randperm(length(L),1);
        Gsimp(L(i),R(i))=0;
        Gsimp(R(i),L(i))=0;
        g=graph(Gsimp);
        bins = conncomp(g);
        temp=tabulate(bins);
        if key==1
            nodes=min(temp(:,2));
        else
            temp(temp(:,2)==1,2)=inf;
            nodes=min(temp(:,2));
        end
            if nodes>=4 && nodes<=12+limit
               nodes=temp(temp(:,2)==min(temp(:,2)),1);
               nodes=find(nodes==bins);
               if len+length(nodes)==199
                   Gsimp(L(i),R(i))=1;
                   Gsimp(R(i),L(i))=1;
                   subG(1,key)={[find(sum(Gsimp,1)>0)]};
                   subG(2,key)={length(find(sum(Gsimp,1)>0))};
                   len=len+length(find(sum(Gsimp,1)>0));
               else
                   subG(1,key)={nodes};
                   subG(2,key)={length(nodes)};
                   disp(key);
                   len=len+length(nodes);
               end

               key=key+1;
               for j=1:length(nodes)
                   Gsimp(nodes(j),:)=0;
                   Gsimp(:,nodes(j))=0;
               end
               select=0;
               disp(limit)
            else
            Gsimp(L(i),R(i))=1;
            Gsimp(R(i),L(i))=1;
            select=select+1;
            limit= floor(select/100);
            end
end
subGC=subG;
end