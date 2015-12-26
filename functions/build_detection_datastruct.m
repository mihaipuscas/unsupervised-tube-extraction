function [B_det, B_detall, Idet1, Idet, nrvals,  n] = build_detection_datastruct(datastruct, path, opt, mean_norm, ivid, featall, W, B)







detindex_traj=dir([path.output,'temp/',num2str(ivid),'/','*_det_traj.mat']);
detindex=dir([path.output,'temp/',num2str(ivid),'/','*_det.mat']);
detallindex=dir([path.output,'temp/',num2str(ivid),'/','*_detall.mat']);



im = datastruct.im;
frame_index = datastruct.frame_index;
trajectories = datastruct.trajectories;
traj_length = size(trajectories,2)/2 -1;

if isempty(detindex_traj)
    [T_list,im] = build_Tlist(frame_index,trajectories, traj_length);
    i=length(frame_index);
    im{i}=imread(frame_index(i).name);
else
    for i=1:length(frame_index)
        im{i}=imread(frame_index(i).name);
    end
end






if ~exist([path.output,'temp/',num2str(ivid),'/'],'dir')
    mkdir([path.output,'temp/',num2str(ivid),'/']);
end

if ~exist('B_detall','var')
    B_detall = build_detall_2full ( detallindex, frame_index, featall, ivid, path.output) ;
end


if ~exist ('B_det','var')
    B_det = build_bdet_2full (ivid, detindex, featall, frame_index, im, opt.target_norm, mean_norm, W, B, path.output);
else
    build_bdet_scraps_2s (B_det, detindex, frame_index, path.output, ivid);
end
%
if ~exist('nrvals','var')
    nrvals = build_nrvals_2s(ivid, B, opt.peak_select, path.output);
end

if isempty(detindex_traj)
    ar = build_detindex_traj(B_detall, nrvals, ivid, opt.peak_select, detindex, T_list, im, path.output);
end

idetindex=dir([path.output,'temp/',num2str(ivid),'/','*_idet.mat']);
if ~exist('Idet1','var')
    if isempty(idetindex)
        Idet1 = build_idet_2s (ivid, frame_index, path.output, nrvals);
    else
        Idet1 = load_idet_2s (idetindex, path.output, ivid);
    end
    
    idetindex=dir([path.output,'temp/',num2str(ivid),'/','*_idet.mat']);
    Idet1 = load_idet_2s (idetindex, path.output, ivid);
    
    if ~exist('Idet','var')
        Idet=cell(size(Idet1,1),size(Idet1,2));
    end
    
    
    
    
    [Idet, ~, n] = norm_idet_2s (Idet1, B_det, datastruct, opt);
    
    save([path.output,'temp/',num2str(ivid,'%04i'),'_temp_',num2str(opt.peak_select),'.mat'],'Idet1','-append')
    
    
else
    if ~exist('Idet','var')
        Idet=cell(size(Idet1,1),size(Idet1,2));
    end
    [Idet, ~, n] = norm_idet_2s (Idet1, B_det, datastruct, opt);
end




detindex_traj=dir([path.output,'temp/',num2str(ivid),'/','*_det_traj.mat']);
for i=1:length(detindex_traj)
    B_det_single_traj=[];
    load([path.output,'temp/',num2str(ivid),'/',num2str(i),'_det_traj.mat'],'B_det_single_traj');
    for j=1:size(B_det_single_traj,1)
        B_det{j,i}=B_det_single_traj{j,i};
    end
end


end
