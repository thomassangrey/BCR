function [lapfft] = laplacianfft(p,LX,LY)
% Calculation of the bilaplacian in spectral space 
% Laplacian is -k^2 
val=size(p);
M=val(1);
N=val(2);
lapfft=zeros(M,N);
% wavenumbers as a function of domain size LX,LY
[kx ky]=kxkyfft(p,LX,LY);
% spectral coefficient of the Laplacian
for ic=1:M
    for jc=1:N
        lapfft(ic,jc)=-(kx(ic)^2+ky(jc)^2)*p(ic,jc);
    end
end
