clear all;

% PARAMETERS
% Number of grid points
M=100;

% Courant Friedrichs Levy Parameter C
cfl=0.5;     % Test with cfl= 1 0.5 0.1 0.05
% Diffusion parameted D
diffd=0.25;  % Test with diffd= 0.05
% Sink term parameter B
gammadt=0.05;  % Test with 0.5 and 1.5

% Non-dimensional final time
MF=100;

% Number of time steps to reach Non-dimensional final time
NITER=MF/cfl;

% Save solution every MSOL time steps
MSOL=2;


% Control the animation speed

timetowait=0.1



isol=1;

% RESOLUTION

% Initial values: start from zero
cc=zeros(M,NITER/MSOL);
for i=1:M
    c(i)=0;
    x(i)=i;
end
cp=c;

% Make N time steps
for n=1:NITER
    
    % New values for interior points
    for i=2:M-1
        cp(i)=c(i)-cfl*(c(i+1)-c(i-1))/2-gammadt*c(i)+(diffd+cfl*cfl/2)*(c(i+1)-2*c(i)+c(i-1));
    end
    
    % Boundary condition (Upwind)
    cp(1)=1.;
    cp(M)=1.;
    
    % Update new values
    c=cp;
    
    % Save values every MSOL time steps
    if mod(n,MSOL)==0
        isol=isol+1;
        cc(:,isol)=c(:);
        
% PLOT
        
        plot(x,c)
        xlabel('i');
        ylabel('C');
        title(['Percent done : ' num2str(floor(100*n/NITER),3)])
        pause(timetowait)
    end
    
end

