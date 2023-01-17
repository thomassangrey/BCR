clear all;

% PARAMETERS

% M calculation nodes (first point below bottom, last one above surface. Boundaries between two first points and two last points)
% (M-2)*DZ=H
% N number of time steps
% Think about the number N of steps to be performed to simulate a fixed time inverval
% You can adapt the speed of plotting by adapting timetowait.
timetowait=0.5

% Number of grid nodes
M=20;
% Depth
H=100;
% Diffusion coefficient
kappa=0.01;
% Grid spacing
DZ=H/(M-2);
% Time step
DT=H*H/kappa/M;
% Number of time steps
N=20;
% Time origin
t=0;
% 2*DS is the (arbitrary) initial difference of C across the domain.
DS=-1;

% RESOLUTION AND PLOT

% Initial field for field CN, you can verify that the finite difference at the boundary leads to zero gradients
% 
for i=1:M;
    z(i)=-H+(i-1-1/2)*DZ;
    CN(i)=37+DS*cos(z(i)/H*pi);
end

% Make N time steps
for n=1:N
    
    
    plot(CN,z)
    xlabel('S');
    ylabel('z');
    pause(timetowait)
    
    % New values for interior points 
    for i=2:M-1
        CNP(i)=CN(i)+kappa*DT/DZ/DZ*(CN(i-1)-2*CN(i)+CN(i+1));
    end
    
    % Update new values and diagnose conservation at time step n by summing concentrations
    SUM(n)=0;
    for i=2:M-1
        % new value is old value for next step
        CN(i)=CNP(i);
        % diagnose sum (integral)
        SUM(n)=SUM(n)+CN(i)*DZ;
    end
    integratedc=SUM(n)
    % Boundary condition (zero gradient)
    CN(1)=CN(2);
    CN(M)=CN(M-1);
    % Update time
    t=t+DT;
    
end

plot(CN,z);
xlabel('C');
ylabel('z');

figure;
title('Conservation over time')
plot(SUM);
xlabel('iteration');
ylabel('SUM');
