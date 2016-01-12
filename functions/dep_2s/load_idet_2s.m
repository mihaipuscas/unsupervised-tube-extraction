function Idet1 = load_idet_2s (idetindex, pathout, ivid)

for i=2:length(idetindex)+1
    Idet_single=[];
    load([pathout,'cache/',num2str(ivid),'/',num2str(i),'_idet.mat'],'Idet_single')
    for icl=1:size(Idet_single,2)
        Idet1{icl,i-1}=Idet_single{icl};
    end
end