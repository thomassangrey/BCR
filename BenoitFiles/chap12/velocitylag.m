function[u,v]= velocitylag(x,y,icase) 
% 
% Calculates velocity components u and v (non-dimensional)
% at any location x and y (non-dimensional)
% For real lagrangien models, the velocities are generally provided on a grid
%    and in the latter case, the routine should interpolate the values to the
%    location of interest

% boundary layer thickness (same as in calling routine traj2D.m
del=0.1;
if icase==1
    % Velocityfield of sverdrup circulation
u=pi/2*sin(y*pi/2)*(1-x-exp(-x/del));
v=cos(y*pi/2)*(-1+1/del*exp(-x/del));
end
if icase==2
    % Alternating anticyclones and cyclones
u=-pi*cos(y*pi/2*2)*sin(x*pi/2*4);
v=2*pi*sin(y*pi/2*2)*cos(x*pi/2*4);
end