function Idet1 = build_idet(ivid, frame_index, pathout, nrvals)

for i=1:length(frame_index)
    display(['At frame ',num2str(i)]);
    Idet_single=[];
    B_det=[];
    if i>1
        for kd=i-1:i
            B_det_single_traj=[];
            load([pathout,'temp/',num2str(ivid),'/',num2str(kd),'_det_traj.mat']);
            for kdd=1:size(B_det_single_traj,1)
                B_det{kdd,kd}=B_det_single_traj{kdd,kd};
            end
        end
        
        for icl=1:size(B_det,1)
            
            tic
            Idet1{icl,i-1}=det_inters (B_det, i , icl, nrvals(icl));
            Idet_single{icl}=Idet1{icl,i-1};
            toc
            
        end
        save([pathout,'temp/',num2str(ivid),'/',num2str(i),'_idet.mat'],'Idet_single','i')
    end
end