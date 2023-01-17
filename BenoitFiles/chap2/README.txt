parabolic.m
Script that shows how to call the function coriolisanim.m. Parameters used to make Figure 2.8 are provided in
the comments.

coriolisanim.m
Function that shows the trajectory of a particle on a parapoloid in absolute axes and the
imprint of the trajectory on the rotating platform. 

coriolisdis.m
Script used to prepare Figures 2.11. Changing the time step allows to see convergence even in
the case where the velocity norm increases. The program calls function numcorio.m

numcorio.m
Function which discretises the inertial oscillation. If other equations need to be discretised, this can be done
by adapting numcorio.m (see Numerical Exercises 2.7 and 2.8)

