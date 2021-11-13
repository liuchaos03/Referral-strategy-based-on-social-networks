function Po=GlinkIN3(Alpha,Beta,GA,G,ID,gama)
    for i=1:length(ID)
    G(ID(i,1),ID(i,2))=1;
    end
    I=eye(length(G));
     P=(Alpha/2);
%     for i=1:length(denode)
%         P(denode)=P(denode)*(1-gama);
%     end

    A=((Beta*I-G)^(-1));
    X=A*(Alpha-P);
    P=P*(1-gama);
%      X(X<0)=0;
      ID=unique(ID);   
      Po=sum(X(ID).*P(ID));  
%      Po=sum(X.*P);  
end