function [sc A]=BA1(N)

 m0 = 7;% 
 m = 4;%

sf=zeros(N);
sf(1:m0,1:m0)=1;
sf(1:m0,1:m0)=sf(1:m0,1:m0)-eye(m0);


for i=1:m0-1
for j=1:m0
list((i-1)*m0+j)=j;
end
end
d=(m0-1)*m0;

for n=m0+1:N
t=d+2*m*(n-m0-1);
for i=1:m
list(t+i)=n; % in the list, every time the above m is n, it represents that the nth nodes is connected to other m nodes
end
k=1;
while k<m+1 % grow other m nodes
p(k)=round((t+1)*rand(1)); % random choose an integer from 1~N
if p(k)>0&p(k)<(t+1)
if sf(n,list(p(k)))==0
list(t+m+k)=list(p(k));
sf(n,list(p(k)))=1;
sf(list(p(k)),n)=1;
k=k+1;
end 
end 
end %end for k

end %end for n
A=sf;


 h=1;
 for i=1:N-1
 for j=i+1:N
 if A(i,j)==1 
 sc(h,:)=[i j];
 h=h+1;
 end
 end
 end
