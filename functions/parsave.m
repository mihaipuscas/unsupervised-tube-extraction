function parsave(fname,varargin)
	numvars=numel(varargin);
	for i=1:numvars
	   eval([inputname(i+1),'=varargin{i};']);  
	end
	save('-mat',fname,inputname(2),'-v7.3');
	for i = 2:numvars    
		save('-mat',fname,inputname(i+1),'-append','-v7.3');
	end
end