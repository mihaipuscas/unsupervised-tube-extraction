function GT = gt_piecemeal(GTO,ivid)



    GTOFA=rdir([GTO,'allda/*.txt']);
    [fr,b1,b2,b3,b4]=textread(GTOFA(ivid).name,'%f %f %f %f %f');
    
    BB=[b1 b2 b3 b4];
    BB_norm= [b2 b1 b2+b4 b1+b3];
    
    GT.BB=BB;
    GT.BBn=BB_norm;
    GT.frames=fr;
end
