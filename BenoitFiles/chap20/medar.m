[a,lon,lat,depth]=medarncread('../nc/clim.med.psal.nc');
sal=double(a);
[a,lon,lat,depth]=medarncread('../nc/clim.med.temp.nc');
tem=double(a);

pcolor(tem(:,:,20)')
shading flat
title('Medar field')
% From here you need to check grid orientations and then calculate
% density to finally calculate geostrophic currents
% Provide for calculation of the local Coriolis parameter, grid spacing
% depending on latidute and calculation of density by an appropriate
% state equation