function[xb,yb,hb] = beringtopo(istoplot)
%
[x y h]=etopo5ncread(1);

% for the ocean only
h=-h;
h(h<0)=NaN;
vv=size(h);
IM=vv(1);
JM=vv(2);
ISUB=20;
JSUB=20;
xx=x(1:ISUB:IM);
yy=y(1:JSUB:JM);
hh=h(1:ISUB:IM,1:JSUB:JM);

if istoplot==1
    pcolor(hh')
    shading flat
    title('Global topography with coarse resolution: press any key to continue')
    pause
end

IS=44*50+42;
IE=47*50+17+20;
JS=37*50+11;
JE=38*50;
xb=x(IS:1:IE);
yb=y(JS:1:JE);
hb=h(IS:1:IE,JS:1:JE);

if istoplot==1
    pcolor(xb',yb',hb')
    shading flat
    title('Extracted part : press any key to continue')
    colorbar
    pause
end

