function [Idet, NN, n] = norm_idet_2s (Idet1, B_det, datastruct, opt)

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
% for very short videos it is worth taking more tracks into consideration

if length(datastruct.frame_index) - opt.mirror_frames +1  < 25 && size(B_det,1) > 1
    nrdiv = size(B_det,1) -1;
else
    nrdiv = size(B_det,1);
end



n=round((NN-1)/nrdiv);