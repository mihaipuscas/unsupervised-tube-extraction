function [featall, mean_norm] = feat_norm_all (featall)

steps=size(featall,2)/20;
ns=[];
for i=1:size(featall,1)
    
    X=[];
    for j=1:round(steps):size(featall,2)
        if ~isempty(featall(i,j).feat)
            X=vertcat(X,featall(i,j).feat);
        end
    end
    ns=vertcat(ns,sqrt(sum(X.^2, 2)));
end

mean_norm=mean(ns);
stdd=std(ns);
target_norm=20;

for i=1:size(featall,1)
    for j=1:size(featall,2)
        if ~isempty(featall(i,j).feat)
            featall(i,j).feat=featall(i,j).feat.*(target_norm/mean_norm);
        end
    end
end
end