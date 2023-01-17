function[fpt]=dirichletbc(f,c)
%
% Function wich applies a constant value on the borders of the field
val=size(f);
M=val(1);
N=val(2);
fp=f;


fp(1,:)=c;
fp(:,1)=c;
fp(M,:)=c;
fp(:,N)=c;
fpt=fp;