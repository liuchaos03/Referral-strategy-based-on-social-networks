function output=genetic(~,Alpha,G,seed,cases,Rca)
%------遗传算法------
%-----初始化
population=cell({});
Profits=zeros();
for area=1:10
    Ss0=tempGiveSs(G,seed,length(G)/2);
    Rs0=tempGiveRs(Alpha,G,Ss0,cases);
    Profits(area)=maxprofit123(Alpha,G,Ss0,Rs0,Rca);
    population{area}={{Ss0},{Rs0}};
end
Best_Fitness=max(Profits);
key=0;t=1;
while key<=5 && t <=25   %当种群的适应度连续超过5代没有明显提升，或者，迭代时间过长，超过100代，则停止
    [~,series]=sort(Profits,'descend');
    population=population(series);
    Profits=Profits(series);
    
    Ss1=population{1,randperm(10,1)}{1,1}{1,1};
    for area=1:10
        Ss0=population{1,area}{1,1}{1,1};
        run=rand(1);
        if run<0.4/area
            continue;                   %直接放入下一代
        elseif run<0.8/area             %交叉
            Ss0=FixGiveSs(G,Ss0,Ss1,seed);
        else
            Ss0=AddGiveSs(G,Ss0,seed);  %变异
        end
        
        Rs0=tempGiveRs(Alpha,G,Ss0,cases);
        Profits(area)=maxprofit123(Alpha,G,Ss0,Rs0,Rca);
        population{1,area}={{Ss0},{Rs0}};
    end
    if Best_Fitness>max(Profits)
        key=key+1;
    else
        if ((max(Profits)-Best_Fitness))<(0.0005*Best_Fitness)
            key=key+1;
        else
            key=0;
        end
        Best_Fitness=max(Profits);
        Best_Fitness=Best_Fitness(1);
    end
    fprintf('G:R%d-A%d=%d ||%s\n', [Rca,cases,t,datestr(now)])
%     if rem(t,5)==0
%         fprintf('G:R%d-A%d=%d ||%s\n', [Rca,cases,t,datestr(now)])
%     end
    t=t+1;  %模拟时间变化
end
%id=find(max(Profits)==Profits);
%Ss=population{1,id}{1,1}{1,1};
%Rs=population{1,id}{1,2}{1,1};
%output=maxprofit123(Alpha,G,Ss,Rs,Rca);
output=max(Profits);
fprintf('G:R%d-A%d=%d ||%s\n', [Rca,cases,t,datestr(now)])
end

function output=maxprofit123(Alpha,G,Ss,rs,Rca)
switch Rca
    case 1
        output=maxprofitR1(Alpha,G,Ss,rs);
    case 2
        output=maxprofitR2b(Alpha,G,Ss,rs);
    case 3
        output=maxprofitR3b(Alpha,G,Ss,rs);
%     case 4
%         output=maxprofitR3a(Alpha,G,Ss,rs);
end
end


function Ss=tempGiveSs(G,Seed,N)
hadnode=Seed;
Ss=zeros(length(G));
while length(hadnode)<=N
    key=randperm(length(hadnode),1);
    temp=find(G(:,hadnode(key))~=0);
    
    t=randperm(length(temp),1);
    if Ss(hadnode(key),temp(t))==1
        continue
    end
    Ss(temp(t),hadnode(key))=1;
    hadnode=unique([hadnode,temp(t)]);
end

end



function Rs=tempGiveRs(Alpha,G,Ss,cases)
Rs=zeros(length(Ss));

switch cases
    case 1
        for i=1:length(Ss)
            if sum(Ss(i,:))==0
                continue
            end
            key=find(Ss(i,:)==1);
            temp=Alpha(key);
            [~,id]=sort(temp,'descend');
            key=key(id(1));
            Rs(i,key)=1;
        end
    case 2
        for i=1:length(Ss)
            if sum(Ss(i,:))==0
                continue
            end
            key=find(Ss(i,:)==1);
            temp=G(i,key);
            [~,id]=sort(temp,'descend');
            key=key(id(1));
            Rs(i,key)=1;
        end
    case 3
        for i=1:length(Ss)
            if sum(Ss(i,:))==0
                continue
            end
            key=find(Ss(i,:)==1);
            id=randperm(length(key),1);
            key=key(id);
            Rs(i,key)=1;
        end
end
end


function  Ss0=FixGiveSs(G,Ss0,Ss1,Seed)

hadnode=zeros(length(G));
for i=1:length(G)
    if sum(Ss0(i,:))>1
        hadnode(i)=1;
    end
    if sum(Ss1(i,:))>1
        hadnode(i)=1;
    end
end

temp_hadnode=find(hadnode==1);
hadnode=Seed;
Ss=zeros(length(G));
t=1;
while length(hadnode)< length(temp_hadnode)  && t< 3*length(temp_hadnode)
    
    t=t+1;
    key=randperm(length(hadnode),1);
    temp=find(G(:,hadnode(key))~=0);
    
    if length(intersect(temp_hadnode,hadnode))/length(temp_hadnode)<0.8
        temp=intersect(temp,temp_hadnode);
        if isempty(temp)
            continue;
        end
    end
    
    k=randperm(length(temp),1);
    if Ss(hadnode(key),temp(k))==1
        continue
    end
    Ss(temp(k),hadnode(key))=1;
    hadnode=unique([hadnode,temp(k)]);
end
Ss0=Ss;
end



