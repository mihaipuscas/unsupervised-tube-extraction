function [feat_frame] = feat_norm_line (feat_frame,target_norm,mean_norm)


for j=1:size(feat_frame,2)
    if ~isempty(feat_frame(1,j).feat)
        feat_frame(1,j).feat=feat_frame(1,j).feat.*(target_norm/mean_norm);
    end
end


end