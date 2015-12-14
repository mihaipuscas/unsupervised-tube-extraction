
function [W,B,model,nmsdet,resbox] = detectors_load_full (cltr,im,featall,target_norm,mean_norm)

% [nmsdet,resbox]


for licl=1:size(cltr,2)
    for k=cltr(licl).start:cltr(licl).end
        if ~isempty(cltr(licl).clusters(k).avgsel)
            
            
            
            
            posim=[];
            ymin=[];ymin=cltr(licl).clusters(k).avgsel(1);
            xmin=[];xmin=cltr(licl).clusters(k).avgsel(2);
            ymax=[];ymax=cltr(licl).clusters(k).avgsel(3);
            xmax=[];xmax=cltr(licl).clusters(k).avgsel(4);
            posim=im{k}(ymin:ymax,xmin:xmax,:);
            auxstr=[];boxss=[];
            boxss=[1 1 size(posim,1) size(posim,2)];
            auxstr=caffe_feat_ex_pad(posim,boxss);
            
            
            
            feattube(licl,k).feat=auxstr.warp(1).feat.*(target_norm/mean_norm);
            feattube(licl,k).BB=[ymin, xmin, ymax, xmax];
            
            feat_frame=[];
            feat_frame = featall(k,:);
      
            
            for k1=1:size(feat_frame,2)
                if ~isempty(feat_frame(1,k1).feat)
                    featbox(k,k1).feat=feat_frame(1,k1).feat;
                    featbox(k,k1).index=feat_frame(1,k1).index;
                    featbox(k,k1).BB=feat_frame(1,k1).BB;
                    featbox(k,k1).overlap=IoU(feat_frame(1,k1).BB,feattube(licl,k).BB);
                end
            end
            
        end
        feattube(licl,1).start=cltr(licl).start;
        feattube(licl,1).end=cltr(licl).end;
    end
    
    
    
    model(licl)=svm_train(featbox, feattube(licl,:));
    
    W{licl}=model(licl).detectors.W;
    B{licl}=model(licl).detectors.B;
    clear featbox
    
end



resbox=[];
featscore=[];
nmsdet=[];
for licl=1:size(cltr,2)
    nmsdet(licl).tube=[];
    nmsdet(licl).resbox=[];
end

for i=1:length(im)
    
    feat_frame=[];
    feat_frame = featall(i, :);
%     feat_frame=feat_norm_line(feat_frame,target_norm,mean_norm);
    
    nmsb1=[]; feattotal=[]; nmspick=[];
    for licl=1:size(cltr,2)
        
        feats=[];
        if i <= cltr(licl).end && i>= cltr(licl).start
            feats=vertcat(vertcat(feat_frame(1,:).feat),feattube(licl,i).feat);
            featscore(i,licl).scorebb(:,5)=feats*W{licl}-B{licl};
            featscore(i,licl).scorebb(:,1:4)=vertcat(vertcat(feat_frame(1,:).BB),feattube(licl,i).BB);
        else
            feats=vertcat(feat_frame(1,:).feat);
            featscore(i,licl).scorebb(:,5)=feats*W{licl}-B{licl};
            featscore(i,licl).scorebb(:,1:4)=vertcat(feat_frame(1,:).BB);
        end
        
        featscore(i,licl).scorebb=sortrows(featscore(i,licl).scorebb,-5);
        
        nmspick=nms(featscore(i,licl).scorebb,0.5);
        nmsbox=featscore(i,licl).scorebb(nmspick(1),1:4);
        nmsdet(licl).tube=[nmsdet(licl).tube;featscore(i,licl).scorebb(nmspick(1),:)];
        nmsdet(licl).resbox=[nmsdet(licl).resbox;[i 1 featscore(i,licl).scorebb(nmspick(1),1:4)]];
        nmsb1=[nmsb1;featscore(i,licl).scorebb(nmspick(1),:)];
        
    end
    resbox=vertcat(resbox,[i 1 nmsbox(1,:)]);
    
end

end



