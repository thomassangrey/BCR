function[val] =locallapl(psi,pseudodiff,dx,dy,i,j)
% Function to calculate the local value of
%   \partial/\partial x ( pseudodiff \partial psi/\partial x  )
%  + \partial/\partial y ( pseudodiff \partial psi/\partial y  )
% the calculation is done at grid point i,j
% pseudodiffusion can for example be 1/h (h is depth) if the streamfunction approach of  a rigid-lid model
%                 or it can be h if the pressure formulation is used in a rigid-lid model
vv=size(psi);
% Get grid size from matrix
NX=vv(1);
NY=vv(2);
% Grid spacing in x direction dx can vary with i
% Grid spacing in y direction dy can vary with j

% Make sur not to search outside the grid
ip1=min(i+1,NX);
im1=max(i-1,1);
jp1=min(j+1,NY);
jm1=max(j-1,1);
% The factor 2 for averaging of pseudodiff and averaging of dx (or dy) cancel out
valxp=(pseudodiff(ip1,j)+pseudodiff(i,j))*(psi(i+1,j)-psi(i,j))/(dx(ip1)+dx(i));
valxm=(pseudodiff(im1,j)+pseudodiff(i,j))*(psi(im1,j)-psi(i,j))/(dx(im1)+dx(i));
valyp=(pseudodiff(i,jp1)+pseudodiff(i,j))*(psi(i,jp1)-psi(i,j))/(dy(jp1)+dy(j));
valym=(pseudodiff(i,jm1)+pseudodiff(i,j))*(psi(i,jm1)-psi(i,j))/(dy(jm1)+dy(j));
% For Dirichlet boundaries, the present function is not called. 
% Hereafter ero gradient conditions on the boundary are enforced
%    by retaining only normal derivative and make sure right-hand side of the Poisson equation is zero there.

if j==NY
   valyp=0;
   valxp=0;
   valxm=0;
end
if j==1
   valym=0;
   valxp=0;
   valxm=0;
end
if i==NX
   valyp=0;
   valxp=0;
   valym=0;
end
if i==1
   valyp=0;
   valxm=0;
   valym=0;
end


% Calculate the final finite differencing
val=(valxp+valxm)/dx(i)+(valyp+valym)/dy(j);