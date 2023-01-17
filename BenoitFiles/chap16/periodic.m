function [fpt] = periodic(f)
% Function which ensures periodic conditions.
% It is assumed that the numerical stencil of the model discretisation uses three points in each direction (one neighbour in
% each direction). If more points are used, the ghost region must be increased.
val=size(f);
M=val(1);
N=val(2);
fp=f;

% order matters and ensures cornes are ok
fp(1,:)=fp(M-1,:);
fp(:,1)=fp(:,N-1);
fp(M,:)=fp(2,:);
fp(:,N)=fp(:,2);
fpt=fp;