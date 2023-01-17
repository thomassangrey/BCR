clear all;
close all;

% Points for plotting
M=800;
% Domain length
LX=2000000;
% Resulting space sampling
DX=LX/M;
% Position of shelf break
L=LX*0.8;
% Width of shelf break
W=LX/20;


% depth profil
for i=1:M
    x(i)=(i-1/2)*DX;
    depth(i)=2000*(1-0.8*tanh((x(i)-L)/W));
end
plot(x,-depth)
title('Depth profile for the calculation of a Tsunami propagation')
   