function tubes_iou = iou_tubes (Idet, B_det)


% iou tubes
for icl=1:size(Idet,1)
    for i=1:size(Idet,2)
        iou=[];
        iou=Idet{icl,i}(1).iou;
        
        [~,I]=sort(iou(:),'descend');
        [ai,aj]=ind2sub(size(iou),I);
        
        leerank{icl,i}.index=[];
        leerank{icl,i}.iou=[];
        leerank{icl,i}.passed=[];
        passedi=[];passedj=[];
        for j=1:length(I)
            if isempty(passedi(passedi==ai(j))) && isempty(passedj(passedj==aj(j)))
                leerank{icl,i}.iou=[leerank{icl,i}.iou iou(ai(j),aj(j))];
                leerank{icl,i}.index=[leerank{icl,i}.index; [Idet{icl,i}(ai(j)).index1 Idet{icl,i}(ai(j)).index2(aj(j))]];
                leerank{icl,i}.passed=[leerank{icl,i}.passed,[0 0]];
                passedi=[passedi,ai(j)];passedj=[passedj,aj(j)];
            end
            
        end
    end
end

tubes_iou=[];

for icl=1:size(Idet,1)
    for j=1:size(leerank{icl,i}.index,1)
        tubes_iou{icl,j}.ind=[];
        tubes_iou{icl,j}.res=[];
        for i=1:size(Idet,2)
            if i==1
                tubes_iou{icl,j}.ind=leerank{icl,1}.index(j,:);
                index1=find([B_det{icl,i}.index]==tubes_iou{icl,j}.ind(end-1));
                index2=find([B_det{icl,i+1}.index]==tubes_iou{icl,j}.ind(end));
                tubes_iou{icl,j}.res=[i 0 B_det{icl,i}(index1).coord; i+1 0 B_det{icl,i+1}(index2).coord];
                
            else
                
                inda=[];
                inda=find(leerank{icl,i}.index(:,1)==tubes_iou{icl,j}.ind(end));
                tubes_iou{icl,j}.ind=[tubes_iou{icl,j}.ind,leerank{icl,i}.index(inda,2)];
                
                index2=[];
                index2=find([B_det{icl,i+1}.index]==tubes_iou{icl,j}.ind(end));
                tubes_iou{icl,j}.res=[tubes_iou{icl,j}.res;i+1 0 B_det{icl,i+1}(index2).coord];
                bb1=B_det{icl,i}(index1).coord;
                
                
                
            end
        end
    end
end

end

