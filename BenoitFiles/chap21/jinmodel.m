clear all
close all


% speed of animation
timetowait=0.1


SECINYEAR=365.25*24*3600

TMAX=40*SECINYEAR
TINI=0

imax=1000
for i=1:imax
    TSPAN(i)=TINI+(i-1)*(TMAX-TINI)/(imax-1.);
end
% For a change, we call a matlab routine for time integration. A Function needs to be passed to this routine ode45
% the function passed is jin.m in which you can find the time derivatives at any moment.
% The solution is in sol
[time,sol]=ode45(@jin,TSPAN,[0;2]);


%From here, basically plotting the results in the schematic way of Figure
%21-7

plot(sol(:,1),sol(:,2))
title('Hw vs TE')
figure
plot(time/SECINYEAR,sol(:,1),time/SECINYEAR,sol(:,2))
title('Hw and TE as a function of time')
figure

hwest=sol(:,1);
teast=sol(:,2);

% From two variables, retrieve other parameters (scale does not matter for
% plotting)
winda=teast;
heast=hwest+winda;

windscale=max(abs(winda))/1.5;
tscale=max(abs(teast));
hscale=1;
NT=size(sol);
NN=NT(1);
H=100

% A plot for each time step
for i=1:NN
    
    xe(1)=0;
    xe(2)=100;
    xe(3)=100;
    xe(4)=0;
    ye(1)=-H-heast(i)/hscale;
    ye(2)=ye(1);
    ye(3)=0;
    ye(4)=0;
    xe(5)=xe(1);
    ye(5)=ye(1);
    xw(1)=-100;
    xw(2)=0;
    xw(3)=0;
    xw(4)=-100;
    yw(1)=-H-hwest(i)/hscale;
    yw(2)=yw(1);
    yw(3)=0;
    yw(4)=0;
    xw(5)=xw(1);
    yw(5)=yw(1);
    xref(1)=-100;
    yref(1)=-H;
    xref(2)=100;
    yref(2)=yref(1);
    xb(1)=-1.2*100;
    xb(2)=-100;
    xb(3)=xb(2);
    xb(4)=xb(1);
    xb(5)=xb(1);
    yb(1)=-2*H;
    yb(2)=yb(1);
    yb(3)=0.05*H;
    yb(4)=yb(3);
    yb(5)=yb(1);
    xbb(1)=1.2*100;
    xbb(2)=100;
    xbb(3)=xbb(2);
    xbb(4)=xbb(1);
    xbb(5)=xbb(1);
    ybb(1)=-2*H;
    ybb(2)=ybb(1);
    ybb(3)=0.05*H;
    ybb(4)=ybb(3);
    ybb(5)=ybb(1);
    
    
    tcol=[1,1-teast(i)/tscale,1-teast(i)/tscale];
    if teast(i) < 0
        tcol=[1+teast(i)/tscale,1+teast(i)/tscale,1];
    end
    fill(xe,ye,tcol)
    hold on
    fill(xb,yb,[0 ,0,0])
    fill(xbb,ybb,[0 ,0,0])
    plot(xw,yw,xref,yref,'-.')
    quiver(-0.3*100-winda(i)/windscale/2*100,0.1*H,winda(i)/windscale*100,0,0)
    
    scatter(-0.3*100,-0.09*H,abs(winda(i)/windscale*200),'o')
    if winda(i)> 0
        scatter(-0.3*100,-0.09*H,abs(winda(i)/windscale*200),'.')
    else
        scatter(-0.3*100,-0.09*H,abs(winda(i)/windscale*200),'x')
    end
    axis([-1.2*100 1.2*100 -2*H 0.3*H])
    axis off
    if i==1
        title('press any key to continue')
        pause
    else
    pause(timetowait)
    end
    hold off
    
end