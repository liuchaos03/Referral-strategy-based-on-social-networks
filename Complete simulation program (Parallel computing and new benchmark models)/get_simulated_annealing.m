function [output,Time]=get_simulated_annealing(c,Alpha,G,seed)
output=zeros();
Time=zeros();
for Rca=1:3
    tic;
    for cases=1:3
        output(Rca,cases)=simulated_annealing(c,Alpha,G,seed,cases,Rca);
    end
    Time(Rca)=toc;
end
end