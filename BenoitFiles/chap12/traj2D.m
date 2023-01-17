

% Grid size for plotting the streamfunction 
IM=30
JM=30

% Number of time steps
NMAX=500

% To control the speed
timetowait=0.02

% icase=1 Sverdrup
% icase=2 alternating cyclones and anticyclones
icase=2

% Number of particles
np=900

% ispot=0 particles on the regular grid
% ispot=1 clustered particles
ispot=0


% Starting time
t=0

% non dimensional time step used

DT=1/(NMAX);




% Allocate coordinates of particles
x=zeros(np,1);
y=zeros(np,1);

% Allocate streamfunction and its coordinates for visualization
psi=zeros(IM,JM);
xp=psi;
yp=psi;


% Creating the streamfunction on a regular grid for plotting
   itot=0
    for i=1:IM
    for j=1:JM
        xx=(i-1)/(IM-1);
        yy=2*(j-1)/(JM-1)-1;
        
        del=0.1;
        xp(i,j)=xx;
        yp(i,j)=yy;
        if icase==1
        psi(i,j)=cos(yy*pi/2)*(1-xx-exp(-xx/del));
        end
        if icase==2
        psi(i,j)=sin(yy*pi/2*2)*sin(xx*pi/2*4);
        end
    end
end


if ispot==0
% Putting particles on a regular grid
itot=0
I1=floor(sqrt(np))
    for i=1:I1
    for j=1:I1
        xx=(i-1)/(I1-1);
        yy=2*(j-1)/(I1-1)-1;
        itot=itot+1;
        x(itot)=xx;
        y(itot)=yy;
        xi=x;
        yi=y;
    end
    end
end
% Concentrate particles around (0.15,-0.5)
if ispot==1
x= 0.15+0.05*randn(np,1);
y= -0.5 +0.05*randn(np,1);
end

% Plot initial situation and wait for start

plot(x,y,'.')
axis([0 1 -1 1]);
hold on
contour(xp',yp',psi')
hold off
title('Press any key to start')
pause


% Make the time step
for n=1:NMAX+1
    
    % For all particles
    for i=1:np
        % Calculate the velocity at the particle location
[u,v]=velocitylag(x(i),y(i),icase);
% predictor of the displacement
xx=x(i)+u*DT;
yy=y(i)+v*DT;
% corrector:
% Calculate velocity at expected endpoint of displacement
[u,v]=velocitylag(xx,yy,icase);
% Use this velocity to update the position
x(i)=x(i)+u*DT;
y(i)=y(i)+v*DT;
end

% Update time and make a plot
t=t+DT
plot(x,y,'.')
axis([0 1 -1 1]);
hold on
contour(xp',yp',psi')
hold off
pause(timetowait)
end
