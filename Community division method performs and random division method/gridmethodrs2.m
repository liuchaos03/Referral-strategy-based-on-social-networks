function [Yita,P0]=gridmethodrs2(Ss,rs,Alphas,Gs)
global Yitars1 P0rs1;
YitaAll=linspace(0,Yitars1,40);
for i=1:20
P0All(21-i)=P0rs1-0.005*(i-1);
end
for i=1:20
P0All(20+i)=P0rs1+0.005*(i);
end


one=ones(100,1);
Betas=100*eye(100);
% Is=eye(100);
for i=1:40
    Pr1_Yita=P0All(i);
    for j=1:40
        Yita=YitaAll(j);
        Pr(i,j)=(Pr1_Yita*one'-one'*(Yita*rs+(Yita^2)*(rs^2))')*((Betas-Gs.*Ss)^-1)*(Alphas-Pr1_Yita*one);
    end
end
N=max(max(Pr));
[i,j]=find(Pr==N);
Yita=YitaAll(i);
P0=P0All(j);
if i==40||1
%     disp('Yita取了边界值');
end
if j==40||1
%     disp('P0取了边界值');
end
end