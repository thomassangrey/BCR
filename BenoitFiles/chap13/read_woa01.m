function read_woa01(file,variable)

% read_woa01.m
%
% read_woa01('file','variable')
%  'file' is NetCDF file
%  'variable' must be 'all', 'list' or '<var_name>'
%
% read WOA01 Levitus T-S-O2, Stddev & nb_obs Netcdf file in memory


% Try to recover which interface is used
fid = fopen('../nc/nctype.dat', 'r');
itype=fscanf(fid,'%u',1)
fclose(fid);

if itype==1
% new mexcdf version
if strcmp( variable, 'list' )
    nc_dump(file)
    return
end
valu=nc_varget(file,variable);
fillval = nc_attget (file,variable,'_FillValue')

valu(valu == fillval) = NaN;
assignin('base',variable,valu);
end

if itype==2
% Seems to be the octCDF interface




if nargin < 2 
   help(mfilename)
   return
end

filesfound = checkforfiles( file );
if filesfound == 0; 
   error(['Couldn''t find ', file])
end



nc = netcdf(file,'nowrite');


variables = ncvar(nc);


if strcmp( variable, 'list' )
    ncdump(file)
    return
end
if strcmp( variable, 'all' )
    for i = 1:length(variables)
        value = variables{i}(:);
        % Replace fillvalues by NaN
        value(find(value == nc{variables{i}}.FillValue )) = NaN;
        % Assign variable in workspace.
        assignin('base', name(variables{i}), value );
    end
else
    value = nc{variable}(:); 
    % Replace fillvalues by NaN
    value(find(value == nc{variable}.FillValue )) = NaN;
    % Assign variable in workspace.
    assignin('base', name(nc{variable}), value );
end

close(nc);

end


%----------------------------------------------------------------------
%----------------------------------------------------------------------
function filesfound = checkforfiles( file )

if exist(file,'file');
   filesfound = 1;
else 
   filesfound = 0;
end

