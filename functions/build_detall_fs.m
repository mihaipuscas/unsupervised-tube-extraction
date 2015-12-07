% builds and saves to disk cell array containing all box scores for each classifier

function B_detall = build_detall_fs (feat_file_list,ivid,pathfhdd,pathout)


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