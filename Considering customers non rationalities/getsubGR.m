function subGR=getsubGR(G,N)

temp=1:N;
k=1;
while ~isempty(temp)
  nodes=temp(randperm(length(temp),10));
  subG(1,k)={nodes};
  subG(2,k)={10};
  temp=setdiff(temp,nodes);
end
subGR=subG;
end