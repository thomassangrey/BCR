function [u,v] = vorttovel(ip,KM,x,y,omofp);

% From vorticity patches to velocities
% There are KM patches, each of which defined by ip points

% Declare arrays with zeros
u=zeros(ip,KM);
v=u;
myi=u;
myj=u;
xm=u;
ym=u;
dx=u;
dy=u;

xx=zeros(ip,1);
yy=xx;
zz=xx;
ww=xx;


for k=1:KM
    % For each patch, calculate the mid point of segments and dx dy values
    [xx yy zz ww]=contourintdef(ip,x(:,k),y(:,k)); 

        xm(:,k)=xx(:);
        ym(:,k)=yy(:);
        dx(:,k)=zz(:);
        dy(:,k)=ww(:);

end


for k=1:KM
    % For each contour make the integral with all other contours
    for m=1:KM
        % For eack point on the contour k, get the contribution from all other contours (m)
        for i=1:ip
        [myi(i,m) myj(i,m) ]=contourint(ip,xm(:,m),ym(:,m),dx(:,m),dy(:,m),x(i,k),y(i,k));
        end
    end
    for m=1:KM
    % add the contribution of each of the contours to the velocity field of each point in contour k
        u(:,k)=u(:,k)-omofp(m)*myi(:,m);
        v(:,k)=v(:,k)-omofp(m)*myj(:,m);
    end
end
