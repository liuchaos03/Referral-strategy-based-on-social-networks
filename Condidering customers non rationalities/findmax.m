function bestone=findmax(pr,Yita,Yita1,Yita2)
   k=Yita1:0.001:Yita2;
   reslut=zeros();
    for i=1:length(k)
        reslut(i,1:2)=[k(i),vpa(subs(pr,Yita,k(i)))]; 
    end
    bestone=reslut(max(reslut(:,2))==reslut(:,2),:);
end