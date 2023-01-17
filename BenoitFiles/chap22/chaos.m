

% Number of time steps
NMAX=4000

% Maximum shift for autocorrelation calculation. Shift in number of time steps NS
NS=NMAX/5

% time step
dt=0.01

% create initial condition already on the attractor by using a transient of nini iterations
nini=5000

% Initialisation of variables
for i=1:NMAX+1
    diff(i)=0;
    errper(i)=0;
    errclim(i)=0;
    errinit(i)=0;
    errmodel(i)=0;
    Delta(i)=0;
    skillinit(i)=0;
    skillmodel(i)=0;
    skillinitcl(i)=0;
    skillmodelcl(i)=0;
end

% Initialisation of autocorrelation arrays with lags from 0 to NS
for i=1:NS+1
corr1(i)=0;
corr2(i)=0;
corr3(i)=0;
tt(i)=0;
end
% To make robust estimates, an ensemble approach is used
% number of members is jmax
jmax=200

% Loop on all members
for j=1:jmax

% Create an initial condition which is random
ini=[randn(1),randn(1),randn(1)]
    
% From this random initial condition, let the solution jump on the attractor by making nini time steps
% with Runge Kutta integration    
[XXxx,t]=rk4(@lorenz,[10,28,8/3],ini,0,dt,nini);

% Use the final position of this adjustement as new initial condition

x0=[XXxx(nini,1),XXxx(nini,2),XXxx(nini,3)]

% 
% Reference solution
[XX,t]=rk4(@lorenz,[10,28,8/3],x0,0,dt,NMAX);
% Solution with perturbed initial condition
[XXP,t]=rk4(@lorenz,[10,28,8/3],x0+[0.01,0,0],0,dt,NMAX);
% Solution with pertrubed parameter (9/3 instead 8/3).
[XXe,t]=rk4(@lorenz,[10,28,9/3],x0+[0,0,0],0,dt,NMAX);

% Norm of the difference between the two solutions differing by initial condition, averaged over jmax members
for k=1:NMAX+1
diff(k)=diff(k)+norm([XX(k,1)-XXP(k,1),XX(k,2)-XXP(k,2),XX(k,3)-XXP(k,3)])/jmax;
end

% For a phase shift ranging from zero to NS*dt, calculate autocorrelations
for ii=0:NS
    % Take as much points as possible for correlation calculation
    N=NMAX-ii;
    N1=1+ii;
    N2=N1+N-1;
    % Variable 1
    xori=XX(1:N,1);
    xshifted=XX(N1:N2,1);
    % For correlations, subtract mean values
    xori=xori-mean(xori);
    xshifted=xshifted-mean(xshifted);
    % Then calculate correlation
    zz=corrcoef([ xori xshifted] );
    % and store it with accumulation of members
    corr1(ii+1)=corr1(ii+1)+zz(1,2)/jmax;
    
    % Same for variable 2
    xori=XX(1:N,2);
    xshifted=XX(N1:N2,2);
    zz=corrcoef([ xori xshifted] );
    corr2(ii+1)=corr2(ii+1)+zz(1,2)/jmax;
    
    % Variable 3
    xori=XX(1:N,3);
    xshifted=XX(N1:N2,3);
    zz=corrcoef([ xori xshifted] );
    corr3(ii+1)=corr3(ii+1)+zz(1,2)/jmax;
    % Value of shift
    tt(ii+1)=(ii-1)*dt;
end

% some skills in function of lead time:
% persistence
% climatology=average
climate=mean(XX);
% Also make ensemble approach by adding contributions of each member
for k=1:NMAX+1
    % Base model is persistence: the error is the actual solution minus the intial condition
    errper(k)=errper(k)+norm([XX(k,1)-x0(1),XX(k,2)-x0(2),XX(k,3)-x0(3)])/jmax;
    % Base model is climatology: the average value is the preduction and the error is the difference of solution and average
    errclim(k)=errclim(k)+norm([XX(k,1)-climate(1),XX(k,2)-climate(2),XX(k,3)-climate(3)])/jmax;
    % Error due to change in initial condition as a function of time
    errinit(k)=errinit(k)+norm([XX(k,1)-XXP(k,1),XX(k,2)-XXP(k,2),XX(k,3)-XXP(k,3)])/jmax;
    % Error due to a model parameter as a function of time
    errmodel(k)=errmodel(k)+norm([XX(k,1)-XXe(k,1),XX(k,2)-XXe(k,2),XX(k,3)-XXe(k,3)])/jmax;
    Delta(k)=(k-1)*dt;
    % Skill of a model with unreliable initial condition (skill with respect to base model of persistence)
    skillinit(k)=skillinit(k)+(1-errinit(k)/errper(k))/jmax;
    % Skill of a model with unreliable parameter condition (skill with respect to base model of persistence)
    skillmodel(k)=skillmodel(k)+(1-errmodel(k)/errper(k))/jmax;
    % Skill of a model with unreliable initial condition (skill with respect to base model of climatology)
    skillinitcl(k)=skillinitcl(k)+(1-errinit(k)/errclim(k))/jmax;
    % Skill of a model with unreliable parameter condition (skill with respect to base model of climatology)
    skillmodelcl(k)=skillmodelcl(k)+(1-errmodel(k)/errclim(k))/jmax;

end
% Next member
end
close all


% An example of trajectories
plot(XX(:,1),XX(:,3))
axis off
title('Solution in (x,z) plane')
%print -deps lorenz1.ps
figure
plot(t,XX(:,1),t,XXP(:,1))
title('x(t) for two slightly perturbed initial conditions')
%print -deps lorenz2.ps
figure


    

plot(t,log(diff))
axis([0 15 -6 4])
title('Log of trajectory distance as a function of time')
%print -deps lorenz3.ps
figure
plot(tt,corr1)
axis([0 5 -.2 1])
title('Autocorrelation as a function of Delta')
%print -deps lorenz5.eps
figure
plot(Delta,skillinit,Delta,skillinitcl)
axis([0 10 -1 1])
title('Skill of a model with unreliable initial condition. Skill with respect to persistence and climatology')
xlabel('Lead time')
%print -deps lorenz4.eps
figure
plot(Delta,skillmodel)
title('Skill of a perturbed model')
axis([0 10 -1 1])
