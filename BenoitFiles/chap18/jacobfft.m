function [a] = jacobfft(psifft,omfft,LX,LY)
% Jacobian of two fields psifft and omfft  available as spectral fields
% Results is the spectral representation of the Jacobian
% Transform method is applied
val=size(omfft);
M=val(1);
N=val(2);
% From domain size LX,LY get wavenumbers represented
[kx ky]=kxkyfft(omfft,LX,LY);

% Calculate spectral coefficients of derivatives
for ic=1:M
    for jc=1:N
        dxomfft(ic,jc)=kx(ic)*i*omfft(ic,jc);
        dyomfft(ic,jc)=ky(jc)*i*omfft(ic,jc);
        dxpsifft(ic,jc)=kx(ic)*i*psifft(ic,jc);
        dypsifft(ic,jc)=ky(jc)*i*psifft(ic,jc);
    end
end


%Padding with zeros so as to subsample with higher frequency in physical domain to avoid aliasing
%then transformation to real domain by inverse FFT
dxpsiphys=real(ifft2(mypadding(dxpsifft)));
dypsiphys=real(ifft2(mypadding(dypsifft)));
dxomphys=real(ifft2(mypadding(dxomfft)));
dyomphys=real(ifft2(mypadding(dyomfft)));

% Calculate Jacobian in the real domain
val=size(dxomphys);
mpad=val(1);
npad=val(2);
for ic=1:mpad
    for jc=1:npad
        jacobphys(ic,jc)=dyomphys(ic,jc)*dxpsiphys(ic,jc)-dxomphys(ic,jc)*dypsiphys(ic,jc);
    end
end
% From physical domain, make FFT transform and truncate series to retained wavenumers
a=myunpadd(fft2(jacobphys));
