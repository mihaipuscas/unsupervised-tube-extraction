function B_detall = build_detall_2s ( detallindex, frame_index, feat_file_list, pathfhdd, ivid, pathout) 


if isempty(detallindex)
    for i=1:length(feat_file_list)
        feat_frame=[];
        load([pathfhdd,num2str(ivid),'/',feat_file_list(i).name])
        for j=1:size(feat_frame,2)
            if ~isempty(feat_frame(1,j).BB)
                B_detall{i}(j).coord=feat_frame(1,j).BB;
                B_detall{i}(j).index=feat_frame(1,j).index;
                B_detall{i}(j).t_out=[];
                B_detall{i}(j).t_in=[];
            end
        end
        B_detall_single=[];
        B_detall_single=B_detall{i};
        B_detall{i}=[];
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