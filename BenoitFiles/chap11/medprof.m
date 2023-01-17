clear;

% Longitude-Latitude box used to calculate horizontal averages 
%  of temperature and salinity profiles
long1=0;
long2=12;
lat1=33;
lat2=42;
[sp,z]=avrprof('../nc/clim.med.psal.nc',long1,long2,lat1,lat2);
[tp,z]=avrprof('../nc/clim.med.temp.nc',long1,long2,lat1,lat2);
plot(sp,z);
title('Mediterranean Salinity')
ylabel('z')
figure

plot(tp,z);
title('Mediterranean Temperature')
ylabel('z')