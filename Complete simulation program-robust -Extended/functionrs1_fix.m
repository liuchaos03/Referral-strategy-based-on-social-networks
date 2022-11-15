function functionrs1_fix(N,c,Alpha,G,seed)

for casers=1:1
disp(['run into functionrs1，accepting--[ ',num2str(casers),' ]---++++++']);

[Ss,Sstep,Ssr]=GiveSs(G,seed);
[rs]=Givers(Alpha,G,Sstep,Ss,Ssr,casers);

[Yita,P0]=TheStepOners1(Alpha,G,Ss,Ssr,rs,seed,casers);
[Ss,Sstep,Ssr]=TheStepTwors1(Alpha,G,Ssr,Ss,Sstep,rs,P0,Yita,seed,c);

[rs]=Givers(Alpha,G,Sstep,Ss,Ssr,casers);
[Yita,P0]=TheStepOners1(Alpha,G,Ss,Ssr,rs,seed,casers);
end

global Yitars1 P0rs1;
Yitars1=Yita;
P0rs1=P0;

end