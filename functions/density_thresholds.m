function [crit_thresholds_f,crit_frames_f]=density_thresholds(I_listf,opt,still12)

% builds local density threshold for each pair of consecutive frames in a
% video
% --------------------------------------------------------
% Unsupervised Tube Extraction
% Copyright (c) 2015, Mihai Puscas
% Licensed under The MIT License [see LICENSE for details]
% -------------------------------------------------------- 

nrpks = opt.peak_number;
nrvar = opt.window_smooth;




ia=1:size(I_listf,1)-1;
if ~isempty(still12)
    for ik=1:length(still12)
        ia(ia == still12(ik)) = [];
    end
end



for j=ia
    x=[];xv=[];
    for jj=1:length(I_listf{j,j+1})
        if ~I_listf{j,j+1}(jj).pass
            I_listf{j,j+1}(jj).b_criteria3=[];
        end
    end
    
    % sorts densities of all boxes in descending order
    xinit=[I_listf{j,j+1}.b_criteria3];
    [x,ix]=sort(xinit,'descend');
    
    
    
    if length(x)<=8
        nrvar=2;
        if length(x)<=4
            nrvar=1;
        end
    end
    
    if length(x)>2;
        
        % computes smoothed density variance of all box pairs in these two
        % frames
        for i=1:length(x)-nrvar
            xv(i)=var(x(i:i+1));
        end
        for i=length(x)-nrvar:length(x)
            xv(i)=var(x(i-nrvar:i));
        end
        
        % finds peaks in the density variance, selects the highest nrpks
        % peaks. if it cannot find any peaks, it lowers the minimum height
        ok=1;ko=1;kocnt=1;
        while(ok && kocnt<=4)
            
            [psor,lsor] = findpeaks(xv,'MinPeakProminence',mean(xv)/ko,'SortStr','descend');
            if ~isempty(lsor)
                
                if length(lsor)>=nrpks
                    psor=psor(1:nrpks);
                    lsor=lsor(1:nrpks);
                end
                ok=0;
            else
                ko=ko*2;
                kocnt=kocnt+1;
            end
        end
        
        % outputs the highest nrpks peaks
        crit_thresholds_f{j}=sort(x(lsor));
        crit_frames_f(j).values=xinit;
        crit_frames_f(j).avg=mean(xinit);
    else
        crit_thresholds_f{j}=mean(xinit);
        crit_frames_f(j).values=mean(xinit);
        crit_frames_f(j).avg=mean(xinit);
    end
    
    
end
crit_thresholds_f{size(I_listf,1)}=[];

