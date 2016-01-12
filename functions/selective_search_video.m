



function selective_search_video(videos, itot, fast_mode)


        
        [pathd,name,~] = fileparts(videos(itot).name) ;

        frames=[dir([pathd,'/*.jpg']);dir([pathd,'/*.jpeg'])];
        pathwr=[pathd,'/sel_boxesfast_',num2str(fast_mode),'/']; %fast
        
        
        for i=1:length(frames)
            [~,name,~] = fileparts(frames(i).name) ;
            if ~exist([pathwr,'bnb_',name,'.mat'],'file')
                if ~exist(pathwr, 'dir')
                    mkdir(pathwr);
                end
                im = imread([pathd,'/',frames(i).name]);
                
          
                boxes=selective_search_boxes(im,fast_mode);
           
                
                save([pathwr,'bnb_',name,'.mat'],'boxes');
                clear boxes blobIndIm blobBoxes hierarchy im
                display(['i=',num2str(i),'        @ ',pathwr,'bnb_',name,'.mat']);
            end
        end
end
