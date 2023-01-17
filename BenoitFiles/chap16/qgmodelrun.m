function [psiphys,omphys,errtime,niter] = qgmodelrun(psi,dissrate,AH,BH,NT,dt,dx,dy,myname,ifreq,bcflag,bcval,omegascale,psiscale)

% Simulates the QG model starting with streamfunction psi
% psi: streamfunction, also defines matrix size
% dissrate: dissipation rate (/s)
% AH : horizontal diffusion (m/s^2)
% BH : horizontal biharmonic diffusion coefficient (m^3/s^2)
% NT: number of time steps to simulate
% dt: time step (s)
% dx: x spacing (m)
% dy: y spacing (m)
% myname: string for filenames of png images created
% ifreq: save an image every ifreq time step
% bcflag: boundary condition flag: 1 periodic
%                                  2 dirichlet
%                                  3 periodic in x
% bcval: if dirichlet, value imposed
% omegascale: scale for plots on vorticity
% psiscale: scale for plots on streamfunction


% Get problem size
%
vv=size(psi);
M=vv(1);
N=vv(2);

% Create coordinates of a grid
xx=zeros(M,N);
yy=zeros(M,N);
for i=1:M
    for j=1:N
        xx(i,j)=i*dx;
        yy(i,j)=j*dy;
    end
end

% Allocate diagnostics array
errtime=zeros(NT,1);
niter=zeros(NT,1);


% Estimate optimal overrelaxation parameter
MM=1/(sqrt(0.5/(M*M)+0.5/(N*N)))

optsur=2/(1+1.5*pi/MM)
if bcflag==1
optsur=2/(1+2*pi/MM)
end
if bcflag==2
optsur=2/(1+pi/MM)
end


brcol=bluered(64);

% Initialise streamfunction
psiphys=psi;
% From streamfunction, calculate vorticity
omphys=laplacian(psiphys,dx,dy);

% Allocate velocity arrays if requested
uvel=psiphys;
vvel=psiphys;

% Apply boundary conditions on fields
if bcflag==1
psiphys=periodic(psiphys);
omphys=periodic(omphys);
end
if bcflag==2
psiphys=dirichletbc(psiphys,0);
omphys=dirichletbc(omphys,0);
end
if bcflag==3
psiphys=periodicx(psiphys);
omphys=periodicx(omphys);
end
    
% Show initial field for streamfunction

        pcolor(psiphys')
        colormap(brcol)
        shading flat
        title ('press any key to start')
        colorbar
        pause
        
psiold=psiphys;
% The first guess on psi for time iterations can be extrapolated
extra=1;

% Now loop on time
for n=0:NT-1

% From known vorticity, get streamfunction with intial guess extrapolated
% from two previous values of psi

[work,nit,relerr,residual]=inversepoisson(omphys,psiphys+extra*(psiphys-psiold),dx,dy,(M+N),0.000001,optsur,bcflag,0);
psiold=psiphys;
psiphys=work;

% store residuals and iterations for diagnostics
errtime(n+1)=relerr;
niter(n+1)=nit;


%Predictor
% From vorticity and streamfunction, calculate jacobian
jacobphys=arakawa(psiphys,omphys,dx,dy);
% Laplacian of omega if friction is present
lap=laplacian(omphys,dx,dy);
if bcflag==1
lap=periodic(lap);
end
if bcflag==3
lap=periodicx(lap);
end

% Update vorticity by time evolution, with implicit dissipation
omphysp=omphys-dt*jacobphys+AH*dt*laplacian(omphys,dx,dy)-BH*dt*laplacian(lap,dx,dy);
omphysp=omphysp/(1+dt*dissrate);
if bcflag==1
omphysp=periodic(omphysp);
end
if bcflag==2
omphysp=dirichletbc(omphysp,0);
end
if bcflag==3
omphysp=periodicx(omphysp);
end

%Corrector: same equation but with estimate new value of omega on RHS
% From vorticity and streamfunction, calculate jacobian
jacobphys=arakawa(psiphys,omphysp,dx,dy);
% Laplacian of omega if friction is present
lap=laplacian(omphysp,dx,dy);
if bcflag==1
lap=periodic(lap);
end
if bcflag==3
lap=periodicx(lap);
end

% Update vorticity by time evolution
omphys=omphys-dt*jacobphys+AH*dt*laplacian(omphysp,dx,dy)-BH*dt*laplacian(lap,dx,dy);
omphys=omphys/(1+dt*dissrate);
if bcflag==1
omphys=periodic(omphys);
end
if bcflag==2
omphys=dirichletbc(omphys,0);
end
if bcflag==3
omphys=periodicx(omphys);
end


if mod(n,ifreq)==0
    % Calculate velocities from streamfunction if necessary
    % Trick here: xx and yy contain x and y so jacobian of psi,x provides
    % -dpsi/dy...
    uvel=arakawa(psiphys,xx,dx,dy);
    vvel=arakawa(psiphys,yy,dx,dy);
    subplot(1,2,1)
pcolor(real(omphys)');
caxis([-omegascale omegascale])
shading('interp')
axis equal
axis off
title 'Vorticity'
colormap(brcol)
%colorbar('horiz')
    subplot(1,2,2)
pcolor(xx,yy,real(psiphys));
caxis([-psiscale psiscale])
shading('interp')
hold on
plotstep=4
quiver(xx(1:plotstep:M,1:plotstep:N),yy(1:plotstep:M,1:plotstep:N),uvel(1:plotstep:M,1:plotstep:N),vvel(1:plotstep:M,1:plotstep:N))
axis equal
axis off
title 'Streamfunction'
hold off
% To produce an animation
if mod(n,ifreq)==0
    tutut=[myname num2str(10000+n) '.png']
    print('-dpng',tutut)
end
pause(0.0001)

end


end