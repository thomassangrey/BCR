beringtopo.m
Function that reads etopo5 topography and extracts region of the Bering Sea 
To use:  [ x y h ]=beringtopo(1) 
The parameter of the function allows to plot the topography during the extraction
After reading the coordinates x and y and the topography h are available

etopo5ncread.m
Function used by beringtopo.m used to read the etopo5 topography from a netCDF file


testpcg.m
Script that shows an template for the use of Matlab conjugate gradient function pcg.
Is shows how to define a user function that calculates A x when provided x and pass it to pcg.
This script can serve as a base for other problems, such as Numerical Exercise 7-8

atimesxfortestpcg.m
Function to be passed to pcg. It shows how to implement the operation A that acts on the unknows, 
when the operator arises from a discrete Laplacian operator. Note that for A to be positive defined,
we need to use minus the discrete Laplacian operator as A.

locallapl.m
Function called by atimesxfortestpcg.m to calculate the Laplacian operator at a grid point.


topexcirculation.m
Script that reads altimetric data for further use in Numerical Exercise 7-2

Era40.m
Script that reads atmospheric pressure field for use in Numerical Exercise 7-3