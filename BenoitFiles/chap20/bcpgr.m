function [pg,xpg,zpg] = bcpgr(rho,x,z)
% Pressure gradient calculations

% Get size of the density field
mm=size(rho);
M=mm(1);
N=mm(2);

% Allocate an array with the same size for the pressure gradient and
% coorrdinates of the gradient value
pg=zeros(M,N);
xpg=x;
zpg=z;
% Gravity
g=9.81;

% On Staggered grid: pg(i,k) is between i and i-1 but on level k
% Density is given in x(i), z(i,k). 
% z=0 at the surface and negative downward

% Start with zero
p=pg;

for i=1:M
    k=N;
    % Top level:  layer thickness above density point up to zero for
    % intergration
    p(i,k)=rho(i,k)*g*(-z(i,k));
    % Pressure in a layer= pressure of layer above+ density times layer
    % height times gravity
    for k=N-1:-1:1
        p(i,k)=p(i,k+1)+(rho(i,k+1)+rho(i,k))*(z(i,k+1)-z(i,k))*0.5*g;
    end
end

% Once pressure is known, finite differencing of chain rule in general
% coordinates.
for i=2:M
    for k=1:N
        pg(i,k)=(p(i,k)-p(i-1,k))/(x(i)-x(i-1))+(rho(i,k)+rho(i-1,k))*0.5*g*(z(i,k)-z(i-1,k))/(x(i)-x(i-1));
        xpg(i)=(x(i)+x(i-1))/2;
        zpg(i)=(z(i,k)+z(i-1,k))/2;
    end
end
% First point not defined but put a reasonable value for plotting
pg(1,:)=pg(2,:);

