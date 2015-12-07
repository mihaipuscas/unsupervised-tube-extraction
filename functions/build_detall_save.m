B_detall = build_detall_2full ( detallindex, frame_index, featall, ivid, pathout) 


if isempty(detallindex)
    for i=1:size(featall,1)
        feat_frame=[];
        for j=1:size(featall,2)
            if ~isempty(featall(i,j).BB)
                B_detall{i}(j).coord=featall(i,j).BB;
                B_detall{i}(j).index=featall(i,j).index;
                B_detall{i}(j).t_out=[];
                B_detall{i}(j).t_in=[];
            end
        end
        B_detall_single=[];
        B_detall_single=B_detall{i};
        save([pathout,'temp/',num2str(ivid),'/',num2str(i),'_detall.mat'],'B_detall_single')
        
    end
    detallindex=dir([pathout,'temp/',num2str(ivid),'/','*_detall.mat']);
else
    
    for i=1:length(frame_index)
        B_detall_single=[];
        load([pathout,'temp/',num2str(ivid),'/',num2str(i),'_detall.mat']);
        B_detall{i}=B_detall_single;
    end
end