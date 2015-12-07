function [tubes, number] = build_1ststage(nmsdet,order, tubes, number)

nr=0;

for j=1:size(nmsdet,2)
    for i=1:size(nmsdet(j).resbox,1)
        nmsdet(j).resbox(i,2)=order;
        tubes{nmsdet(j).resbox(i,1)}=[tubes{i};nmsdet(j).resbox(i,:)];
    end
    nr=nr+1;
end


number = [number,number(end)+nr];


end
