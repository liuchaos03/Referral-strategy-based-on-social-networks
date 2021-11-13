function pro=nextrs(rs,Yita,x,XRi)
    pro=0;
    temp=find(rs(:,x));
        XRi(XRi<0)=0;
    for i=1:length(rs)
        temp2=[];
        if isempty(temp)
            break
        end
        for j=1:length(temp)
            pro=pro+Yita*((1/2)^(i-1))*XRi(temp(j));
            temp2=[temp2,find(rs(:,temp(j)))'];
        end
        temp=temp2;
    end
end