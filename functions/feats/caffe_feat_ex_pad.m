function ssb = caffe_feat_ex_pad(im,boxss)

% posneg is 0 for negatives, 1 for positives

% caffe init here
use_gpu=1;
% init caffe network (spews logging info)


ssb=[];

ssb.coord=boxss;
imaux=zeros(size(im));
imaux=im;
d = load('/home/kellanved/Desktop/code_github/caffe/matlab/caffe/ilsvrc_2012_mean');

for j=1:size(ssb.coord,1)
    ymin=ssb.coord(j,1);
    xmin=ssb.coord(j,2);
    ymax=ssb.coord(j,3);
    xmax=ssb.coord(j,4);
    cropi=[];
    cropi=imaux(ymin:ymax,xmin:xmax,:);

    ssb.warp(j).img=rcnn_im_crop(im,[xmin ymin xmax ymax],'warp',227,16,d.image_mean);
    ssb.warp(j).index=j;
end


%%% Batch size = 10
batch_size=10;
batch_nr=floor(size(ssb.warp,2)/batch_size)+1;
% prepare batches
for jb=1:batch_nr
    for k=1:batch_size
        last=mod(size(ssb.warp,2),batch_size);
        if jb == batch_nr
            if last
                if k> last
                    inputImages(:, :, :, k) = ssb.warp((jb-1)*batch_size+last).img;
                else
                    inputImages(:, :, :, k) = ssb.warp((jb-1)*batch_size+k).img;
                end
            end
            
        else
            inputImages(:, :, :, k) = ssb.warp((jb-1)*batch_size+k).img;
        end
    end
    
    
    
    scores = caffe('forward', {inputImages});
    featscores=squeeze(scores{1});
    
    for k=1:batch_size
        ssb.warp((jb-1)*batch_size+k).feat=featscores(:,k)';
        ssb.warp((jb-1)*batch_size+k).img=[];
    end
    
end



end

