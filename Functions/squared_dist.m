function sq_distmat = squared_dist(A,B)

[nA,dim] = size(A);
nB = size(B,1);

A_ext = ones(nA,dim*3);
A_ext(:,2:3:end) = -2*A;
A_ext(:,3:3:end) = A.^2;

B_ext = ones(nB,dim*3);
B_ext(:,1:3:end) = B.^2;
B_ext(:,2:3:end) = B;

sq_distmat = A_ext * B_ext.';

return;

