function [Ss,Sstep,Ssr]=TheStepTwors3(Alpha,G,Ssr,Ss,Sstep,rs,P0,Yita,seed,c)
% c=0.00000;
global fid error
q=0;
Beta=length(G);
I=eye(length(G));
one=ones(length(G),1);
%%%---����ÿ���˵�Ч�ã�����Ss-----------------------start---------%       
       XR1=((Beta*I-G.*Ss)^(-1))*(Alpha-P0*one);    %���㵱ǰYita�ͼ۸��£�ÿ���˵�������
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
                   pro2=nextrs2(Ss,Sstep,Yita,x,temp(k),XR1,c);
                     if c>pro2 || error>rand(1)
%                     if (c>pro2 && (1-error)>rand(1))|| (c<=pro2 && error<rand(1))
                       Ss(temp(k),x)=0;
                       [Sstep,Ssr]=dedges(Ss,Sstep,Ssr,x,temp(k));
%                     disp([num2str(temp(k)),'ȥ��1��',num2str(pro2)]);
                     fprintf(fid,'%s\r\n',[num2str(temp(k)),'ȥ����',num2str(pro2)]);
                    else
                      fprintf(fid,'%s\r\n',[num2str(temp(k)),'������',num2str(pro2)]);  
                    end
%                     disp([num2str(Yita*XR1(temp(k))),'--',num2str(pro2)]);
               end
           end
       end
       XR1=((Beta*I-G.*Ss)^(-1))*(Alpha-P0*one);    %���㵱ǰYita�ͼ۸��£�ÿ���˵�������
       XR1(XR1<0)=0;
       for i=1:size(Sstep,1)-1
           for j=1:size(Sstep,2)
                if Sstep(i,j)==0
                    break;
                end
                x=Sstep(i,j);  
                 pro=nextrs(rs,Yita,x,XR1);
            Utility=Alpha(x)*XR1(x)-(1/2)*Beta*(XR1(x)^2)+XR1(x)*(G(x,:).*Ss(x,:)*XR1)-P0*XR1(x)-c*(sum(Ss(:,x)))+pro;                  
          if Utility<=0
               q=q+1;
%                 Ss(x,:)=0;
%                 rs(x,:)=0;rs(:,x)=0;
                listde(q)=x; 
          end
          end
        end
       if q~=0
           for q=1:length(listde)
               x=listde(q);
              [Ss,Sstep,Ssr]=Derelation(Ss,Sstep,Ssr,x);
%               disp(['Ч�ø�������:',num2str(length(listde))]);
           end
       end
      

       temp=sum(Ss,2);
       if sum(temp==0)>length(seed)
           temp=find(temp==0);
           temp=setdiff (temp,seed);
%            disp(['���ʸ�������:',num2str(length(temp))]);
           for i=1:length(temp)
               x=temp(i);
               [Ss,Sstep,Ssr]=Derelation(Ss,Sstep,Ssr,x);
           end
       end
       
       %-------��������ͨ��Ssͼ---------------%
%        temp2=find(sum(Ss)==0);  %��֪�������Ƽ�����
       temp=(Ss+Ss')^(length(Ss));       %�ҳ�����ͨ��
%      temp=temp-diag(diag(temp));   %ʹ�öԽ���Ԫ��Ϊ0��
       temp=find(temp(seed(1),:)==0);
%        temp=setdiff (temp,temp2);
           for i=1:length(temp)
               x=temp(i);
               [Ss,Sstep,Ssr]=Derelation(Ss,Sstep,Ssr,x);
           end
       
%%%---����ÿ���˵�Ч�ã�����Ss-----------------------end---------%
end