function [I_listf, aux12 , still12] = build_intersect(datastruct, frame_index, scale_interval, sci)



ahigh  = scale_interval(sci).area_high;
alow = scale_interval(sci).area_low;

    


still12=[];
si=size(datastruct.im{1});
Area_datastruct.image=si(1)*si(2);
%datastruct.intersection 1->2
for i=1:length(frame_index)-2
    exclusion=[];   %% exclusion
    for j=1:size(datastruct.B_list{i},2)
        I_listf{i,i+1}(j).index1=j;
        aux12{i}(j,1)=j;
        if ~isempty(datastruct.B_list{i}(j).t_out)
            
            I_listf{i,i+1}(j).index1=j;
            I_listf{i,i+1}(j).nr_t1=length(datastruct.B_list{i}(j).t_out);   %nr of trajectories bb1
            I_listf{i,i+1}(j).area1=(datastruct.B_list{i}(j).coord(3)-datastruct.B_list{i}(j).coord(1))*(datastruct.B_list{i}(j).coord(4)-datastruct.B_list{i}(j).coord(2));
            if I_listf{i,i+1}(j).area1/Area_datastruct.image >= alow && I_listf{i,i+1}(j).area1/Area_datastruct.image <= ahigh
                I_listf{i,i+1}(j).pass = 1;
            else
                I_listf{i,i+1}(j).pass = 0;
            end

            I_listf{i,i+1}(j).nr_t2=[];
            boxes_good=[];
            boxes_good=find(datastruct.intersection{i}(j,:)==1);
            boxes_good_noex=boxes_good;
            [dd,d1,d2]=intersect(exclusion,boxes_good);    % exclusion
            boxes_good(d2)=[];
            I_listf{i,i+1}(j).index2=boxes_good;
            if ~isempty(boxes_good)
                for k=1:length(boxes_good)
                    I_listf{i,i+1}(j).area2(k)=(datastruct.B_list{i+1}(boxes_good(k)).coord(3)-datastruct.B_list{i+1}(boxes_good(k)).coord(1))*(datastruct.B_list{i+1}(boxes_good(k)).coord(4)-datastruct.B_list{i+1}(boxes_good(k)).coord(2));
                    I_listf{i,i+1}(j).nr_t2(k)=length(datastruct.B_list{i+1}(boxes_good(k)).t_in); %nr of trajectories bb2, intersect
                    I_listf{i,i+1}(j).nr_i12(k)=length(intersect(datastruct.B_list{i}(j).t_out,datastruct.B_list{i+1}(boxes_good(k)).t_in));
                    I_listf{i,i+1}(j).t_criteria3(k)=I_listf{i,i+1}(j).nr_i12(k)/(I_listf{i,i+1}(j).area1+I_listf{i,i+1}(j).area2(k));    
                end
                
                I_listf{i,i+1}(j).b_criteria3=max(I_listf{i,i+1}(j).t_criteria3);
                I_listf{i,i+1}(j).index2b3=I_listf{i,i+1}(j).index2(find(I_listf{i,i+1}(j).t_criteria3(:)==I_listf{i,i+1}(j).b_criteria3));
                
                exclusion=[exclusion, I_listf{i,i+1}(j).index2b3]; %% exclusion
                
                if length(I_listf{i,i+1}(j).index2b3)>1
                    [vsort,vindex]=sort(datastruct.intersectionk{i}(j,:),'descend');
                    vals=[];
                    for iii=1:length(I_listf{i,i+1}(j).index2b3)
                        vals(iii)=find(vindex==I_listf{i,i+1}(j).index2b3(iii));
                    end
                    [m,vali]=min(vals);
                    I_listf{i,i+1}(j).index2b3=I_listf{i,i+1}(j).index2b3(vali);
                end
                
                aux12{i}(j,7)=I_listf{i,i+1}(j).b_criteria3;
                aux12{i}(j,6)=I_listf{i,i+1}(j).index2b3;
                aux12{i}(j,8)=I_listf{i,i+1}(j).area1;
            end
        end      
    end
    
    if numel(fieldnames(I_listf{i,i+1})) == 1
        still12=[still12,i];
    end
    
end


end
