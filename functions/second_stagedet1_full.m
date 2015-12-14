function [nmsdet1,resbox1,cltr1] = second_stagedet1_full(Idet,B_det,im,nrvals,n,featall,target_norm,mean_norm)


for icl=1:size(Idet,1)
    for i=1:size(Idet,2)
        proto{icl,i}.lm=[];
        passed=[];
        for j=1:nrvals(icl)
            if ~isempty(Idet{icl,i}(j).indexsortiou)
                ok=0;k=1;
                while ~ok
                    first=[];
                    first=Idet{icl,i}(j).indexsortiou(k);
                    if isempty(find(passed==first))
                        Idet{icl,i}(j).localmatch=[Idet{icl,i}(j).index1,first];
                        
                        passed=[passed,first];
                        
                        
                        ok=1;
                    else
                        if k< length(Idet{icl,i}(j).indexsortiou)
                            k=k+1;
                        else
                            ok=1;
                        end
                    end
                end
            end
        end
        
        proto{icl,i}.lm=vertcat(Idet{icl,i}.localmatch);
        proto{icl,i}.traverse=zeros(size(proto{icl,i}.lm));
    end
end


for icl=1:size(proto,1)
    for i=1:size(proto,2)-1
        inter=[];ia=[];ib=[];
        if ~isempty(proto{icl,i+1}.lm) && ~isempty(proto{icl,i}.lm)
            [inter,ia,ib]=intersect(proto{icl,i}.lm(:,2),proto{icl,i+1}.lm(:,1));
            proto{icl,i}.inter=inter;
            proto{icl,i}.edge=[ia ib];
            proto{icl,i}.traverse=zeros(size(proto{icl,i}.lm));
        else
            if ~isempty(proto{icl,i}.lm)
                proto{icl,i}.traverse=zeros(size(proto{icl,i}.lm));
                proto{icl,i}.inter=[];
                proto{icl,i}.edge=[];
            else
                
                
                proto{icl,i}.inter=[];
                proto{icl,i}.edge=[];
                proto{icl,i}.traverse=[];
            end
            
        end
        
        
    end
    
end


for icl=1:size(proto,1)
    track{icl}=cl_track(proto,icl);
    cltr1{icl}=tracks_split_det(track{icl},Idet,B_det,icl,n);
    [W{icl},B{icl},model{icl},nmsdet1{icl},resbox1{icl}]= detectors_load_full (cltr1{icl},im,featall,target_norm,mean_norm);
    
end



end



