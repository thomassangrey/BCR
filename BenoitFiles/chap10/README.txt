contourdyn.m
Script that implements a simple contour dynamics program.
To recreate Figure 10-11, use itest=3
To speed up the calculation, you can decrease the number of contour points ip 
You can also decrease the number of time steps ntot
To recreate Figure 10-12 you have to implement the three patch configuration in itest=1 for example

contourintdef.m 
Function called by contourdyn.m to define contour parameters

contourint.m
Function which calclulates the contribution of one contour on the velocity in one point

updatex.m
Function to move the points with the velocity field

vortovel.m
Function which diagnoses velocity from vorticity patches


shearedflow.m
For the use of shearedflow.m, please go into the folder of Chapter 16 since it uses some functions developped there
A precomputed animation of the sheared flow instability can be found in the sub-folder Animation
