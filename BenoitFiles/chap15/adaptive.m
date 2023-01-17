clear all;
close all
% PARAMETERS

% To control animation speed
timetowait=0.01

% Number of sampling points for the fine reference function
mfine=1000;

% Range for x
xmin=-10;
xmax=10;

% Number of discretisation points 
m=10;

% Parameters for the grid adaptaion
FSCALE=1;
LSCALE=1;
% Term for gradient to be scaled so that pseudo-time is O(1)
alpha=LSCALE/FSCALE;
% background weight to control weight to get a regular grid
% Strong filtering
% beta=3.1;
% Medium filtering
beta=0.1;
% No filtering
% beta=0;

% Pseudo time step
dt=0.1;

% Initialization
% The fine resolution function
for i=1:mfine
    xf(i)=xmin+(xmax-xmin)*(i-1)/(mfine-1);
    ff(i)=functiontofollow(xf(i));
end
 % The original sampling with m points
for i=1:m
    x(i)=xmin+(xmax-xmin)*(i-1)/(m-1);
    f(i)=functiontofollow(x(i));
end
% Show the initial fine function and sampling points
plot(x,f,'o',xf,ff);
title('Initial sampling of function functiontofollow: press key to continue')
pause;

% Adaptation

% Initialisation
xn=x;
xini=x;
fini=f;

% To be sure to converge, large number of step
for n=1:1000
    
    cof=dt*alpha;
    cof2=dt*beta;
    for i=2:m-1
        xn(i)=x(i)+(abs(f(i+1)-f(i))-abs(f(i)-f(i-1)))*cof+cof2*(x(i+1)-2*x(i)+x(i-1));
    end
    xn(1)=x(1);
    xn(m)=x(m);
    x=xn;
    % Reevaluate function value at the new positions
    for i=1:m
        f(i)=functiontofollow(x(i));
    end
    % Plot the situation
    plot(x,f,'o',xf,ff,x,f,'-.');
    title(['Iteration :' int2str(n)])
    pause(timetowait);
    % Interpolate the function sampled with the m points linearly on the
    % fine grid to compute an rms error between actual function and the
    % linear interpolations relying on the sampling
    ffine=interp1(x,f,xf);
    err(n)=norm(ff-ffine);
end
figure;

% Results

plot(err);
title('rms error of lineary interpolated function using the sampling')
xlabel('Iteration')
figure;

ffineini=interp1(xini,fini,xf);
plot(xf,ffineini,xini,fini,'o',xf,ff);
axis([-10 10 -1.1 1.1]);
axis off;
title('Standard uniform grid')
%print -deps uniformgrid.eps;
figure;

plot(xf,ffine,x,f,'o',xf,ff);
axis([-10 10 -1.1 1.1]);
axis off;
title('Adapted grid')
%print -deps adaptedgrid.eps;
axis off;
