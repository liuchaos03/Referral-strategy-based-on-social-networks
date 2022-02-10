
function NN=linkNN2(Alpha,Beta,G,ID)
c=0;
I=eye(length(G));
one=ones(length(G),1);
G_1=G;
G_1(ID)=1;

% A=(Beta*I-G)^(-1);
% A_1=(Beta*I-G_1)^(-1);
A=(I/(Beta*I-G));
A_1=(I/(Beta*I-G_1));
%T=((one'*((Beta*I)^(-1))*one)^(-1))*((Beta*I)^(-1));
T=(I/(one'*(I/(Beta*I))*one))*(I/(Beta*I));
%----------------NC-------------
Pt=(1/4)*(one'*T*Alpha-c)*one'*A*(2*(Alpha-c*one)-(one'*T*Alpha-c)*one);
Pt_1=(1/4)*(one'*T*Alpha-c)*one'*A_1*(2*(Alpha-c*one)-(one'*T*Alpha-c)*one);
NN=Pt_1-Pt;
end