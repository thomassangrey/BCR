function [f] = lorenz(x,par)

%  x    :  state vector x
%  par  :  parameters sigma, r ,b 
% This are the classical Lorenz equations
f(1) = par(1)*(x(2)-x(1));
f(2) = par(2)*x(1)-x(2)-x(1)*x(3);
f(3) = x(1)*x(2)-par(3)*x(3);

     