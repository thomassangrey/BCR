function [SN] = diffusionstep(S,ntmh,dt,dz,alpha,source,sink,BCB,BCS,iflag)

% Perform a time step dt for variable S
% grid spacing dz is constant
% ntmh(k) is the turbulent diffusion at the interface between k and k-1
% alpha is the implicitness factor (zero: explicit, one: implicit)
% source(k) is a term added to the right-hand side 
% sink(k) is a term subtracted to the right hand side in a Patankar step

MM=size(S);
M=MM(2);
% Grid parameter
dd=dt/dz^2;

% Filling a linear system for thomas algorithm: interior points
for k=2:M-1
    bt(k)=-alpha*ntmh(k)*dd;
    ct(k)=-alpha*ntmh(k+1)*dd;
    at(k)=1-bt(k)-ct(k)+dt*sink(k)/(S(k)+10^(-30));
    ft(k)=S(k)+source(k)*dt+ (1-alpha)*ntmh(k+1)*dd*(S(k+1)-S(k))-(1-alpha)*ntmh(k)*dd*(S(k)-S(k-1));
end
if iflag==0
    % Dirichlet in k=1 and k=M
    bt(1)=0;
    bt(M)=0;
    at(1)=1;
    at(M)=1;
    ct(1)=0;
    ct(M)=0;
    ft(1)=BCB;
    ft(M)=BCS;
end
if iflag==1
    % Neumann on diffusive flux in k=1+1/2 and k=M-1/2
    bt(1)=0;
    bt(M)=0;
    at(1)=1;
    at(M)=1;
    ct(1)=0;
    ct(M)=0;
    ft(1)=0;
    ft(M)=0;
    k=2;
    ft(k)=S(k)+source(2)*dt+ (1-alpha)*ntmh(k+1)*dd*(S(k+1)-S(k))+dt/dz*BCB;
    bt(k)=0;
    at(k)=1-bt(k)-ct(k);
    k=M-1;
    ct(k)=0;
    ft(k)=S(k)+source(k)*dt -dt/dz*BCS-(1-alpha)*ntmh(k)*dd*(S(k)-S(k-1));
    at(k)=1-bt(k)-ct(k);
end
% Solve the tridiagonal system
SN=thomas(bt,at,ct,ft);
        