function [Sstep,Ssr]=dedges(Ss,Sstep,Ssr,x,temp)
     Tlen=sum( Ssr(x,:)~=0);
      Ssr(x,1:Tlen)=[setdiff(Ssr(x,:),[0,temp]),0];
            
      if sum(Ss(x,:))==0
          [R,~]=find(Sstep==temp);
      Tlen=sum( Sstep(R,:)~=0);
      Sstep(R,1:Tlen)=[setdiff(Sstep(R,:),[0,temp]),0];
      end
            
end