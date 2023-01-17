function [psif,nit,relerr,r] = inversepoisson(om,psistart,dx,dy,nmax,tol,optsur,bcflag,bcval)
% Inversion of equation Laplacian psi = omega
% starting field for iterations is psistart
% Grid spacing is uniform dx and dy
% Maximum number of iterations is nmax
% tol is the relative error below which iterations are stopped
% optsur: overrelaxation parameter (between 0 and 2)
% bcflag: boundary flag: 1 for perdiocicity on both direction
%                        2 for dirichlet condition with value bcval
%                        3 for periodicity in x direction and fixed value
%                        in y boundaries
%                    
val=size(om);
M=val(1);
N=val(2);
% Initial value
psi=psistart;
psin=psi;
% allocate array for residue
r=zeros(M,N);

% Adapt stopping criteria
n=0;
relerr=1;
err=zeros(M,N);


while n < nmax & relerr > tol
% iterate    
    n=n+1;
    errtot=0;
    psitot=0;
    avrpsi=0;
    
    for i=2:M-1
        for j=2:N-1
            dx2=(psi(i+1,j)+psi(i-1,j)-2*psi(i,j))/(dx*dx);
            dy2=(psi(i,j+1)+psi(i,j-1)-2*psi(i,j))/(dy*dy);
            err(i,j)=(om(i,j)-(dx2+dy2))/(2/(dx*dx)+2/(dy*dy));
            % Gauss Seidel approach: directly put newly found value into array
            psi(i,j)=psi(i,j)-optsur*err(i,j);
            errtot=errtot+err(i,j)*err(i,j);
            psitot=psitot+psi(i,j)*psi(i,j);
            avrpsi=avrpsi+psi(i,j);
        end
    end
    
    errtot=errtot/(N-2)/(M-2);
    psitot=psitot/(N-2)/(M-2)-(avrpsi/(N-2)/(M-2))^2;
    % For stopping criterium
    relerr=sqrt(errtot/psitot);
   
    if bcflag==1
    psi=periodic(psi);
    end
    if bcflag==2
        psi=dirichletbc(psi,bcval);
    end
    if bcflag==3
    psi=periodicx(psi);
    % keep initial value of psi
    psi(:,1)=psistart(:,1);
    psi(:,N)=psistart(:,N);
    end
    
    
    avrpsi=avrpsi/(N-2)/(M-2);
    
    
end

% psin=psi;
% Final results with diagnostics on residue and number of iterations.
nit=n;
psif=psi;
r=err;

