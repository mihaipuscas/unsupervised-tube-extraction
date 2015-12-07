function [Idet, NN, n] = norm_idet_2s (Idet1, B_det)

for icl=1:size(Idet1,1)
    for i=1:size(Idet1,2)
        if i>1
            tic
            Idet{icl,i-1}=Idet1{icl,i-1};
            toc
        end
    end
end

NN=10;
n=round((NN-1)/size(B_det,1));