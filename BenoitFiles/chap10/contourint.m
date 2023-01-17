function [u,v] = contourint(ip,xm,ym,dx,dy,xi,yi)

%assumes that on entry
% x(ip+1)=x(1);
% y(ip+1)=y(1);

% Calculate the contribution of contour defined by xm, ym with segments dx dy
% to the velocity diagnose in point xi,yi


u=0;
v=0;

% Integrate over all points of contour xm,ym 
for j=1:ip
    dist=(xi-xm(j))^2+(yi-ym(j))^2;
    cof=log(dist);
    u=u+cof*dx(j);
    v=v+cof*dy(j);
end
