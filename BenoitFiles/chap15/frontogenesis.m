clear all;
close all
% PARAMETERS

% icase=1 the case shown in the book, a rectangle
%      =2 some cloud of particles at a similar position
%      =3 define your own distribution
icase=1

% Number of particles for case 2 and 3
NP=400

if icase==1
NP=400
end
% To slow down, increase timetowait
timetowait=0.1
% Grid size for streamfunction plotting
IM=30;
JM=30;

% Number of time steps
NMAX=15;  % 

% Initial time
t=0;



% Resulting grid parameters 
DX=1/(IM-1);
DY=1/(JM-1);
DT=1.5/(NMAX);

x=zeros(NP);
y=zeros(NP);
fig=figure;

% Filling streamfunction
for i=1:IM
    for j=1:JM
        xx=2*(i-1)/(IM-1)-1;
        yy=2*(j-1)/(JM-1)-1;
        xp(i,j)=xx;
        yp(i,j)=yy;
        psi(i,j)=xx*yy;
    end
end

if icase==1

% Put 400 parcels on a small recangle
for i=1:100
    x(i)=-0.05+0.1*(i-1)/99.;
    y(i)=0.95;
end
for i=1:100
    x(i+100)=0.05;
    y(i+100)=0.95-0.2*(i-1)/99.;
end
for i=1:100
    x(i+200)=0.05-0.1*(i-1)/99.;
    y(i+200)=0.75;
end
for i=1:100
    x(i+300)=-0.05;
    y(i+300)=0.75+0.2*(i-1)/99.;
end

end

if icase==2
   x=0.1*randn(NP,1) ;
   y=0.9+0.1*randn(NP,1);
end
if icase==3
% define your own distribution
   for i=1:NP
   x(i)=sin(i);
   y(i)=cos(i);
   end
end
% Save initial points and check they fall inside the nondimensiona domain

for i=1:NP
  x(i)=max(x(i),-1);
  x(i)=min(x(i),1);
  y(i)=max(y(i),-1);
  y(i)=min(y(i),1);
end

xi=x;
yi=y;

% RESOLUTION & PLOT
% Initial position
    plot(x,y,'.');
    axis equal;
    hold on;
    % Show contour of streamfunction
    contour(xp',yp',psi')
    title('Kinematic frontogenesis. To start press any key')
    hold off;
    pause;

    % Loop over time
for n=1:NMAX
    % Move each point with an Lagrangian advection
    % discretized by a predictor corrector method
    for i=1:NP
        % Get velocities at departure
        [u,v]=velocityfronto(x(i),y(i));
        % predictor of arrival point
        xx=x(i)+u*DT;
        yy=y(i)+v*DT;
        % corrector based on velocity at expected arrival
        [u,v]=velocityfronto(xx,yy);
        % Final destination with this velocity
        x(i)=x(i)+u*DT;
        y(i)=y(i)+v*DT;
    end
    % increase time
    t=t+DT;
    plot(x,y,'.');
    axis([-1 1 -1 1])
    axis equal;
    hold on;
    % Show contour of streamfunction
    contour(xp',yp',psi')
    hold off;
    pause(timetowait);
end

