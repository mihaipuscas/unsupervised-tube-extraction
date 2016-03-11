% --------------------------------------------------------
% Unsupervised Tube Extraction
% Copyright (c) 2015, Mihai Puscas
% Licensed under The MIT License [see LICENSE for details]
% --------------------------------------------------------

clear all;
clear mex;

[opt, path] = startup();                              % startup

videos=[rdir([path.dataset,'*/**/*.avi'])];           % get video paths

%% pre-processing

% 
% 
for ivid = 1 : length(videos)
    % extracting  cnn features (+pad) and saving them to disk on path.
    cnn_feat_allframes (path, videos(ivid).name, ivid, opt.use_gpu)
    
    
    % selective search box proposals, saved to disk
    selective_search_video(videos,ivid,opt.speed);
    
    
    BB_trajectory_intersection(path, opt, videos, ivid)
    % computes trajectory intersections for box pairs across consecutive
    % frames
   
    
end


%% processing tubes

for ivid= 1 : length(video)
    
    
    display(['At ivid = ', num2str(ivid)]);
    

    datastruct = build_initial_datastruct(path,videos,ivid);
    
    
    cltr = build_optiflow_chains(datastruct, opt);
    
    im = datastruct.im;
    frame_index = datastruct.frame_index;
    
    %compute feat norm, and missing features if any
    matcaffe_init(opt.use_gpu);
    [featall,mean_norm] = features_process(path, opt, frame_index, im, ivid);
    
    
    
    if ~exist([path.output,'cache_common/',num2str(ivid),'/'],'dir')
        mkdir([path.output,'cache_common/',num2str(ivid),'/']);
    end
    
    
    save([path.output,'cache_common/',num2str(ivid,'%04i'),'_cache_common_',num2str(opt.peak_select),'.mat'],'mean_norm' ,'cltr')
    
    
    target_norm = opt.target_norm;
    
    % compute detection tubes
    % detection tubes saved in path.output, bounding boxes represented using [ymin, xmin, ymax, xmax]
    for scale = 1 : size(cltr,2)
        detection_tubes(path, opt, datastruct,  ivid , mean_norm, featall, cltr{scale},scale)
    end

    
end
