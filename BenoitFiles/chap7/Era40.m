%clear all;

% Try to recover which interface is used
fid = fopen('../nc/nctype.dat', 'r');
itype=fscanf(fid,'%u',1)
fclose(fid);

if itype==2



% Read the full data here for montly mean
nc=netcdf('../nc/era40dec2000.mslp.mean.nc','nowrite');
ncdump('../nc/era40dec2000.mslp.mean.nc')
% For reading daily data, you will need to deal with the third dimension of the array
disp(nc.discription(:))
disp(nc.author(:))
disp(nc.date(:))
myvar=var(nc);
% Get coordinate and time information

lat=nc{'latitude'}(:);
long=nc{'longitude'}(:);
time=nc{'time'}(:);
% The pressure field
patmb=nc{'msl'}(:);
VV=size(patmb);
patm=reshape(patmb,VV(2),VV(3));
end

if itype==1



% Read the full data here for montly mean

ncfile='../nc/era40dec2000.mslp.mean.nc'
lat=nc_varget(ncfile,'latitude');
long=nc_varget(ncfile,'longitude');
time=nc_varget(ncfile,'time');
patmb=nc_varget(ncfile,'msl');
patm=patmb;


end


% Be aware of indexing in patm it is NOT patm(i,j) as usual with i=longitude and j latitude increasing
% but according to the coordinates found in long(i) and lat(j)
% 


pcolor(long,lat,patm);
shading flat
colorbar
title('Atmospheric pressure')
