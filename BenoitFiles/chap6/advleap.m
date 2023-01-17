clear all;

% PARAMETERS
% Number of grid points
M=100;
% Courant-Friedrichs-Levy parameter C
cfl=0.75;
% Final position of the hat to be transported
% (contrary to previous examples, we calculate the time such that we reach grid point
%  MF at the end of the iterations
MF=50;

% Speed of animation
timetowait=0.1


% Position of the hat
i1=10;
i2=30;

% Deduced number of time steps to reach final position
N=MF/cfl;

% SOLUTION

% Initial values
for i=1:M
    c(i)=0;
    x(i)=i;
    ce(i)=0;
end
for i=i1:i2
    c(i)=1;
    % Stores the exact solution (just a shift)
    ce(i+MF)=1;
end
% 
ci=c;
cm=c;
cp=c;

% cm contains c at moment n-1
% c  contains c at moment n
% cp contains c at moment n+1

% First step for Leapfrog:
for i=2:M-1
    c(i)=cm(i)-cfl/2*(cm(i+1)-cm(i-1));  % (Euler step)
   % Alternative brute force initialisation for time level 2
   % c(i)=cm(i);
   % Or Euler upwind initialisation of time level 2
   % c(i)=cm(i)-cfl*(cm(i)-cm(i-1));
   
end

% Make N time steps
for n=1:N
    
    % New values for interior points by Leapfrog scheme
    for i=2:M-1
        cp(i)=cm(i)-cfl*(c(i+1)-c(i-1));
    end
    
    % Boundary condition (Upwind)
    cp(M)=c(M)-cfl*(c(M)-c(M-1));
    cp(1)=0.;
    
    % Boundary condition (Periodic)
    % cp(M)=cp(2);
    % cp(1)=cp(M-1);
    
    % Update new values
    for i=1:M
        cm(i)=c(i);
        c(i)=cp(i);
    end
    % Diagnose variance
    csquare(n)=0;
    for i=2:M-1
        csquare(n)=csquare(n)+c(i)*c(i);
    end
    plot(x,c,'-')
    xlabel('x');
    ylabel('C');
    pause(timetowait)
    
end

% PLOT

figure;
plot(csquare/M)
xlabel('Time step');
ylabel('Total variance');

figure;
plot(x,c,'-',x,ce,'-.',x,ci,'--')
xlabel('x');
ylabel('C');
title('Final solution and exact solution')
