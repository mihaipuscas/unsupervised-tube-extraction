function B_det = build_bdet_2full (ivid, detindex, featall, frame_index, im, target_norm, mean_norm, W, B, pathout)

if isempty(detindex)
    resbox=[];
    featscore=[];
    for i=1:length(im)
        display(['at frame ', num2str(i)]);
        nmsb1=[]; nmspick=[];
        
        feat_frame = [];
        feat_frame=featall(i,:);
        feat_frame=feat_norm_line(feat_frame,target_norm,mean_norm);
        B_det_single=[];
        
        tic
        for icl=1:size(cltr,2)
            
            
            featscore=[];
            feats=[];findex=[];
            if i <= cltr(icl).end && i>= cltr(icl).start
                
                feats=vertcat(vertcat(feat_frame(1,:).feat),feattube(icl,i).feat);
                findex=vertcat(vertcat(feat_frame(1,:).index,-1));
                featscore.scorebb(:,5)=feats*W{icl}-B{icl};
                featscore.scorebb(:,1:4)=vertcat(vertcat(feat_frame(1,:).BB),feattube(icl,i).BB);
                featscore.scorebb(:,6)=findex;
            else
                feats=vertcat(feat_frame(1,:).feat);
                findex=vertcat(feat_frame(1,:).index);
                featscore.scorebb(:,5)=feats*W{icl}-B{icl};
                featscore.scorebb(:,1:4)=vertcat(feat_frame(1,:).BB);
                featscore.scorebb(:,6)=findex;
            end
            
            
            featscore.scorebb=sortrows(featscore.scorebb,-5);
            
            
            nmspick=nms(featscore.scorebb(:,1:5),0.5);
            topp=nmspick(1);
            nmsbox=featscore.scorebb(topp,1:4);
            nmsb1=[nmsb1;featscore.scorebb(topp,:)];
            
            last_score=find(featscore.scorebb(nmspick,5)>=0);
            for jj=1:size(nmspick,1) %last_score
                B_det{icl,i}(jj).coord=featscore.scorebb(nmspick(jj),1:4);    %nmspick(jj)
                B_det{icl,i}(jj).index=featscore.scorebb(nmspick(jj),6);
                B_det{icl,i}(jj).t_in=[];
                B_det{icl,i}(jj).t_out=[];
                B_det{icl,i}(jj).score=featscore.scorebb(nmspick(jj),5);
                B_det{icl,i}(jj).flag=[];
                cc=[];
                cc=B_det{icl,i}(jj).coord;
                B_det{icl,i}(jj).area=(cc(3)-cc(1)+1)*(cc(4)-cc(2)+1);
            end
            
            B_det_single{icl}=B_det{icl,i};
        end
        toc
        tic
        save([pathout,'temp/',num2str(ivid),'/',num2str(i),'_det.mat'],'B_det_single','i')
        toc
        B_det_single=[];
        nmspickfin=nms(nmsb1(:,1:5),0.5);
        nmsbox=nmsb1(nmspickfin,1:4);
        resbox=vertcat(resbox,[i 1 nmsbox(1,:)]);
        
        
    end
else
    
    for i=1:length(frame_index)
        B_det_single=[];
        load([pathout,'temp/',num2str(ivid),'/',num2str(i),'_det.mat']);
        for j=1:length(B_det_single)
            B_det{j,i}=B_det_single{j};
        end
    end
end



end
