function xprime = jin(t,x)
% Parameters of eq21-29 and 21-30
beta=2.28E-11;
c=1.4;
H=100;
rhoocean=1024;
nuturbu=0.001;
L=15000000;
DTH=10;
DTV=10;
rdampingh=4.8/(360*24*3600)
mucoupling=0.96*0.01/9;
climstress=0.012;
wclim=3/(24*3600);




alpha=wclim/climstress
gamma=H/(rhoocean*nuturbu)

gp=c*c/H
RD=sqrt(c/beta)




xprime=zeros(2,1);
a0=rdampingh
a1=mucoupling/(rhoocean*beta*RD*RD)
a2=(mucoupling*(gamma*DTH/L+alpha*DTV/H+wclim*DTV*L/(H*H*H*gp*rhoocean) )-rdampingh-wclim/H)
a3=wclim*DTV/H/H
xprime(1)=-a0*x(1)-a1*x(2); 
xprime(2)=a2*x(2)+a3*x(1);

forroot1=(a0-a2)*(a0-a2);
forroot2=4*(a1*a3-a0*a2);


