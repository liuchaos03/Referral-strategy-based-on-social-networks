function NC=linkNC2(Alpha,Beta,G,ID)
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

%---NC-------
Pt=(1/4)*(Alpha-c*one)'*( ( A'*one*one'*A )/(one'*A*one) )*(Alpha-c*one);
Pt_1=(1/4)*(Alpha-c*one)'*( ( A_1'*one*one'*A_1 )/(one'*A_1*one) )*(Alpha-c*one);
NC=Pt_1-Pt;
end

