trync.m
This small script can be used to test which kind of netCDF interface is likely to work.
When executed it should tell which interface works and create a small file called nctype.dat
In nctype.dat the value is
0 for no identified interface
1 for a recent MEXCDF interface
2 for a octCDF interface with direct netCDF library calls