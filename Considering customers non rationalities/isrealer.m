function [Yita1,Yita2]=isrealer(Yita1,Yita2)
    temp=zeros();
for i=1:length(Yita1)
    if ~isreal(Yita1(i))
        temp(i)=-inf;
    else
        temp(i)=Yita1(i);
    end
end
    Yita1=temp;
    temp=zeros();
for i=1:length(Yita2)
    if ~isreal(Yita2(i))
        temp(i)=-inf;
    else
        temp(i)=Yita2(i);
    end
end
    Yita2=temp;
end