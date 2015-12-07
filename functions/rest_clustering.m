function cltr = rest_clustering (track,B_det,icl)



frame_index=zeros(size(B_det));
track_expanded=zeros(size(track,2),length(frame_index)); 
track_index=zeros(size(track,2),length(frame_index));
track_link=zeros(size(track,2));

for i=1:size(track,2)
    k=1;ok=1;
    track(i).coord=[];
    if ~isempty(track(i).pt)
        l=size(track(i).pt,2)-1;
        track(i).coord=[];
        for j=track(i).pt(1):track(i).pt(1)+size(track(i).pt,2)-2
            indd=find([B_det{icl,j}.index]==track(i).pt(j-track(i).pt(1)+2));
            track(i).coord=vertcat(track(i).coord,B_det{icl,j}(indd).coord);
        end
        
        if l>2
            while ok
                if ~track_expanded(k,track(i).pt(1))
                    track_expanded(k,track(i).pt(1):track(i).pt(1)+l-1)=track(i).pt(2:end);
                    track_index(k,track(i).pt(1):track(i).pt(1)+l-1)=i;
                    ok=0;
                else
                    k=k+1;
                end
            end
        end
        
    end
end


bb=[];
for i=1:length(frame_index)-1
    
    box_index=[];tr_index=[];box_coord=[];
    box_index=track_expanded(find(track_expanded(:,i)>0),i);
    if ~isempty(box_index)
        tr_index=track_index(find(track_index(:,i)>0),i);
        for j=1:length(box_index)
            box_ind(j)=find([B_det{icl,i}.index]==box_index(j));
        end
        for j=1:length(box_index)
            box_coord=vertcat(box_coord,B_det{icl,i}(box_ind(j)).coord);
        end
        
        overlap=0.65;
        clusters(i).struct=RectangleClustering_avemin(box_coord,box_index,tr_index,overlap);
        for j=1:size(clusters(i).struct,2)
            cntr=[];bb2=[];
            cntr=clusters(i).struct(j).centroid;
            bb2=clusters(i).struct(j).sel;
            bb=vertcat(bb,[i 1 bb2]);
        end
        
    else
        bb=vertcat(bb,[i 1 0 0 0 0]);
    end
    
    
end

for i=1:size(clusters,2)
    for j=1:size(clusters(i).struct,2)
        combi=[];
        combi=combnk(clusters(i).struct(j).tracks,2);
        for k=1:size(combi,1)
            track_link(combi(k,1),combi(k,2))=1;
            track_link(combi(k,2),combi(k,1))=1;
        end
    end
end

tClusters=TrackClustering(track_link);

kicl=0;
for licl=1:size(tClusters,2)
    if(size(tClusters(licl).tracks,1)>2)
        kicl=kicl+1;
        tracklets=[];
        tracklets=tClusters(licl).tracks;
        cltr(kicl).track_exp=zeros(size(tracklets,1),length(frame_index)); %put them in a matrix, length > 3
        cltr(kicl).track_i=zeros(size(tracklets,1),length(frame_index));
        for i=1:size(tracklets,1)
            kt=tracklets(i);
            k=1;ok=1;
            if ~isempty(track(kt).pt)
                l=size(track(kt).pt,2)-1;
                
                
                if l>2
                    while ok
                        if ~cltr(kicl).track_exp(k,track(kt).pt(1))
                            cltr(kicl).track_exp(k,track(kt).pt(1):track(kt).pt(1)+l-1)=track(kt).pt(2:end);
                            cltr(kicl).track_i(k,track(kt).pt(1):track(kt).pt(1)+l-1)=kt;
                            ok=0;
                        else
                            k=k+1;
                        end
                    end
                end
                
            end
        end
        
        
        
        cltr(kicl).bb=[];
        for i=1:length(frame_index)-1
            box_index=[];tr_index=[];box_coord=[];box_ind=[];
            box_index=cltr(kicl).track_exp(find(cltr(kicl).track_exp(:,i)>0),i);
            
            if ~isempty(box_index)
                tr_index=cltr(kicl).track_i(find(cltr(kicl).track_i(:,i)>0),i);
                for j=1:length(box_index)
                    box_ind(j)=find([B_det{icl,i}.index]==box_index(j));
                end
                for j=1:length(box_index)
                    box_coord=vertcat(box_coord,B_det{icl,i}(box_ind(j)).coord);
                end
                
                overlap=0.65;
                cltr(kicl).clusters(i).struct=RectangleClustering_avemin(box_coord,box_index,tr_index,overlap);
                
                for j=1:size(cltr(kicl).clusters(i).struct,2)
                    cntr=[];bb2=[];
                    cntr=cltr(kicl).clusters(i).struct(j).centroid;
                    bb2=cltr(kicl).clusters(i).struct(j).sel;
                    cltr(kicl).bb=vertcat(cltr(kicl).bb,[i 1 bb2]);
                end

            else
                cltr(kicl).bb=vertcat(cltr(kicl).bb,[i 1 0 0 0 0]);
            end
        end
    end
end


if exist('cltr','var')
    for i=1:length(frame_index)-1
        for j=1:size(cltr,2)
            if i<= size(cltr(j).clusters,2) && ~isempty(cltr(j).clusters(i).struct)
                bb=[];bbavg=[];
                
                cltr(j).clusters(i).avgsel=bb;
                
                for k=1:size(cltr(j).clusters(i).struct,2)
                    bb=vertcat(bb,cltr(j).clusters(i).struct(k).sel);
                end
                if size(bb,1)>1
                    cltr(j).clusters(i).avgsel=mean(bb);
                else
                    cltr(j).clusters(i).avgsel=bb;
                end
                
                
                
            end
        end
    end
    
    
    
    for licl=1:size(cltr,2)
        cltr(licl).length=0;
        cltr(licl).start=0;
        cltr(licl).end=0;
        
        
        bb=[];
        bb=cltr(licl).bb;
        for jcl= 1 : size(cltr(licl).clusters,2)
            if ~isempty(cltr(licl).clusters(jcl).avgsel)
                if ~cltr(licl).length
                    cltr(licl).start=jcl;
                    cltr(licl).length=cltr(licl).length+1;
                else
                    cltr(licl).length=cltr(licl).length+1;
                end
            end
        end
        cltr(licl).end=cltr(licl).start+cltr(licl).length-1;
        
        
    end
else
    cltr=[];
end



end

