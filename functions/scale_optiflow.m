function cltr = scale_optiflow(datastruct, frame_index, opt, scale_interval, sci) 

% --------------------------------------------------------
% Unsupervised Tube Extraction
% Copyright (c) 2015, Mihai Puscas
% Licensed under The MIT License [see LICENSE for details]
% -------------------------------------------------------- 

[I_listf, aux12 , still12] = build_intersect(datastruct, frame_index, scale_interval, sci);
% builds intersection list


%thresholding
[crit_thresholds_f,~]=density_thresholds(I_listf,opt,still12);
% density auto thersholding 

interval = build_interval (crit_thresholds_f, still12, frame_index);
% selects the frames in which we have pairs of boxes that pass the required
% conditions


% optical flow chains
[track, ~] = build_optiflow_tracks (datastruct, opt, interval, frame_index, aux12, crit_thresholds_f, scale_interval, sci);

% optical flow clustering -> optiflow tubes
[cltr] = build_optiflow_tubes (datastruct, frame_index,track , interval);
