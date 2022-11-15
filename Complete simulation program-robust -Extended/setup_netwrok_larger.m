function [Alpha,seed,G]=setup_netwrok_larger(G)
g=graph(G);
bins = conncomp(g);
A=tabulate(bins);
key=A((A(:,2)<=2),1);
key=ismember(bins,key);
G(key,:)=[];
G(:,key)=[];

N=length(G);

key=sum(G);
[~,id]=sort(key,'descend');
seed=id(1);

Alpha=sort(rand(1,N),'descend');

temp=zeros(1,N);
for i=1:N
    temp(id(i))=Alpha(i);
end
Alpha=temp;
end