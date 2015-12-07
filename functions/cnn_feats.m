function cnn_feats(path,im,frame_index)

    
    if exist([path.features,num2str(ivid),'_pad.mat'],'file')
        load ([path.features,num2str(ivid),'_pad.mat'])
        
        if size(featall,1)<size(frame_index,1)
            if exist('featall_pad','var')
                
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
                
                ii=size(featall_pad,1);
                featall=[featall;featall_pad(ii,:)]
            else
                
                
                use_gpu=1;
                if exist('use_gpu', 'var')
                    matcaffe_init(use_gpu);
                else
                    matcaffe_init();
                end
                
                for ii=size(featall,1)+1:size(frame_index,1)
                    
 
                    boxss=[];
                    boxss=selective_search_boxes(im{ii},1);
                    auxstr=[];
                    
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
                display([path.dataset,'output/features/all/',num2str(ivid),'.mat']);
            end
        end
    end