% extracts cnn features for all frames in a video

function cnn_feat_allframes (path, pathvid, ivid, use_gpu)




if ~exist(path.features,'dir')
    mkdir(path.features);
end

pathstr = fileparts(pathvid);
frame_index=[rdir([pathstr,'/*.jpg'])];
featall=[];

caffe_init = 0;




if ~exist([path.features,num2str(ivid),'_pad.mat'],'file')
    
    if ~caffe_init
        matcaffe_init(use_gpu);
        caffe_init = 1;
    end
    
    for i=1:length(frame_index)
        
        
        
        im{i}=imread(frame_index(i).name);
        boxss=selective_search_boxes(im{i},1);
        
        tic
        auxstr=caffe_feat_ex_pad(im{i},boxss);
        toc
        
        for k1=1:size(auxstr.coord,1)
            
            featall(i,k1).feat=auxstr.warp(k1).feat;
            featall(i,k1).index=auxstr.warp(k1).index;
            featall(i,k1).BB=auxstr.coord(k1,:);
            
        end
        
    end
    
    
    save([path.features,num2str(ivid),'_pad.mat'],'featall','-v7.3');
    display([path.features,num2str(ivid),'_pad.mat']);
    
end



end
