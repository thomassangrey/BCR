function [u,v,t] = numcorio(f,dt,alpha,t0,tf,u0,v0,dtsol) 

%disp(['Computing inertial oscillation']);
% Initial condition
u(1)=u0;
v(1)=v0;
t(1)=t0;
time=t0;

% Starting iterations
un=u0;
vn=v0;

% Parameters appearing in the discretisations
umafdt=(1-alpha)*f*dt;
afdt=alpha*f*dt;
det1=1/(1+afdt*afdt);

n=0;
% Extract solution every dtsol/dt time steps
nsol=dtsol/dt;

isol=0;

% Loop until final time tf is reached
while time< tf,
    % right hand side of discretisation
   ru=un+umafdt*vn;
   rv=vn-umafdt*un;
    % solve linear system for the new velocities unp and vnp
   unp=(ru+afdt*rv)*det1;
   vnp=(rv-afdt*ru)*det1;
   % update time
   time=time+dt;
   % call old value the values you just calculated
   un=unp;
   vn=vnp;
   % increase counter of time steps
   n=n+1;
   % save solution every nsol steps
   if mod(n,nsol)==0,
       isol=isol+1;
       t(isol)=time;
       v(isol)=vn;
       u(isol)=un;
   end
end