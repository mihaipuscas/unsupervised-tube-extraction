function tubes_dens = density_tubes (Idet,B_det)


% density tubes
% highest scoring boxes are matched using highest density

for icl=1:size(Idet,1)
    for i=1:size(Idet,2)
        density=[];
        density=Idet{icl,i}(1).density;
        
        [~,I]=sort(density(:),'descend');
        [ai,aj]=ind2sub(size(density),I);
        
        lerank{icl,i}.index=[];
        lerank{icl,i}.density=[];
        lerank{icl,i}.passed=[];
        passedi=[];passedj=[];
        for j=1:length(I)
            if isempty(passedi(passedi==ai(j))) && isempty(passedj(passedj==aj(j)))
                lerank{icl,i}.density=[lerank{icl,i}.density density(ai(j),aj(j))];
                lerank{icl,i}.index=[lerank{icl,i}.index; [Idet{icl,i}(ai(j)).index1 Idet{icl,i}(ai(j)).index2(aj(j))]];
                lerank{icl,i}.passed=[lerank{icl,i}.passed,[0 0]];
                passedi=[passedi,ai(j)];passedj=[passedj,aj(j)];
            end
            
        end
    end
end

tubes_dens=[];

for icl=1:size(Idet,1)
    for j=1:size(lerank{icl,i}.index,1)
        tubes_dens{icl,j}.ind=[];
        tubes_dens{icl,j}.res=[];
        for i=1:size(Idet,2)
            if i==1
                tubes_dens{icl,j}.ind=lerank{icl,1}.index(j,:);
                                
                index1=find([B_det{icl,i}.index]==tubes_dens{icl,j}.ind(end-1));
                index2=find([B_det{icl,i+1}.index]==tubes_dens{icl,j}.ind(end));
                tubes_dens{icl,j}.res=[i 0 B_det{icl,i}(index1).coord; i+1 0 B_det{icl,i+1}(index2).coord];
                
                
            else
                
                
                inda=[];
                inda=find(lerank{icl,i}.index(:,1)==tubes_dens{icl,j}.ind(end));
                tubes_dens{icl,j}.ind=[tubes_dens{icl,j}.ind,lerank{icl,i}.index(inda,2)];
                
                index2=[];
                index2=find([B_det{icl,i+1}.index]==tubes_dens{icl,j}.ind(end));
                tubes_dens{icl,j}.res=[tubes_dens{icl,j}.res;i+1 0 B_det{icl,i+1}(index2).coord];
                bb1=B_det{icl,i}(index1).coord;
                
            end
        end
    end
end

end
