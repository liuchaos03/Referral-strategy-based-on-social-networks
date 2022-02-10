function [matrix,G]=randnet(N,linknum)

G=zeros(N);
Address=zeros(1,((N*N-N)/2));
 while sum(Address)<linknum
       n=linknum-sum(Address);
       tmp=rand(1,n);
       tmp=ceil(tmp*((N*N-N)/2));        % (N*N-N)/2)代表一个矩阵的上三角的总数
       Address(tmp)=1;      
 end
 
 k=0;
 for i=1:N
     for j=i+1:N
         k=k+1;
         G(i,j)=Address(k);
     end
 end
 
 [L,R]=find(G==1);
 matrix=[R,L];

end