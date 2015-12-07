function ilist = det_inters (B_det, i , icl, nrvals)
ilist=[];
ilist.density=[];


nrvals1=nrvals;
nrvals2=nrvals;

ilist(1).density = zeros(nrvals2,nrvals1);
ilist(1).iou=zeros(nrvals2,nrvals1);


for i1=1:nrvals1
    
    ilist(i1).index1=B_det{icl,i-1}(i1).index;
    ilist(i1).index2=[];
    ilist(i1).n12=[];
    ilist(i1).crit=[];
    ilist(i1).critsort=[];
    ilist(i1).localmatch=[];
    ilist(i1).index2iou=[];
    ilist(i1).n12iou=[];
    ilist(i1).critiou=[];
    ilist(i1).critsortiou=[];
    ilist(i1).indexsortiou=[];
    
    for j1=1:nrvals2
        
        iou=IoU(B_det{icl,i-1}(i1).coord,B_det{icl,i}(j1).coord);
        ilist(1).iou(i1,j1)=iou;
        n12=[];
        ilist(i1).index2=[ilist(i1).index2,B_det{icl,i}(j1).index];
        n12=length(intersect(B_det{icl,i}(j1).t_out,B_det{icl,i-1}(i1).t_out));
        ilist(i1).n12=[ilist(i1).n12, n12];
        ilist(i1).crit=[ilist(i1).crit,(n12/(B_det{icl,i}(j1).area+B_det{icl,i-1}(i1).area))];
        ilist(1).density(i1,j1)=n12/(B_det{icl,i}(j1).area+B_det{icl,i-1}(i1).area);
        if iou>0.5
            ilist(i1).index2iou=[ilist(i1).index2iou,B_det{icl,i}(j1).index];
            ilist(i1).n12iou=[ilist(i1).n12iou, n12];
            ilist(i1).critiou=[ilist(i1).critiou,(n12/(B_det{icl,i}(j1).area+B_det{icl,i-1}(i1).area))];    
        end
        
    end
    
    I=[];
    [ilist(i1).critsort,I]=sort(ilist(i1).crit,'descend');
    ilist(i1).indexsort=ilist(i1).index2(I);
    
    I=[];
    [ilist(i1).critsortiou,I]=sort(ilist(i1).critiou,'descend');
    ilist(i1).indexsortiou=ilist(i1).index2iou(I);
end



for i1 = 1: nrvals1
    for j1 = 1: nrvals2
        if ~ilist(1).density(i1,j1)
            
            n12=length(intersect(B_det{icl,i}(j1).t_out,B_det{icl,i-1}(i1).t_out));
            ilist(1).density(i1,j1)=n12/(B_det{icl,i}(j1).area+B_det{icl,i-1}(i1).area);
            
        end
    end
end
end




