function [X,t] = rk4(fun,par, x0,t0, dt,N)

%  function  f must be a MATLAB function (vector of same size as x0) with with declaration
%            function [f] = fun(x,par)
%  par holds parameters of the function. It may be dummy.  
%  
%  Call
%      [X,t] = rk4(@fun,par, x0,t0, dt,N)
%
%  Input parameters
%  fun  :  String with the name of the function.
%  par  :  Parameters of the function.  May be empty.
%  x0   :  Initial condition on vector x .
%  t0   :  Initial time
%  dt   :  time increment
%  N    :  number of time steps to perform
%
%  Output parameters
%  X    :  computed solution vector containing the N+1 time steps including the initial condition.
%  t    :  time of the corresponding solution
%  Note, if time is needed as an argument in the function, you can use an augmented state vector

M=max(size(x0));
X=zeros(N+1,M);
t=zeros(1,N+1);
% Inital condition
X(1,:)=x0;
t(1)=t0;
% Now N steps
for n=1:N
    tt=t(n);
    xx=X(n,:);
    f = feval(fun,xx,par);
    k1=dt*f;
    f=feval(fun,xx+k1/2,par);
    k2=dt*f;
    f=feval(fun,xx+k2/2,par);
    k3=dt*f;
    f=feval(fun,xx+k3,par);
    k4=dt*f;
    % Runge-Kutta weighting
    X(n+1,:)=X(n,:)+(k1+2*k2+2*k3+k4)/6;
    t(n+1)=t(n)+dt;
end