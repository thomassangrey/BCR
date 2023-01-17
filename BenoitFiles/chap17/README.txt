Baroclinic.m
Script that simulates the baroclinic instability in a two layer system with initially uniform interface slope
(Philips problem). To recreate the sequence of Figure 17-8 run the program. Then try to adapt 
dissipation parameters and beta effects.

arakawa.m
Function to calculate the Arakawa Jacobian (see also chapter 16)

bcpert.m
Function to impose boundary conditions on the streamfunction perturbation. In particular implementation
of impermability needs special treatment for finite amplitudes. (17.84).

bcpertom.m
Function to impose boundary conditions on vorticity.

laplacian.m
Function which calculates the discrete Laplacian of a field (see also chapter 16)

inversepoissonbc.
Function to invert the two coupled  Poisson equations arising in the QG model of the two layer baroclinic instability