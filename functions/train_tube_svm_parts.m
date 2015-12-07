function [W,B,model,feattube] = train_tube_svm (cltr, im, pathfhdd, ivid, feat_file_list, target_norm, mean_norm)

    % train svm
    for icl=1:size(cltr,2)
        featbox = [];
        for k=cltr(icl).start:cltr(icl).end
            if ~isempty(cltr(icl).clusters(k).struct)
                
                
                
                
                
                ymin=cltr(icl).clusters(k).avgsel(1);
                xmin=cltr(icl).clusters(k).avgsel(2);
                ymax=cltr(icl).clusters(k).avgsel(3);
                xmax=cltr(icl).clusters(k).avgsel(4);
                posim=im{k}(ymin:ymax,xmin:xmax,:);

                boxss=[1 1 size(posim,1) size(posim,2)];
                auxstr=caffe_feat_ex_pad(posim,boxss);
                auxstr.warp(1).feat=auxstr.warp(1).feat.*(target_norm/mean_norm);
                
                feattube(icl,k).feat=auxstr.warp(1).feat;
                feattube(icl,k).BB=[ymin, xmin, ymax, xmax];
                
                
                feat_frame=[];
                load([pathfhdd,num2str(ivid),'/',feat_file_list(k).name])
                
                for k1=1:size(feat_frame,2)
                    if ~isempty(feat_frame(1,k1).feat)
                        
                        featbox(k,k1).feat=feat_frame(1,k1).feat.*(target_norm/mean_norm);
                        featbox(k,k1).index=feat_frame(1,k1).index;
                        featbox(k,k1).BB=feat_frame(1,k1).BB;
                        featbox(k,k1).overlap=IoU(feat_frame(1,k1).BB,feattube(icl,k).BB);
                    end
                    
                end
                
            end
            feattube(icl,1).start=cltr(icl).start;
            feattube(icl,1).end=cltr(icl).end;
        end
        
        if ~exist([path.dataset,'output/features/'],'dir')
            mkdir([path.dataset,'output/features/']);
        end
        
        
        
        model(icl)=svm_train(featbox, feattube(icl,:));
        W{icl}=model(icl).detectors.W;
        B{icl}=model(icl).detectors.B;
        
    end