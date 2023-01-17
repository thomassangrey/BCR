%




% M points in along channel direction. Two of them are for periodic conditions
% N points across channel, take an odd number of points (psi on center)

dx=5000;
dy=dx;
% with of channel is WW  times the width of shear layer
WW=20;
WW=8;
% number of points across half shear layer
NP=8;
NP=6;
N=(NP*2)*WW+1;
L=(N-1)*dy/(2*WW);
U=1;
LX=2*7.89*2*L;
% For Bickley jet try
%LX=2*6*L;
M=LX/dx+2;
M=floor(M);
AH=1;
BH=10*dx*dy;
dissrate=0.00000;

brcol=bluered(64);
dt=0.1*dx/U
psiscale=U*L
bcflag=3
myname='shearedflow'
omegascale=psiscale/L/L;
NT=50000;
bcval=0;
% INITIALIZATION

for ic=1:M
    for jc=1:N
        omphys(ic,jc)=0;
        xx(ic,jc)=(ic-M/2)*dx;
        yy(ic,jc)=(jc-N/2)*dy;
        if yy(ic,jc) > L*1.001
            psiphys(ic,jc)= U*(-yy(ic,jc)+WW*L);
        elseif yy(ic,jc) < -L*1.001
            psiphys(ic,jc)= U*(yy(ic,jc)+WW*L);
        else
            psiphys(ic,jc)= (-U/L*(yy(ic,jc)^2/2)+(WW-1/2)*U*L);
        end
            psiphys(ic,jc)=psiphys(ic,jc)*(1+0.001*sin(4*pi*xx(ic,jc)/LX));
        % For symmetric jets
        %psiphys(ic,jc)=psiphys(ic,jc)*(1+0.005*sign(yy(ic,jc))*sin(4*pi*xx(ic,jc)/LX));
    end
end


[psiphys,omphys,errtime,niter] = qgmodelrun(psiphys,dissrate,AH,BH,NT,dt,dx,dy,myname,10,bcflag,bcval,omegascale,psiscale);
