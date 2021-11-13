function [rs]=Givers(Alpha,G,Sstep,Ss,Ssr,temp)
%%%---Three strategies for accepting recommendation and generating recommendation networks------start---------%
% temp=2;
rs=zeros(length(G));
key=rs;kill=1;
 switch temp  
     case 1
        while sum(sum(Ss,2)~=0)~=sum(sum(rs,2)~=0)   
        for i=2:size(Sstep,1)
            for j=1:size(Sstep,2)
                if Sstep(i,j)==0
                    break;
                end
                temp=find(Ss(Sstep(i,j),:)==1);
                [~,temp2]=sort(Alpha(temp),'descend');
                for k=1:length(temp2)
                   if rs(temp(temp2(k)),Sstep(i,j))==0 &&( sum(rs(temp(temp2(k)),:)) || ~isempty(intersect(Sstep(1,:),temp(temp2(k)))) )  && sum(rs(Sstep(i,j),:))==0
                     rs(Sstep(i,j),temp(temp2(k)))=1;
                     break
                   end   
                end

            end
        end
        
        if sum(sum(rs==key))==length(G)*length(G)
            kill=kill+1;
            if kill>(length(G))/2
                break;
            end
        else
            key=rs;
        end
        
        end
     case 2
        while sum(sum(Ss,2)~=0)~=sum(sum(rs,2)~=0)   
        for i=2:size(Sstep,1)
            for j=1:size(Sstep,2)
                if Sstep(i,j)==0
                    break;
                end
                temp=find(Ss(Sstep(i,j),:)==1);
                temp2=G(Sstep(i,j),temp);
                [~,temp2]=sort(temp2,'descend');
                 for k=1:length(temp2)
                   if rs(temp(temp2(k)),Sstep(i,j))==0 &&( sum(rs(temp(temp2(k)),:)) || ~isempty(intersect(Sstep(1,:),temp(temp2(k)))) ) && sum(rs(Sstep(i,j),:))==0
                     rs(Sstep(i,j),temp(temp2(k)))=1;
                     break
                   end
                 end
            end
        end
        if sum(sum(rs==key))==length(G)*length(G)
            kill=kill+1;
            if kill>(length(G))/2
                break;
            end
        else
            key=rs;
        end
        
        end
        
     case 3
       while sum(sum(Ss,2)~=0)~=sum(sum(rs,2)~=0)  
        for i=2:size(Sstep,1)
            for j=1:size(Sstep,2)
                if Sstep(i,j)==0||sum(rs(Sstep(i,j),:)) 
                    break; 
                end
                [temp,temp2]=find(Ssr==Sstep(i,j));
                [~,temp2]=sort(temp2,'descend');
                    for k=1:length(temp2)
                        if rs(temp(temp2(k)),Sstep(i,j))==0 &&( sum(rs(temp(temp2(k)),:)) || ~isempty(intersect(Sstep(1,:),temp(temp2(k)))) ) && sum(rs(Sstep(i,j),:))==0
                            rs(Sstep(i,j),temp(temp2(k)))=1;
                            break
                        end
                    end
            end
        end  
        if sum(sum(rs==key))==length(G)*length(G)
            kill=kill+1;
            if kill>(length(G))/2
                break;
            end
        else
            key=rs;
        end
        
       end
 end
%%%---------end---------%
end