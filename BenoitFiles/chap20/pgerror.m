clear all;
close all;

% Number of points in x and z direction
M=50;
N=100;

% Depth in the middle of the domain
HM=200;
% With of the domain
L=500000;
% Resulting grid spacing
dx=L/N;

% Depth of pycnocline
D=10;
% Width of pycnocline
W=20;

for i=1:N
    for k=1:M
        % Grid position
        x(i)=(i-N/2)*dx;
        xpl(i,k)=x(i);
    end
end
for i=1:N
    % Depth profile from HM-150 to HM+150 
    H(i)=HM+150*tanh(x(i)/L*20);
    for k=1:M
        s=(k-0.5)/M;
        % Sigma coordinates here
        z(i,k)=-H(i)+s*H(i);
        % Density is only z dependent and a zero pressure gradient should
        % result
        rho(i,k)=5*tanh((z(i,k)+D)/W);
    end
end

% With this distribution calculate discrete pressure gradient
[pg,xpg,zpg]=bcpgr(rho,x,z);
xplb=xpl;
% x coordinates of the gradient for plotting
for k=1:M
    for i=1:N
        xplb(i,k)=xpg(i);
    end
end

% Scale so as to translate into velocity scale
pg=pg/0.0001/1024;
pgmax=max(max(abs(pg)));
contour(xpl',z',rho');
hold on
pcolor(xplb',zpg',pg');

shading interp;
br=bluered(64);
colormap(br);
caxis([-pgmax pgmax]);
colorbar;
hold on;
plot(x,-H);
title('Density lines and pressure gradient error')
