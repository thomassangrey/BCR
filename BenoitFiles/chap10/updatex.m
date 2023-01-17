function [xn,yn] = updatex(ip,KM,x,y,u,v,dt)

% Simple Euler displacement for all points using the velocities u and v
% for k=1:KM
%     for i=1:ip
%         xn(i,k)=x(i,k)+u(i,k)*dt;
%         yn(i,k)=y(i,k)+v(i,k)*dt;
%     end
% end
% The following shoul be faster than a double loop
xn(1:ip,:)=x(1:ip,:)+u*dt;
yn(1:ip,:)=y(1:ip,:)+v*dt;
% Close contour
% for k=1:KM
%    xn(ip+1,k)=xn(1,k);
%    yn(ip+1,k)=yn(1,k);
% end
    xn(ip+1,:)=xn(1,:);
    yn(ip+1,:)=yn(1,:);
%
