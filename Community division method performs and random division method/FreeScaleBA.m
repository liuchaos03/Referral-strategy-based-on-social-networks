function [sc A]=BA1(N)
%function [sc A]=BA1(m0,m,N)
% 生成标准BA网络(m0>=m,m0不能等于1), A为邻接矩阵sparse matrix，并输出到文件中(mat或者txt)
% mat存放稀疏矩阵sf,
% txt存放BA网络每条边的节点号
 m0 = 7;% m0 初始节点，全连接
 m = 4;% m 加一个点的同时加的边数
% N 总的节点数
% list----生成的一个辅助向量，该向量中的元素为每条边端点的节点。for example, 假设网络中节点4的度为7，则在list向量中会存在7个4，而这7个4的位置不一定是连续在一起的。
% preferential attachment体现在随机的从list向量中选取元素，选中哪个元素，该元素表示的节点即被选中。由于list向量中每个节点的个数与它的度有关，因此，度越大的点被选中的概率越大。

sf=zeros(N);
sf(1:m0,1:m0)=1;
sf(1:m0,1:m0)=sf(1:m0,1:m0)-eye(m0);

% hand=waitbar(m0/N,'BA model building');

for i=1:m0-1
for j=1:m0
list((i-1)*m0+j)=j; %初始m0个节点全连接，每个节点在list中出现 m0-1次
end
end
d=(m0-1)*m0;

for n=m0+1:N
t=d+2*m*(n-m0-1);
for i=1:m
list(t+i)=n; % in the list, every time the above m is n, it represents that the nth nodes is connected to other m nodes
end
k=1;
while k<m+1 % grow other m nodes
p(k)=round((t+1)*rand(1)); % random choose an integer from 1~N
if p(k)>0&p(k)<(t+1)
if sf(n,list(p(k)))==0
list(t+m+k)=list(p(k));
sf(n,list(p(k)))=1;
sf(list(p(k)),n)=1;
k=k+1;
end 
end 
end %end for k
% waitbar(n/N,hand);
end %end for n
% close(hand);

%将生成的BA网络（稀疏矩阵A）存入文件BA.mat,文件中的内容为矩阵变量A，读取（load）后，在命令窗口访问A就可得到BA网络
A=sf;
% save BA1000 A

%degree distribution 
% df=sum(A>0);                                   % 计算 度
% pp2=tabulate(df);                              % 统计个数
% sw=find(pp2(:,3)>0);
% loglog(pp2(sw,1),pp2(sw,3)/100,'b*');
% lsline %最小二乘拟合直线
% title('BA无标度网络度分布图')
% xlabel('k');
% ylabel('P(k)');

%将BA网络每条边的节点号存放在矩阵sc中，并将其输出到文本BA.txt
% [R,L]=int16(find(A==1));
% sc=[L,R];

 h=1;
 for i=1:N-1
 for j=i+1:N
 if A(i,j)==1 
 sc(h,:)=[i j];
 h=h+1;
 end
 end
 end
%[w,x]=size(sc); 
% fid=fopen('BAn100k101.txt','wt');
% for i=1:w
% for j=1:x
% fprintf(fid,'%d',sc(i,j)); 
% fprintf(fid,'\t'); %对输出进行格式化，否则矩阵中每个元素的值不会空格，也不会换行输出
% end
% fprintf(fid,'\n');
% end
% fclose(fid);