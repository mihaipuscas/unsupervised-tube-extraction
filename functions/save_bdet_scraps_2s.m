function save_bdet_scraps_2s (B_det, detindex, frame_index, pathout, ivid)

if length(detindex)<length(frame_index)
    for i=1:size(B_det,2)  % fixed here at 21:28   length(frame_index)
        B_det_single=[];
        %                         load([pathout,'temp/',num2str(ivid),'/',num2str(i),'_det.mat']);
        for j=1:size(B_det,1)
            B_det_single{j}=B_det{j,i};
        end
        
        save([pathout,'temp/',num2str(ivid),'/',num2str(i),'_det.mat'],'B_det_single')
    end
end