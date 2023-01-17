function[nu , kappa]= nukappa(tke,eps,NS,MS) 
% Calculates turbulent viscosity nu and diffusivity kappa using stability functions 

numax=1;
kappamax=1;
vv=size(tke);
M=vv(2);
for k=2:M
    val=tke(k)^2/eps(k)^2;
    alphaN(k)=val*NS(k);
    alphaM(k)=val*MS(k);
end
for k=2:M
[cmu(k), cmup(k)]=stabfunction(alphaN(k),alphaM(k));
end
for k=2:M
    val=tke(k)^2/eps(k);
    nu(k)=cmu(k)*val+10^(-6);
    kappa(k)=cmup(k)*val+10^(-7);
    %kappa(k)=0.001;
    if nu(k) > numax
        nu(k)=numax;
    end
    if kappa(k)>kappamax
        kappa(k)=kappamax;
    end
end
nu(1)=nu(2);
kappa(1)=kappa(2);
