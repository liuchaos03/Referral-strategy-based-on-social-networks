function [pr,temp]=maxprofit2(Alpha,P0,Yita,G,rs,Ss)
    Beta=length(Alpha);
    I=eye(length(Alpha));
    one=ones(length(Alpha),1);
    XR=((Beta*I-G.*Ss)^(-1))*(Alpha-P0*one);  %Ïû·ÑÁ¿
    XR(XR<0)=0;
    XR((sum(Ss,1)'+sum(Ss,2))==0)=0;
    pr=sum(P0*XR);
    
    temp=0;
    for i=1:length(Alpha)
        key=find(rs(:,i)==1);
        temp=temp+sum(Yita*XR(rs(:,i)==1));
        for j=1:length(key)
        temp=temp+sum((Yita/2)*XR(rs(:,key(j))==1));
        end
    end
    
    pr=pr-temp;  
end