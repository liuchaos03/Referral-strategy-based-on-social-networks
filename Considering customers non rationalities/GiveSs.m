function [Ss,Sstep,Ssr]=GiveSs(G,seed)
% one=ones(length(G),1);
% V=G*one;
V=sum(G~=0);
%%%----����ȫ״̬����ʼ�����Ƽ�����------start---------%
   Ss=zeros(length(G));
   Ssr=zeros(length(G));
   Sstep=zeros(length(G));                %ÿһ�д���һ���׶Σ�ÿ���׶δ洢ͬһ��ʱ��������Ƽ�����
   Sstep(1,1:length(seed))=seed; 
   for i=1:length(Sstep)
       for j=1:length(Sstep)
           if Sstep(i,j)==0
               break;
           end  
       Ss(G(:,Sstep(i,j))>0,Sstep(i,j))=1;
       Ss(setdiff(unique(Sstep),[0,Sstep(i,:)]),Sstep(i,j))=0;
       temp=find(Ss(:,Sstep(i,j))>0);
       Ssr(Sstep(i,j),1:length(temp))=temp(randperm(length(temp)));
       end
           if length(unique(Sstep))==V+1
               break
           end
       [temp,~]=find(Ss>0);
       temp=setdiff(temp,unique(Sstep)); 
        Sstep(i+1,1:length(temp))=temp;  
   end  
   Sstep(Sstep(:,1)==0,:)=[];   
%%%----����ȫ״̬����ʼ�����Ƽ�����--------end------%
end