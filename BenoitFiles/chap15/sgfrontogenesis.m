clear all;
close all
% Number of isolines to show
M=30;
% To control the animation speed
timetowait=0.1

% Scaling is arabitray and can be traced to the
% non-dimension temperature variation, the spatial scale, coriolis frequency
% , velocity convergence and gravity 
SCALE=1/0.6;

% Profide the initial distribution of Y(T)
for i=1:M
    % Non dimensional temperature (cold to the left)
    T(i)=-1+2*i/(M+1);
    Y0(i)=atanh(T(i));
    % From there, calculate -dY/dT and apply a scaling
    % Derivative of atanh(z) is 1/(1-z^2)
    S0(i)=-SCALE/(1-T(i)^2);
end

% Loop over time
for t=0:0.03:1
    % Loop over all isolines
    for i=1:M
        % Time evolution of slopes and geostrophic coordinate
        S=S0(i)*exp(-t);
        Y=Y0(i)*exp(-t);
        % Calculate start and end point of each line, knowing Y and S
        zp(1)=0;
        yp(1)=Y-0.5/S;
        zp(2)=1;
        yp(2)=Y+0.5/S;
        % Then plot the line and hold the plot open for next line
        plot(yp,zp);
        xlabel('y')
        ylabel('z')
        axis([-1 1 0 1])
        hold on
        
    end
    pause(timetowait)
    hold off
    xlabel('y')
    ylabel('z')
    axis([-1 1 0 1])
    if t==0
            title('Initial distribution: To start press any key')
            pause
    end
end

