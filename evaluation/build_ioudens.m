function [tubes, number] = build_ioudens(nmsdet,order, tubes, number)

nr=0;

for k=1:size(nmsdet,1)
    for j=1:size(nmsdet,2)
        if ~isempty(nmsdet{k,j})
            for i=1:size(nmsdet{k,j}.res,1)
                nmsdet{k,j}.res(i,2)=order;
                tubes{i}=[tubes{nmsdet{k,j}.res(i,1)};nmsdet{k,j}.res(i,:)];
            end
            nr=nr+1;
        end
    end
end


number = [number,number(end)+nr];


end
