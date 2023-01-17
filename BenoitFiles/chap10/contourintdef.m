function [xm,ym,dx,dy] = contourintdef(ip,x,y)

% defines central point of a segment and corresponding segment dx and dy
% assumes that on entry
% x(ip+1)=x(1);
% y(ip+1)=y(1);

% Allocate
xm=zeros(ip,1);
ym=xm;
dx=xm;
dy=xm;

% Now fill in
for i=1:ip
    xm(i)=(x(i)+x(i+1))*0.5;
    ym(i)=(y(i)+y(i+1))*0.5;
    dx(i)=x(i+1)-x(i);
    dy(i)=y(i+1)-y(i);
end
