function [T_list,im] = build_Tlist (frame_index,trajectories, traj_length)

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
    
end

clear ind