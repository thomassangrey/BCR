spectralekman.m
Function that calculates the spectral solution of the Ekman layer with constant eddy viscosity.
The parameter N is the number of modes retained.
If run with N=5 you can recreate figure 8-12.
For higher values if N you can see the behaviour of Figure 8-13
Two see how a solution behaves for the wind-stress case, use isol=1 

ekmanh.m
Function called by spectralekman. It provides the exact solution of the problem. 
