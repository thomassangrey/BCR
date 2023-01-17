function [h] = uvplot(u,v,x,y,scale,istep)

val=size(u);
M=val(1);
N=val(2);
for i=round(istep/2+1):istep:M-1
    for j=round(istep/2+1):istep:N-1
        xx(1)=x(i,j);
        yy(1)=y(i,j);
        xx(2)=x(i,j)+(u(i,j)+u(i+1,j))/2*scale;
        yy(2)=y(i,j)+(v(i,j)+v(i,j+1))/2*scale;
        plot(xx,yy,xx(1),yy(1),'o','MarkerSize',2)
        hold on
    end
end
h=M;
