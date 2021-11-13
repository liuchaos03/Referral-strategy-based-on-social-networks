% ZResultOut=ZResultOut_010;
% ZResultOuterr=ZResultOuterr_010;

profit=zeros();
for ii=1:length(ZResultOut)
     for jj=2:4
         for kk=1:3
             profit(ii,jj-1,kk)=ZResultOut{1,ii}{1,jj}{1,kk}{1,6};
         end
     end
end
 

profitA=zeros();
for ii=1:length(ZResultOuterr)
     for jj=2:4
         for kk=1:3
             profitA(ii,jj-1,kk)=ZResultOuterr{1,ii}{1,jj}{1,kk}{1,6};
         end
     end
end


A=profit-profitA;
for i=1:length(ZResultOuterr)
    for j=1:3
         for k=1:3
             A(i,j,k)=A(i,j,k)./profit(i,j,k);
         end
    end
end

%  A=A(randsample(1:length(A),100,'true'),:,:);
B=zeros(length(A),3);
for i=1:3
B(:,1)=A(:,i,1);
B(:,2)=A(:,i,2);
B(:,3)=A(:,i,3);
%  subplot(1,3,i)
%  boxplot((B))
temp(i,1:3)=mean(B);
tem2(i,1:3)=std(B);
end

%--plot errorbar

% for i=1:3
%     for k=1:3
%         subplot(3,3,(i-1)*3+k);
%       errorbar(-Average(i,(k-1)*3+1:k*3),-Variance(i,(k-1)*3+1:k*3),'-o');
%       xlim([0.5,3.5])
%     end
% end