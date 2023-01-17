function [pl] = coriolisanim(pm,n,nend,alpha,beta,X0) 

% RESOLUTION

% n      :  number of calculation points for one period
% nend   :  stop after nend calculation points (if you want to plot after a quarter of oscillation use nend=n/4+1
% alpha  :  V_0/(X_0 Omega)
% beta   :  U_0/(X_0 Omega)

% Number of loops for the animation
NLOOPS=1;
% The speed of the animation can be controlled by the timetowait parameter
timetowait=0.1;

for nn=1:NLOOPS

pl=pm;

% Plot the edge of the platform: a circle
for i=1:101
    xc(i)=10*cos(i*pi*2/100);
    yc(i)=10*sin(i*pi*2/100);
end

% Time steps to reach nend/n revolutions with rate Omega
for j=1:nend
 % ot=omega t
    ot=(j-1)*pi*2/n;
 % dot= omega delta t
    dot=pi*2/n;
 % four line segments to see rotation of plane (two segments fixed, two segments attached to rotating table
    x1(1)=7*cos((j-1)*pi*2/n);
    z1(1)=7*sin((j-1)*pi*2/n);
    x1(2)=10*cos((j-1)*pi*2/n);
    z1(2)=10*sin((j-1)*pi*2/n);
    x2(1)=10*cos((j-1)*pi*2/n+pi/2);
    z2(1)=10*sin((j-1)*pi*2/n+pi/2);
    x2(2)=7*cos((j-1)*pi*2/n+pi/2);
    z2(2)=7*sin((j-1)*pi*2/n+pi/2);
    x3(1)=10.5;
    z3(1)=0;
    x3(2)=12;
    z3(2)=0;
    x4(1)=0;
    z4(1)=10.5;
    x4(2)=0;
    z4(2)=12;
 % XXA and YAA solution in absolute axes as a function of initial conditions
    x0=X0;
    XA(1)=x0*cos(ot)+ beta*x0*sin(ot);
    YA(1)=alpha*x0*sin(ot);
 % storage of trajectory in absolute axes
    XAA(j)=XA(1);
    YAA(j)=YA(1);
 % rotation of trajectory inprint on rotating axis        
    for i=1:j-1;
        xn=xt(i)*cos(dot)-yt(i)*sin(dot);
        yn=xt(i)*sin(dot)+yt(i)*cos(dot);
        xt(i)=xn;
        yt(i)=yn;
    end
 % adding of new point to the trajectory
    xt(j)=XA(1);
    yt(j)=YA(1);

% PLOT

   
        pm = plot(x1,z1,'b-',xc,yc,XA,YA,'o',xt,yt,'.',XAA,YAA,'-',x1(2),z1(2),'ko',x2,z2,'b-',x3,z3,'b-',x4,z4,'b-');
        axis('equal');
        axis('off');
        % set lines to 2 pixels wide
        set(pm(3),'LineWidth',3)
        set(pm(5),'LineWidth',2)
        set(pm(2),'LineWidth',2)
        set(pm(1),'LineWidth',2)
        set(pm(6),'LineWidth',6)
        set(pm(7),'LineWidth',2)
        set(pm(8),'LineWidth',2)
        set(pm(9),'LineWidth',2)
        pause(timetowait)
    
end

clear xn xt yn yt XAA YAA

% Do another loop for the animation
end % end loop of repeated animation