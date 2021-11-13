function [ZCoutput]=functionrs2(N,c,Alpha,G,seed)

global Keylen
global Yitars1 P0rs1;
YitaAll=linspace(0,Yitars1,Keylen+1);
YitaAll(1)=[];
% YitaAll=0.00001:0.00005:0.001;
for i=1:Keylen/2
P0All((Keylen/2)+1-i)=P0rs1-0.005*(i-1);
end
for i=1:Keylen/2
P0All((Keylen/2)+i)=P0rs1+0.005*(i);
end
one=ones(N,1);
Betas=N*eye(N);

for casers=1:3
disp(['进入functionrs2-R2-，方案--[ ',num2str(casers),' ]---++++++']);
% casers=1;
%%%----设定初始变量----------------------end----------%  
[Ss0,Sstep0,Ssr0]=GiveSs(G,seed);
[rs0]=Givers(Alpha,G,Sstep0,Ss0,Ssr0,casers);
sim=1;
Output=cell({});
% [Yita,P0]=TheStepOners2(Alpha,G,Ss,Ssr,rs,seed,casers);

for i=1:Keylen
    P0=P0All(i);
    for j=1:Keylen
    Yita=YitaAll(j);
        
    [Ss,Sstep,Ssr]=TheStepTwors2(Alpha,G,Ssr0,Ss0,Sstep0,rs0,P0,Yita,seed,c);
    [rs]=Givers(Alpha,G,Sstep,Ss,Ssr,casers);
    [Ss,Sstep,Ssr]=TheStepTwors2(Alpha,G,Ssr,Ss,Sstep,rs,P0,Yita,seed,c);
    [rs]=Givers(Alpha,G,Sstep,Ss,Ssr,casers);

%     Pr(i,j)=(P0*one'-one'*(Yita*rs+(Yita^2)*(rs^2))')*((Betas-G.*Ss)^-1)*(Alpha-P0*one);
  [keypr,keypo]= maxprofit2(Alpha,P0,Yita,G,rs,Ss);
  Pr(i,j)=keypr;
  Po(i,j)=keypo;
   GSs(i,j)={Ss};
   Grs(i,j)={rs};
    end
end
N=max(max(Pr));
[i,j]=find(Pr==N);
i=i(1);
j=j(1);
P0=P0All(i(1));
Yita=YitaAll(j(1));
GSsmax=GSs{i,j};
Grsmax=Grs{i,j};
Po=Po(i,j);
if i==Keylen||i==1
    disp(['P0取了边界值',num2str(i)]);
    if i==1
        disp('重新调整');
    [Yita,P0,GSsmax,Grsmax,N,Po]=functionrs2_find(N,c,Alpha,G,seed,casers,P0,Yita,3);    
    end
    if i==Keylen
        disp('重新调整');
    [Yita,P0,GSsmax,Grsmax,N,Po]=functionrs2_find(N,c,Alpha,G,seed,casers,P0,Yita,4);    
    end
end
if j==Keylen||j==1
    disp(['Yita取了边界值',num2str(j)]);
    if j==1
        disp('重新调整');
     [Yita,P0,GSsmax,Grsmax,N,Po]=functionrs2_find(N,c,Alpha,G,seed,casers,P0,Yita,1);
    end
    if j==Keylen
        disp('重新调整');
    [Yita,P0,GSsmax,Grsmax,N,Po]=functionrs2_find(N,c,Alpha,G,seed,casers,P0,Yita,2);
    end
end

   Output(sim,:)={sim,Yita,P0,GSsmax,Grsmax,N,Po,sum(sum(Grsmax))+1,sum(sum(GSsmax))};
   ZCoutput{1,casers}=Output;  
%   disp(['方案：',num2str(casers)]);
Yitars1=Yita; 
P0rs1=P0;

end



end