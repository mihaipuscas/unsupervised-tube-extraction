% ------------------------------------------------------------------------
function neg_2_add= sample_negatives(first_time, model, Curr_frame_Boxes, parameters)
% ------------------------------------------------------------------------
% ---------------------------------------------------------
% Copyright (c) 2014, Ross Girshick
% 
% This file is part of the R-CNN code and is available 
% under the terms of the Simplified BSD License provided in 
% LICENSE. Please retain this notice and LICENSE if you use 
% this file (or any portion of it) in your project.
% ---------------------------------------------------------

neg_ovr_thresh = 0.3;


if first_time
    I = find([Curr_frame_Boxes(:).overlap] < neg_ovr_thresh);
    neg_2_add= vertcat( Curr_frame_Boxes(I).feat );

else
    z= bsxfun(@plus, vertcat(Curr_frame_Boxes(:).feat) * model.detectors.W, model.detectors.B);
    I = find((z > parameters.hard_thresh) & ([Curr_frame_Boxes(:).overlap] < neg_ovr_thresh)');
     % Avoid adding duplicate features ???
    neg_2_add= vertcat(Curr_frame_Boxes(I).feat);    
end

end