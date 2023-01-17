function [ubol,wbol,S] = bolusv(rho,kappa,dx,dz)
% Bolus velocity from density
% Get grid size
val=size(rho);
M=val(1);
N=val(2);
% C staggering assumed
% rho centered
% u left
% w below
% S (relative slope) corner
% Allocate arrays
S=zeros(M,N);
ubol=S;
wbol=S;
for i=2:M
    for k=2:N
        % Calculate slopes times kappa
        S(i,k)= -kappa*(rho(i,k)-rho(i-1,k)+rho(i,k-1)-rho(i-1,k-1))/(rho(i,k)-rho(i,k-1)+rho(i-1,k)-rho(i-1,k-1))*dz/dx;
    end
end
for i=1:M-1
    for k=1:N-1
        % Calculate bolus velocity, by construction with zero discrete
        % divergence 
        ubol(i,k)=-(S(i,k+1)-S(i,k))/dz;
        wbol(i,k)=+(S(i+1,k)-S(i,k))/dx;
    end
end
