
% Name of the analysed file

Name = 'output'

% OUTPUTS
% -------
% - fileout is the name of the analysis field plot
% - format_out --> format of the plot:
% format_out = 1 --> jpeg format
% format_out = 2 --> eps format

format_out = 2;

% name of the analysis output files 
fileout1 = [Name,'_analysis'];
fileout2 = [Name,'_error'];


% ---------------------------------------------------------------
% ---------------------------------------------------------------


% Read data and coastline
data = dlmread('./diva/data.dat');
cont = dlmread('./diva/coast.cont');

% if reading of .anl files does not work, try to read netcdf file result.nc
% Or try to adapt uread for little-endian big-endian problems


% Read analysed field
[flag,c4,imax,jmax,kmax,valex,nbmots] = uread('./diva/fieldgher.anl');
% Read error field
[flag,c4err,imax,jmax,kmax,valexe,nbmots] = uread('./diva/errorfieldgher.anl');
% Read info on topology and grid spacing
gridinfo = textread('./diva/gridInfo.dat');

display('contour plotting ...')

ncont=cont(1,1);

ioff=2;
for i=1:ncont
    np=cont(ioff,1);
    xx=cont(ioff+1:ioff+np,1);
    yy=cont(ioff+1:ioff+np,2);

    % to close the contours
    xx = [xx;xx(1)];
    yy = [yy;yy(1)];

    ioff=ioff+np+1;
    hold on
    plot(xx,yy,'k','LineWidth',2)
    fill(xx,yy,[0.7,0.7,.7])
    clear np xx yy
end
hold on;


% analysis plotting
% -----------------

display('analysed field plotting ...')

gg=reshape(c4,imax,jmax);
for i=1:imax
    for j=1:jmax
        if gg(i,j)==valex 
            gg(i,j)=NaN;
        end
    end
end

% grid parameters

xorigin = gridinfo(1)
yorigin = gridinfo(2)
dx = gridinfo(3)
dy = gridinfo(4)
xend = xorigin+(gridinfo(5)-1)*dx
yend = yorigin+(gridinfo(6)-1)*dy

x = [xorigin:dx:xend];
y = [yorigin:dy:yend];


pcolor(x,y,gg')
shading('interp')
xlabel('Longitude ( ^{\circ} E)','fontsize',14)
ylabel('Latitude ( ^{\circ} N)','fontsize',14)
title('Analysis','fontsize',14)
axis([xorigin xend 30 46])
caxis([36 39])
colorbar('horiz')
colormap(jet)

% Now add data points..
%display('data plotting...')

scatter(data(:,1),data(:,2),2,([1 1 1]),'filled')

if (format_out == 1),
    print('-djpeg',[fileout1,'.jpg'])
else 
    print('-depsc2',[fileout1,'.eps'])
end;
display('your plots are finished')
cd(this_directory);
figure
display('contour plotting ...')

ncont=cont(1,1);

ioff=2;
for i=1:ncont
    np=cont(ioff,1);
    xx=cont(ioff+1:ioff+np,1);
    yy=cont(ioff+1:ioff+np,2);

    % to close the contours
    xx = [xx;xx(1)];
    yy = [yy;yy(1)];

    ioff=ioff+np+1;
    hold on
    plot(xx,yy,'k','LineWidth',2)
    fill(xx,yy,[0.7,0.7,.7])
    clear np xx yy
end
hold on;


% analysis plotting
% -----------------

display('analysed field plotting ...')

gg=reshape(c4err,imax,jmax);
for i=1:imax
    for j=1:jmax
        if gg(i,j)==valexe 
            gg(i,j)=NaN;
        end
    end
end

% grid parameters

xorigin = gridinfo(1)
yorigin = gridinfo(2)
dx = gridinfo(3)
dy = gridinfo(4)
xend = xorigin+(gridinfo(5)-1)*dx
yend = yorigin+(gridinfo(6)-1)*dy

x = [xorigin:dx:xend];
y = [yorigin:dy:yend];


pcolor(x,y,gg')
shading('interp')
xlabel('Longitude ( ^{\circ} E)','fontsize',14)
ylabel('Latitude ( ^{\circ} N)','fontsize',14)
title('Error','fontsize',14)
axis([xorigin xend 30 46])
caxis([0 0.7])
colorbar('horiz')
colormap(jet)

% Now add data points..
%display('data plotting...')

scatter(data(:,1),data(:,2),2,([1 1 1]),'filled')

if (format_out == 1),
    print('-djpeg',[fileout1,'.jpg'])
else 
    print('-depsc2',[fileout1,'.eps'])
end;
display('your plots are finished')

