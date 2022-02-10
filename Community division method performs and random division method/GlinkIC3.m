function Po=GlinkIC3(Alpha,Beta,GA,G,ID,gama)
    for i=1:length(ID)
    G(ID(i,1),ID(i,2))=1;
    end
    I=eye(length(G));
    A=(Beta*I-GA)^(-1);
    P=((A+A')^(-1))*A*Alpha;
%     for i=1:length(denode)
%         P(denode(i))=P(denode(i))*(1-gama);
%     end   
     P=P*(1-gama);
    A=(Beta*I-G)^(-1);
    X=A*(Alpha-P);
%    X(X<0)=0;
     ID=unique(ID);   
     Po=sum(X(ID).*P(ID));   
%     Po=sum(X.*P);  
end