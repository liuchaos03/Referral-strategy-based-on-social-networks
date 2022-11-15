function [output,Time]=get_genetic(c,Alpha,G,seed)
output=zeros();
Time=zeros();
for Rca=1:3
    tic;
    for cases=1:3
        output(Rca,cases)=genetic(c,Alpha,G,seed,cases,Rca);
    end
    Time(Rca)=toc;
end
end