function  Ss0=AddGiveSs(G,Ss,Seed)
for i=1:length(Ss)
    if rand(1)>0.75    %大于一定概率，开始变化
        
        if rand(1)>0.45                     %  一半的概率，不推荐；一半的概率产生新推荐
            key=find(Ss(:,i)~=0);
            if isempty(key)
                continue
            end
            
            key=key(randperm(length(key),1));
            Ss(key,i)=0;
        else
            key=find(G(:,i)~=0);
            key=setdiff(key,Seed);
            if length(key)>1
                key=key(randperm(length(key),1));
                Ss(key,i)=1;
            end
        end
    end
end
Ss0=Ss;
end



function  pro=maxprofitR1(Alpha,G,Ss,rs)
[Alpha_sort,id]=sort(Alpha);
key=zeros(length(id),1);
for i=1:length(id)
    if sum(Ss(id(i),:))==0        %没有被推荐
        key(i)=1;
    end
end
Alpha_sort(key==1)=[];
%MATLAB
Betas=eye(length(G))*length(G);
one=ones(length(G),1);
Gs=G;

Alpha_sort=Alpha_sort(floor(length(Alpha_sort)*0.375):floor(length(Alpha_sort)*0.625));
Alpha_sort=Alpha_sort(randperm(length(Alpha_sort),5));
N=length(Alpha_sort);

%Yitas=zeros(N,1);
Profits=zeros(N,1);
PrYita=sym('PrYita');
%Pr1_Yita=(one'*((Betas-Gs.*Ss)^(-1))*Alpha+PrYita*one'*rs'*((Betas-Gs.*Ss)^(-1))*one)/(2*one'*((Betas-Gs.*Ss)^-1)*one);
Gss=Gs.*(Ss);
Gss=((Betas^-1)+(Betas^-1)*Gss*(Betas^-1));

p1=one'*(Gss)*Alpha;
p2=one'*rs'*(Gss)*one;
p3=(2*one'*(Gss)*one);
Pr1_Yita=(p1+PrYita*p2)/p3;
for i=1:N
    key=0;
    Pr=Alpha_sort(i);
    rz=solve(Pr1_Yita==Pr,PrYita);
    temp=double(vpa(rz));
    if length(temp)>1
        if min(temp)>0
            key=min(temp);
        else
            if max(temp)<0
                key=0;
            end
        end
    else
        if temp<0
            key=0;
        else
            key=temp;
        end
    end
    [Profits(i),~]=maxprofit1(Alpha,Pr,real(key),G,rs,Ss);
    %    Yitas(i)=real(key)
end
try
    key=find(max(Profits)==Profits);
    pro=Profits(key(1));
catch
    disp("pro==0")
    pro=0;
end
end


%%
%----------



function  pro=maxprofitR2b(Alpha,G,Ss,rs)
[Alpha_sort,id]=sort(Alpha);
key=zeros(length(id),1);
for i=1:length(id)
    if sum(Ss(id(i),:))==0        %没有被推荐
        key(i)=1;
    end
end
Alpha_sort(key==1)=[];
%MATLAB

Alpha_sort=Alpha_sort(floor(length(Alpha_sort)*0.375):floor(length(Alpha_sort)*0.625));
Alpha_sort=Alpha_sort(randperm(length(Alpha_sort),10));
N=length(Alpha_sort);

temp=zeros();
k=1;
for i=1:N
    Yitarank=linspace(0,Alpha_sort(i),N);
    Yitarank(1)=[];
    for j=1:length(Yitarank)
        temp(k,[1,2])=[Alpha_sort(i),Yitarank(j)];
        k=k+1;
    end
end
Profits=zeros(length(temp),1);
try
    parfor i=1:length(temp)
        [Profits(i),~]=maxprofit2(Alpha,temp(i,1),temp(i,2),G,rs,Ss);
        %    Yitas(i)=real(key)
    end
    key=find(max(Profits)==Profits);
    pro=Profits(key(1));
catch
    disp("temp==0")
    pro=0;
end
end


function  pro=maxprofitR3b(Alpha,G,Ss,rs)
[Alpha_sort,id]=sort(Alpha);
key=zeros(length(id),1);
for i=1:length(id)
    if sum(Ss(id(i),:))==0        %没有被推荐
        key(i)=1;
    end
end
Alpha_sort(key==1)=[];
%MATLAB
% key=randperm(length(Alpha_sort),length(Alpha_sort));
% Alpha_sort=Alpha_sort(key);
% N=floor(length(Alpha_sort)/3);
Alpha_sort=Alpha_sort(floor(length(Alpha_sort)*0.375):floor(length(Alpha_sort)*0.625));
Alpha_sort=Alpha_sort(randperm(length(Alpha_sort),10));
N=length(Alpha_sort);


temp=zeros();
k=1;
for i=1:N
    Yitarank=linspace(0,Alpha_sort(i),10);
    Yitarank(1)=[];
    for j=1:length(Yitarank)
        temp(k,[1,2])=[Alpha_sort(i),Yitarank(j)];
        k=k+1;
    end
end
if length(temp)>250
    temp=temp(randperm(length(temp),250),:);
end
Profits=zeros(length(temp),1);
try
    parfor i=1:length(temp)
        [Profits(i),~]=maxprofit3(Alpha,temp(i,1),temp(i,2),G,rs,Ss);
        %    Yitas(i)=real(key)
    end
    key=find(max(Profits)==Profits);
    pro=Profits(key(1));
catch
    disp("temp==0")
    pro=0;
end
end