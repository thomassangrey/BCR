function [fpt] = periodicx(f)
% Function which ensures periodic conditions in X direction
% It is assumed that the numerical stencil of the model discretisation uses three points in each direction (one neighbour in
% each direction). If more points are used, the ghost region must be increased.
% Periodic in x 
val=size(f);
M=val(1);
N=val(2);
fp=f;


fp(1,:)=fp(M-1,:);
fp(M,:)=fp(2,:);
fpt=fp;