clear all;

% PARAMETERS

% Coriolis
lat=30;
f=2*2*pi/(24*3600)*cos(pi/180*(lat));

% Inertial period
TP=2*pi/f;

%time step. To test convergence, decrease fdt
% fdt=f dt

fdt=0.05;


dt=fdt/f;
% sampling of the discrete solution every dtsol second.
dtsol=1*dt;

% Intitial stuff
t0=0;
u0=0;
v0=1;
% Simulation time (note the time is used, not the number of steps)
tf=10*TP;


% RESOLUTION

% Explicit
alpha=0.;
[ue,ve,te]=numcorio(f,dt,alpha,t0,tf,u0,v0,dtsol);

% Implicit
alpha=1.;
[ui,vi,ti]=numcorio(f,dt,alpha,t0,tf,u0,v0,dtsol);

% Trapezoidal
alpha=0.5;
[ut,vt,tt]=numcorio(f,dt,alpha,t0,tf,u0,v0,dtsol);

% PLOT

plot(ue,ve,':',ui,vi,'.',ut,vt,'-')
axis([-3 3 -3 3])
axis('equal')
axis([-2 2 -2 2])
legend('\alpha = 0','\alpha = 1','\alpha = 0/2');
xlabel('u');
ylabel('v');