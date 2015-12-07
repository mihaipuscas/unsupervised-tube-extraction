
function [ov] = IoU(BB1, BB2)

% BBs are represented by 4 values: [top corner y, top corner x, bottom
% corner y, bottom corner x]

bi=[max(BB1(1),BB2(1)) ; max(BB1(2),BB2(2)) ; min(BB1(3),BB2(3)) ; min(BB1(4),BB2(4))];

iw= bi(3)-bi(1)+1;
ih= bi(4)-bi(2)+1;
ia= iw*ih;

if iw>0 && ih>0
    % compute overlap as area of intersection / area of union
    ua= (BB1(3)-BB1(1)+1)*(BB1(4)-BB1(2)+1)+...
        (BB2(3)-BB2(1)+1)*(BB2(4)-BB2(2)+1)-...
        ia;
    ov= ia/ua;
else
    ov= 0;
end
    
end
