function [nmsdet11,nmsdet22,nmsdet,resbox,tubes_dens,tubes_iou] = loadtubes(path1,path2)


nmsdet11=[];
nmsdet22=[];
nmsdet=[];
resbox=[];
tubes_dens=[];
tubes_iou=[];

if exist(path1,'file')
load(path1);
end

if exist(path2,'file')
load(path2);
end