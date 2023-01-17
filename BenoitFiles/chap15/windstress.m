function [val] = windstress(t) 

% Wind stress function used in upwelling.m Here for 3 inertial periods
% at f=0.0001 a wind speed of 20m/s is used
val=0.001*20*20;
if t > 3*2*pi/0.0001 
    val=0;
end
