%-------All--simulate-----------
ZResultSet=cell({});
ZResultOut=cell({});
ZResultOuterr=cell({});
global fid
global Keylen error
Keylen=10;
fid=fopen('edgesC4.txt','wt');
tic;
 N=50; 
for i=1:200
[Alpha,~,~,~,GF,GS,GG]=SetupNet3(N);   
Alpha=Alpha';
 G=GS;
 seed=find(max(Alpha)==Alpha);     
  c=0.00001;

for ti =1:2
if ti==1
    error=0;
elseif ti==2
    error=0.05;    %the probabilities of the customers making wrong decisions
end
ZResultSet{i}={N,c,Alpha,G,seed};
ZCoutput1=functionrs1(N,c,Alpha,G,seed);
toc;
ZCoutput12=functionrs12(N,c,Alpha,G,seed);
toc;
ZCoutput2=functionrs2(N,c,Alpha,G,seed);
toc;
ZCoutput3=functionrs3(N,c,Alpha,G,seed);
toc;

if ti==1
ZResultOut{i}={ZCoutput1,ZCoutput12,ZCoutput2,ZCoutput3};
elseif ti==2   
ZResultOuterr{i}={ZCoutput1,ZCoutput12,ZCoutput2,ZCoutput3};   
end

end

disp(['Íê³É--[ ',num2str(i),' ]---********************************************']);
end
fclose(fid);
