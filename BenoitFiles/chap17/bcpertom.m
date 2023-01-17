function [fp] = bcpertom(f)

% Boundary condition on vorticity
val=size(f);
M=val(1);
N=val(2);
fp=f;
% Periodicity on x
fp(M,:)=fp(2,:);
fp(1,:)=fp(M-1,:);

% Weak friction: zero gradient on wall
fp(:,1)=fp(:,2);
fp(:,N)=fp(:,N-1);
