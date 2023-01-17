function [psi1,psi2,nit,relerr] = inversepoissonbc(om1,om2,ps1,ps2,dx,dy,R,nmax,tol,optsur)

% Inversion of two coupled Poisson equations arising in the QG model
% om1 and om2 are the vorticities appearing in the RHS
% ps1 and psi2 the starting point for streamfunctions
%    these for arrays must have the same dimensions
% Here the fields are perturbations with respect to the base current
% dx and dy is the grid spacing of the uniform grid
% R is the deformation radius
% A maxiumum of nmax iterations is performed unless the relative error is
% below the value tol
% Overrelaxation parameter is optsum
% The output are the two streamfunction fields psi1 and psi2
%  nit is the number of iterations needed to converge
%  relerr is the relative error
val=size(om1);
M=val(1);
N=val(2);
% Initialise
psi1=ps1;
psi2=ps2;
r=zeros(M,N);

% Adapt stopping criteria
n=0;
relerr=1;
err=zeros(M,N);

while n < nmax && relerr > tol
    
    n=n+1;
    errtot=0;
    psitot=0;
    avrpsi=0;
    % Loop over points
    for i=2:M-1
        for j=2:N-1
            dx2=(psi1(i+1,j)+psi1(i-1,j)-2*psi1(i,j))/(dx*dx);
            dy2=(psi1(i,j+1)+psi1(i,j-1)-2*psi1(i,j))/(dy*dy);
            % residue
            err=(om1(i,j)-(dx2+dy2-(psi1(i,j)-psi2(i,j))/(2*R^2)))/(2/(dx*dx)+2/(dy*dy)+1/(2*R^2));
            % overrelaxation
            psi1(i,j)=psi1(i,j)-optsur*err;
            % diagnostics of errors and solution norm
            errtot=errtot+err*err;
            psitot=psitot+psi1(i,j)*psi1(i,j);
            avrpsi=avrpsi+psi1(i,j);
            % Same for region 2
            dx2=(psi2(i+1,j)+psi2(i-1,j)-2*psi2(i,j))/(dx*dx);
            dy2=(psi2(i,j+1)+psi2(i,j-1)-2*psi2(i,j))/(dy*dy);
            err=(om2(i,j)-(dx2+dy2+(psi1(i,j)-psi2(i,j))/(2*R^2)))/(2/(dx*dx)+2/(dy*dy)+1/(2*R^2));
            psi2(i,j)=psi2(i,j)-optsur*err;
            errtot=errtot+err*err;
            psitot=psitot+psi2(i,j)*psi2(i,j);
            avrpsi=avrpsi+psi2(i,j);
        end
    end
% Apply boundary condition
    psi1=bcpert(psi1);
    psi2=bcpert(psi2);
    
   

% Calculate relative error
    errtot=errtot/(N-2)/(M-2);
    psitot=psitot/2/(N-2)/(M-2)-(avrpsi/2/(N-2)/(M-2))^2;
    relerr=sqrt(errtot/psitot);
    

end

nit=n

