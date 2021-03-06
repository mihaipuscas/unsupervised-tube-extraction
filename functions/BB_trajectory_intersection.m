


% computes common trajectories between pairs of bounding boxes in
% consecutive frames, across the whole video.


function BB_trajectory_intersection(path, opt, videos, ivid)

% --------------------------------------------------------
% Unsupervised Tube Extraction
% Copyright (c) 2015, Mihai Puscas
% Licensed under The MIT License [see LICENSE for details]
% -------------------------------------------------------- 



pathstr = fileparts(videos(ivid).name);
frame_index=[]; im=[];
tra_index=[rdir([pathstr,path.trajectories])];  % new dense trajectories impdt1


if ~exist([pathstr,'/bbinta_',num2str(opt.Iou_thresh*100),'_',num2str(opt.area_min*100),'_',num2str(opt.area_max*100),'imprpar.mat'],'file') 
    if ~isempty(tra_index)
        
        display(['La ivid = ', num2str(ivid)]);
        
        seg_index=[];
        frame_index=[rdir([pathstr,'/*.jpg'])];
        seg_index=[rdir([pathstr,'/sel_boxesfast_',num2str(opt.speed),'/bnb*.mat'])];
        
        trajectories=[];
        trajectories=importdata([tra_index.name]);
        trajectories=[trajectories [1:size(trajectories,1)]']; % append trajectory index
        traj_length=size(trajectories,2)/2-1; % length of extracted trajectories
        T_list=[];B_list=[];
        
        % build datasructures
        for i=1:length(frame_index)
            im=imread(frame_index(i).name);
            S=load(seg_index(i).name,'boxes');
            for j=1:size(S.boxes,1)
                B_list{i}(j).coord=S.boxes(j,:);
                B_list{i}(j).index=j;
                B_list{i}(j).t_in=[];
                B_list{i}(j).t_out=[];
            end
            
        end
        
        
        
        intersection=[]; intersectionk=[];
        % trajectories in bounding boxes, bb criteria
        
        for i=1:length(frame_index)-2
            tic
            
            ok=1;
            T_list=[];
            % compute trajectory list for two consecutive frames
            for ii=1:2
                im=imread(frame_index(i).name);
                ind=[];
                % trajectories that pass through the frame
                ind=find(trajectories(:,1) >= i+ii-1 & trajectories(:,1)< i+ii-1+traj_length);
                traj_split=trajectories(ind,:);
                % points of intersection
                if ~isempty(traj_split)
                    point_intersect=[zeros(size(traj_split,1),2),traj_split(:,size(traj_split,2))];
                    for j=1:size(traj_split,1)
                        frame_dif=i+ii-1-(traj_split(j,1)-traj_length); % frame offset
                        point_intersect(j,1:2)=traj_split(j,frame_dif*2:frame_dif*2+1);
                        T_list{ii}(j).coord=point_intersect(j,1:2);
                        T_list{ii}(j).index=point_intersect(j,3);
                        T_list{ii}(j).start=traj_split(j,1)-traj_length+1;
                        T_list{ii}(j).stop =traj_split(j,1);
                    end
                else
                    ok=0;
                end
                
            end
            
            
            
            
            
            
            
            intersection{i}=zeros(size(B_list{i},2),size(B_list{i+1},2));  % logical
            intersectionk{i}=zeros(size(B_list{i},2),size(B_list{i+1},2)); % iou k
            
            % compute box pair trajectory intersection.
            if ok
                T_temp=[];
                T_temp=[vertcat(T_list{1}.coord),vertcat(T_list{1}.index),vertcat(T_list{1}.stop)];
                T_temp1=[];
                T_temp1=[vertcat(T_list{2}.coord),vertcat(T_list{2}.index),vertcat(T_list{2}.start)];
                
                
                si=size(im);
                for b1=1:size(B_list{i},2)
                    
                    kfra=frame_overlap(B_list{i}(b1).coord,si(1:2));
                    b1_temp=[];
                    b1_temp_coord=[];
                    b1_temp_coord=B_list{i}(b1).coord;
                    for b2=1:size(B_list{i+1},2)
                        
                        b2_temp=[];
                        b2_temp_coord=[];
                        b2_temp_coord=B_list{i+1}(b2).coord;
                        
                        kfra2=frame_overlap(b2_temp_coord,si(1:2));
                        
                        
                        if kfra<opt.area_max && kfra2<opt.area_max && kfra > opt.area_min && kfra2 > opt.area_min
                            krit=IoU(b1_temp_coord,b2_temp_coord);
                            intersectionk{i}(b1,b2)=krit;
                            if krit>opt.Iou_thresh
                                intersection{i}(b1,b2) = 1;
                                
                                %%% testing
                                xmin_bb1=b1_temp_coord(2);
                                ymin_bb1=b1_temp_coord(1);
                                xmax_bb1=b1_temp_coord(4);
                                ymax_bb1=b1_temp_coord(3);
                                xmin_bb2=b2_temp_coord(2);
                                ymin_bb2=b2_temp_coord(1);
                                xmax_bb2=b2_temp_coord(4);
                                ymax_bb2=b2_temp_coord(3);
                                
                                
                                for k=1:size(T_list{1},2)
                                    
                                    x_point=T_temp(k,1);
                                    y_point=T_temp(k,2);
                                    id_point=T_temp(k,3);
                                    
                                    if i~=T_temp(k,4)
                                        if x_point>xmin_bb1 && x_point<xmax_bb1
                                            if  y_point>ymin_bb1 && y_point<ymax_bb1
                                                b1_temp=[b1_temp,id_point];
                                            end
                                        end
                                    end
                                end
                                
                                for k=1:size(T_list{2},2)
                                    
                                    x_point=T_temp1(k,1);
                                    y_point=T_temp1(k,2);
                                    id_point=T_temp1(k,3);
                                    
                                    if (i+1)~=T_temp1(k,4)
                                        if x_point>xmin_bb2 && x_point<xmax_bb2
                                            if y_point>ymin_bb2 && y_point<ymax_bb2
                                                b2_temp=[b2_temp,id_point];
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        if ~isempty(b2_temp)
                            B_list{i+1}(b2).t_in=unique(b2_temp);
                        end
                    end
                    if ~isempty(b1_temp)
                        B_list{i}(b1).t_out=unique(b1_temp);
                    end
                end
                
                for j=1:size(B_list{i},2)
                    aux=[];
                    aux=B_list{i}(j).t_out;
                    B_list{i}(j).t_out=[];
                    B_list{i}(j).t_out=unique(aux);
                    
                end
                
            end
            toc
        end
        
        
        parsave([pathstr,'/bbinta_',num2str(opt.Iou_thresh*100),'_',num2str(opt.area_min*100),'_',num2str(opt.area_max*100),'imprpar.mat'],B_list,intersectionk)
        display([pathstr,'/bbinta_',num2str(opt.Iou_thresh*100),'_',num2str(opt.area_min*100),'_',num2str(opt.area_max*100),'imprpar.mat']);
        B_list=[];
    end
end