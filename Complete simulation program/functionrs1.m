function ZCoutput=functionrs1(N,c,Alpha,G,seed)

for casers=1:3
disp(['run into functionrs1£¬accepting--[ ',num2str(casers),' ]---++++++']);

[Ss,Sstep,Ssr]=GiveSs(G,seed);
[rs]=Givers(Alpha,G,Sstep,Ss,Ssr,casers);
sim=1;
Output=cell({});
[Yita,P0]=TheStepOners1(Alpha,G,Ss,Ssr,rs,seed,casers);
Output(sim,:)={sim,Yita,P0,Ss,rs,0,0,0,0};
while 1
    sim=sim+1;
    [Ss,Sstep,Ssr]=TheStepTwors1(Alpha,G,Ssr,Ss,Sstep,rs,P0,Yita,seed,c);
    [rs]=Givers(Alpha,G,Sstep,Ss,Ssr,casers);
  
    [pr,po]=maxprofit1(Alpha,P0,Yita,G,rs,Ss);
    Output(sim,:)={sim,Yita,P0,Ss,rs,pr,po,sum(sum(rs))+1,sum(sum(Ss))};
    
    [Yita,P0]=TheStepOners1(Alpha,G,Ss,Ssr,rs,seed,casers);
    if  Output{sim,2}==Yita&&Output{sim,3}==P0
        if sim>=3 && Output{sim,2}==Output{sim-1,2}&&Output{sim,3}==Output{sim-1,3}
            if sum(sum(Output{sim,4}==Output{sim-1,4}))==N*N&&sum(sum(Output{sim,5}==Output{sim-1,5}))==N*N 
            break
            else
                disp('update network');
            end
        end
    else
        disp('update price/reward');
    end
    
    if sim>=8
        break;
    end
    
end
  ZCoutput{1,casers}=Output;  % the result of different accepting strategies
end

global Yitars1 P0rs1;
Yitars1=Yita;
P0rs1=P0;

end