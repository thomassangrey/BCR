function[lon,lat,depth]=etopo5ncread(bidon)

disp(['Reading etopo5' ]);
% Old mexcdf version
% nc = netcdf('../nc/etopo5.nc', 'nowrite');   % Open NetCDF file.
% disp(nc.description(:))         % Global attribute.
% disp(nc.author(:))              % Global attribute.
% disp(nc.date(:))                % Global attribute.
% variables = var(nc);            % Get variable data.
% lat=variables{2}(:);
% lon=variables{1}(:);
% depth=variables{3}(:);
% depth=depth';
% nc = close(nc); 
% 

% Try to recover which interface is used
fid = fopen('../nc/nctype.dat', 'r');
itype=fscanf(fid,'%u',1)
fclose(fid);

if itype==1


% New mexcdf version
ncfile='../nc/etopo5.nc';
% Look at the content
nc_dump(ncfile)
% Then read the relevant parameters
lat=nc_varget(ncfile,'topo_lat');
lon=nc_varget(ncfile,'topo_lon');
depthi=nc_varget(ncfile,'topo');


end

if itype==2
% octCDF type
ncfile='../nc/etopo5.nc';
% Look at the content
ncdump(ncfile)

nc=netcdf(ncfile,'r');
lat=nc{'topo_lat'}(:);
lon=nc{'topo_lon'}(:);
depthi=nc{'topo'}(:);


end


size(depthi)
depth=double(depthi');
norm(depth)