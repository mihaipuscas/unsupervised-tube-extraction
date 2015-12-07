% function computes features for any missed video frames and normalizes

function [featall,mean_norm] = features_process(path, opt, frame_index, im, ivid)

display(['checking if features have been computed for the whole video...']);

if exist([path.features,num2str(ivid),'_pad.mat'],'file')
    load ([path.features,num2str(ivid),'_pad.mat']);
    
    if size(featall,1)<size(frame_index,1)
        if exist('featall_pad','var')
            
            if size(featall_pad,1)<size(frame_index,1)
                
                
                if size(featall_pad,2)<size(featall,2)
                    for ii=size(featall,1)+1:size(frame_index,1)
                        for jj=size(featall_pad,2)+1:size(featall,2)
                            featall_pad(ii,jj).feat=[];
                            featall_pad(ii,jj).index=[];
                            featall_pad(ii,jj).BB=[];
                        end
                    end
                end
                
                if size(featall,2)<size(featall_pad,2)
                    for ii=1:size(featall,1)
                        for jj=size(featall,2)+1:size(featall_pad,2)
                            featall(ii,jj).feat=[];
                            featall(ii,jj).index=[];
                            featall(ii,jj).BB=[];
                        end
                    end
                end
                
                %%%!!!
                ii=size(featall_pad,1);
                featall=[featall;featall_pad(ii,:)]
            else
                
                display('Computing features for the remaining frames...');
                
                matcaffe_init(opt.use_gpu);
                
                
                for ii=size(featall,1)+1:size(frame_index,1)
                    
                    boxss=selective_search_boxes(im{ii},1);
                    
                    tic
                    auxstr=caffe_feat_ex_pad(im{ii},boxss);
                    toc
                    
                    for k1=1:size(auxstr.coord,1)
                        featall_pad(ii,k1).feat=auxstr.warp(k1).feat;
                        featall_pad(ii,k1).index=auxstr.warp(k1).index;
                        featall_pad(ii,k1).BB=auxstr.coord(k1,:);
                        featall(ii,k1).feat=auxstr.warp(k1).feat;
                        featall(ii,k1).index=auxstr.warp(k1).index;
                        featall(ii,k1).BB=auxstr.coord(k1,:);
                    end
                    
                end
                
                
                save([path.features,num2str(ivid),'_pad.mat'],'featall_pad','-append','-v7.3');
            end
        end
    end
    
    
    for ifr = size(frame_index,1)-opt.mirror_frames+1 : size(frame_index,1)
        offset =  ifr - size(frame_index,1) + opt.mirror_frames ;
        featall(ifr,:)= featall(size(frame_index,1)-opt.mirror_frames - offset ,:);
    end
    
    
    
    %feature normalization
    display(['Feature normalization, target norm = ' num2str(opt.target_norm)]);
    [featall,mean_norm]=feat_norm_all(featall);
    
end

