function [Ss,Sstep,Ssr]=Derelation(Ss,Sstep,Ssr,x)
        Ss(x,:)=0;   
        [temp,~]=find(Sstep==x);
        Tlen=sum(Sstep(temp,:)~=0);
        Sstep(temp,1:Tlen)=[setdiff(Sstep(temp,:),[0,x]),0];
        [L,~]=find(Ssr==x);
        for i=1:length(L)
            Tlen=sum( Ssr(L(i),:)~=0);
            Ssr(L(i),1:Tlen)=[setdiff(Ssr(L(i),:),[0,x]),0];
        end
        
   for i=1:length(Ssr(x,:))
        if Ssr(x,i)==0
            break;
        end
        Ss(Ssr(x,i),x)=0;       
        if sum(Ss(Ssr(x,i),:))==0 
              [Ss,Sstep,Ssr]=Derelation(Ss,Sstep,Ssr,Ssr(x,i));
        end
   end
    Ssr(x,:)=0;
end