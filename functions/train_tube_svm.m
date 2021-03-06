function [W,B,model,feattube] = train_tube_svm (cltr, im, featall, target_norm, mean_norm)

% --------------------------------------------------------
% Unsupervised Tube Extraction
% Copyright (c) 2015, Mihai Puscas
% Licensed under The MIT License [see LICENSE for details]
% -------------------------------------------------------- 
% takes optical flow clusters as positives + hard negative mining to build
% classifiers. 

for icl=1:size(cltr,2)
    featbox = [];
    for k=cltr(icl).start:cltr(icl).end
        if ~isempty(cltr(icl).clusters(k).struct)
            
            
            
            
            posim=[];
            ymin=[];ymin=cltr(icl).clusters(k).avgsel(1);
            xmin=[];xmin=cltr(icl).clusters(k).avgsel(2);
            ymax=[];ymax=cltr(icl).clusters(k).avgsel(3);
            xmax=[];xmax=cltr(icl).clusters(k).avgsel(4);
            posim=im{k}(ymin:ymax,xmin:xmax,:);
            auxstr=[];boxss=[];
            boxss=[1 1 size(posim,1) size(posim,2)];
            auxstr=caffe_feat_ex_pad(posim,boxss);
            auxstr.warp(1).feat=auxstr.warp(1).feat.*(target_norm/mean_norm);
            
            feattube(icl,k).feat=auxstr.warp(1).feat;
            feattube(icl,k).BB=[ymin, xmin, ymax, xmax];
            
            
            
         
                for k1=1:size(featall(k,:),2)
                    if ~isempty(featall(k,k1).feat)
                        featbox(k,k1).feat=featall(k,k1).feat;
                        featbox(k,k1).index=featall(k,k1).index;
                        featbox(k,k1).BB=featall(k,k1).BB;
                        featbox(k,k1).overlap=IoU(featall(k,k1).BB,feattube(icl,k).BB);
                    end
                    
                end
                
           
            
        end
        feattube(icl,1).start=cltr(icl).start;
        feattube(icl,1).end=cltr(icl).end;
    end
    

    
    
    
    model(icl)=svm_train(featbox, feattube(icl,:));
    W{icl}=model(icl).detectors.W;
    B{icl}=model(icl).detectors.B;
    

end




end




