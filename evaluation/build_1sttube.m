function [tubes, number] = build_1sttube(resbox,order, tubes, number)


for i=1:size(resbox,1)
        resbox(i,2)=order;
        tubes{resbox(i,1)}=[tubes{i};resbox(i,:)];
end

if isempty(number)
    number(1)=1;
else
    number = [number,number(end)+1];
end

end
