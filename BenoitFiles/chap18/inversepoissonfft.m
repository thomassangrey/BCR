function [a] = inversepoissonfft(omfft,LX,LY)
% Inversion of Poisson equation in spectral space is trivial
val=size(omfft);
% Problem size
M=val(1);
N=val(2);
% wave numbers based on domain size
[kx ky]=kxkyfft(omfft,LX,LY);
for ic=1:M
    for jc=1:N
        if ic+jc==2
            % Zero value for uniform field
            psifft(ic,jc)=0;
        else
            % Inversion is division by -k^2
            psifft(ic,jc)=omfft(ic,jc)/(-kx(ic)*kx(ic)-ky(jc)*ky(jc));
        end
    end
end
a=psifft;
