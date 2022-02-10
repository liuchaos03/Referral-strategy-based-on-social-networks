function Po=GlinkNN3(Alpha,Beta,GA,G,ID,gama)
    N=Beta;
    for i=1:length(ID)
    G(ID(i,1),ID(i,2))=1;
    end
    I=eye(length(G));
    P=sum(Alpha)/(2*N);
    one=ones(1,N);
    P=one'*P;
%     for i=1:length(denode)
%         P(denode(i))=P(denode(i))*(1-gama);
%     end    
     P=P*(1-gama);
    A=((Beta*I-G)^(-1));
    X=A*(Alpha-P);
%     X(X<0)=0;
    ID=unique(ID);   
    Po=sum(X(ID).*P(ID));   
%         Po=sum(X.*P);  
end