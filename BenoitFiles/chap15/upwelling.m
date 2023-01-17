clear all;
close all
% PARAMETERS

% Number of grid points
M=100;
% Reduced gravity
gprime=0.08;
% Initial height of reduced gravity layer
h0=50;
% Coriolis parameter
f=0.0001;

% Resulting deformation radius
RD=sqrt(gprime*h0)/f;

% Grid spacing small enough to resolve the front
dx=RD/15;

% Small horizontal diffusion
ah=10;

% Minimal value of layer depth (corresponds to outcropping)
hmin=0.1;

% Time step controlled by internal gravity waves
dt=dx/sqrt(gprime*h0)*0.1;

% Simulation of ten inertial periods
Tf=2*pi/f*10;

% Time steps needed to reach the simulation time
ntot=Tf/dt;

% To control the animation speed
timetowait=0.01


% Zero transports to start with
for i=1:M+1
    hu(i)=0;
end
hun=hu;
hv=hu;
hvn=hv;

% To plot crosses that indicate the wind
for i=1:M/10;
    forplot(i)=10;
    xplot(i)=(i-1)*10*dx;
end

% Initial depth of surface layer
for i=1:M
    h(i)=h0;
    x(i)=(i-1)*dx;
end
hn=h;

% RESOLUTION & PLOT

t=0;
% Time loop
for n=0:ntot
    
    % Equation for depth
    for i=1:M
        hn(i)=h(i)-dt/dx*(hu(i+1)-hu(i));
        hn(i)=max(hn(i),hmin); 
    end
    h=hn;
    
    % Equation for hu
    for i=2:M
        hun(i)=hu(i)+f*dt*hv(i)-1/2*gprime*dt/dx*(h(i)^2-h(i-1)^2)+dt*ah/(dx*dx)*(hu(i+1)+hu(i-1)-2*hu(i));
    end
    hun(1)=0;
    hun(M+1)=0;
    hu=hun;
    % Apply correction when outcropping arives
    hu=flooddry(hun,h,hmin);
    
    % Equation for hv
    for i=2:M
        hvn(i)=hv(i)-f*dt*hu(i)+dt*windstress(t)/1024+dt*ah/(dx*dx)*(hv(i+1)+hv(i-1)-2*hv(i));
    end
    hv=hvn;
    
    
    
    t=t+dt;
    
    % Once in a while make a plot
    if mod(n,10)==0
    if windstress(t) > 0
        plot(x,-h,xplot,forplot,'x');
    else
        plot(x,-h);
    end
        
        hold on
        % Vertical scale for surface is greatly exagerated
        plot(x,(h-h0)*0.1+5,'.');
        axis([0 x(M) -100 15])
        title([ 'Time : ',num2str(t,4)])
        if n==0
            title('To start press any key')
            pause
        end
        pause(timetowait)
        hold off
    end
    
end
