function pro2=nextrs2(Ss,Sstep,Yita,~,temp,XRi,c)
    pro=0;
%     temp=find(rs(:,temp));
        XRi(XRi<0)=0;

        keyword=unique(Sstep);
        keyword=setdiff(keyword, [0,temp]);
%         [R,L]=find(Sstep==temp);
%         k=1;
%         keyword=zeros();
%         for i=R:size(Sstep,1)
%             for j=1:size(Sstep,2)
%                 if i==R || j<L
%                     continue
%                 end
%                 if Sstep(i,j)==0
%                     break
%                 end
%                 keyword(k)=Sstep(i,j);
%                 k=k+1;
%             end
%         end
        
    for i=1:length(Ss)
        temp2=[];
        if isempty(temp)
            break
        end
        for j=1:length(temp)
            if i>1 && XRi(temp(j))<c
                continue
            end
            pro=pro+Yita*((1/2)^(i))*XRi(temp(j));
            temp2=[temp2,find(Ss(:,temp(j)))'];
        end
        temp=intersect(temp2, keyword);
        keyword=setdiff(keyword,temp);
    end
    pro2=pro;
end