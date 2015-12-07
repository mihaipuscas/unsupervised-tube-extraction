function [I_listf, aux12 , still12] = build_intersections(im, frame_index, B_list, intersection, intersectionk, scale_number, interval, I_listf, aux12 , still12)


area_high  = interval(scale_number).area_high;
area_low   = interval(scale_number).area_low;


still12{scale_number} = [];
si=size(im{1});
Area_image=si(1)*si(2);
%intersection 1->2
for i=1:length(frame_index)-2
    exclusion=[];   %% exclusion
    for j=1:size(B_list{i},2)
        I_listf{scale_number,i}(j).index1=j;
        aux12{scale_number,i}(j,1)=j;
        if ~isempty(B_list{i}(j).t_out)
            
            I_listf{scale_number,i}(j).index1=j;
            I_listf{scale_number,i}(j).nr_t1=length(B_list{i}(j).t_out);   %nr of trajectories bb1
            I_listf{scale_number,i}(j).area1=(B_list{i}(j).coord(3)-B_list{i}(j).coord(1))*(B_list{i}(j).coord(4)-B_list{i}(j).coord(2));
            if I_listf{scale_number,i}(j).area1/Area_image >= area_low && I_listf{scale_number,i}(j).area1/Area_image <= area_high
                I_listf{scale_number,i}(j).pass = 1;
            else
                I_listf{scale_number,i}(j).pass = 0;
            end
            
            I_listf{scale_number,i}(j).nr_t2=[];
            boxes_good=[];
            boxes_good=find(intersection{i}(j,:)==1);
            boxes_good_noex=boxes_good;
            [dd,d1,d2]=intersect(exclusion,boxes_good);    % exclusion
            boxes_good(d2)=[];
            I_listf{scale_number,i}(j).index2=boxes_good;
            if ~isempty(boxes_good)
                for k=1:length(boxes_good)
                    I_listf{scale_number,i}(j).area2(k)=(B_list{i+1}(boxes_good(k)).coord(3)-B_list{i+1}(boxes_good(k)).coord(1))*(B_list{i+1}(boxes_good(k)).coord(4)-B_list{i+1}(boxes_good(k)).coord(2));
                    I_listf{scale_number,i}(j).nr_t2(k)=length(B_list{i+1}(boxes_good(k)).t_in); %nr of trajectories bb2, intersect
                    I_listf{scale_number,i}(j).nr_i12(k)=length(intersect(B_list{i}(j).t_out,B_list{i+1}(boxes_good(k)).t_in));
                    I_listf{scale_number,i}(j).t_criteria3(k)=I_listf{scale_number,i}(j).nr_i12(k)/(I_listf{scale_number,i}(j).area1+I_listf{scale_number,i}(j).area2(k));
                end
                
                I_listf{scale_number,i}(j).b_criteria3=max(I_listf{scale_number,i}(j).t_criteria3);
                I_listf{scale_number,i}(j).index2b3=I_listf{scale_number,i}(j).index2(find(I_listf{scale_number,i}(j).t_criteria3(:)==I_listf{scale_number,i}(j).b_criteria3));
                
                exclusion=[exclusion, I_listf{scale_number,i}(j).index2b3]; %% exclusion
                
                if length(I_listf{scale_number,i}(j).index2b3)>1
                    [vsort,vindex]=sort(intersectionk{i}(j,:),'descend');
                    vals=[];
                    for iii=1:length(I_listf{scale_number,i}(j).index2b3)
                        vals(iii)=find(vindex==I_listf{scale_number,i}(j).index2b3(iii));
                    end
                    [m,vali]=min(vals);
                    I_listf{scale_number,i}(j).index2b3=I_listf{scale_number,i}(j).index2b3(vali);
                end
                
                aux12{scale_number,i}(j,7)=I_listf{scale_number,i}(j).b_criteria3;
                aux12{scale_number,i}(j,6)=I_listf{scale_number,i}(j).index2b3;
                aux12{scale_number,i}(j,8)=I_listf{scale_number,i}(j).area1;
            end
        end
    end
    
    if numel(fieldnames(I_listf{scale_number,i})) == 1
        still12{scale_number}=[still12{scale_number},i];
    end
    
end
end
