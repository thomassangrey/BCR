chaos.m
Based on the Lorentz equations, calculates a series of trajectories for calculating diagnostics on skill autocorrelations etc.
It produces Figures as 22-1 (a&b), 22-2 (a&b)n 22-3.
The user can experiment with the ensemble size in averaging and the amplitude of the perturbations (both in initial conditions and
parameter values). 



rk4.m
Function which allows to use Runge-Kutta for the time integration of a set of differential equations. The right
hand side must be passed as a function.

lorenz.m
Function describing the Lorenz equations and integrated via Runge Kutta function rk4.m to calculate trajectories

oigrav.m
Template for data assimilation with optimal interpolation in a one-dimensional gravity wave problem.
The simulation starts with an imperfect initial condition compared to a reference solution. Then the
simulation advances and data extracted from the reference solution are assimilated into the forecast to improve
the solution. The animation shows this process and indicates when data are assimulated and the resulting analysis used 
for restarting the model. Observe how with time the forecast approaches the reference solution.
After a first test, different sampling strategies can be tried as well as changes in the analysis parameters. 
One can also try to use an incorrect model for the forecast and see if assimilation can correct)


kalmanupwadv.m
Template to show the Kalman filter on an advection problem with an upwind scheme. Run with the provided 
parameters, Figure 22-7 can be recreated. Then adapt the parameters and look at the effect of
incorrect modelling (use an even worse model velocity) and add some noise on observations.


divashow.m
Script to plot the Salinity field obtained with an optimal interpolation approach implemented in DIVA
(Data interpolating Variational Analysis : http://modb.oce.ulg.ac.be/projects/1/diva ). The script reads the data in folder ./diva using
a function uread.m

uread.m
Function to read binary fields generated with DIVA. Normally this function does not need to be edited. It uses gzfopen.m and gzfclose.m 

gzfopen.m and gzfclose.m
Functions to deal with binary fields generated with DIVA. Not to be edited.