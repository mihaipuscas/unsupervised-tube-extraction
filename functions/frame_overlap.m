function [ k ] = frame_overlap( r1, size )
%frame size comparison


h1=r1(3)-r1(1)+1;
w1=r1(4)-r1(2)+1;
h2=size(1);
w2=size(2);
A1=h1*w1;
A2=h2*w2;
k=A1/A2;

end

