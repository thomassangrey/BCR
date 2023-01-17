% Template for the use of a conjugate gradient solver pcg with a poisson equation
%
% \partial/\partial x ( pseudodiff \partial psi/\partial x  )
%  + \partial/\partial y ( pseudodiff \partial psi/\partial y  )= rhs
%
% Grid size
M=60
N=50
% Dimension of domain
LX=1
LY=1
% uniform grid 
dxx=LX/(M-1)
dyy=LY/(N-1)
% Array for grid coordinates
x=zeros(M,N);
y=x;
% Array for right hand side of system written as linear system A x= b
% and initial guess
bbb=zeros(M*N,1);
xx0=zeros(M*N,1);

% Array for land-sea mask: O for sea, 1 for land
issea=zeros(M,N);
% Array for the solution on the 2D grid
psi=zeros(M,N);
% Array containing dirichlet conditions if issea=0 at that point
psibc=zeros(M,N);
% Array containing the forcing term on the right-hand side
rhs=zeros(M,N);
% Array containing pseudodiffusion
pseudodiff=zeros(M,N);



% Now fill in for the particular case we have
% axes origin=0
x(1,:)=0;
y(:,1)=0;
% grid spacing
for ic=1:M
    dx(ic)=dxx;
end
for jc=1:N
    dy(jc)=dyy;    
end


% grid position from grid spacing
for ic=2:M
    for jc=1:N
        x(ic,jc)=x(ic-1,jc)+(dx(ic)+dx(ic-1))/2;
    end
end
for ic=1:M
    for jc=2:N
        y(ic,jc)=y(ic,jc-1)+(dy(jc)+dy(jc-1))/2;
    end
end

% mask, topography and forcing for the particular application
for ic=1:M
    for jc=1:N    
    psi(ic,jc)=0;
    issea(ic,jc)=1;
% Example of a change in coefficient 
    pseudodiff(ic,jc)=1;
    if ic>50
            pseudodiff(ic,jc)=1.1;
    end
        
    rhs(ic,jc)=100;
    end
end
%
% topology: We try Dirichlet in the west and east, with a value of 1 in the east
issea(1,:)=0;
psibc(1,:)=0;
issea(M,:)=0;
psibc(M,:)=1;
% Test boundary condition with zero gradient in the south and north
% This needs sea points at the boundary and no forcing
issea(2:M-1,N)=1;
issea(2:M-1,1)=1;
rhs(:,N)=0;
rhs(:,1)=0;



% From here on quite general
% %

% Corner points are NEVER used. So put zero value there
issea(1,1)=0;
psibc(1,1)=0;
issea(M,1)=0;
psibc(M,1)=0;
issea(M,N)=0;
psibc(M,N)=0;
issea(1,N)=0;
psibc(1,N)=0;
% For plotting purpose, if necessary, you can use average values at corners.



for j=1:N
    for i=1:M
        if issea(i,j)==1
        psi(i,j)=0;
    else
        % on land point force Dirichlet condition
        psi(i,j)=psibc(i,j);
        end
    end
end
% bbb will contain the righ-hand side of A x = b translated from a 2D array into the model state as a 1D array
% Ordering of the points is with i increasing first
ii=0
for j=1:N
    for i=1:M
        ii=ii+1;
        if issea(i,j)==1
% On a sea point
% Note we change the sign on the right hand side, because pcg needs a positive defined matrix A
% The discrete Laplacian operator is NEGATIVE defined. Hence we multiply each side of the equation by -1
% The function atimesxfortestpcg passed to the program pcg therefore calculates "minus discrete laplacian"
        bbb(ii)=-rhs(i,j);
% First guess of the solution in sea points
        xx0(ii)=0;
        else
% On land point the right hand side is the known value and the corresponing line k in the matrix A should
%    just have a one on the diagonal, zero elsewhere. It means that Ax at this line k will restitute the component x(k)
        bbb(ii)=psibc(i,j);
% Here the initial guess is trivial since we know the solution 
        xx0(ii)=psibc(i,j);    
        end
    end
end

% Call of linear system solver calling function atimesxfortestpcg.m
% pcg passes to our function atimesxforttestpg parameters dx,dy,issea and h
[xxx fflag relres niter resi] =pcg(@atimesxfortestpcg,bbb,0.00001,M*N,[],[],xx0,dx,dy,issea,pseudodiff);        
fff=fflag
%pause
% Push back solution xxx of pcg into regular grid
ii=0;
for j=1:N
    for i=1:M
        ii=ii+1;
        if issea(i,j)==1
        psi(i,j)=xxx(ii);
        else
        psi(i,j)=psibc(i,j);
        end
    end
end

% Now show solution

pcolor(x',y',psi')
title ([ 'Solution after ', int2str(niter), ' iterations'])
colorbar
figure


% If you want to show the residue
plot(log(resi))
title ( 'Convergence to the solution (log(residue))')
