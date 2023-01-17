clear all;
% To control speed
timetowait=1


% PARAMETERS
% Number of grid points
M=100;
% Courant Friedrich Levy parameter u*dt/dx
cfl=0.5;

% Number of points over which the solution is to be advected
MF=50;
% Resulting number of time steps to be calculated
NITER=MF/cfl;

% Position of the initial condition, the hat problem
i1=10;
i2=30;

% Location of the observing station, grid point number kloc
kloc=40;



% INITIALIZATION

% Solution is zero
for i=1:M
    c(i)=0;
    x(i)=i;
    ce(i)=0;
end
% Except for the hat location
for i=i1:i2
    c(i)=1;
    ce(i+MF)=1;
end
% Initialisation of arrays storing i
ci=c;
% cp contains the prediction for moment n+1
cp=c;
% cu contains the uncorrected solution for comparison
cu=c;

% Here, for educational purpose, we
% explicitely formulate the model matrix
for i=1:M
    for j=1:M
        MM(i,j)=0;
    end
end
MM(1,1)=1;
% The model is made imperfect by not using the correct
% velocity but an underestimated velocity by a factor 0.9
% The model is also imperfect since we implement an upwind
% finite differencing (point i is only connected to point i 
% and i-1)
cflerr=cfl*0.9;
for i=2:M
    MM(i,i)=1-cflerr;
    MM(i,i-1)=cflerr;
end

% Initializatio of Forecast error. We start with the 
% correct initial condition
PERR=zeros(M,M);
% If you want to express that you are not sure about the
% Initial condition, in ag given point 10 you might try
%PERR(10,10)=0.1;


% Now time stepping with assimilation every time step
% 

for n=1:NITER
    % Uncorrected solution is given as a reference
    cu=(MM*cu')';
    % Forecast
    cp=(MM*c')';
    % Old value is the new forecast
    c=cp;     
    % Adavance Error with Lyapounv equation
    PERR=MM*PERR*MM';
    % The error at the inflow is zero
    PERR(1,1)=0;
    % We add an estimate of the model error variance 0.01
    for i=2:M
        PERR(i,i)=PERR(i,i)+0.01;
    end
    % From there, calulate the kalman gain matrix assuming
    % an obervational error variance of 0.0001
    KAL=PERR(:,kloc)/(PERR(kloc,kloc)+0.0001);
    % Extract data from the exact solution
    for i=1:M
        di=round(cfl*n);
        cex(i)=ci(max(i-di,1));
    end
    % Observation of exact solution in the observing point
    obs=cex(kloc);
    % Misfit multiplied by Kalman gain (c is a line instead of column
    % vector)
    myerr=(obs-c(kloc))*KAL';
    % Show forecast error covariance
    % Error covariance
    subplot(1,2,1)
    pcolor(PERR');
    colorbar
   
    % correct the model forecast
    c=c+myerr;
    % Calculate the error covariance of the analysis
    for i=1:M
        for j=1:M
            PERRA(i,j)=PERR(i,j)- KAL(i)*PERR(kloc,j);
        end
    end
    % The error covariance of the analysis will be used for the next
    % step as error covariance
    PERR=PERRA;
    % Plot of the different components
    subplot(1,2,2)
    plot(x,c,'-',x,cu,'+',x,cex,'--',x(kloc),cex(kloc),'o')
    legend('Forecast' ,'Uncorrected model', 'Exact solution', 'Observation')
    axis([0 100 -0.4 1.4])
    pause(timetowait)
end


