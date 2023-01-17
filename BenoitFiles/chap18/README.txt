qgspectral.m
QG model with FFT approach and transform method. Run with the original parameters
allows to create a sequence as in Figure 18-17. Afterwards, adapt dissipation parameters or initial distribution of eddies.
Other matlab files are subroutines, normally not changed by the user. If not used to FFT and IFFT, look at testfft.m



bilaplacianfft.m
Function to apply Biharmonic operator in spectral space

Laplacianfft.m
Function to apply Laplacian operator in spectral space

jacobfft.m
Function to calculate the jacobian (in spectral space) from two fields (in spectral space) by transform method in a physical grid
To avoid aliasing, a higher resolution grid is created by padding fourrier coefficients with zeros

mypadding.m
Function to add zeros to FFT arrays in the rigth location and adequate scaling. 3/2 times the original points are created

myunpadd.m
Inverse function of mypadding.m

kxkyfft.m
Function to create wavenumber arrays from domain size and dimensions.

inversepoissonfft.m
Function to invert Poisson equation in spectral space.

kmean.m
Diagnostic function to calculate average wavenumbers of energy and enstrophy

testfft.m
Script to see how fft, ifft and padding works.