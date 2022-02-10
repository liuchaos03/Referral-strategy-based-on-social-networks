
function [Yita,P0]=TheStepOners1(Alpha,G,Ss,~,rs,seed,casers)
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
for q=1:N*0.6-1
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


for q=1:N*0.6-1
%---------------------------------------
p1=PAll(q,1);p2=PAll(q,2);
Betas=simulate{q,1};
Alphas=simulate{q,2};
one=simulate{q,3};
Gs=simulate{q,4};
Ss=simulate{q,5};
rs=simulate{q,6};

%-----------Calculating Yita Range----------------------------
Yita1=(p1*2*one'*((Betas-Gs.*Ss)^(-1))*one-one'*((Betas-Gs.*Ss)^(-1))*Alphas)/( one'*rs'*((Betas-Gs.*Ss)^(-1))*one);
Yita2=(p2*2*one'*((Betas-Gs.*Ss)^(-1))*one-one'*((Betas-Gs.*Ss)^(-1))*Alphas)/( one'*rs'*((Betas-Gs.*Ss)^(-1))*one);
[Yita1,~]=sort([Yita1,Yita2]);        %Yita1 is the lower limit; Yita2 is the upper limit.
Yita2=Yita1(2);Yita1=Yita1(1);


%----------Revenue, Best Yita, Price Calculations----------------
if Yita2>=0           
     if Yita1<0
         Yita1=0;
     end
    %--------------------
    %MATLAB
    Yita=sym('Yita');
    Pr1_Yita=(one'*((Betas-Gs.*Ss)^(-1))*Alphas+Yita*one'*rs'*((Betas-Gs.*Ss)^(-1))*one)/(2*one'*((Betas-Gs.*Ss)^-1)*one);
    pr=(Pr1_Yita*one'-Yita*one'*rs')*((Betas-Gs.*Ss)^-1)*(Alphas-Pr1_Yita*one);
    dy=diff(pr);
    rz=solve(dy==0,Yita);
    rz=double(vpa(rz));
    
    if length(rz)>1
        for i=1:length(rz)
            if Yita1<=rz(i) && rz(i)<=Yita2
                rz=rz(i);
                break;
            end
        end

    if sum(rz>0)
      rz=min(rz(rz>0));
    else
      rz=max(rz);  
    end
    end
    
    if Yita1<=rz && rz<=Yita2
    
    prq=subs(pr,Yita,rz);               % Seeking the Optimal profit
    prq=double(vpa(prq));               
    
    else
        temp=findmax(pr,Yita,Yita1,Yita2);
            prq=double(temp(2));
            rz=double(temp(1));
    %save
    end
    
    Yita1=rz;
   pr1=(one'*((Betas-Gs.*Ss)^-1)*Alphas+Yita1*one'*rs'*((Betas-Gs.*Ss)^-1)*one)/(2*one'*((Betas-Gs.*Ss)^-1)*one);

else  
    pr1=p2;
    Yita1=0;
    prq=p2*one'*((Betas-Gs*rs)^(-1))*(Alphas-p2*one);    
end

    Reslut{q}={q,prq,Yita1,pr1};   % Stage, profit, award, Price;  
end
    temp=zeros();
    for q=1:N*0.6-1
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
      disp('Adjust Yita,Non-maximum');
     end
          
     if P0>0.6
         Reslut=Reslut(min(Reslut(:,3))==Reslut(:,3),:);
         Yita=Reslut(1,3);P0=Reslut(1,4);
         disp('Adjust P0,Non-maximum');
     end
     
end