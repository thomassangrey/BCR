function [ftpadded] = mypadding(ft)

%two dimensional padding with zeros to avoid aliasing in products M and N
%must be a multiple of 4
val=size(ft);
M=val(1);
N=val(2);
p=3*M/2;
q=3*N/2;
% larger padding (need to adapt myunpadd}
%p=2*M;
%q=2*N;
ftpadded=zeros(p,q);
% Indexes for zeros to add 
pn=(p-M)/2+1;
po=pn+M-1;
qn=(q-N)/2+1;
qo=qn+N-1;
ftpadded(pn:po,qn:qo)=fftshift(ft);
% Shift to standard matlab fft ordering and application of scaling due to change in 
% number of modes
ftpadded=fftshift(p/M*q/N*ftpadded);
