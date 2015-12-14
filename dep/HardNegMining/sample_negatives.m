% ------------------------------------------------------------------------
function neg_2_add= sample_negatives(first_time, model, Curr_frame_Boxes, parameters)
% ------------------------------------------------------------------------
%                     sample_negatives(first_time, model, Boxes(t,:), parameters);
%d.feat = rcnn_scale_features(d.feat, opts.feat_norm_mean);

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