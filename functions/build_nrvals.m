function nrvals = build_nrvals(ivid, B_det, path, opt)


% number of tubes we're looking for

detindex=dir([path.output,'temp/',num2str(ivid),'/','*_det.mat']);

nrvals=zeros(size(B_det,1),1);
for  i = 1 : size(B_det,2)
    for icl = 1 : size(B_det,1)
        a=[];
        a=find([B_det{icl,i}.score]>0);
        if ~isempty(a)
            nrvals(icl)=max(nrvals(icl),a(end));
            if nrvals(icl) > 25
                nrvals(icl) = 25;
            end
        end
    end
end

if ~exist([path.output,'temp/'],'dir')
    mkdir([path.output,'temp/']);
end

save([path.output,'temp/',num2str(ivid,'%04i'),'_temp_',num2str(opt.peak_select),'.mat'],'nrvals','-append')

end
