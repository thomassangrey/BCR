function [ft] = myunpadd(ftpadded)

%two dimensional unpadding, ie truncation of FFT series, to avoid aliasing in products

val=size(ftpadded);
p=val(1);
q=val(2);
%Size of the unpadded, original ffts
M=2*p/3;
N=2*q/3;
% if larger unpadding is needed, also need to adapt mypadding
%M=p/2;
%N=q/2;

% Shift the fourier coefficients to retrieve the first modes more easily
ftshifted=fftshift(ftpadded);
% Get indexes for valid coefficients
pn=(p-M)/2+1;
po=pn+M-1;
qn=(q-N)/2+1;
qo=qn+N-1;

% extract coefficients of truncated series
ft=ftshifted(pn:po,qn:qo);
% shift to standart Matlab ordering and apply scaling correction due
% to change in number of points.
ft=fftshift(M/p*N/q*ft);
