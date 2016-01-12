function build_bdet_scraps_2s (B_det, detindex, frame_index, pathout, ivid)

if length(detindex)<length(frame_index)
    for i=1:size(B_det,2)  
        B_det_single=[];
        for j=1:size(B_det,1)
            B_det_single{j}=B_det{j,i};
        end
        
        save([pathout,'cache/',num2str(ivid),'/',num2str(i),'_det.mat'],'B_det_single')
    end
end