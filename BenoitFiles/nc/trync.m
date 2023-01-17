% Tries to detect if the netcdf interfacing is 
% otcdf (similar to an older mexcdf) or mexcdf with SNCTOOLS

isoct=0
ismex=0


try
pkg load octcdf
isoct=1
catch
message='Does not seem to be an octave version with octcdf'
end



try
ncdump('etopo5.nc','header')
isoct=1
catch
% Obviously did not turn out to work
message='ncdump does not work'
isoct=0
end

try
nc_dump('etopo5.nc')
ismex=1
catch
% Obviously did not turn out to work
message='nc_dump does not work'
ismex=0
end

if ismex+isoct==0

end

itype=0

if ismex==1
message='New mexCDF interface'
itype=1
end

if isoct==1
message='octCDF interface'
itype=2
end

fid = fopen('nctype.dat', 'w');
fprintf(fid,'%u',itype)
fclose(fid);

