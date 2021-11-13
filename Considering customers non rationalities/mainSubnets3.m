%-------All--simulate-----------
% ZResultSet=cell({});
% ZResultOut=cell({});

main;

global fid
global Keylen
global  Ss rs Yitars1 P0rs1
Keylen=6;
fid=fopen('edgesC4.txt','wt');
tic;
N=200; 
 
for i=1:100
G0=ZResultSet{1, i}{1, 4};  
Alpha=ZResultSet{1, i}{1, 3};  
for sub=1:1
    if sub==1
        subG=getsubGC(G0,N);
    elseif sub==2
        subG=getsubGR(G0,N);
    end
ZResultOut2=cell({});    
for j=1:length(subG)
% [Alpha,~,~,~,GF,GS,GG]=SetupNet3(N);   %%Establish initial network
% Alpha=Alpha';
temp=subG{1,j};
G=zeros(length(G0));
for jj=1:length(temp)
    for k=1:length(temp)
        G(temp(jj),temp(k))=G0(temp(jj),temp(k));
        G(temp(k),temp(jj))=G0(temp(k),temp(jj));
    end
end
 
%  seed=find(max(Alpha)==Alpha);     
seed=find(max(Alpha(temp))==Alpha);
c=0.00001;
%  c=0.00005;
ZCoutput12{1, 2}{1, 6}=0;
ZCoutput2{1, 2}{1, 6}=0;
ZCoutput3{1, 2}{1, 6}=0;
for ti=1:1


       rs=funrs(G,seed,temp);
       Ss=funss(G,seed,temp);
%        [Yita,P0]=TheStepOners1(Alpha,G,Ss,0,rs,seed,casers);
       Yitars1=ZResultOut{1, i}{1, 2}{1, 1}{1, 2};
       P0rs1=ZResultOut{1, i}{1, 2}{1, 1}{1, 3};
       [U1]=functionrsN7(N,c,Alpha,G,seed);
       [U2]=functionrsN8(N,c,Alpha,G,seed);
       [U3]=functionrsN9(N,c,Alpha,G,seed);
       
end
       ZResultOut2{j}={U1,U2,U3};
disp(['done--[ ',num2str(j+1),' ]---********************************************']);
end
% fclose(fid);

profit=zeros();
for ii=1:length(ZResultOut2)
    for jj=1:3
        for kk=1:3
            profit(ii,jj,kk)=ZResultOut2{1,ii}{1,jj}{1,kk}{1,6};
        end
    end
end

if sub==1
ZRoutC{i,1}=sum(profit(:,:,1));
ZRoutC{i,2}=sum(profit(:,:,2));
ZRoutC{i,3}=sum(profit(:,:,3));
elseif sub==2
ZRoutR{i,1}=sum(profit(:,:,1));
ZRoutR{i,2}=sum(profit(:,:,2));
ZRoutR{i,3}=sum(profit(:,:,3));  
end
    
end
end

 profitA=zeros();
 for ii=1:length(ZResultOut)
     for jj=2:4
         for kk=1:3
             profitA(ii,jj-1,kk)=ZResultOut{1,ii}{1,jj}{1,kk}{1,6};
         end
     end
 end

 Om_Cd=zeros();
 for i=1:100
       for j=1:3 
            for k=1:3
       Om_Cd(i,j,k)=profitA(i,j,k)-ZRoutC{i,k}(j);
            end
      end
 end

 

function rs=funrs(G,seed,temp)
rs=zeros(length(G));
temp2=seed;
temp3=seed;
ti=1;
while length(temp3)~=length(temp)
    temp5=[];
    for i=1:length(temp2)
        temp4=find(G(temp2(i),:)>0);
        temp4=setdiff(temp4,temp3);
        for j=1:length(temp4)
                rs(temp4(j),temp2(i))=1;
        end
        temp5=[temp5,temp4];
        temp3=[temp3,temp4];
    end
    temp2=temp5;
    ti=ti+1;
    if ti>100
        break
    end
end
end


function rs=funss(G,seed,temp)
rs=zeros(length(G));
temp2=seed;
temp3=seed;
ti=1;
while length(temp3)~=length(temp)
    temp5=[];
    for i=1:length(temp2)
        temp4=find(G(temp2(i),:)>0);
        temp4=setdiff(temp4,temp3);
        for j=1:length(temp4)
                rs(temp4(j),temp2(i))=1;
        end
        temp5=[temp5,temp4];
    end
    temp2=temp5;
    temp3=unique([temp3,temp5]);
    ti=ti+1;
    if ti>100
        break
    end
end
end