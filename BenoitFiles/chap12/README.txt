traj2D.m

Script which illustrates the parcel trajectories obtained by a Lagrangian approach
To reproduce Figure 12-9, use icase=2 and ispot=0
To show the shearing, put a large amount of particles in one location (ispot=1)
Also consider changing the time discretization (try an explicit Euler for example)
You can also change the time-step
If you want to calculate actual concentration distributions, you can distribute particles corresponding
to a case found in tvdadv2D.m (Chapter 5) and compare both approaches


velocitylag.m
Function used by traj3D.m to calculate the velocity components at a given location.