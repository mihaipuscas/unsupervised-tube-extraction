clear all

path_new = 'videoyoutube_shots_resized/';
addpath(genpath('/home/duba/mihai/duba_dep'));
addpath('/home/duba/mihai/duba_dep/dependencies');
addpath(genpath('./functions'));

%path_new = '/media/kellanved/01D0058246D86AE0/yt/youtube_shots_resized/';
%load ('videos_test.mat','videos');
load('/home/mihai/video_batches/videos_batch0.mat');






speed = 2;  % selective search speed; 1=slow, 2=fast;

cutoff_overlap= 0.5;
cutoff_frame=0.95;
cutoff_frame_low=0.0005;

traj_filename='/*impdt11.txt';


parpool(14);


%% selective search box output

parfor ivid=1:length(videos)
    try
        
        parafun(path_new, videos, ivid, speed, cutoff_overlap, cutoff_frame_low, cutoff_frame, traj_filename);
        
    catch err
        
        
        
        
        
        fid = fopen('logFileyoutube_batch3int','a+');
        fprintf(fid,'%s\n','------======------')
        fprintf(fid,'%s\n',['Eroare la ivid = ',num2str(ivid)])
        fprintf(fid,'%s\n',err.message);
        
        for e=1:length(err.stack)
            fprintf(fid,'in %s at line %i\n',err.stack(e).name,err.stack(e).line);
        end
        fclose(fid);
        display(['error at ', num2str(ivid)])
    end
    
    
    
    
end
