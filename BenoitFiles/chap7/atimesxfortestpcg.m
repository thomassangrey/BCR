function[ax] = atimesxfortestpcg(x,dx,dy,issea,pseudodiff)
% Function that shows how to define a function describing the matrix operation A x
% resulting from the application of
% assumes symmetric and positive defined matrix A
% 
% issea is a mask containing zero for land, one for sea points
% pseudodiff is a 2D array containing the pseudodiffusion appearing in 
%  \partial/\partial x ( pseudodiff \partial psi/\partial x  )
%  + \partial/\partial y ( pseudodiff \partial psi/\partial y  )
% x is the vector of unknowns used internally by pcg. If we order the points increasing first the i index, 
%    we can define the 2D array psi easily
% dx(i) is the grid spacing in x direction
% dy(i) is the grid spacing in y direction
MM=size(issea);
% Get grid size of the problem
NX=MM(1);
NY=MM(2);
% Declare 2D field of the same size
psi=zeros(NX,NY);


ii=0;
% allocate the results A x  to be provided to the calling program pcg
ax=x;

% Fill the 2D array from the 1D array containing the unknowns
for j=1:NY
for i=1:NX
     ii=ii+1;
    psi(i,j)=x(ii,1);
end
end
% If you want to see the sequence of calls by pcg you can uncomment the plotting of the array x
%pcolor(psi')
%colorbar
%title('x to which is applied operator')
%pause(0.01)

% Now loop across grid and distinguish two situations:
ii=0;
for j=1:NY
for i=1:NX
    ii=ii+1;
    if issea(i,j)==1
        % Here we have a real unknown on the sea and the equation is the poisson equation
        % To be positive defined, one must change the sign of the discrete laplacian
    ax(ii,1)=-locallapl(psi,pseudodiff,dx,dy,i,j);
    else
        % Here we are on land, and a Dirchlet condition is applied. The resulting line in the linear system is simply
        % psi(i,j)= boundary condition
        % and the application of A on x for this line simly restitutes psi(i,j)
    ax(ii,1)=psi(i,j);
    end
end
end
% To have a feedback on iterations show the norm x'Ax
ax'*x


