function cltr = build_optiflow_chains(datastruct, opt)
% builds optical flow tubes, on different scales
% --------------------------------------------------------
% Unsupervised Tube Extraction
% Copyright (c) 2015, Mihai Puscas
% Licensed under The MIT License [see LICENSE for details]
% -------------------------------------------------------- 

frame_index = datastruct.frame_index;
scale_interval(1).area_high = opt.area_max;
scale_interval(1).area_low  = opt.area_min*10;
scale_interval(2).area_high = opt.area_max;
scale_interval(2).area_low  = opt.area_min;

dens_list = [];
dens_aux  = [];
still12   = [];

if opt.multiscale
    for i = 1 : size(scale_interval,2)
        cltr{i} = scale_optiflow(datastruct, frame_index, opt, scale_interval, i);
        
        
    end
else
    cltr{1} = scale_optiflow(datastruct, frame_index, opt, scale_interval, 1);
end



display('Finished optiflow tubes...');
end


