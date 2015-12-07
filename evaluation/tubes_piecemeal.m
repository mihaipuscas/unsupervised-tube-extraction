function [tubes,number,k] = tubes_piecemeal ( path_result,  videos, ivid, threshold_number)


% do we have multi scale?
results = rdir(path_result);
nr = size(results,1);

for i=1:nr
    

path1{i}=[results(i).name,'/',num2str(ivid,'%04i'),'_test_naf_',num2str(threshold_number),'.mat'];
path2{i}=[results(i).name,'/',num2str(ivid,'%04i'),'_test_tubes_',num2str(threshold_number),'.mat'];
[nmsdet11{i},nmsdet22{i},nmsdet{i},resbox{i},tubes_dens{i},tubes_iou{i}] = loadtubes(path1{i},path2{i});

end






[pathstr,~,~] = fileparts(videos(ivid).name);
frame_index=[];
frame_index=[rdir([pathstr,'/*.jpeg']);rdir([pathstr,'/*.jpg'])];

for i=1:length(frame_index)
    tubes{i}=[];
end

number=[];

k=1;

for i=1:nr
    % first tubes
    [tubes, number] = build_1sttube(resbox{i}, k, tubes, number);
    k=k+1;
end
for i=1:nr
    % first stage tubes
    [tubes, number] = build_1ststage(nmsdet{i}, k, tubes, number);
    k=k+1;
end


% we evaluated the second stage detectors on a single scale
nr=1;
for i=1:nr
% second stage full
[tubes, number] = build_2nd(nmsdet11{i}, k, tubes, number);
k=k+1;
end

for i=1:nr
[tubes, number] = build_2nd(nmsdet22{i}, k, tubes, number);
k=k+1;
end


% ioudens
for i=1:nr
[tubes, number] = build_ioudens(tubes_dens{i}, k, tubes, number);
k=k+1;
end

for i=1:nr
[tubes, number] = build_ioudens(tubes_iou{i}, k, tubes, number);
k=k+1;
end



end





