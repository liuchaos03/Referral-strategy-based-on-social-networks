function [rs] = Getbestreferr(GA,Alpha,NCN)
%Getbestreferr此处显示有关此函数的摘要
%   此处显示详细说明
N=length(Alpha);
Beta=N;
gama=0;
%------ NCN对应市场情况；IC=1；IN=2；NC=3；NN=4；
 RBegin=find(max(Alpha)==Alpha);               % %随机开始 或者从最大的Alpha开始
 [net(:,1),net(:,2)]=find(GA~=0);
%-------------IC ---IN ---NC----NN---------------------    
G=zeros(N);  rs=zeros(N);
netf=zeros();
nodeID=1:N;
nodeNet=zeros();
k=1;
%----------第一个点寻找第二个点-------
    tmp=net(net(:,1)==RBegin,:);
    [rank,~]=size(tmp);
    
    nodeID(nodeID==RBegin)=[];                %去除已经选取后的点
    nodeNet(k)=RBegin;
    %-----------------------计算每一条边的收益--------------------
    switch NCN
        case 1
I=eye(length(GA));
A=(sparse(Beta*I-GA)\I);
P=((A+A')^(-1))*A*Alpha;        
    Result=getlinkIC(Alpha,Beta,G,tmp,rank);
        case 2
P=Alpha/2;   
    Result=getlinkIN(Alpha,Beta,G,tmp,rank);
        case 3
I=eye(length(GA));
A=(sparse(Beta*I-GA)\I);
one=ones(1,N);
P=(1/2)*(one*A*Alpha)/(one*A*one');  
one=ones(1,N);
P=one*P;
    Result=getlinkNC(Alpha,Beta,G,tmp,rank);
        case 4
P=sum(Alpha)/(2*N);
one=ones(1,N);
P=one*P;
    Result=getlinkNN(Alpha,Beta,G,tmp,rank);        
    end
    [order,addre]=sort(Result,'descend');   
   

    %-----------------------找到最大的以后，存入-------------------
    for i=1:rank
        if order(i)>0 && sum(G(tmp(addre(i),2),:))==0
            if Alpha(tmp(addre(i),2))<=P(tmp(addre(i),2))
                if Alpha(tmp(addre(i),2))>=(1-gama)*P(tmp(addre(i),2))
               
                G(tmp(addre(i),1),tmp(addre(i),2))=1;    rs(tmp(addre(i),1),tmp(addre(i),2))=1;
                G(tmp(addre(i),2),tmp(addre(i),1))=1;
                netf(k,1:3)=[tmp(addre(i),1),tmp(addre(i),2),order(i)];
                nodeID(nodeID==netf(k,2))=[]; 
                k=k+1;
                nodeNet(k)=netf(k-1,2);
                break;
                else
                  continue
                end
            else
            G(tmp(addre(i),1),tmp(addre(i),2))=1; rs(tmp(addre(i),1),tmp(addre(i),2))=1;
            G(tmp(addre(i),2),tmp(addre(i),1))=1;
            netf(k,1:3)=[tmp(addre(i),1),tmp(addre(i),2),order(i)];
            k=k+1;
            nodeNet(k)=tmp(addre(i),2);
            break;
            end
        else
            break
        end   
    end 

    
while ~isempty(nodeID)
   tmp=[];
   
   chooseid=net(ismember(net(:,1),nodeNet),:);         %查到当前已在网络中的点，的朋友群
   
   for CP=1:length(nodeNet)
       tmp=[tmp;find(chooseid(:,2)==nodeNet(CP))];
   end
   chooseid(tmp,:)=[];
   tmp=chooseid;
     
    note=0;
    if isempty(tmp)
        break
    end
    [rank,~]=size(tmp);    
    if NCN==1
    Result=getlinkIC(Alpha,Beta,G,tmp,rank);
    elseif NCN==2
    Result=getlinkIN(Alpha,Beta,G,tmp,rank);
    elseif NCN==3
    Result=getlinkNC(Alpha,Beta,G,tmp,rank);
    elseif NCN==4
    Result=getlinkNN(Alpha,Beta,G,tmp,rank);        
    end
    [order,addre]=sort(Result,'descend');   
    for i=1:rank
        if order(i)>0 && sum(G(tmp(addre(i),2),:))==0
            if Alpha(tmp(addre(i),2))<=P(tmp(addre(i),2))
                if Alpha(tmp(addre(i),2))>=(1-gama)*P(tmp(addre(i),2))
               
                G(tmp(addre(i),1),tmp(addre(i),2))=1;   rs(tmp(addre(i),1),tmp(addre(i),2))=1;
                G(tmp(addre(i),2),tmp(addre(i),1))=1;
                netf(k,1:3)=[tmp(addre(i),1),tmp(addre(i),2),order(i)];
                note=1;
                nodeID(nodeID==netf(k,2))=[]; 
                k=k+1;
                nodeNet(k)=netf(k-1,2);
                break;
                else
                  continue
                end
            else
            G(tmp(addre(i),1),tmp(addre(i),2))=1; rs(tmp(addre(i),1),tmp(addre(i),2))=1;
            G(tmp(addre(i),2),tmp(addre(i),1))=1;
            netf(k,1:3)=[tmp(addre(i),1),tmp(addre(i),2),order(i)];
            k=k+1;
            nodeNet(k)=tmp(addre(i),2);
            note=1;
            break;
            end
        else
            break;
        end   
    end 
   
%----------------退出条件--------------- 
    if note==0
        break;
    end
  nodeID(nodeID==tmp(addre(i),2))=[]; 
  
end
end


            



