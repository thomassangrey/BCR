function [pl] = aliasanim(n,nper) 

% 
% Matlab function that shows an animation of the aliasing problem. 
% It samples a cosine function with increasing time steps. 
% To be used from the command line by typing for example 
%    aliasanim(300,2)
% n: number of initial sampling points per period of the signal
% nper: number of periods shown for the real signal
% (suggested: n=300, nper=2)
% when launched, the sampling frequency is decreased

% For visualisation NLOOPS are showns
NLOOPS=3
% The speed of the animation can be controlled by the timetowait parameter
timetowait=0.1


% Initial signal, nicely sampled if n is large. 
% di = omega Delta t 
for i=1:nper*n
    di=2*pi/(nper*n)*nper;
    t(i)=di*(i-1);
    z(i)=cos(t(i));
end
figure
% show the original sampling
    plot(t,z,'g-');
    title('Original signal: to animate the sampling press any key');
    axis([0 2*nper*pi -1 1])
    xlabel('\omega t')
pause

% Repeat the animation NLOOP times
for ntimes=1:NLOOPS

% For each image
for j=1:n*nper-1
    % Create a sampling (ts and zs) with decreasing frequency
    jj=nper*n;
    for i=1:nper*n
        di=2*pi/(nper*n)*nper*j;
        ts(i)=di*(i-1);
        zs(i)=cos(ts(i));
    end
    
% PLOT with original signal in light 
    
    h=plot(t,z,'g-',ts(1:jj),zs(1:jj),'o',ts(1:jj),zs(1:jj),'b-');
    if di/pi< 1
    title([' \omega \Delta t / \pi =' num2str(di/pi,'%1.3f') ' : no aliasing']);
else
    title([' \omega \Delta t / \pi =' num2str(di/pi,'%1.3f') ' :    ALIASING'])
end
    axis([0 2*nper*pi -1 1])
    xlabel('\omega t')
    % set lines to 2 pixels wide
    set(h(2),'LineWidth',2)
    set(h(3),'LineWidth',2)
       pause(timetowait)
 end

end % end of the NLOOPS
%movie(M)