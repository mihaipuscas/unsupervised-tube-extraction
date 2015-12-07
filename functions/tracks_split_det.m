
function cltr = tracks_split_det(track,Idet,B_det,icl,n)


frame_index=zeros(size(Idet));
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




for i=1:size(track,2)
    if ~isempty(track(i).pt)
        track(i).start=track(i).pt(1);
        track(i).end=track(i).pt(1)+length(track(i).pt)-2;
        track(i).length=track(i).end-track(i).start+1;
    end
end

[length_sort,length_index]=sort([track.length],'descend')


ok=1;k=1;i=1;

while ok
    
    aa=find(length_sort==length_sort(k));
    if numel(aa) <= 1
        
        cltr(i).start=track(length_index(k)).start;
        cltr(i).end=track(length_index(k)).end;
        cltr(i).track_ind=zeros(size(track_expanded));
        cltr(i).track_ind(find(track_index==k))=k;
        cltr(i).track_e=zeros(size(track_expanded));
        cltr(i).track_e=track_expanded(find(track_index==k));
        cltr(i).bb=[];
        kk=1;
        for jj=1:length(frame_index)+1
            cltr(i).bb=[cltr(i).bb;[jj 1 0 0 0 0]];
            cltr(i).clusters(jj).avgsel=[];
            if jj>=cltr(i).start && jj<=cltr(i).end
                cltr(i).clusters(jj).avgsel=[];
                cltr(i).bb(jj,:)=[jj 1 track(length_index(k)).coord(kk,:)];
                cltr(i).clusters(jj).avgsel=[track(length_index(k)).coord(kk,:)];
                kk=kk+1;
            end
        end
        
        
        i=i+1;
        k=k+1;
    else
        
        ab=numel(aa);
        rb=randperm(ab);
        k=aa(rb(1));
        cltr(i).start=track(length_index(k)).start;
        cltr(i).end=track(length_index(k)).end;
        cltr(i).track_ind=zeros(size(track_expanded));
        cltr(i).track_ind(find(track_index==k))=k;
        cltr(i).track_e=zeros(size(track_expanded));
        cltr(i).track_e=track_expanded(find(track_index==k));
        cltr(i).bb=[];
        cltr(i).clusters=[];
        cltr(i).clusters.avgsel=[];
        cltr(i).clusters.struct=[];
        kk=1;
        for jj=1:length(frame_index)+1
            cltr(i).bb=[cltr(i).bb;[jj 1 0 0 0 0]];
            cltr(i).clusters(jj).avgsel=[];
            if jj>=cltr(i).start && jj<=cltr(i).end
                cltr(i).clusters(jj).avgsel=[];
                cltr(i).bb(jj,:)=[jj 1 track(length_index(k)).coord(kk,:)];
                cltr(i).clusters(jj).avgsel=[track(length_index(k)).coord(kk,:)];
                kk=kk+1;
            end
        end
        
        
        i=i+1;
        k=aa(end)+1;
        if k>length(length_sort)
            ok=0;
        end
        
    end
    
    if i>n
        ok=0;
    end
    
end

% 
% for i=cltr(2).start:cltr(2).end
%     figure(1), imshow(im{i});
%         bb2=cltr(2).bb(i,3:6) %track(i).coord(j-track(i).pt(1)+1,:);
%     rectangle('position',[bb2(2),bb2(1),bb2(4)-bb2(2),bb2(3)-bb2(1)],'EdgeColor','b','LineWidth',3);
%     aaa=waitforbuttonpress;
% 
% end

    








