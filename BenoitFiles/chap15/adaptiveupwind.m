close all;
clear all;


% PARAMETERS
% to control the speed
timetowait=0.001

% Domain definition
xmin=0;
xmax=50000;

% Number of grid points in the domain
m=41;

% minimal grid size
dmin=(xmax-xmin)/(m-1)/100;

% Scales for grid moving
FSCALE=1;
LSCALE=1000;
TSCALE=9000;

alpha=LSCALE/(TSCALE*FSCALE);    
% Weight on regular grid, increased value of beta leads to more uniform
% grid
beta=100
beta=0.1

% Lagrangian approach
islagr=0;   % islagr=1 adds lagrangien-like approach (else : 0)

% Internal loop for grid moving
ktimes=60;  % 

% Time step
dt=10;

% Move the whole thing over 
displacement=10000

% Number of steps to move displacement x units with velocity 1
nsteps=displacement/dt
% INITIALIZATION

% Here c values and x values are not staggered

for i=1:m
    % Initial grid is uniform
    x(i)=xmin+(xmax-xmin)*(i-1)/(m-1);
    % reference concentration
    c(i)=1.;
    % uniform velocity field
    u(i)=1.;
    % grid velocity
    unum(i)=0.;
    % fluxes
    flux(i)=0;
end
% Triangle at grid point 15
for i=10:20
    c(i)=2-abs((i-15))/5;
end
% Initial value
cini=c;
xini=x;



% RESOLUTION

% New value of grid
xn=x;

dxc=c*(xmax-xmin)/(m-1);
% Initial value of C dx
for i=2:m-1
     
    dxc(i)=c(i)*(x(i+1)-x(i-1))/2;
end
dxcn=dxc;
% Initial time
t=0;
% First get a nice point distribution before actually making advection
kmaxini=8000
for k=0:kmaxini
    xo=xn;
    % Calculate C at position xo, knowing c in x
    ca=pchip(x,c,xo);
    % plot initial adaptation
    if mod(k,10)==0
    plot(xo,ca,'-',x,c,'o');
    if k==0
        title('Generating initial distribution: press key to start')
        pause
    end
    title(['Percentage done ',num2str(k*100/kmaxini,3)])
    pause(0.00001);
    end
    cof =dt*alpha;
    cof2=dt*alpha*beta*FSCALE/LSCALE;
    % Move points
    for i=2:m-1
        xn(i)=xo(i)+cof*(abs(ca(i+1)-ca(i))-abs(ca(i)-ca(i-1)))+cof2*(xo(i+1)-2*xo(i)+xo(i-1));
    end
    % If moved risk of overtaking, ensure points remain ordered
    for i=3:m-1
        if xn(i+1) < xn(i)+(xn(i)-xn(i-1))/20
            xn(i)=xn(i+1)-(xn(i)-xn(i-1))/10;
        end
    end
    xn(1)=x(1);
    xn(m)=x(m);
end
% Once good position of the initial grid is known,
% interpolate C onto this grid
xo=xn;
cini=pchip(x,c,xo);


x=xn;
c=cini;
% Real program starts here:
% Now we have the initial condition on an irregular grid

dxc=c*(xmax-xmin)/(m-1);
% Calculation of C dx
for i=2:m-1
    dxc(i)=c(i)*(x(i+1)-x(i-1))/2;
end
dxcn=dxc;
figure
plot(x,c,'+',x,c,'-')
title('Now starting advection : press key to continue')
pause

% Now time move
for n=1:nsteps
    t=t+dt;
    cof=dt*alpha;
    cof2=dt*beta*alpha*FSCALE/LSCALE;
    xo=x;
    xn=x;
    ca=c;
   % Adapting grid
    for k=1:ktimes
        xo=xn;
        
        for i=2:m-1
            % Move position with advection. Since ktimes iterations
            % distance to move is u dt/ktimes
            xo(i)=xo(i)+u(i)*dt/ktimes*islagr;  % For lagrangien-like approach
            xo(i)=min(xo(m)-dmin,xo(i));
            xo(i)=max(xo(1)+dmin,xo(i));
        end
        xo(1)=x(1);
        xo(m)=x(m);
        % Add some test on overtaking since points are moved towards the
        % outlet
        for i=2:m-1
            if xo(i+1) < xo(i)+dmin;
                xo(i)=xo(i+1)-dmin;
            end
        end
        % Now move with adaptive approach
        for i=2:m-1
            xn(i)=xo(i)+cof*(abs(ca(i+1)-ca(i))-abs(ca(i)-ca(i-1)))+cof2*(xo(i+1)-2*xo(i)+xo(i-1));
        end
        % Again, check for overtaking of points
        for i=3:m-1
            if xn(i+1) < xn(i)+(xn(i)-xn(i-1))/20
                xn(i)=xn(i+1)-(xn(i)-xn(i-1))/10;
            end
        end
        xn(1)=x(1);
        xn(m)=x(m);
    end
    
    % Calculating grid moving velocity
    for i=2:m
        unum(i)=(xn(i)+xn(i-1)-x(i)-x(i-1))/(2*dt);
    end
    % adapte fluxes based on relative velocity
    for i=2:m
        if u(i)-unum(i) > 0
            flux(i)=(u(i)-unum(i))*c(i-1);
        else
            flux(i)=(u(i)-unum(i))*c(i);
        end
    end
    % Update C dx
    for i=2:m-1
        dxcn(i)=dxc(i)+(flux(i)-flux(i+1))*dt;
    end
    % From C dx, get C
    for i=2:m-1
        c(i)=dxcn(i)/(xn(i+1)-xn(i-1))*2;
    end
    % Put the newly optained values as old values for the next time step
    dxc=dxcn;
    x=xn;
    %plot(x,c,'o',x,unum*10,x,-(u-unum)*10)
    plot(x,c,'o')
    axis([xmin xmax 0.8 2])
    pause(timetowait)
end
figure
plot(x,c,'o',xini+displacement,cini,'-.')
    axis([xmin xmax 0.8 2])
   title('Final position with exact solution')
   
   max(c)

