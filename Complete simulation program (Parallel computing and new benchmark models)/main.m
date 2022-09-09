%-------All--simulate-----------
ZResultSet=cell({});
ZResultOut=cell({});
ZrobustOut=cell({});
Ttime=cell({});
global Keylen
Keylen=10;
tic;
N=100;             %network size
for i=1:100          %Simulation times
    [Alpha,~,~,~,GF,GS,GG]=SetupNet3(N);   %Establishing Initial Network
    Alpha=Alpha';
    G=GS;
    seed=find(max(Alpha)==Alpha);  %Leading customers
    % c=0.0000000001;
    c=0.00001;        %Recommended cost
    
    ZResultSet{i}={N,c,Alpha,G,seed};
    disp(datestr(now))
    [outputG,Ttime{i}{1,1}]=get_genetic(c,Alpha,G,seed);
    
    [outputS,Ttime{i}{1,2}]=get_simulated_annealing(c,Alpha,G,seed); % [R1{A1,A2,A3};R2{A1,A2,A3};R3{A1,A2,A3}]
    
    ZrobustOut{i}={outputG,outputS};
    
    ZCoutput1=functionrs1(N,c,Alpha,G,seed);
    
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
    
    disp(datestr(now))
    disp(['done--[ ',num2str(i),' ]---********************************************']);
end
toc;