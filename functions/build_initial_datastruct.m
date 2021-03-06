% --------------------------------------------------------
% Unsupervised Tube Extraction
% Copyright (c) 2015, Mihai Puscas
% Licensed under The MIT License [see LICENSE for details]
% -------------------------------------------------------- 


function datastruct = build_initial_datastruct(path,videos,ivid)

[pathstr,~,~] = fileparts(videos(ivid).name);
patho=[pathstr(length(path.dataset)+1:end)];
frame_index=[];seg_index=[];

frame_index=[rdir([pathstr,'/*.jpeg']);rdir([pathstr,'/*.jpg'])];



[T_list,B_list,im,trajectories] = build_datastruct(frame_index,pathstr,path);

Area = size(im{1},1)*size(im{1},2);

% bb intersection thresholds


datpath=[pathstr,path.intersection];


load(datpath)


if ~exist('intersection','var') && ~exist('intersectionk','var')
    intersection=iou_binary;
    intersectionk=iou_coefficient;
    clear iou_binary iou_coefficient
end

if ~exist('intersection','var') && exist('intersectionk','var')
    for i=1:length(intersectionk)
        si=size(intersectionk{i});
        for ii=1:si(1)
            for jj=1:si(2)
                if intersectionk{i}(ii,jj)>=0.5
                    intersection{i}(ii,jj)=1;
                else
                    intersection{i}(ii,jj)=0;
                end
            end
        end
    end
end

datastruct.T_list        = T_list;
datastruct.B_list        = B_list;
datastruct.im            = im;
datastruct.intersection  = intersection;
datastruct.intersectionk = intersectionk;
datastruct.frame_index   = frame_index;
datastruct.trajectories  = trajectories;
end
