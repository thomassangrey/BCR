advdiffsource.m
Script that shows the time evolution of an advection-diffusion equation with a sink. Note the
boundary layer at the outflow. This script can be used to recreate Figure 6-10 or explore other
combinations with dominant advection, diffusion or destruction.


tvdadv2D.m
Script that allows to experiment with different advection schemes. 
It is suggested to show the simulations each time a new scheme is introduced during
the lecture. The parameters to be adapted are described in the script. 
In particular look at the effect of splitting, limiters in all cases.
In the case of complex flows, also look at the effect of pseudo compressibility (imass parameter)

To recreate Figure 6-13: 
Tf=1
iprof=2
tvd=5 in tvdlim.m for left panel, tvd=1 for right panel
imass=0
isplit=0
velprof=2
amplivar=1


To recreate Figure 6-15: 
same as for Figure 6-13 but with isplit=2

To recreate Figure 6-17: 
same as for Figure 6-13 but with isplit=2 and tvd=5

To recreate Figure 6-18 and Figure 6-19
Tf=4
iprof=1
tvd=1
imass=1
isplit=2
velprof=3
amplivar=4
(try with imass=0 to see the effect of pseudo-compressibility)

To recreate Figure 6-20 
same as for Figure 6-18 but with tvd=5 (upwind)

To recreate Figure 6-20 
same as for Figure 6-18 but with tvd=4 (lax wendroff)



adv1D.m
Function used by tvdadv2D.m 
It discretises the 1D advection problem with or without artificial compressibility
Normally there is no need to edit this file except for understanging the code

tvdlim.m
Function that calculates the limiter function used in the advection scheme.
It must be edited to switch between upwind, centered or one of the TVD schemes


advleap.m
Script that shows the 1D advection using a Leapfrog scheme and produces Figure 6-22.
One should try to see the effect of different choices for the first step in the time iterations

thomas.m
Function that allows to solve a tridiagonal system (see Appendix)
To be used for the design of a trapezoidal advection scheme.
Check the variance evolution in this case


