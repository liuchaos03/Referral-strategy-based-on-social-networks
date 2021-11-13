%-------All--simulate-----------
ZResultSet=cell({});
ZResultOut=cell({});
global Keylen
Keylen=10;
tic;
for i=1:100          %Simulation times
 N=100;             %network size
 [Alpha,~,~,~,GF,GS,GG]=SetupNet3(N);   %Establishing Initial Network
Alpha=Alpha';                
 G=GS;
 seed=find(max(Alpha)==Alpha);  %Leading customers
% c=0.0000000001;
  c=0.00001;        %Recommended cost

ZResultSet{i}={N,c,Alpha,G,seed};

ZCoutput1=functionrs1(N,c,Alpha,G,seed);
toc;
ZCoutput12=functionrs12(N,c,Alpha,G,seed); % R1{A1,A2,A3} 
toc;
ZCoutput2=functionrs2(N,c,Alpha,G,seed);   % R2{A1,A2,A3} 
toc;
ZCoutput3=functionrs3(N,c,Alpha,G,seed);   % R3{A1,A2,A3}  
toc;
ZResultOut{i}={ZCoutput12,ZCoutput2,ZCoutput3};

disp(['done--[ ',num2str(i),' ]---********************************************']);
end
toc;