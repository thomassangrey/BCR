function [lap] = laplacian(p,dx,dy)
% Function which implements a simple discretisation of a Laplacian of p.
% Grid must be uniform.
% Values not defined on border.
val=size(p);
M=val(1);
N=val(2);
lap=zeros(M,N);

for i=2:M-1
    for j=2:N-1
        lap(i,j)=(p(i+1,j)+p(i-1,j)-2*p(i,j))/(dx*dx)+(p(i,j+1)+p(i,j-1)-2*p(i,j))/(dy*dy);
    end
end
