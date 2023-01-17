clear all;
close all
% PARAMETERS

% If too fast, increase timetowait
timetowait=0.0001
% Number of grid points on the vertical
M=102;
% Depth
H=100;
% Time step to be used
dt=200;
% Number of time steps to be calculated
nsteps=3000;
% Coriolis frequency
fcorio=1*10^(-4);
% Implicitness of the scheme
alpha=1;
% Atmospheric forcing
% Heat flux in W/m^2
heatflux=00;
% Wind in m/s and resulting ustar
U10=15;
ustarwind=sqrt(10^(-3)*(1+U10*U10)/1028);
% Or, if wind is directly given by its stress: tauxxx in N/m^2:
tauxxx=0.15;
ustarwind=sqrt(tauxxx/1028);

% Pressure gradient
press=0.00001*1024;
press=0;



% Grid spacing resulting from the depth and number of grid points
dz=H/(M-2);

% Parameters of the turbulence models
c1=1.44;
c2=1.92;
c3=-0.2;
z0surf=0.1;
z0bot=0.1;
kkarm=0.4;
CDRAG=kkarm^2/(log(dz/(2*z0bot)))^2;


tkemin=10^(-10);
epsmin=10^(-15);






% Initial profile
NBV=0.015;
for k=1:M
    rho(k)=-tanh((k-M/1.3)/M*8.14);
    z(k)=-H+(k-1.5)*dz;
% You can use a linear case for example
    rho(k)=-1-NBV^2/9.81*1028*z(k);
% Zero velocity and no turbulence
    u(k)=0;
    v(k)=0;
    tke(k)=tkemin;
    eps(k)=epsmin;
end

% Allocate arrays
MS=zeros(1,M);
ntmh=MS;
NS=MS;
source=MS;
sink=MS;

% RESOLUTION


