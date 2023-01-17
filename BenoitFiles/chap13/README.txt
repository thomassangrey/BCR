iwave.m
Script to show the eigenvalues and eigenmodes of the vertical mode problem
As a first test, the constant N case can be looked at, setting N0=0.01 (lower bound) and N1=0.01 (upper bound)
To increase the number of grid points and modes represented, change parameter KM (from 50 to 450 to reproduce panels
of Figure 13-6)
Then the variable N case can be looked at, with N0=0.001. 
To change the modes displayed, change parameter im1 (im1=1 for Figure 13-7, im1=10 for Figure 13-8 , im1=26 for Figure 13-9)
Note that eigenfunctions are defined up to an unspecified sign, so changing paramters can lead to eigenfunction which change sign

iwavemed.m
Script similar to iwave.m but reading T,S profiles from the Mediterranean Sea from wich an average N^2 profile is taken
This profile is then used to calculate the eigenvalues and deformation radius for different values of the
horizontal wavenumber


nsmed.m
Function called by iwavemed.m to compute N^2 from Mediterranean profiles
(see Folder on chapter 11 for scripts used within nsmed.m)

levitus.m
Template to read Levitus climatology using reading function read_woa01.m
