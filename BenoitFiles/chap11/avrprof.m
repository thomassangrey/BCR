function[avrprof,z]= avrprof(file,long1,long2,lat1,lat2) 
%
% Provides and average profile avrprof and the vertical position z of the profile data 
%
% Input= filename of the Mediterranean climatoloy and the bounding box for the averaging

disp(['Computing average profile']);
[a,b,c,d]=medarncread(file);

idim=size(a);
% find grid coordinates of the box to be used for averages
i1=max(find(b<long1));
i2=min(find(b>long2));
j1=max(find(c<lat1));
j2=min(find(c>lat2));

for il=1:idim(3)
    mp(il)=0;
    ip(il)=0;
end
% Make the average over the grid indexes
for il=i1:i2,
  for jl=j1:j2,
      % Vertical profile
      for kl=1:idim(3),
          % If a valid point, add to the average
          if ~isnan(a(il,jl,kl))
              % summed value
          mp(kl)=mp(kl)+a(il,jl,kl);
              % number of points in the average
          ip(kl)=ip(kl)+1;
          end
      end
  end
end
   
for kl=1:idim(3),
    % Calculate average at the depth of the initial data
    avrprof(kl)=NaN;
    if ip(kl)>0
    avrprof(kl)=mp(kl)/ip(kl);
    end
    z(kl)=-d(kl);
end
