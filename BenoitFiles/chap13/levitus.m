% Show variables in the file
read_woa01('../nc/woa01an.nc','list')


% Read variable mean temparature
read_woa01('../nc/woa01an.nc','WOA01_MEAN_TEMP');

% Look at size 
size(WOA01_MEAN_TEMP)

% Try to see how it is organised
pcolor(WOA01_MEAN_TEMP(:,:,1))
title('SST')
shading flat




% Now another field
read_woa01('../nc/woa01an.nc','WOA01_MEAN_PSAL');

% Look at size 
size(WOA01_MEAN_PSAL)

% Try to see how it is organised
figure
pcolor(WOA01_MEAN_PSAL(:,:,1))
title('SSS')
shading flat

% From here on, try to recover coordinates,
% calculate the density profiles requested.
