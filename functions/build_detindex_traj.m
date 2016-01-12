function B_detall = build_detindex_traj(B_detall, nrvals, ivid, threshold_number, detindex, T_list, im, pathout)    

% detection boxes trajectory intersection

for i=1:length(detindex)
    display(['At frame ',num2str(i)]);
    B_det_single=[];
    B_det_single_traj=[];
    load([pathout,'cache/',num2str(ivid),'/',num2str(i),'_det.mat']);
    
    b=B_detall{i};
    for icl=1:size(B_det_single,2)   %-2 bug, -1 true
        tic
        a=[];b=B_detall{i};
        [a,b]=det_trajintersect(nrvals(icl),B_det_single{icl},T_list,b,i,im);
        B_det_single_traj{icl,i}=a;
        B_detall{i}=b;
        toc
        
    end
    
    
    B_detall_single_traj=B_detall{i};
    save([pathout,'cache/',num2str(ivid),'/',num2str(i),'_det_traj.mat'],'B_det_single_traj','i')
    save([pathout,'cache/',num2str(ivid),'/',num2str(i),'_detall_traj.mat'],'B_detall_single_traj','i')
    
    
end

save([pathout,'cache/',num2str(ivid,'%04i'),'_cache_',num2str(threshold_number),'.mat'],'B_detall','nrvals','-append')
end
