function[kx, ky]=kxkyfft(p,LX,LY)
% Calculation of wavenumbers from domain size LX,LY and number of modes
val=size(p);
M=val(1);
N=val(2);
% Note that matlab FFT routines store spectal coefficients with shortest wave in the middle of the array
% Note also the the first wavenumer is zero
kx=(2*pi/LX)*[0:(M/2-1) (-M/2):-1];
ky=(2*pi/LY)*[0:(N/2-1) (-N/2):-1];

