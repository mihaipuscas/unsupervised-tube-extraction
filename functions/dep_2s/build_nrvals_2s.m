function nrvals = build_nrvals_2s(ivid, B, threshold_number, pathout)

          
          % number of tubes we're looking for
          
	      detindex=dir([pathout,'temp/',num2str(ivid),'/','*_det.mat']);
          
	      nrvals=zeros(size(B,2),1);
	      for  i=1:size(detindex,1)-1
		  B_det_single=[];
		  tic
		  load([pathout,'temp/',num2str(ivid),'/',num2str(i),'_det.mat']);
		  toc
		  for icl=1:size(B,2)
		      a=[];
		      a=find([B_det_single{icl}.score]>0);
		      if ~isempty(a)
			  nrvals(icl)=max(nrvals(icl),a(end));
			  if nrvals(icl)>25
			      nrvals(icl)=25;
			  end
		      end
		  end
	      end
	      
	      save([pathout,'temp/',num2str(ivid,'%04i'),'_temp_',num2str(threshold_number),'.mat'],'nrvals','-append')
	      
end
