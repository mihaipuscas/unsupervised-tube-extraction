function [track, aux12] = build_optiflow_tracks (datastruct, opt, interval, frame_index, aux12, crit_thresholds_f, scale_interval, sci)
% outputs optical flow "chains" - concatenated box pairs
% --------------------------------------------------------
% Unsupervised Tube Extraction
% Copyright (c) 2015, Mihai Puscas
% Licensed under The MIT License [see LICENSE for details]
% -------------------------------------------------------- 


%sorting results by area , eliminating zeros, initializing
%tracks

si=size(datastruct.im{1});
Area_image=si(1)*si(2);

% scale selection
ahigh  = scale_interval(sci).area_high;
alow   = scale_interval(sci).area_low;



for i=interval
    % sorts box pairs by area
    aux12{i}=sortrows(aux12{i},-8);
    for j=1:length(aux12{i})
        if aux12{i}(j,8)/Area_image < alow || aux12{i}(j,8)/Area_image > ahigh
            % checks if box area is within conditions
            aux12{i}(j,7)=0;
        end
    end
    
    
    aux12{i}(aux12{i}(:,7) == 0,:) = [];
    
    
    
    
    if length(crit_thresholds_f{i}) >= opt.peak_select
        % if we have at least opt.peak_number peaks
        aux12{i}(find(aux12{i}(:,7) <  crit_thresholds_f{i}(opt.peak_select)),:)=[];
        % discard all pairs of boxes with density lower than the threshold
        if length(crit_thresholds_f{i}) > opt.peak_select
            aux12{i}(find(aux12{i}(:,7) >  crit_thresholds_f{i}(end)),:)=[];
            % if possible, discard pairs with density higher than the last
            % detected peak
        end
    else
        aux12{i}(find(aux12{i}(:,7) <  crit_thresholds_f{i}(end)),:)=[];
    end
    edge(i).boxid=[aux12{i}(:,1),aux12{i}(:,6)];
    traverse(i).array=zeros(size(edge(i).boxid,1),2);
    traverse(i).array_merge=zeros(size(edge(i).boxid,1),2);
end



% concatenate box pairs
pathcount=1;
track(pathcount).pt=[];

for i=interval(1:end-1) %1:length(frame_index)-2
    if i==length(frame_index)-2
        for k1=1:size(edge(i).boxid,1)
            n11=edge(i).boxid(k1,1);
            n21=edge(i).boxid(k1,2);
            if traverse(i).array(k1,1) == 0
                traverse(i).array(k1,:) = pathcount;
                if isempty(track(pathcount).pt)
                    track(pathcount).pt = i;
                end
                track(pathcount).pt = [track(pathcount).pt,n11,n21];
                pathcount = pathcount+1;
                track(pathcount).pt=[];
                n11=[];n21=[];
            end
        end
    else
        
        
        for k1=1:size(edge(i).boxid,1)
            n11=edge(i).boxid(k1,1);
            n21=edge(i).boxid(k1,2);
            if traverse(i).array(k1,1) == 0
                traverse(i).array(k1,:) = pathcount;
                if isempty(track(pathcount).pt)
                    track(pathcount).pt = i;
                end
                track(pathcount).pt = [track(pathcount).pt,n11,n21];
                
                for k2=1:size(edge(i+1).boxid,1)
                    n12=edge(i+1).boxid(k2,1);
                    n22=edge(i+1).boxid(k2,2);
                    if n21==n12
                        traverse(i+1).array(k2,:) = pathcount;
                        if isempty(track(pathcount).pt)
                            track(pathcount).pt = i;
                        end
                        
                        track(pathcount).pt = [track(pathcount).pt,n22];
                        
                        break;
                    end
                end
                
                pathcount=pathcount+1;
                track(pathcount).pt=[];
                n11=[];n21=[];n12=[];n22=[];
                
                
            else
                pathcount1=[];
                pathcount1=traverse(i).array(k1,1);
                for k2=1:size(edge(i+1).boxid,1)
                    n12=edge(i+1).boxid(k2,1);
                    n22=edge(i+1).boxid(k2,2);
                    if n21==n12
                        traverse(i+1).array(k2,:) = pathcount1;
                        if isempty(track(pathcount1).pt)
                            track(pathcount1).pt = i;
                        end
                        track(pathcount1).pt = [track(pathcount1).pt,n22];
                        break;
                    end
                    n12=[];n22=[];
                end
            end
            
        end
    end
end

end
