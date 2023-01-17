clear all;

% PARAMETERS

% alpha  :  scaled azimuthal initial velocity V_0/(X_0 Omega)
% beta   :  scaled radial initial velocity U_0/(X_0 Omega)
% X0     :  Initial distance (less then 10 for plotting reasons)
% n      :  number of time steps to show a full period
% nend   :  last time step (to show only half a period nend=n/2)

alpha=0.4;
beta=0.9;
X0=3;
n=101;
nend=n/1+1;

% Other Examples
% coriolisanim(100,101,0,0,5) part a of Figure 2.8
% coriolisanim(100,101,1,0,5) part b of Figure 2.8
% coriolisanim(100,101,-1,0,5) part c of Figure 2.8

% PLOT

    pm = figure(1);
    figure(gcf);
   coriolisanim(pm,n,nend,alpha,beta,X0);
