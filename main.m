% --------------------------------------------------------
% Unsupervised Tube Extraction
% Copyright (c) 2015, Mihai Puscas
% Licensed under The MIT License [see LICENSE for details]
% -------------------------------------------------------- 

addpath(genpath('./functions'))
addpath(genpath('./tools'))
addpath(genpath('./caffe'))
addpath(genpath('./dep'))
addpath('./evaluation');


path.dataset = '/home/kellanved/Desktop/clean_code/ucf_last_process/selection_proc_last/';      % dataset location
path.output = '/home/kellanved/Desktop/clean_code/ucf_last_process/output_hg/';                 % output path
path.segmentation ='/sel_boxesfast_2/bnb*.mat';                                                 % selective search box file names
path.trajectories   ='/*impdt11.txt';                                                           % improved dense trajectories file names
path.features='/media/kellanved/SAMSUNG/featextr/output/features/pad/';                         % feature files path
path.logfile ='logfile_gh';                                                                     % log file path

                                                                                                                                                                                                                                     

videos=[rdir([path.dataset,'*/**/*.avi'])];


opt.multiscale    = 1;                              % multiscale, 1 computes tubes for multiple image area ranges
opt.secstage      = 1;                              % computes second stage detectors ~ time consuming
opt.secms         = 0;                              % 1. computes second stage on all scales, 0 computes second stage on a single scale


opt.use_gpu       = 1;                              % use gpu for feature computation
opt.mirror_frames = 3;                              % n frames mirrored at the end of the video, to maintain a high trajectory number
opt.peak_number   = 3;                              % largest n density peaks taken into consideration
opt.peak_select  = round(opt.peak_number/2);       % selecting the median detected density peak
opt.window_smooth = 4;                              % smoothing window for density auto-threshold

opt.Iou_thresh    = 0.5;                            % intersection over union threshold
opt.area_max      = 0.95;                           % largest image area percentage for which the algorithm computes box pairs
opt.area_min      = 0.005;                          % smallest image area percentage for which the algorithm computes box pairs
opt.target_norm   = 20;                             % target norm for feat normalization
opt.speed         = 2;                              % initial selective search porposals, fastest

path.intersection = ['/bbinta_',num2str(opt.Iou_thresh*100),'_',num2str(opt.area_min*100),'_',num2str(opt.area_max*100),'imprpar.mat'];






%% pre-processing



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
    
    cl_ft=1:length(videos);
    
    
    datastruct = build_initial_datastruct(path,videos,ivid);
    
    cltr = build_optiflow_chains(datastruct, opt);
    
    im = datastruct.im;
    frame_index = datastruct.frame_index;
    
    %compute feat norm, and missing features if any
    matcaffe_init(opt.use_gpu);
    [featall,mean_norm] = features_process(path, opt, frame_index, im, ivid);
    
    
    
    if ~exist([path.output,'temp/',num2str(ivid),'/'],'dir')
        mkdir([path.output,'temp/',num2str(ivid),'/']);
    end
    
    
    save([path.output,'temp/',num2str(ivid,'%04i'),'_temp_',num2str(opt.peak_select),'.mat'],'mean_norm' ,'cltr')
    
    
    target_norm = opt.target_norm;
    
    % compute detection tubes
    for scale = 1 : size(cltr,2)
        detection_tubes(path, opt, datastruct,  ivid , mean_norm, featall, cltr{scale},scale)
    end
    
    
    
end



%% evaluation example


eval = eval_ucf(videos, opt);