% Make all time steps
for n=1:nsteps
    % time is
    t=n*dt;
    % Calculate N^2 and M^2 from velcoties and density anomaly
    [NS,MS]=NSMS(rho,u,v,z);
    % ustar on the bottom from the value above the bottom
    ustarbot=sqrt(CDRAG)*sqrt(u(2)^2+v(2)^2);
    % Define M^2 at the boundaries from ustar instead of finite differences
    MS(2)=ustarbot^2/z0bot^2;
    MS(M)=ustarwind^2/z0surf^2;
    
    % From tke, eps N^2 and M^2 calculate turbulent viscosity nu and turbulent diffusivity kappa
    [nu,kappa]=nukappa(tke,eps,NS,MS);
    
    
    % For plotting purposes, store surface velocity
    usurf(n)=u(M-1);
    vsurf(n)=v(M-1);
    
    
    % density equation has no source and no sink
    source=zeros(1,M);
    sink=source;
    % at the bottom zero flux
    BCB=0;
    % at the surface, buoyancy flux due to heatflux
    BCS=-(heatflux/(1024*4160))*1.7*10^(-4)*1024;
    % flux is ised as boundary requires iflag=1 in routine diffusionstep
    iflag=1;
    % Advances in time the variable rho, knowing its sources, sinks and boundary conditions
    SN=diffusionstep(rho,kappa,dt,dz,alpha,source,sink,BCB,BCS,iflag);  
    % put reasonable values for plotting purposes (in principle, you should use flux values)
    SN(1)=SN(2); 
    SN(M)=SN(M-1);
    % udpate density
    rho=SN;
    
    % alternate splitting on two velocity components
    for sw=1:2
        if mod(sw+n,2)==0
            % for u velocity source is coriolis and sink is zero
            source=fcorio*v+press/1024;
            sink=zeros(1,M);
            % boundary condition is due to windstress
            BCS=-ustarwind^2;
            BCB=-ustarbot*u(2);
            % flux condition
            iflag=1;
            SN=diffusionstep(u,nu,dt,dz,alpha,source,sink,BCB,BCS,iflag)     ;  
            % put reasonable values for plotting (in principle, you should use flux values)
            SN(1)=SN(2);
            SN(M)=SN(M-1);
            u=SN;
        else
            % v velocity soure is other coriolis term
            source=-fcorio*u;
            sink=zeros(1,M);
            % No wind stress on v component. Can easily be adapted
            BCS=0;
            BCB=-ustarbot*v(2);
            % flux conditions
            iflag=1;
            SN=diffusionstep(v,nu,dt,dz,alpha,source,sink,BCB,BCS,iflag)     ;  
            % put reasonable values for plotting (in principle, you should use flux values)
            SN(1)=SN(2);
            SN(M)=SN(M-1);
            v=SN;
        end
    end
    
    % once new values of density and velocity are found update parameters used in turbulence models
    [NS , MS]=NSMS(rho,u,v,z);
    ustarbot=sqrt(CDRAG)*sqrt(u(2)^2+v(2)^2);
    MS(2)=ustarbot^2/z0bot^2;
    MS(M)=ustarwind^2/z0surf^2;
    [nu , kappa]=nukappa(tke,eps,NS,MS);
    
    % tke equation
    for k=1:M
        if NS(k) < 0
            % static instability makes buoancy gradient a source term
            source(k)=nu(k)*MS(k)-kappa(k)*NS(k);
            sink(k)=eps(k);
        else
            % static stability
            source(k)=nu(k)*MS(k);
            sink(k)=kappa(k)*NS(k)+eps(k);
        end
    end
    
    % take care of staggering to define nu for tke at right positions
    for k=2:M
        nutke(k)=(nu(k)+nu(k-1))/2;
    end
    nutke(1)=nutke(2);
    
    % Define tke values at boundaries
    BCB=ustarbot^2;
    BCS=ustarwind^2;
    % Dirichlet condition
    iflag=0;
    SNB=diffusionstep(tke(2:M),nutke(2:M),dt,dz,alpha,source(2:M),sink(2:M),BCB,BCS,iflag)     ;  
    % update value and enforce minimal value
    for k=2:M
        tke(k)=SNB(k-1);
        if tke(k)<tkemin
            tke(k)=tkemin;
        end
    end
    
    % Now the last equation is for dissipation rate
    for k=1:M
        val=eps(k)/tke(k);
        if c3*NS(k)< 0
            source(k)=val*c1*nu(k)*MS(k)-val*(c3*kappa(k)*NS(k));
            sink(k)=val*(c2*eps(k));
        else
            source(k)=val*c1*nu(k)*MS(k);
            sink(k)=val*(c2*eps(k))+val*(c3*kappa(k)*NS(k));
        end
    end
    
    % boundary value of epsilon
    BCB=ustarbot^3/z0bot/kkarm;
    BCS=ustarwind^3/z0surf/kkarm;
    % dirichlet condition
    iflag=0;
    SNB=diffusionstep(eps(2:M),nutke(2:M),dt,dz,alpha,source(2:M),sink(2:M),BCB,BCS,iflag);  
    
    for k=2:M
        eps(k)=SNB(k-1);
        % mixing length??
        % eps(k)=tke(k)^(3/2)/10;
        if eps(k)<epsmin
            eps(k)=epsmin;
        end
    end
    for k=2:M
        % check, need for constants
        ll(k)=tke(k)^(3/2)/eps(k);
    end
    
    [aa,ii]=max(NS);
    hh(n)=z(ii);
    time(n)=t;
    % Once in a while make a plot
    if mod(n-1,10)==0
        subplot(2,2,1)
        plot(rho,z,'-')
        %hold on
        aaaa = [ 'Turbulence model, time ' num2str(t/24/3600,'%4.2f') ' days'];
        disp([aaaa]);
        title(aaaa)
        xlabel('Density anomaly')
        ylabel('z')
        axis([-1 1.4 -100 0])
        subplot(2,2,2)
        plot(u,z,'-.',v,z,'-')
        %hold on
        aaaa = [ 'Turbulence model, time ' num2str(t/24/3600,'%4.2f') ' days'];
        disp([aaaa]);
        title(aaaa)
        xlabel('Velocity components, v is the solid line')
        ylabel('z')
        axis([-0.5 0.5 -100 0])
        subplot(2,2,3)
        plot(log10(tke),z,'-')
        %hold on
        aaaa = [ 'Turbulence model, time ' num2str(t/24/3600,'%4.2f') ' days'];
        disp([aaaa]);
        title(aaaa)
        xlabel('log(Turbulent kinetic energy)')
        ylabel('z')
        axis([-8 0 -100 0])
        
        subplot(2,2,4)
        plot(log10(eps),z,'-')
        %hold on
        aaaa = [ 'Turbulence model, time ' num2str(t/24/3600,'%4.2f') ' days'];
        disp([aaaa]);
        title(aaaa)
        xlabel('log(Dissipation)')
        ylabel('z')
        axis([-10 -2 -100 0])
        pause(timetowait)
    end
    
end

figure
plot(usurf,vsurf)
axis equal
title ('surface hodograph')
