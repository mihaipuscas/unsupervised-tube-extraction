function [boxstruct,boxall] = det_trajintersect (nr_vals, boxstruct, T_list , boxall, i , im)



 %STOP
si=size(im{i});
all_index=[boxall.index];

if nr_vals > size(boxstruct,2)
    nr_vals = size(boxstruct,2);
end



for b1=1:nr_vals
    index=boxstruct(b1).index;
    
    if index == -1
        
        kfra=frame_overlap(boxstruct(b1).coord,si(1:2));
        xmin_bb1=boxstruct(b1).coord(2);
        ymin_bb1=boxstruct(b1).coord(1);
        xmax_bb1=boxstruct(b1).coord(4);
        ymax_bb1=boxstruct(b1).coord(3);
        boxstruct(b1).area=(ymax_bb1-ymin_bb1+1)*(xmax_bb1-xmin_bb1+1);
        
        for k=1:size(T_list{i},2)
            
            x_point1=T_list{i}(k).coord(1);
            y_point1=T_list{i}(k).coord(2);
            id_point1=T_list{i}(k).index;
            
%             if T_list{i}(k).pass
                if x_point1>xmin_bb1 && x_point1<xmax_bb1 && ...
                        y_point1>ymin_bb1 && y_point1<ymax_bb1 && i~=T_list{i}(k).stop
                    
                    boxstruct(b1).t_out(length(boxstruct(b1).t_out)+1)=id_point1;
                    
                    
                end
%             end
            
            
            
        end
        if ~isempty(boxstruct(b1).t_out)
            boxstruct(b1).local_density=length(boxstruct(b1).t_out)/boxstruct(b1).area;
        end
        
        
        
    else
        if isempty(boxall(index).t_out)
            
            kfra=frame_overlap(boxstruct(b1).coord,si(1:2));
            xmin_bb1=boxstruct(b1).coord(2);
            ymin_bb1=boxstruct(b1).coord(1);
            xmax_bb1=boxstruct(b1).coord(4);
            ymax_bb1=boxstruct(b1).coord(3);
            boxstruct(b1).area=(ymax_bb1-ymin_bb1+1)*(xmax_bb1-xmin_bb1+1);
            
            if size(T_list,2) >= i
                for k=1:size(T_list{i},2)
                    
                    x_point1=T_list{i}(k).coord(1);
                    y_point1=T_list{i}(k).coord(2);
                    id_point1=T_list{i}(k).index;
                    
                    %                 if T_list{i}(k).pass
                    if x_point1>xmin_bb1 && x_point1<xmax_bb1 && ...
                            y_point1>ymin_bb1 && y_point1<ymax_bb1 && i~=T_list{i}(k).stop
                        
                        boxstruct(b1).t_out(length(boxstruct(b1).t_out)+1)=id_point1;
                        boxall(index).t_out=[boxall(index).t_out, id_point1];
                        
                        
                    end
                    %                 end
                    
                    
                    
                end
                if ~isempty(boxstruct(b1).t_out)
                    boxstruct(b1).local_density=length(boxstruct(b1).t_out)/boxstruct(b1).area;
                end
            else
                boxstruct(b1).t_out=[];
                boxall(index).t_out=[];
                boxstruct(b1).local_density=[];
            end
            
        else
            
            xmin_bb1=boxstruct(b1).coord(2);
            ymin_bb1=boxstruct(b1).coord(1);
            xmax_bb1=boxstruct(b1).coord(4);
            ymax_bb1=boxstruct(b1).coord(3);
            boxstruct(b1).area=(ymax_bb1-ymin_bb1+1)*(xmax_bb1-xmin_bb1+1);
            boxstruct(b1).t_out=unique(boxall(index).t_out);
            if ~isempty(boxstruct(b1).t_out)
                boxstruct(b1).local_density=length(boxstruct(b1).t_out)/boxstruct(b1).area;
            end
        end
    end
    
end


end
