qgmodel.m
Template for a quasigesotrophic model. It needs to be adapted for specific simulations.
To recreate the sequence if Figure 16-6 run without changing. Then try to adapt qgmodelrun.m
to include the beta term and simulate other situations.

qgmodelrun.m
Function which actually solves the QG model over a given number of time steps, startting from
a streamfunction. Some basic boundary conditions are implemented.


inversepoisson.m
Function that inverses the Laplacian equation with vorticity on the righ-hand side. Several boundary conditions
can be specified (see first lines of the code). On return, one gets streamfunction, residu and iterations needed to converge. 


laplacian.m
Calculates the laplacian of a function.

arakawa.m
Calculates the Arakawa Jacobian of two functions. As a by-product, it can be used to calculate gradients by providing as a
second field an array filled with x or y values.

periodic.m
Applies periodic boundary conditions, in all directions.

dirichletbc.
Applies a constant value at all boundaries

periodicx.m
Applies periodicity in x direction (channel configuration)

bluered.m
Function to create a red-blue colormap (obsolete on newer version of matlab, where you can specify named colorbars directly)

shearedflow.m
Template to show how the QG model can be used to analyse sheared flow instabilities of Chapter 10. To reproduce the sequence of
Figure 10-4 run the script. Then change numerical parameters or flow conditions.