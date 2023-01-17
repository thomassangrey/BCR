abcdgrid.m
Script which plots the relative error on the squared frequency for each of the Arakawe grids
To retrieve Figure 9-14, use Rodx=2 and Rodx=2 

abcdgriderr.m
Function called to calculate the error on the frequency for the different grids.


sumatra.m
Script that plots a schematic topography profile for the calculation of a tsunami propagation.


shallow.m
Template for the development of a shallow water equation model. It includes a discretization of the
shallow water equations without friction and without nonlinear advection. If run as such, the propagation
of a Kelvin wave is seen in a periodic domain. Try to add a diagnostic on the error (here you can compare
with the known solution of a Kelvin wave) and check the error for different time steps and grid spacings.