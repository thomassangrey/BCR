frontogenesis.m
Script to show the cinematic frontogenesis in a convergence-divergence.
When executed with the default parameters, and animated version of Figure 15-12 is recreated.
Other particle distributions should be tried

sgfrontogenesis.m
Script that shows the solution of the semi-geostrophic fronal adjustment of a front
with zero potential vorticity. It shows an animated version of Figure 15-14.
The script can be adapted to deal with another initial distribution of the slopes.
As exercise, try to formulate the solution in non-dimensional terms to inteprete the SCALE parameter

upwelling.m
Script template to simulate a coastal upwelling.
Depending on the wind impulse, outcropping can arise.

windstress.m
Function which provides the wind stress for upwelling.m
It can be edited to increase wind intensity or to control the duration of the wind gust

flooddry.m
Function to control numerically the outcropping situation arising in upwelling.m


adaptive.m
Script that show the adaptation of grid points to local gradients.
For beta=0.1 one can recreate Figure 15-15. For higher values of beta, a uniform grid is obtained
while for beta=0, regions with constant values of f are void of grid points.

functiontofollow.m
Defines the function which adaptive.m should try to sample optimally. It can be edited to try with other functions.

adaptiveupwind.m
Script to illustrate the moving grid and parallel solution of a tracer advection.
First the script adapts the location of the points to the initial condition, and then advection is started.
To recreate parts of Figure 15-24: for the upwind solution on a uniform grid, use beta=100, islagr=0 . 
For the adaptive solution use beta=1, islagr=0. For the almost lagrangian approach beta=0.1, islagr=1.
Finally for a mixed version  beta=1, islagr=1.
In all cases, not how points move laterally to follow the solution.

tvdadv1D.m
Script that implements a 1D TVD advection scheme. To reproduce a Figure similar to 15-20, use tvd=1
in tvdlim.m. Try with different CFL parameters (in particular the case CFL=1) and different initial distributions of C.

tvdlim.m
Function, to be edited, to calculate the limiter value depending on the limiter function chosen

adv1D.m
Function used within tvdadv1D.m to advect in one direction over one time-step. 

