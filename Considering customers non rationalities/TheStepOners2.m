function [Yita,P0]=TheStepOners2(Alpha,G,Ss,~,rs,seed,casers)
N=length(G);
one=ones(N,1);
I=eye(N);
Beta=N*I;
C1=(((Beta-G.*(Ss))^(-1))*Alpha)./(((Beta-G.*Ss)^(-1))*one); 
Alphas=Alpha;
Betas=Beta;
Gs=G;
Reslut=cell({});

simulate=cell({});PAll=zeros();
for q=1:N-1
    if q==1
    PAll(q,1)=0;PAll(q,2)=min(C1);
    simulate(q,1)={Betas};
    simulate(q,2)={Alphas};
    simulate(q,3)={one};
    simulate(q,4)={Gs};
    simulate(q,5)={Ss};
    simulate(q,6)={rs};
    else
    a=find(min(C1)==C1);
    C1(a)=[];
    Betas(a,:)=[];Betas(:,a)=[];
    Alphas(a)=[];
    one(a)=[];
    Gs(a,:)=[]; Gs(:,a)=[];
    for i=1:length(seed)
        if seed(i)>a
            seed(i)=seed(i)-1;
        end
    end
[Ss,Sstep,Ssr]=GiveSs(Gs,seed);
           if length(rs)==3
               rs=zeros(2);
               rs(3-Sstep(1,1),Sstep(1,1))=1;
           else
               rs=Givers(Alphas,Gs,Sstep,Ss,Ssr,casers);
           end
    PAll(q,1)=PAll(q-1,2);PAll(q,2)=min(C1);
    simulate(q,1)={Betas};
    simulate(q,2)={Alphas};
    simulate(q,3)={one};
    simulate(q,4)={Gs};
    simulate(q,5)={Ss};
    simulate(q,6)={rs};
    end
end


for q=1:N-1
%-----最佳推荐网络的生成----------------%
%---------------------------------------
p1=PAll(q,1);p2=PAll(q,2);
Betas=simulate{q,1};
Alphas=simulate{q,2};
one=simulate{q,3};
Gs=simulate{q,4};
Ss=simulate{q,5};
rs=simulate{q,6};

%-----------计算Yita范围----------------------------
Yita=sym('Yita');
y1=(one'*((Betas-Gs.*Ss)^(-1))*Alphas+one'*(Yita*rs+(Yita^2)*(rs^2))'*((Betas-Gs.*Ss)^-1)*one)/(2*one'*((Betas-Gs.*Ss)^-1)*one)-p1;
y2=(one'*((Betas-Gs.*Ss)^(-1))*Alphas+one'*(Yita*rs+(Yita^2)*(rs^2))'*((Betas-Gs.*Ss)^-1)*one)/(2*one'*((Betas-Gs.*Ss)^-1)*one)-p2;
Yita1=vpa(solve(y1));
Yita2=vpa(solve(y2));
[Yita1,Yita2]=isrealer(Yita1,Yita2);
Yita1=sort([Yita1,Yita2]);
% AllYita(q)={Yita1};
% [Yita1,~]=sort([Yita1,Yita2]);        % Yita1就是下限；Yita2就为上限
% Yita2=Yita1(2);Yita1=Yita1(1);
if  sum((Yita1)>0)
    if length(Yita1)>=3
        if sum(Yita1>0)==1  
        Yita2=Yita1(end)+0.5*Yita1(end);Yita1=Yita1(end);   
        elseif sum(Yita1>0)>=3
            Yita1=Yita1(Yita1>0);
            Yita2=Yita1(2);Yita1=Yita1(1); 
        else
        Yita2=Yita1(end);Yita1=Yita1(end-1);
        end
    else
     Yita2=Yita1(2);Yita1=Yita1(1); 
    end
else
    Yita1=-0.8;
    Yita2=-0.5;
end
%----------收益，最佳Yita，价格的计算----------------
if Yita2>=0             %当 Yita范围与 大于零 有交集时
     if Yita1<0
         Yita1=0;
     end
    %--------------------
    %MATLAB的运算
    Yita=sym('Yita');
    Pr1_Yita=(one'*((Betas-Gs.*Ss)^(-1))*Alphas+one'*(Yita*rs+(Yita^2)*(rs^2))'*((Betas-Gs.*Ss)^-1)*one)/(2*one'*((Betas-Gs.*Ss)^-1)*one);
    pr=(Pr1_Yita*one'-one'*(Yita*rs+(Yita^2)*(rs^2))')*((Betas-Gs.*Ss)^-1)*(Alphas-Pr1_Yita*one);
    dy=diff(pr);
    rz=solve(dy==0,Yita);
    rz=double(vpa(rz));                        %% 对于结果进行化简
    
    if length(rz)>1
        for i=1:length(rz)
            if Yita1<=rz(i) && rz(i)<=Yita2
                rz=rz(i);
                break;
            end
        end
%     rz=max(rz);
    if sum(rz>0)
      rz=min(rz(rz>0));
    else
      rz=max(rz);  
    end
    end
    
    if Yita1<=rz && rz<=Yita2
    
    prq=subs(pr,Yita,rz);               %求最优收益
    prq=double(vpa(prq));                        %% 对于结果进行化简
    
    else
        temp=findmax(pr,Yita,Yita1,Yita2);
            prq=double(temp(2));
            rz=double(temp(1));
    %结果保存
    end
    
    Yita1=rz;
    pr1=(one'*((Betas-Gs.*Ss)^(-1))*Alphas+one'*(Yita1*rs+(Yita1^2)*(rs^2))'*((Betas-Gs.*Ss)^-1)*one)/(2*one'*((Betas-Gs.*Ss)^-1)*one);

else   %当 Yita范围与 大于零 无交集时
    pr1=p2;
    Yita1=0;
    prq=p2*one'*((Betas-Gs*rs)^(-1))*(Alphas-p2*one);    
end

    Reslut{q}={q,prq,Yita1,pr1};   %储存结果： 阶段，收益，返现，价格；   
end
    temp=zeros();
    for q=1:N-1
    temp(q,1:4)=[real(Reslut{q}{1,1}),real(Reslut{q}{1,2}),real(Reslut{q}{1,3}),real(Reslut{q}{1,4})];
    end
    Reslut=temp;
     P0=Reslut((max(Reslut(:,2))==Reslut(:,2)),:);
     Yita=P0(3);
     P0=P0(4);
     if Yita==0
%     P0=P0(4);
      Reslut=Reslut(Reslut(:,3)~=0,:);
      Yita=Reslut(1,3);P0=Reslut(1,4);
%       disp('使用非最大收益,调整Yita');
     end
          
     if P0>0.6
         Reslut=Reslut(min(Reslut(:,3))==Reslut(:,3),:);
         Yita=Reslut(1,3);P0=Reslut(1,4);
%          disp('使用非最大收益，调整P0');
     end
     
end