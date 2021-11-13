%-------All--simulate-----------
ZResultSet=cell({});
ZResultOut=cell({});
global fid
global Keylen
Keylen=10;
fid=fopen('edgesC4.txt','wt');
tic;
for i=1:100
 N=100; 
 [Alpha,~,~,~,GF,GS,GG]=SetupNet3(N);
Alpha=Alpha';
 G=GS;
 seed=find(max(Alpha)==Alpha);    
c=0.00001;
%  c=0.00005;

ZResultSet{i}={N,c,Alpha,G,seed};
ZCoutput1=functionrs1(N,c,Alpha,G,seed);
toc;
ZCoutput12=functionrs12(N,c,Alpha,G,seed);
toc;
ZCoutput2=functionrs2(N,c,Alpha,G,seed);
toc;
ZCoutput3=functionrs3(N,c,Alpha,G,seed);
toc;
ZResultOut{i}={ZCoutput1,ZCoutput12,ZCoutput2,ZCoutput3};

disp(['done--[ ',num2str(i),' ]---********************************************']);
end
fclose(fid);