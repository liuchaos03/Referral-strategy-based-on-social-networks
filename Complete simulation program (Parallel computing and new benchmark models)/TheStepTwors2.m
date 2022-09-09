function [Ss,Sstep,Ssr]=TheStepTwors2(Alpha,G,Ssr,Ss,Sstep,rs,P0,Yita,seed,c)
% c=0.00000;
q=0;
Beta=length(G);
I=eye(length(G));
one=ones(length(G),1);
%%%---Calculate everyone's utility, update Ss-----------------------start---------%           
       XR1=((Beta*I-G.*Ss)^(-1))*(Alpha-P0*one);    %Calculate the current Yita and price per person's consumption
       for i=1:size(Sstep,1)-1
           for j=1:size(Sstep,2)
                if Sstep(i,j)==0
                    break;
                end
               x=Sstep(i,j);
            XR1i=zeros(length(XR1),1);
            XR1i(XR1>0)=XR1(XR1>0);
            XR1i(XR1<0)=0;
            XR1i(x)=0;
               temp=find(Ss(:,x)>0);       
               for k=1:length(temp)     
                   key=Ss(:,temp(k)).*XR1i;
                   key(key<c)=0;
                   if c>Yita*XR1(temp(k))+sum((Yita/2)*(key))
                       Ss(temp(k),x)=0;
                     [Sstep,Ssr]=dedges(Ss,Sstep,Ssr,x,temp(k));
                   end
               end
           end
       end
       XR1=((Beta*I-G.*Ss)^(-1))*(Alpha-P0*one);     %Calculate the current Yita and price per person's consumption
       for i=1:size(Sstep,1)-1
           for j=1:size(Sstep,2)
                if Sstep(i,j)==0
                    break;
                end
                x=Sstep(i,j);
            XR1i=zeros(length(XR1),1);
            XR1i(XR1>0)=XR1(XR1>0);
            XR1i(XR1<0)=0;
            XR1i(x)=0;
            rs2=rs^2;
            
            Utility=Alpha(x)*XR1(x)-(1/2)*Beta*(XR1(x)^2)+XR1(x)*(G(x,:).*Ss(x,:)*XR1)-P0*XR1(x)-c*(sum(Ss(:,x)))+sum(Yita*XR1i(rs(:,x)==1))+sum((Yita^2)*(rs2(:,x)>0)'*XR1i);                 
  %             if (Alpha(x)*XR1(x)-(1/2)*Beta*(XR1(x)^2)+XR1(x)*(G(x,:).*Ss(x,:)*XR1))>0     
          if Utility<=0
               q=q+1;
                listde(q)=x; 
          end
          end
        end
       if q~=0
           for q=1:length(listde)
               x=listde(q);
              [Ss,Sstep,Ssr]=Derelation(Ss,Sstep,Ssr,x);
           end
       end
       
       temp=sum(Ss,2);
       if sum(temp==0)>length(seed)
           temp=find(temp==0);
           temp=setdiff (temp,seed);
           for i=1:length(temp)
               x=temp(i);
               [Ss,Sstep,Ssr]=Derelation(Ss,Sstep,Ssr,x);
           end
       end
       
       %-------Eliminate disconnected Ss---------------%
       temp=(Ss+Ss')^(length(Ss));      
       temp=find(temp(seed(1),:)==0);
           for i=1:length(temp)
               x=temp(i);
               [Ss,Sstep,Ssr]=Derelation(Ss,Sstep,Ssr,x);
           end
       
%%%------------------end---------%
end