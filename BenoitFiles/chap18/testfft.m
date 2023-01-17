
close all;
x=zeros(12,4);
for i=1:4
x(:,i)=[1:12]/12*2*pi;
end
F=sin(x)




plot(F(:,1))
title('Original signal')
figure

FF=fft2(F);
bar(abs(FF(:,1)))

title('Fourier amplitudes. index 1 corresponds to constant, index 2 to fundamental mode')

figure
FFPAD=mypadding(FF);
bar(abs(FFPAD(:,1)))
title('Padded fourier modes. Note amplitude change with respect to unpadded version and number of modes')

figure
FFORI=ifft2(FF);
plot(real(FFORI))
title('Inverse Fourier transform. Should be the same as original data')


figure
FFFINE=ifft2(FFPAD);
plot(real(FFFINE))
title('Inverse Fourier transform of padded FFT. Note the finer resolution and correct amplitude')

