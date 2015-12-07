
function eval = eval_ucf(videos, opt)

path.dataset = '/media/kellanved/HDD Extern 2/work_archive/tubelets/datasets/ucf_last_process/selection_proc_last/';


% results
path_result='./evaluation/ucf_sports_results/';

% ground truth
GTO='./evaluation/ucf_annotation/';

kk=0;

intest=[6;7;8;9;10;11;12;13;14;21;22;23;24;25;26;27;28;29;30;31;32;39;40;41;42;43;44;45;46;47;48;49;50;51;52;55;56;57;58;63;64;65;66;67;68;69;70;75;76;77;78;79;80;81;82;83;88;89;90;91;92;93;94;95;103;104;105;106;107;108;109;110;111;112;113;114;115;120;121;122;123;124;125;126;127;128;137;138;139;140;141;142;143;144;145;146;147;148;149;150]';
tubes = [];
GT =[];

for ivid=intest
    kk=kk+1;
    [tubes{kk},number{kk},n_stages] = tubes_piecemeal (path_result, videos, ivid, opt.peak_select);
    GT{kk} = gt_piecemeal(GTO,ivid);
end

n_stages = 8;


for k=1:n_stages
    
    n_objts= 0;
    mBAO= 0;
    n_tot_tubes= 0;
    n_corr_objts= 0;
    key=0;
    
    for v = 1:length(GT)
        
        
        m= number{v}(k);
        n_objts = n_objts +1;
        ov =[]; mtube = [];
        
        for nr = 1:length(GT{v}.frames)
            
            
            fr  = GT{v}.frames(nr);
            bb  = GT{v}.BBn(nr,:);
            res = tubes{v}{fr}(1:m,:);
            
            for nrtubes = 1:size(res,1)
                ov(nrtubes,nr) = IoU(bb,res(nrtubes,3:6));
            end
        end
        
        mtube = mean(ov');
        
        mBAO = mBAO + max(mtube);
        mb(v) = max(mtube);
        if max(mtube) >= 0.5
            n_corr_objts =n_corr_objts+1;
        end
        
        n_tot_tubes = n_tot_tubes + number{v}(k);
        
        
    end
    
    
    eval.mBAO(k)= mBAO / n_objts;
    eval.CorLoc(k)= n_corr_objts  / n_objts;
    eval.n_tot_tubes(k)= n_tot_tubes / n_objts;
    
    display(['Stage ', num2str(k)])
    display(['N. average used tubes = ', num2str(eval.n_tot_tubes(k))])
    display([' mBAO = ', num2str(eval.mBAO(k))]);
    display([' CorLoc = ', num2str(eval.CorLoc(k))])
    
end

end