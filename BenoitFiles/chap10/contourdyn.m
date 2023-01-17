clear all;

% frequency of the plots, every nfreq time steps
nfreq=5; 

t=0;
% If you have a fast machine you can increase the waiting time between plots
timetowait=0.0001

% itest defines the situation simulated
% 0 user defined
% 1 one elliptical eddy of axes ration rat=b/a
% 2 three cocentric elliptical eddies  of axes ratio rat=b/a
% 3 thin layer
% 4 two circular eddies of radius 0.4 at distance dist
itest=3;

if itest==0
    % user defined: try to see how to implement new conditions
    
elseif itest==1
    % one elliptical eddy of axes ratio rat=b/a
    % number of points on each contour
    ip=200;
    % number of time steps
    ntot=600;
    % time step
    dt=0.05;
    % number of patches
    KM=1;
    % eddy shape
    rat=4;
    % mode four perturbation
    nlobes=4;
   
    % define KM patches
    for k=1:KM
        % define the points of the contour
        for i=1:ip+1
            th=i/ip*2*pi;
            
            r=1+0.00*cos(th*nlobes);
            % coordinates of the contour points
            x(i,k)=1*r*cos(i/ip*2*pi)+0.01*sin(i/ip*3*pi);
            y(i,k)=1/rat*r*sin(i/ip*2*pi)+0.01*cos(i/ip*3*pi);
        end
        % value of omega over 4 pi for the patch
        omofp(k)=1/(4*pi);
        % colour for the plotting for the patch
        mycol(k)='r';
    end
    
elseif itest==2
    % three cocentric elliptical eddies  of axes ratio rat=b/a
    % For parameters, see explanation of itest=1
    
    nfreq=1;
    ip=200;
    ntot=100;
    dt=0.07;
    KM=3;
    rat=3.5;
    rat=2.5;
    nlobes=2;
    for k=1:KM
        for i=1:ip+1
            th=i/ip*2*pi;
            r=1+0.00*cos(th*nlobes)-(k-1)/KM;
            x(i,k)=1*r*cos(i/ip*2*pi);
            y(i,k)=1/rat*r*sin(i/ip*2*pi);
        end
        omofp(k)=1/(4*pi);
        mycol(k)='b';
    end
    mycol(1)='g';
    mycol(2)='y';
    
elseif itest==3
    % thin layer
    
    nfreq=1;
    nfreq=5
    ip=200;
    ntot=220*3;
    dt=0.05;
    KM=2;
    rat=1;
    nlobes=10;
    for k=1:KM
        for i=1:ip+1
            th=i/ip*2*pi;
            r=1+0.003*cos(th*nlobes+(k-1)*pi/2)-0.05*(k-1);
            x(i,k)=1*r*cos(i/ip*2*pi);
            y(i,k)=1/rat*r*sin(i/ip*2*pi);
        end
        omofp(k)=-1/(4*pi);
    end
    mycol(1)='b';
    mycol(2)='w';
    omofp(2)=-omofp(1);
    
elseif itest==4
    % two circular eddies of radius 0.4 at distance dist
    
    dist=1.4;
    nfreq=1;
    ip=100;
    ntot=400;
    dt=0.1;
    KM=2;
    rat=1;
    for k=1:KM
        for i=1:ip+1
            th=i/ip*2*pi;
            r=0.4;
            x(i,k)=1*r*cos(i/ip*2*pi)+dist*(k-1.5);
            y(i,k)=1/rat*r*sin(i/ip*2*pi);
        end
        omofp(k)=1/(4*pi);
    end
    mycol(1)='r';
    mycol(2)='r';
    
else
    
    dist=.8;
    nfreq=1;
    ip=75;
    ntot=180;
    dt=0.15;
    ip=300;
    ntot=400;
    ntot=550;
    dt=0.05;
    KM=3;
    rat=1;
    for k=1:KM
        for i=1:ip+1
            th=i/ip*2*pi;
            r=0.3;
            if k==2
                r=0.3*sqrt(2);
            end
            x(i,k)=1*r*cos(i/ip*2*pi)+dist*(k-2);
            y(i,k)=1/rat*r*sin(i/ip*2*pi);
        end
        omofp(k)=1/(4*pi);
    end
    mycol(1)='r';
    mycol(2)='b';
    omofp(2)=-omofp(2);
    mycol(3)='r';
    
end


% From here relatively general code


%Close contour with reduntant point, also usefull for integration
for k=1:KM
    x(ip+1,k)=x(1,k);
    y(ip+1,k)=y(1,k);
end

%allocate tables
u=zeros(ip,KM);
v=zeros(ip,KM);

% Initialize old values
xo=x;
yo=y;
xn=x;
yn=y;

% ntot time step
for n=1:ntot
    
    %Predictor 
    % Diagnose velocity from vorticity
    [u,v]=vorttovel(ip,KM,x,y,omofp);
    % Move contour points with this velocity
    [xn,yn]=updatex(ip,KM,x,y,u,v,dt);
    % Store first guess of velocity
    un=u;
    vn=v;
    
    %Corrector
    % Diagnose velocity at the expected location
    [u,v]=vorttovel(ip,KM,xn,yn,omofp);
    % Average velcities from both estimates
    u=(u+un)/2;
    v=(v+vn)/2;
    % Make the real move from the old position
    [x,y]=updatex(ip,KM,xo,yo,u,v,dt);
    
    % Save the position as the old position for the next step
    xo=x;
    yo=y;
    
    % update time
    
    t=t+dt;
    
    % Once in a while make a nice plot
    if mod(n,nfreq)==0
        for k=1:KM
            fill(x(:,k),y(:,k),mycol(k))
            hold on;
        end
        hold off;
        axis([-1.5 1.5 -1.5 1.5]);
        
        axis equal;
        axis off;
        title(['time   ', num2str(t)])
        tutut=['contour' num2str(10000+n) '.png']
        print('-dpng',tutut)
        pause(timetowait);
    end

end