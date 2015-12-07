function [mean_norm] = feat_norm (pathfhdd,ividclft)


feat_file_list=dir([pathfhdd,num2str(ividclft),'/*.mat']);

ns=[];
for i=1:length(feat_file_list)
    feat_frame=[];
    load([pathfhdd,num2str(ividclft),'/',feat_file_list(i).name])
    steps=size(feat_frame,2)/30;
    X=[];
    for j=1:round(steps):size(feat_frame,2)
        if ~isempty(feat_frame(1,j).feat)
            X=vertcat(X,feat_frame(1,j).feat);
        end
    end
    ns=vertcat(ns,sqrt(sum(X.^2, 2)));
end

mean_norm=mean(ns);
stdd=std(ns);
target_norm=20;


end
