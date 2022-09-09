%------------抽取结果
%===时间对比=========
Gen=zeros(1,3);
Sim=zeros(1,3);
Our=zeros(1,3);
for i=1:size(Ttime,1)
    Gen=Gen+Ttime{1, 1}{1, 1};
    Sim=Sim+Ttime{1, 1}{1, 2};
    Our=Our+Ttime{1, 1}{1, 3};
end
OurGen=(Gen-Our)./Gen;  
OurSim=(Sim-Our)./Sim;  


%===profit对比=========
Genp=zeros(3,3);
Simp=zeros(3,3);
Ourp=zeros(3,3);
for i=1:size(Ttime,1)
    Genp=Genp+ZrobustOut{i, 1}{1, 1}  ;
    Simp=Simp+ZrobustOut{i, 1}{1, 2}  ;
    Ourp=Ourp+[ZResultOut{1, i}{1, 1}{1, 1}{1, 6},ZResultOut{1, i}{1, 1}{1, 2}{1, 6}  ,ZResultOut{1, i}{1, 1}{1, 3}{1, 6}  ;...
               ZResultOut{1, i}{1, 2}{1, 1}{1, 6},ZResultOut{1, i}{1, 2}{1, 2}{1, 6}  ,ZResultOut{1, i}{1, 2}{1, 3}{1, 6}  ;...
               ZResultOut{1, i}{1, 3}{1, 1}{1, 6},ZResultOut{1, i}{1, 3}{1, 2}{1, 6}  ,ZResultOut{1, i}{1, 3}{1, 3}{1, 6}];
end
OurGenp=(Ourp-Genp)./Genp;  
OurSimp=(Ourp-Simp)./Simp;  
