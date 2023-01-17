clear all;

% To control speed
timetowait=0.1

% PARAMETERS
% Number of points
M=100;
% CFL parameter
cfl=0.5;

% Moving the solution over MF points
MF=50;

% Position of the initial hat
i1=10;
i2=30;

% Number of time steps to move over MF points
NITER=MF/cfl;

% Initialisation of variables
for i=1:M
    % Tracer value
    c(i)=0;
    % its position
    x(i)=i;
    % exact solution for comparison
    ce(i)=0;
    % Grid spacing
    dx(i)=1;
    % time step
    dt=1;
    % velocity to be coherent with cfl value
    u(i)=cfl*dx(i)/dt;
end
% hat value
for i=i1:i2
    c(i)=1;
end
% exact solution is shifter initial conditions
for i=1:M-MF
    ce(i+MF)=c(i);   % Ideal final solution
end
ci=c;
cp=c;


plot(x,c,'-',x,ce,'-.',x,ci,'--');
    axis([0 100 -0.4 1.4]);
    title('to start press any key')
    pause
% RESOLUTION

t=0;
for n=1:NITER
    cp=adv1D(u,c,dt,dx,M);
    t=t+dt;
    for i=1:M
        c(i)=cp(i);
    end
    c(1)=c(2);
    c(M)=c(M-1);
    plot(x,c,'-',x,ce,'-.',x,ci,'--');
    axis([0 100 -0.4 1.4]);
    pause(timetowait);
end
