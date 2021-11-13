function [pr,temp]=maxprofit1(Alpha,P0,Yita,G,rs,Ss)
    Beta=length(Alpha);
    I=eye(length(Alpha));
    one=ones(length(Alpha),1);
    XR=((Beta*I-G.*Ss)^(-1))*(Alpha-P0*one);  %Ïû·ÑÁ¿
    XR(XR<0)=0;
    XR((sum(Ss,1)'+sum(Ss,2))==0)=0;
    pr=sum(P0*XR);
    
    temp=0;
    for i=1:length(Alpha)
        temp=temp+sum(Yita*XR(rs(:,i)==1));
    end
    
    pr=pr-temp;  
end