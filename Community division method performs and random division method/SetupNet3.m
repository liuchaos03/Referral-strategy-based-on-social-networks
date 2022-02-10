%-------------根据输入生成三种网络-------------
function [Alpha,netF,netS,netG,GF,GS,GG]=SetupNet3(N)

Alpha=rand(1,N);                   %每个人取值0-1
%-------------Regular netWork
GF=triu(ones(N))-eye(N);         %生成全连接网络（Regular network）
GF=GF+GF';  
L=0;R=0;
[L,R]=find(GF==1);
for i=1:length(L)
    GF(L(i),R(i))=rand;
end
netF=[R,L];
%-----------------------------
%------------Sclae free-network
[~,GS]=FreeScaleBA(N);                   %采用BA方法生成无标度网络
%GS=GS+GS';
%triu(GS.0) 
L=0;R=0;
[L,R]=find(GS==1);
[~,order]=sort(Alpha,'descend');              %从大到小排序

netS=[R,L];
for i=1:length(netS)                          %将度高的节点，与Alpha大的节点进行匹配
    netS(i,1)=order(netS(i,1));
    netS(i,2)=order(netS(i,2));
end

GS=zeros(N);
for i=1:length(netS)
    GS(netS(i,1),netS(i,2))=rand;
end

%----------------------------
%------------Random network
[~,GG]=randnet(N,(length(netS))/2);          %随机生成的网络边数要和无标度网络的保持一致
GG=GG+GG';
L=0;R=0;
[L,R]=find(GG==1);
netG=[R,L];
for i=1:length(netG)
    GG(netG(i,1),netG(i,2))=rand;
end
%-------------------------
end