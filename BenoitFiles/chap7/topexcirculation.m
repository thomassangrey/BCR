%clear all;

% Try to recover which interface is used
fid = fopen('../nc/nctype.dat', 'r');
itype=fscanf(fid,'%u',1)
fclose(fid);

if itype==2

% Read the full data
nc=netcdf('../nc/madt_oer_merged_h_18861.nc','nowrite');
disp(nc.discription(:))
disp(nc.author(:))
disp(nc.date(:))
myvar=ncvar(nc);
% Get coordinate information
lat=myvar{2}(:);
long=myvar{3}(:);
ssh=myvar{6}(:);


end

if itype==1

% Read the full data
ncfile='../nc/madt_oer_merged_h_18861.nc';
nc_dump(ncfile)

% Get coordinate information
lat=nc_varget(ncfile,'NbLatitudes');
long=nc_varget(ncfile,'NbLongitudes');
ssh=nc_varget(ncfile,'Grid_0001');


end


% Apply mask on land
ssh(ssh>100000)=NaN;
% Get the region of interest
atlssh=ssh(800:1080,500:800);
x=long(800:1080);
y=lat(500:800);
% Plot the subregion
pcolor(x,y,atlssh');
shading flat
colorbar
title('Sea surface height anomaly')