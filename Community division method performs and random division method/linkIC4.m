function IC=linkIC4(Alpha,Beta,G,ID)
% c=0;
I=eye(length(G));
% one=ones(length(G),1);
G_1=G;
G_1(ID)=1;

% A=(Beta*I-G)^(-1);
% A_1=(Beta*I-G_1)^(-1);
A=(sparse(Beta*I-G)\I);
A_1=(sparse(Beta*I-G_1)\I);
%T=((one'*((Beta*I)^(-1))*one)^(-1))*((Beta*I)^(-1));

%---IC-------
% Pt=(1/4)*(Alpha-c*one)'*((( (I/A)+(I/A)' ) /2)^(-1))*(Alpha-c*one);
% Pt_1=(1/4)*(Alpha-c*one)'*((( (I/A_1)+(I/A_1)' ) /2)^(-1))*(Alpha-c*one);
tmp=sparse(A)\I;
Pt=2*I/( (tmp)+(tmp)' );
Pt=(1/4)*(Alpha)'*Pt*(Alpha);

tmp=sparse(A_1)\I;
Pt_1=2*I/((tmp)+(tmp)');
Pt_1=(1/4)*(Alpha)'*Pt_1*(Alpha);

IC=Pt_1-Pt;
end

