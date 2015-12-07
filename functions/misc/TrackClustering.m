% INPUT: connected is an N X N boolean matrix, representing the adjacency matrix
% of a graph in which tracks i and j are connected iff connected(i,j) = 1
% OUTPUT: Clusters{c} is the c-th final tube and contains the *indexes* of
% the tracks grouped in cluster c


function Clusters = TrackClustering(connected)



n= size(connected,1);
marked= zeros(n,1);


% Graph visit and cluster building %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        

c= 1;
for i=1:n
    if marked(i) == 0
        Clusters(c).tracks=[];
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
		Clusters(c).tracks= C;
        c= c + 1;
    end 
end
            


end