function interval = build_interval (crit_thresholds_f, still12, frame_index)


for i=1:size(crit_thresholds_f,2);
    if isempty(crit_thresholds_f{i})
        still12=[still12,i];
    end
end

% stilling closed frames
interval=1:length(frame_index)-1;
if ~isempty(still12)
    for ik=1:length(still12)
        interval(interval == still12(ik)) = [];
    end
end
interval=interval(1:end-1);


end