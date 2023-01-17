% M points in along channel direction. Two of them are for periodic conditions
% N points across channel, take an odd number of points (psi on center)
%
M=125;
N=125;
% Name of png files
myname='testgfd'
% Number of time steps
NT=50000

% Scale of the eddy
L=25000;

% Resolution with respect to the scale
dx=L/5;
dy=dx;

% Diffusion and dissipation parameters
% Diffusion
AH=0.1
% Biharminic diffusion
BH=10*dx*dy
% Dissipation rate
dissrate=0.00000


% Plotting scales
omegascale=0.00001;
psiscale=L*L*omegascale

% Time step based on estimate of valocity scale and CFL valye
dt=0.1*dx*dy/L/L/omegascale


% bcfalg=1: perdiodic
% bcflag=2: dirichlet with bcval value everywhere
bcflag=2
bcval=0
imode=2
% Initial eddy, perturbed by mode 2 structure
for ic=1:M
    for jc=1:N
        xx(ic,jc)=(ic-M/2)*dx;
        yy(ic,jc)=(jc-N/2)*dy;
        rr=sqrt(xx(ic,jc)^2+yy(ic,jc)^2)/L;
        th=atan2(yy(ic,jc),xx(ic,jc));
        r=rr*(1+0.03*cos(imode*th));
        psiphys(ic,jc)=exp(-r*r)*L^2*omegascale;
    end
end

% Now run the model

[psiphys,omphys,errtime,niter] = qgmodelrun(psiphys,dissrate,AH,BH,NT,dt,dx,dy,myname,10,bcflag,bcval,omegascale,psiscale)
