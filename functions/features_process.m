% function computes features for any missed video frames and normalizes

function [featall,mean_norm] = features_process(path, opt, frame_index, im, ivid)


% mirror features for mirror frames if they haven't been computed
if size(featall,1) == size(frame_index,1) - opt.mirror_frames
    for ifr = size(frame_index,1)-opt.mirror_frames+1 : size(frame_index,1)
        offset =  ifr - size(frame_index,1) + opt.mirror_frames ;
        featall(ifr,:)= featall(size(frame_index,1)-opt.mirror_frames - offset ,:);
    end
end




%feature normalization
display(['Feature normalization, target norm = ' num2str(opt.target_norm)]);
[featall,mean_norm]=feat_norm_all(featall);

end

