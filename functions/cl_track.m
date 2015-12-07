function track= cl_track(proto,icl)


    pathcount=1;
    track(pathcount).pt=[];

    for i=1:size(proto,2)
        if i==size(proto,2)
            for k1=1:size(proto{icl,i}.lm,1)
                n11=proto{icl,i}.lm(k1,1);
                n21=proto{icl,i}.lm(k1,2);
                if proto{icl,i}.traverse(k1,1) == 0
                    proto{icl,i}.traverse(k1,:) = pathcount;
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
            
            
            for k1=1:size(proto{icl,i}.lm,1)
                n11=proto{icl,i}.lm(k1,1);
                n21=proto{icl,i}.lm(k1,2);
                if proto{icl,i}.traverse(k1,1) == 0
                    proto{icl,i}.traverse(k1,:) = pathcount;
                    if isempty(track(pathcount).pt)
                        track(pathcount).pt = i;
                    end
                    track(pathcount).pt = [track(pathcount).pt,n11,n21];
                    
                    for k2=1:size(proto{icl,i+1}.lm,1)
                        n12=proto{icl,i+1}.lm(k2,1);
                        n22=proto{icl,i+1}.lm(k2,2);
                        if n21==n12
                            proto{icl,i+1}.traverse(k2,:) = pathcount;
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
                    
                    
                    pathcount1=proto{icl,i}.traverse(k1,1);
                    for k2=1:size(proto{icl,i+1}.lm,1)
                        n12=proto{icl,i+1}.lm(k2,1);
                        n22=proto{icl,i+1}.lm(k2,2);
                        if n21==n12
                            proto{icl,i+1}.traverse(k2,:) = pathcount1;
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