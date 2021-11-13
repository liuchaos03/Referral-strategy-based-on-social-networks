function [Ss,Sstep,Ssr]=TheStepTwors1(Alpha,G,Ssr,Ss,Sstep,rs,P0,Yita,seed,c)
% c=0.00000;
global fid error
q=0;
Beta=length(G);
I=eye(length(G));
one=ones(length(G),1);
%%%---计算每个人的效用，更新Ss-----------------------start---------%       
       XR1=((Beta*I-G.*Ss)^(-1))*(Alpha-P0*one);    %计算当前Yita和价格下，每个人的消费量
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
                     if c>Yita*XR1(temp(k)) ||error>rand(1)
%                     if (c>Yita*XR1(temp(k)) && (1-error)>rand(1)) || (c<=Yita*XR1(temp(k)) && error>rand(1))
                          
                       Ss(temp(k),x)=0;
                     [Sstep,Ssr]=dedges(Ss,Sstep,Ssr,x,temp(k));
%                       disp([num2str(temp(k)),'去除：',num2str(Yita*XR1(temp(k)))]);
                     fprintf(fid,'%s\r\n',[num2str(temp(k)),'del：',num2str(Yita*XR1(temp(k)))]);
                    else
%                       disp([num2str(temp(k)),'保留：',num2str(Yita*XR1(temp(k)))]);
                    fprintf(fid,'%s\r\n',[num2str(temp(k)),'save：',num2str(Yita*XR1(temp(k)))]);
                    end
               end
           end
       end
       XR1=((Beta*I-G.*Ss)^(-1))*(Alpha-P0*one);    %计算当前Yita和价格下，每个人的消费量
       XR1(XR1<0)=0;
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
           Utility=Alpha(x)*XR1(x)-(1/2)*Beta*(XR1(x)^2)+XR1(x)*(G(x,:).*Ss(x,:)*XR1)-P0*XR1(x)-c*(sum(Ss(:,x)))+sum(Yita*XR1i(rs(:,x)==1));             
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
%                disp(['效用负:',num2str(x)]);
              [Ss,Sstep,Ssr]=Derelation(Ss,Sstep,Ssr,x);
           end
%            disp(['效用负总人数:',num2str(length(listde))]);
       end
       
       temp=sum(Ss,2);
       if sum(temp==0)>length(seed)
           temp=find(temp==0);
           temp=setdiff (temp,seed);
           for i=1:length(temp)
               x=temp(i);
%                disp(['无资格:',num2str(x)]);
               [Ss,Sstep,Ssr]=Derelation(Ss,Sstep,Ssr,x);
           end
%             disp(['无资格总人数:',num2str(length(temp))]);
       end

       %-------消除不连通的Ss图---------------%
%        temp2=find(sum(Ss)==0);  %已知不参与推荐的人
       temp=(Ss+Ss')^(length(Ss));       %找出不连通的
%      temp=temp-diag(diag(temp));   %使得对角线元素为0；
       temp=find(temp(seed(1),:)==0);
%        temp=setdiff (temp,temp2);
           for i=1:length(temp)
               x=temp(i);
               [Ss,Sstep,Ssr]=Derelation(Ss,Sstep,Ssr,x);
           end
       
%%%---计算每个人的效用，更新Ss-----------------------end---------%
end