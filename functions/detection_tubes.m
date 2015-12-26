function detection_tubes(path, opt, datastruct, ivid , mean_norm, featall, cltr,scale)

T_list = datastruct.T_list;
[W,B,~,feattube] = train_tube_svm (cltr, datastruct.im, featall, opt.target_norm, mean_norm);
[nmsdet, resbox, B_detall, B_det]     = initial_detection_tubes(path, opt, ivid, featall, datastruct.im, cltr, feattube, W, B);

if ~exist([path.output,'/',num2str(scale),'/'],'dir')
    mkdir([path.output,'/',num2str(scale),'/']);
end


save([path.output,'/',num2str(scale),'/',num2str(ivid,'%04i'),'_test_naf_',num2str(opt.peak_select),'.mat'],'resbox')
display([path.output,'/',num2str(scale),'/',num2str(ivid,'%04i'),'_test_naf_',num2str(opt.peak_select),'.mat'])
save([path.output,'/',num2str(scale),'/',num2str(ivid,'%04i'),'_test_tubes_',num2str(opt.peak_select),'.mat'],'nmsdet') 
display([path.output,'/',num2str(scale),'/',num2str(ivid,'%04i'),'_test_tubes_',num2str(opt.peak_select),'.mat'])

frame_index = datastruct.frame_index;


% second stage detectors

detindex_traj=dir([path.output,'/',num2str(scale),'/','temp/',num2str(ivid),'/','*_det_traj.mat']);
detallindex=dir([path.output,'/',num2str(scale),'/','temp/',num2str(ivid),'/','*_detall.mat']);


[B_det, B_detall, Idet1, Idet, nrvals,  n] = build_detection_datastruct(datastruct, path, opt, mean_norm, ivid, featall, W, B);





display('Computing density tubes');
tubes_dens = density_tubes(Idet,B_det);
save([path.output,'/',num2str(scale),'/',num2str(ivid,'%04i'),'_test_tubes_',num2str(opt.peak_select),'.mat'],'tubes_dens','-append')
display([path.output,'/',num2str(scale),'/',num2str(ivid,'%04i'),'_test_tubes_',num2str(opt.peak_select),'.mat'])


display('Computing iou tubes');
tubes_iou = iou_tubes(Idet1,B_det);
save([path.output,'/',num2str(scale),'/',num2str(ivid,'%04i'),'_test_tubes_',num2str(opt.peak_select),'.mat'],'tubes_iou','-append')
display([path.output,'/',num2str(scale),'/',num2str(ivid,'%04i'),'_test_tubes_',num2str(opt.peak_select),'.mat'])


%
%
tic
[nmsdet11,resbox11] =  second_stagedet_full(Idet,B_det,datastruct.im,nrvals,featall,opt.target_norm,mean_norm);
toc
save([path.output,'/',num2str(scale),'/',num2str(ivid,'%04i'),'_test_tubes_',num2str(opt.peak_select),'.mat'],'nmsdet11','resbox11','-append')
display([path.output,'/',num2str(scale),'/',num2str(ivid,'%04i'),'_test_tubes_',num2str(opt.peak_select),'.mat'])

%
%
tic
[nmsdet22,resbox22,cltr1] = second_stagedet1_full(Idet,B_det,datastruct.im,nrvals,n,featall,opt.target_norm,mean_norm);
toc
save([path.output,'/',num2str(scale),'/',num2str(ivid,'%04i'),'_test_tubes_',num2str(opt.peak_select),'.mat'],'nmsdet22','resbox22','cltr1','n','-append')
display([path.output,'/',num2str(scale),'/',num2str(ivid,'%04i'),'_test_tubes_',num2str(opt.peak_select),'.mat'])


