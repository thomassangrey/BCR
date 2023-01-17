% To slow down increase timetowait
timetowait=0.1
% Number of grid points
M=63;
% Number of time steps
NT=2000

% Pseudo observation network starts in iob, ends in ioe with steps of ist
iob=floor(M/2+1)-20;
ioe=iob+40;
ist=5;

% Data is extracted every nstep time steps
nstep=100;

% Calculate indexes for pseudo-observations
iobs=0;
for i=iob:ist:ioe
    iobs=iobs+1;
    iobsindex(iobs)=i;
end
% Number of observations at each assimilation cycle
nobs=iobs;

% Allocation of arrays H P H^T
HPHT=zeros(nobs,nobs);
% P H^T
PHT=zeros(M-2,nobs);
% y_0
yob=zeros(1,nobs);
% y_0 - H x
misfit=yob;

% State variables velocity and surface height
% Reference solution
u=zeros(1,M);
ssh=zeros(1,M);
% Forecast solution
uf=zeros(1,M);
sshf=zeros(1,M);
% Analysed solution for restarting
ssha=zeros(1,M);

% Parameters of the model
% Grivity
g=9.81;
% grid spacing
DX=1000;
% Water depth
H=100;
% initial time
t=0;
% time step (to be smaller than dx/sqrt(g h))
DT=2

% Domain length with water
RL=(M-2)*DX;

% Initial ssh
for i=1:M
    x(i)=(i-1.5)*DX;
    ssh(i)=0.9*cos((i-1.5)*DX*2*3.1415/RL);
end

% The forecasts starts with a very bad guess, ie zero elevation
sshf=zeros(1,M);

% Create covariance matrices with direct selection of relevant components
% Variance of the background
VAR=0.3^2;
% Correlation length
RL=10000;
% Error variance on observation
VAROBS=0.02^2;
for i=1:nobs
    for j=1:nobs
        xi=x(iobsindex(i));
        xj=x(iobsindex(j));
        % Covariance between data points
        HPHT(i,j)=exp(-(xi-xj)^2/RL^2)*VAR;
    end
end
for i=1:M-2
    for j=1:nobs
        xi=x(i+1);
        xj=x(iobsindex(j));
        % Covariance between data point and model point
        PHT(i,j)=exp(-(xi-xj)^2/RL^2)*VAR;
    end
end
% Kalman gain with diagonal matrix for observational error
KKALM=PHT*inv(HPHT+VAROBS*diag(ones(nobs,1)));


% Now time stepping
for n=1:NT
    t=t+DT;
    
    % Advance in time both reference solution ssh 
    % and forecast sshf with the same equations
    for i=2:M-1
        % Reference
        ssh(i)=ssh(i)-H*(u(i+1)-u(i))*DT/DX;
        % Forecast (if you want to see the effect of a bad model, use
        % another value of H here
        sshf(i)=sshf(i)-H*(uf(i+1)-uf(i))*DT/DX;

    end
    % Now velocity
    for i=3:M-1
        u(i)=u(i)-g*(ssh(i)-ssh(i-1))*DT/DX;
        uf(i)=uf(i)-g*(sshf(i)-sshf(i-1))*DT/DX;
    end
    
    
    % Every nstep perfrom an assimilation
    if mod(n,nstep)==0
        tassimil=t;
        
        % Extract observations from the reference solution 
        % and add noise. If you want to see the effect of 
        % specifying an incorrect estimation of observational noise
        % in the assimilation, put another value VAROBS here than 
        % in the Kalman gain.
        for i=1:nobs
            yob(i)=ssh(iobsindex(i))+randn(1,1)*sqrt(VAROBS);
            xob(i)=x(iobsindex(i));
        end
        % From data, calculate misfit
        for i=1:nobs
            misfit(i)=yob(i)-sshf(iobsindex(i));
        end
        % From misfit and Kalman gain matrix, calculate correction
        corr=KKALM*misfit';
        % Calculate analysed ssh
        for i=2:M-1
            ssha(i)=sshf(i)+corr(i-1);
        end
        % When asssimilating, plot data extracted, reference solution, 
        % forecast and analysis. Wait some time to show and then proceed
        plot(x(2:M-1),sshf(2:M-1),'r',x(2:M-1),ssh(2:M-1),'g',xob,yob,'bo',x(2:M-1),ssha(2:M-1),'b');
        tt=[ 'time '  num2str(t) ' sec'];
        axis( [x(2) x(M-1) -1 1]);
        title(tt);
        legend('Forecast' ,'True field' ,'Observations', 'Analysis');
        pause(5);
        % Use the analysed field as new forecast
        sshf=ssha;
    end

    % For all time steps, plot evolution of reference and forecast
    plot(x(2:M-1),sshf(2:M-1),'r',x(2:M-1),ssh(2:M-1),'g')
    tt=[ 'time '  num2str(t) ' sec']
    axis( [x(2) x(M-1) -1 1])
    title(tt)
    legend('Forecast','True field')
    pause(timetowait)
    
end
