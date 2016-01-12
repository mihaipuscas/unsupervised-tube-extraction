function detection_tubes(path, opt, datastruct, ivid , mean_norm, featall, cltr,scale)

resbox = [];            % first detection tube, highest scoring boxes over all detectors
nmsdet = [];            % first stage detection tubes,  highest scoring boxes over each detector

nmsdet11 = [];          % second stage detection tube - type 1. The highest 'nrvals' scoring
% boxes over each detector computed in the first
% stage are clustered using the full optiflow
% algorithm

nmsdet22 = [];          % second stage detection tube - type 2. The highest 'nrvals' scoring
% boxes are clustered up to the track stage of the
% optiflow pipeline. On average, this stage will
% output -> 'n' tubes


tubes_iou  = [];        % the highest 'nrvals' scoring boxes are linked by selecting the pair
% with the highest Intersection over Union

tubes_dens = [];        % the highest 'nrvals' scoring boxes are linked by selecting the pair
% with the highest density


path.output_scale = [path.output,'/',num2str(scale),'/'];

if ~exist([path.output_scale],'dir')
    mkdir([path.output_scale]);
end


if exist([path.output_scale,num2str(ivid,'%04i'),'_test_naf_',num2str(opt.peak_select),'.mat'],'file')
    load([path.output_scale,num2str(ivid,'%04i'),'_test_naf_',num2str(opt.peak_select),'.mat']);
end

if exist([path.output_scale,num2str(ivid,'%04i'),'_test_tubes_',num2str(opt.peak_select),'.mat'],'file')
    load([path.output_scale,num2str(ivid,'%04i'),'_test_tubes_',num2str(opt.peak_select),'.mat']);
end

if exist([path.output_scale,num2str(ivid,'%04i'),'_cache_',num2str(opt.peak_select),'.mat'],'file')
    load([path.output_scale,num2str(ivid,'%04i'),'_cache_',num2str(opt.peak_select),'.mat']);
end





% compute first stage detectors and the first tube

if isempty(nmsdet)

    [W,B,~,feattube] = train_tube_svm (cltr, datastruct.im, featall, opt.target_norm, mean_norm);
    [nmsdet, resbox, B_detall, B_det]     = initial_detection_tubes(path, opt, ivid, featall, datastruct.im, cltr, feattube, W, B);
    
    % save first stage results and cache to disk
    save([path.output_scale,num2str(ivid,'%04i'),'_test_naf_',num2str(opt.peak_select),'.mat'],'resbox')
    display([path.output_scale,num2str(ivid,'%04i'),'_test_naf_',num2str(opt.peak_select),'.mat'])
    save([path.output_scale,num2str(ivid,'%04i'),'_test_tubes_',num2str(opt.peak_select),'.mat'],'nmsdet')
    display([path.output_scale,num2str(ivid,'%04i'),'_test_tubes_',num2str(opt.peak_select),'.mat'])
    save([path.output_scale,num2str(ivid,'%04i'),'_cache_',num2str(opt.peak_select),'.mat'],'W','B','B_detall','B_det')
    display([path.output_scale,num2str(ivid,'%04i'),'_cache_',num2str(opt.peak_select),'.mat']);
    
end


% IoU and density tubes
% Region proposals with a score higher than 0 are linked by the highest
% density/ Intersection over Union.
% Largest number of proposals, and least accurate.

[B_det, B_detall, Idet1, Idet, nrvals,  n] = build_detection_datastruct(datastruct, path, opt, mean_norm, ivid, featall, W, B);

if isempty(tubes_dens)
    display('Computing density tubes');
    tubes_dens = density_tubes(Idet,B_det);
    save([path.output_scale,num2str(ivid,'%04i'),'_test_tubes_',num2str(opt.peak_select),'.mat'],'tubes_dens','-append')
    display([path.output_scale,num2str(ivid,'%04i'),'_test_tubes_',num2str(opt.peak_select),'.mat'])
end

if isempty(tubes_iou)
    display('Computing iou tubes');
    tubes_iou = iou_tubes(Idet1,B_det);
    save([path.output_scale,num2str(ivid,'%04i'),'_test_tubes_',num2str(opt.peak_select),'.mat'],'tubes_iou','-append')
    display([path.output_scale,num2str(ivid,'%04i'),'_test_tubes_',num2str(opt.peak_select),'.mat'])
end


if opt.secstage && ~(opt.secms == 0 && scale > 1)
    
    display('Computing second stage detection tubes');
    %
    % second stage detection tubes I - highest scoring region proposals of
    % each detector are clustered using the full optiflow clustering
    % pipeline and then used to build new detectors
    if isempty(nmsdet11)
        
        tic
        [nmsdet11,resbox11] =  second_stagedet_full(Idet,B_det,datastruct.im,nrvals,featall,opt.target_norm,mean_norm);
        toc
        save([path.output_scale,num2str(ivid,'%04i'),'_test_tubes_',num2str(opt.peak_select),'.mat'],'nmsdet11','resbox11','-append')
        display([path.output_scale,num2str(ivid,'%04i'),'_test_tubes_',num2str(opt.peak_select),'.mat'])
    end
    
    %
    % second stage detection tubes II- highest scoring region proposals of
    % each detector are clustered using the optiflow clustering
    % pipeline up to building "tracks" and then used to build new detectors
    if isempty(nmsdet22)
        tic
        [nmsdet22,resbox22,~] = second_stagedet1_full(Idet,B_det,datastruct.im,nrvals,n,featall,opt.target_norm,mean_norm);
        toc
        save([path.output_scale,num2str(ivid,'%04i'),'_test_tubes_',num2str(opt.peak_select),'.mat'],'nmsdet22','resbox22','-append')
        display([path.output_scale,num2str(ivid,'%04i'),'_test_tubes_',num2str(opt.peak_select),'.mat'])
    end
    
end


