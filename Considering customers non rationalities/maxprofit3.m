function [pr,pro]=maxprofit3(Alpha,P0,Yita,G,rs,Ss)
    Beta=length(Alpha);
    I=eye(length(Alpha));
    one=ones(length(Alpha),1);
    XR=((Beta*I-G.*Ss)^(-1))*(Alpha-P0*one);  %Ïû·ÑÁ¿
    XR(XR<0)=0;
    XR((sum(Ss,1)'+sum(Ss,2))==0)=0;
    pr=sum(P0*XR);
    pro=0;
      for x=1:length(Alpha)  
        temp=find(rs(:,x));
        for i=1:length(rs)
        temp2=[];
        if isempty(temp)
            break
        end
        for j=1:length(temp)
            pro=pro+Yita*((1/2)^(i-1))*XR(temp(j));
            temp2=[temp2,find(rs(:,temp(j)))'];
        end
        temp=temp2;
        end
      end
    
    pr=pr-pro;  
end