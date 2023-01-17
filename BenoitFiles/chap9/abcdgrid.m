clear all;
% Ratios of the deformation radius and the grid spacings
% R/dx and R/dy
Rodx=2;
Rody=2;

% parameters passed to the error calculation are theta ( k dx /2). So here we go up to k dx = pi/2
for i=1:100
    for j=1:100
        erra(i,j)=abcdgriderr('A',(i-1)/99*pi/4,(j-1)/99*pi/4,Rodx,Rody);
        errb(i,j)=abcdgriderr('B',(i-1)/99*pi/4,(j-1)/99*pi/4,Rodx,Rody);
        errc(i,j)=abcdgriderr('C',(i-1)/99*pi/4,(j-1)/99*pi/4,Rodx,Rody);
        errd(i,j)=abcdgriderr('D',(i-1)/99*pi/4,(j-1)/99*pi/4,Rodx,Rody);
    end
end

surf(erra')
shading interp
caxis([0 1])
colorbar
axis([0 100 0 100 0 1])
title('A-grid','FontSize',20)
%print -depsc agrid.eps
figure

surf(errb')
shading interp
caxis([0 1])
colorbar
axis([0 100 0 100 0 1])
title('B-grid','FontSize',20)
%print -depsc bgrid.eps
figure

surf(errc')
shading interp
caxis([0 1])
colorbar
axis([0 100 0 100 0 1])
title('C-grid','FontSize',20)
%print -depsc cgrid.eps
figure

surf(errd')
shading interp
caxis([0 1])
colorbar
axis([0 100 0 100 0 1])
title('D-grid','FontSize',20)
%print -depsc dgrid.eps
