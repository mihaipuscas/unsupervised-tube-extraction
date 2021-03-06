% --------------------------------------------------------
% Fast R-CNN
% Copyright (c) 2015, Mihai Puscas
% Licensed under The MIT License [see LICENSE for details]
% -------------------------------------------------------- 


function [T_list,B_list,im, trajectories] = build_datastruct (frame_index,pathstr,path)

seg_index=[rdir([pathstr,path.segmentation])];  % selective search bbs
tra_index=[rdir([pathstr,path.trajectories])];  %load raw trajectory data



trajectories=importdata([tra_index.name]);
trajectories=[trajectories [1:size(trajectories,1)]']; % append trajectory index
traj_length=size(trajectories,2)/2 -1; % length of extracted trajectories



T_list=[];B_list=[];

% build datasructures
for i=1:length(frame_index)-1
    im{i}=imread(frame_index(i).name);
    
    % trajectories that pass through the frame
    ind=find(trajectories(:,1) >= i & trajectories(:,1)< i+traj_length);
    traj_split=trajectories(ind,:);
    % points of intersection
    point_intersect=[zeros(size(traj_split,1),2),traj_split(:,size(traj_split,2))];
    for j=1:size(traj_split,1)
        frame_dif=i-(traj_split(j,1)-traj_length); % frame offset
        point_intersect(j,1:2)=traj_split(j,frame_dif*2:frame_dif*2+1);
        T_list{i}(j).coord=point_intersect(j,1:2);
        T_list{i}(j).index=point_intersect(j,3);
        T_list{i}(j).start=traj_split(j,1)-traj_length+1;
        T_list{i}(j).stop =traj_split(j,1);
        
    end
    clear point_intersect traj_split
    
    load(seg_index(i).name,'boxes')
    for j=1:size(boxes,1)
        B_list{i}(j).coord=boxes(j,:);
        B_list{i}(j).index=j;
        B_list{i}(j).t_in=[];
        B_list{i}(j).t_out=[];
    end
    clear boxes
    clear ind

end
im{end+1}=imread(frame_index(end).name);


end