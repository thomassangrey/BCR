kepsmodel.m
Script including a simple 1D model solving equations for u,v,rho including a turbulence closure scheme of
the k-epsilon type. 
The code is fairly general except that initial conditions and forcings are simple.
(only forcing in x direction is implemented but can be copied easily for y direction)
Experiments can include change in stratification, forcings, coriolis parameter



diffusionstep.m
Function that allows to make a time-step for a variable transmitted as a parameter, knowing its source and sink term
as well as boundary conditions.

thomas.m
Function that solves tridiagonal systems created in diffusionstep.m

NSMS.m
Function which calculates N^2 and M^2 from u,v,rho and dz

nukappa.m
Function which calculates the turbulent viscosity and diffusivity from tke, eps, N^2 and M^2

stabfunction
Stability functions involved in the turbulence model


