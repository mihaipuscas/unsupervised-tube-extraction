function X_pos= get_positive_feat(Boxes, Tube)

pos_ovr_thresh= 0.5;

X_pos= [];
for t= Tube(1).start: Tube(1).end
    X_pos= [X_pos; Tube(t).feat];
end


for t= Tube(1).start: Tube(1).end   
    I = find([Boxes(t,:).overlap] >= pos_ovr_thresh);
    X_pos = cat(1, X_pos, Boxes(t,I).feat);  
end

end

