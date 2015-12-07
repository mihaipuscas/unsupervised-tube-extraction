function [dens_list, dens_aux , still12] = build_pairings(im, frame_index, B_list, intersection, intersectionk, opt)


interval(1).area_high = opt.area_max;
interval(1).area_low  = opt.area_min*10;
interval(2).area_high = opt.area_max;
interval(2).area_low  = opt.area_min;

dens_list = [];
dens_aux  = [];
still12   = [];

if opt.multiscale
    for i = 1 : size(interval,2)
        [dens_list, dens_aux , still12] = build_intersections(im, frame_index, B_list, intersection, intersectionk, i, interval, dens_list, dens_aux , still12);
    end
else
    [dens_list, dens_aux , still12] = build_intersections(im, frame_index, B_list, intersection, intersectionk, 1, interval, dens_list, dens_aux , still12);
end



end
