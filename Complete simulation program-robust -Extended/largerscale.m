%%
%---Amozon
Amozon=importdata("E:\data\amazon\train.txt");
temp=Amozon(:,1:2);
Amozon_id=unique(temp);
Amozon_link=Amozon(:,1:2)+1;  %下标从0 开始，因此要进行转换

%%
Gm=sparse(length(Amozon_id), length(Amozon_id));
L=Amozon_link(:,1);
R=Amozon_link(:,2);


for i=1:length(Amozon_link)
    Gm(L(i,1),R(i,1))=1;
    Gm(R(i,1),L(i,1))=1;
    disp(i)
end
%%
community=randperm(length(Gm),length(Gm));
Fix=[1,9879;9880,17560;17561,26105;26106,36483;36484,47001;47002,57433;47002,57433;66852,75705;76705,85008;85009,91599];
Gcell={};
Gcell(1)={Gm};
for i=1:size(Fix,1)
    key=community(Fix(i,1):Fix(i,2));
    temp=Gm(key,:);
    temp=temp(:,key);
    Gcell(i+1)={full(temp)};
end

g=graph(Gcell{10});
bins = conncomp(g);
A=tabulate(bins);
A=sortrows(A,2,'descend');
%%
%---YouTube
YouTube=importdata("E:\data\YouTube\com-youtube.ungraph.txt");
YouTube=YouTube.data;
YouTube_id=unique(YouTube(:));
for i=1:length(YouTube_id)
    if i~=YouTube_id(i)
        break
    end
end
key=i;
disp(i);

YouTube_link=YouTube(:,1:2);  %替换正确的标序，去除无用的节点

for i=key:length(YouTube_id)
    L=YouTube_id(i)==YouTube_link(:,1);
    R=YouTube_id(i)==YouTube_link(:,2);

    YouTube_link(L,1)=i;
    YouTube_link(R,2)=i;
    disp(i)
end

max(max(YouTube_link))==length(YouTube_id)

%---------------
GYoutube=sparse([YouTube_link(:,1);YouTube_link(:,2)],[YouTube_link(:,2),YouTube_link(:,1)],ones(1,2*length(YouTube_link)),length(YouTube_id), length(YouTube_id));


key=floor(linspace(1,length(YouTube_id),101));
Fix=zeros();
for i=1:length(key)-1
    Fix(i,1:2)=[key(i),key(i+1)];
end
Fix(2:end,1)=Fix(2:end,1);

community=randperm(length(YouTube_id),length(YouTube_id));
Gcell={};
Gcell(1)={GYoutube};
for i=1:10%size(Fix,1)
    key=community(Fix(i,1):Fix(i,2));
    temp=GYoutube(key,:);
    temp=temp(:,key);
    Gcell(i+1)={full(temp)};
end

g=graph(Gcell{1});
bins = conncomp(g);
A=tabulate(bins);
A=sortrows(A,2,'descend');

bins=centrality(g,'degree');
[~,A]=sort(bins,'descend');
A=A(randperm(1000,10));
for i=1:10
v = bfsearch(g,A(i));
temp1=v(1:1000);
G=GYoutube(temp1,:);
G=G(:,temp1);
Gcell{i+1}=full(G);
end
% v = bfsearch(g,A(2));
% temp2=v(1:5000);
% length(intersect(temp1,temp2))

% G=GYoutube(temp1,:);
% G=G(:,temp1);
% g=graph(G);
% bins = conncomp(g);
% A=tabulate(bins);
% A=sortrows(A,2,'descend');
%%
%---Douban
Douban=importdata("F:\竞赛与项目\项目2022\论文old-1\Referral-strategy-based-on-social-networks-main\Complete simulation program-robust -heuristic\douban\edges.csv");
Douban_id=unique(Douban(:));
max(max(Douban))==length(Douban_id)


GDouban=sparse(length(Douban_id), length(Douban_id));
for i=1:length(GDouban)
    key=Douban(:,1)==Douban_id(i);
    key=Douban(key,2);
    GDouban(Douban_id(i),key)=1;
    GDouban(key,Douban_id(i))=1;
    disp(i);
end
key=floor(linspace(1,154908,11));
Fix=zeros();
for i=1:10
    Fix(i,1:2)=[key(i),key(i+1)];
end
Fix(2:end,1)=Fix(2:end,1);

community=randperm(length(GDouban),length(GDouban));
Gcell={};
Gcell(1)={GDouban};
for i=1:size(Fix,1)
    key=community(Fix(i,1):Fix(i,2));
    temp=GDouban(key,:);
    temp=temp(:,key);
    Gcell(i+1)={full(temp)};
end


g=graph(Gcell{1});
bins = conncomp(g);
A=tabulate(bins);
A=sortrows(A,2,'descend');

bins=centrality(g,'degree');
[~,A]=sort(bins,'descend');
A=A(randperm(1000,10));
for i=1:10
v = bfsearch(g,A(i));
temp1=v(1:1000);
G=GDouban(temp1,:);
G=G(:,temp1);
Gcell{i+1}=full(G);
end
