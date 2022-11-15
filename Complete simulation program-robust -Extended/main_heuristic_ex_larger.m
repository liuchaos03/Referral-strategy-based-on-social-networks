%profile on;
%-------All--simulate-----------
ZResultOut=cell({});
ZrobustOut=cell({});

Ttime=cell({});
global Keylen
Keylen=6;  % 必须是偶数
tic;
%network size
t=datestr(now);
for i=1:length(20)         %Simulation times
    c=0.00001;
    
    G=Gcell{1+i};
    [Alpha,seed,G]=setup_netwrok_larger(G);
    Alpha=Alpha';
    N=length(G);
    
    [outputG,Ttime{i}{1,1}]=get_genetic(c,Alpha,G,seed);
    
    [outputS,Ttime{i}{1,2}]=get_simulated_annealing(c,Alpha,G,seed); % [R1{A1,A2,A3};R2{A1,A2,A3};R3{A1,A2,A3}]
    
    ZrobustOut{i}={outputG,outputS};
    
    functionrs1_fix(N,c,Alpha,G,seed);
    
    Time=zeros();
    tic;
    ZCoutput12=functionrs12(N,c,Alpha,G,seed); % R1{A1,A2,A3}
    Time(1)=toc;
    tic;
    ZCoutput2=functionrs2(N,c,Alpha,G,seed);   % R2{A1,A2,A3}
    Time(2)=toc;
    tic;
    ZCoutput3=functionrs3(N,c,Alpha,G,seed);   % R3{A1,A2,A3}
    Time(3)=toc;
    tic;
    ZResultOut{i}={ZCoutput12,ZCoutput2,ZCoutput3};
    Ttime{i}{1,3}=Time;
    
    %     disp(datestr(now))
    disp(['done--[ ',num2str(i),' ]---********************************************']);
    disp(['开始时间',t,'| 结束时间', datestr(now)]);
end
toc;
%profile viewer;
%profile off;