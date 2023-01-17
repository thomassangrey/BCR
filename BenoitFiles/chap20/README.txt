medar.m
Template to read temperature and salinity fields of the Mediterranean Sea. To be used to 
calculate geostrophic currents. This will need the programming of the whole geostrophic calculation
from T,S values via density and pressure to velocities

medarncread.m
Function used by medar.m to read netCDF files. 

bolus.m
Script to illustrate the effect of GentMcWilliams parameterisation of on the flattening of ispycnals. With the default parameters, Figure 20-19
can be retrieved. The density fields is advected with the bolus velocity calculated in bolusv.m The avection is done
with the TVD schemes already encountered before (using adv1D.m and tvdlim.m)

bolusv.m
Function to calculate bolus velocity in a vertical plane from density.

ctocenter.m
Function to average staggered velocity field to centered values.

pgerror.m
Script to show the pressure gradient error introduced by discetisation on general vertical coordinates. Try to 
change pycnlcline depth (try D=100) and strength. Also change the number of grid points.

bcpgr.m 
Function which calculates the pressure gradient from density distribution in a vertical section with general vertical coordinates.
Here one should implement different discretisations