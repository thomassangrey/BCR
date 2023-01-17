function [NS,MS] = NSMS(rho,u,v,z) 
% Computes N^2 and M^2
% Assumes staggered grod NS and MS(k) in (k-1/2)

vv=size(rho);
M=vv(2);

for k=2:M
    MS(k)=((u(k)-u(k-1))/(z(k)-z(k-1)))^2+((v(k)-v(k-1))/(z(k)-z(k-1)))^2;
    NS(k)=-((rho(k)-rho(k-1))/(z(k)-z(k-1)))*9.81/1028;
end
MS(1)=MS(2);
NS(1)=NS(2);
