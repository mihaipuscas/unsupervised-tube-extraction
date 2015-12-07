function image = local_prepareImage(crimg,IMAGE_MEAN)
% ------------------------------------------------------------------------
if nargin < 2
    d = load('/home/kellanved/work/caffe/matlab/caffe/ilsvrc_2012_cropped_mean');
    IMAGE_MEAN = d.image ;  %.image_mean; 
end

IMAGE_DIM = 227;
%indices = [0 IMAGE_DIM-CROPPED_DIM] + 1;
%center = floor(indices(2) / 2)+1;

image = zeros(IMAGE_DIM, IMAGE_DIM, 3, 'single');

    % read file
    
    % resize to fixed input size
    im = single(crimg);
    im = imresize(im, [IMAGE_DIM IMAGE_DIM], 'bilinear');
    % Transform GRAY to RGB
    if size(im,3) == 1
        im = cat(3,im,im,im);
    end
    % permute from RGB to BGR (IMAGE_MEAN is already BGR)
    im = im(:,:,[3 2 1]) - IMAGE_MEAN;
    % Crop the center of the image   The one below flips the image;
    %         image = permute(im(center:center+CROPPED_DIM-1,...
    %         center:center+CROPPED_DIM-1,:),[2 1 3]);
    image = permute(im,[2 1 3]);

end