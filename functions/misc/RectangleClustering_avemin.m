% boxes contains *all* the rectangles whose density is higher than the
% threshold (e.g., after the "first peak").
% selected_rectangles will contain the selected rectangles.
% boxes(:,1) contain the y-coordinates of the top corners
% boxes(:,2) contain the x-coordinates of the top corners
% boxes(:,3) contain the y-coordinates of the bottom corners
% boxes(:,4) contain the x-coordinates of the bottom corners


function sepcl = RectangleClustering_avemin(boxes,index,tr_index,overlap)


% Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


n= size(boxes,1);
connected= zeros(n);
marked= zeros(n,1);

for i=1:n
    for j=i+1:n
        if IntersectOverMin(boxes(i,:), boxes(j,:)) >= overlap % It's the interesction over min and not over union !!!
            connected(i,j)= 1;
            connected(j,i)= 1;
        end
    end
end


% Graph visit and cluster building %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        

c= 1;
for i=1:n
    if marked(i) == 0
        Q= [i];
        C= [i];
        marked(i)= 1;
        
        q_indx= 1;
        while q_indx <= length(Q)
            k= Q(q_indx);
            q_indx= q_indx + 1;
            
            for j=1:n
                if connected(k,j) && ~marked(j) 
					Q= [Q; j];
                    C= [C; j];
					marked(j)= 1;
				end 
            end 
        end
		Clusters{c}= C;
        c= c + 1;
    end 
end
            


% For each cluster choose the average size rectangle %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

selected_rectangles= NaN(length(Clusters), 4);
for c=1:length(Clusters)
%      figure(c),imshow(im{14})
    sepcl(c).coord=[];
    sepcl(c).index=[];
    sepcl(c).sel=[];
    sepcl(c).tracks=[];
    sepcl(c).centroid=[];
    
    clear b1 b2 b3 b4

    
    
    C= Clusters{c};
    % compute the areas of all the rectangles in the current cluster ---------
    l= length(C);
    for i=1:l
        k= C(i);
        b1(i)= boxes(k,1);        
        b2(i)= boxes(k,2);        
        b3(i)= boxes(k,3);        
        b4(i)= boxes(k,4);  
        sepcl(c).coord=vertcat(sepcl(c).coord,boxes(k,:));
        sepcl(c).index=[sepcl(c).index,index(k)];
        sepcl(c).tracks=[sepcl(c).tracks,tr_index(k)];

    end
    sepcl(c).sel=[mean(b1), mean(b2), mean(b3), mean(b4)];
    sepcl(c).centroid=[mean(b3)-mean(b1), mean(b4)-mean(b2)];

end
        

end