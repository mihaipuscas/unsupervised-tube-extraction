function [tubes, number] = build_2nd(nmsdet,order, tubes, number)

nr=0;


for k=1:size(nmsdet,2)
    for j=1:size(nmsdet{k},2)
        if ~isempty(nmsdet) && isfield(nmsdet{1},'tube')
            for i=1:size(nmsdet{k}(j).resbox,1)
                nmsdet{k}(j).resbox(i,2)=order;
                tubes{nmsdet{k}(j).resbox(i,1)}=[tubes{i};nmsdet{k}(j).resbox(i,:)];
            end
            nr=nr+1;
        end
    end
end


number = [number,number(end)+nr];


end
