%-------------Generating three kinds of networks based on input-------------
function [Alpha,netF,netS,netG,GF,GS,GG]=SetupNet3(N)

Alpha=rand(1,N);                   %0-1
%-------------Regular netWork
GF=triu(ones(N))-eye(N);         %£¨Regular network£©
GF=GF+GF';  
L=0;R=0;
[L,R]=find(GF==1);
for i=1:length(L)
    GF(L(i),R(i))=rand;
end
netF=[R,L];
%-----------------------------
%------------Sclae free-network
[~,GS]=FreeScaleBA(N);                   %
%GS=GS+GS';
%triu(GS.0) 
L=0;R=0;
[L,R]=find(GS==1);
[~,order]=sort(Alpha,'descend');              

netS=[R,L];
for i=1:length(netS)                          
    netS(i,1)=order(netS(i,1));
    netS(i,2)=order(netS(i,2));
end

GS=zeros(N);
for i=1:length(netS)
    GS(netS(i,1),netS(i,2))=rand;
end

%----------------------------
%------------Random network
[~,GG]=randnet(N,(length(netS))/2);        
GG=GG+GG';
L=0;R=0;
[L,R]=find(GG==1);
netG=[R,L];
for i=1:length(netG)
    GG(netG(i,1),netG(i,2))=rand;
end
%-------------------------
end