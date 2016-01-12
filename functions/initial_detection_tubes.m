function  [nmsdet, resbox, B_detall, B_det] = initial_detection_tubes(path, opt, ivid, featall, im,  cltr, feattube, W, B)


for i=1:size(featall,1)
    for j=1:size(featall,2)
        if ~isempty(featall(i,j).BB)
            B_detall{i}(j).coord=featall(i,j).BB;
            B_detall{i}(j).index=featall(i,j).index;
            B_detall{i}(j).t_out=[];
            B_detall{i}(j).t_in=[];
            
        end
        
    end
end

resbox=[];
featscore=[];
nmsdet=[];
for icl=1:size(cltr,2)
    nmsdet(icl).tube=[];
    nmsdet(icl).resbox=[];
    nmsdet(icl).index=[];
end


if ~exist([path.output_scale,'cache/',num2str(ivid),'/'],'dir')
    mkdir([path.output_scale,'cache/',num2str(ivid),'/']);
end


for i=1:length(im)
    
    nmsb1=[]; feattotal=[]; nmspick=[];

    for icl=1:size(cltr,2)
        
        feats=[];findex=[];
        if i <= cltr(icl).end && i>= cltr(icl).start
            feats=vertcat(vertcat(featall(i,:).feat),feattube(icl,i).feat);
            findex=vertcat(vertcat(featall(i,:).index,-1));
            featscore(i,icl).scorebb(:,5)=feats*W{icl}-B{icl};
            featscore(i,icl).scorebb(:,1:4)=vertcat(vertcat(featall(i,:).BB),feattube(icl,i).BB);
            featscore(i,icl).scorebb(:,6)=findex;
        else
            feats=vertcat(featall(i,:).feat);
            findex=vertcat(featall(i,:).index);
            featscore(i,icl).scorebb(:,5)=feats*W{icl}-B{icl};
            featscore(i,icl).scorebb(:,1:4)=vertcat(featall(i,:).BB);
            featscore(i,icl).scorebb(:,6)=findex;
        end
        
        featscore(i,icl).scorebb=sortrows(featscore(i,icl).scorebb,-5);
        
        
        feattotal=[feattotal;featscore(i,icl).scorebb(find(featscore(i,icl).scorebb(:,5)>0),:)];
        
        nmspick=nms(featscore(i,icl).scorebb(:,1:5),0.5);
        nmsbox=featscore(i,icl).scorebb(nmspick(1),1:4);
        nmsdet(icl).tube=[nmsdet(icl).tube;featscore(i,icl).scorebb(nmspick(1),1:5)];
        nmsdet(icl).resbox=[nmsdet(icl).resbox;[i 1 featscore(i,icl).scorebb(nmspick(1),1:4)]];
        nmsdet(icl).index=[nmsdet(icl).index;featscore(i,icl).scorebb(nmspick(1),6)];
        nmsb1=[nmsb1;featscore(i,icl).scorebb(nmspick(1),:)];
        
        for jj=1:size(nmspick,1)
            B_det{icl,i}(jj).coord=featscore(i,icl).scorebb(nmspick(jj),1:4);
            B_det{icl,i}(jj).index=featscore(i,icl).scorebb(nmspick(jj),6);
            B_det{icl,i}(jj).t_in=[];
            B_det{icl,i}(jj).t_out=[];
            B_det{icl,i}(jj).score=featscore(i,icl).scorebb(nmspick(jj),5);
            B_det{icl,i}(jj).flag=[];
            
            
            B_det_single{icl}(jj).coord=featscore(i,icl).scorebb(nmspick(jj),1:4);    %nmspick(jj)
            B_det_single{icl}(jj).index=featscore(i,icl).scorebb(nmspick(jj),6);
            B_det_single{icl}(jj).t_in=[];
            B_det_single{icl}(jj).t_out=[];
            B_det_single{icl}(jj).score=featscore(i,icl).scorebb(nmspick(jj),5);
            B_det_single{icl}(jj).flag=[];
            cc=[];
            cc=B_det_single{icl}(jj).coord;
            B_det_single{icl}(jj).area=(cc(3)-cc(1)+1)*(cc(4)-cc(2)+1);
        end
    end
    nmspicktotal=nms(feattotal,0.5);
    nmstotalbox=feattotal(nmspicktotal,1:4);
    
    nmspickfin=nms(nmsb1(:,1:5),0.5);
    nmsbox=nmsb1(nmspickfin,1:4);
    
    

    
    tic
    save([path.output_scale,'cache/',num2str(ivid),'/',num2str(i),'_det.mat'],'B_det_single','i')
    toc
    B_det_single=[];
    
    resbox=vertcat(resbox,[i 1 nmsbox(1,:)]);
end
           
if ~exist ([path.output_scale,'cache/',num2str(ivid,'%04i'),'_cache_',num2str(opt.peak_select),'.mat'],'file')
    save([path.output_scale,'cache/',num2str(ivid,'%04i'),'_cache_',num2str(opt.peak_select),'.mat'],'W','B','cltr','feattube');
else
    save([path.output_scale,'cache/',num2str(ivid,'%04i'),'_cache_',num2str(opt.peak_select),'.mat'],'W','B','cltr','feattube','-append');
end



if ~exist([path.output_scale],'dir')
    mkdir([path.output_scale]);
end


end