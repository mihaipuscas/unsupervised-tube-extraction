function [opt, path] = startup()


addpath(genpath('./functions'))
addpath(genpath('./tools')) 
addpath(genpath('./caffe'))
addpath(genpath('./dep'))


path.dataset = 'insert_path';      % dataset location
path.output = 'insert_path';                 % output path
path.segmentation ='/sel_boxesfast_2/bnb*.mat';                                                 % selective search box file names
path.trajectories   ='/*impdt11.txt';                                                           % improved dense trajectories file names
path.features='insert_path';                         % feature files path
path.logfile ='logfile_gh';                                                                     % log file path



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


end