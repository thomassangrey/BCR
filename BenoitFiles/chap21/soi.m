clear all
% Read indexes without filtering
% To use a filtered version call soiread(1)
[sst,oi,time]=soiread(0)

% Plot it
subplot(2,1,1)
bar(time,sst,1)
axis([1950 2005 -4 4])
grid on
title('Temperature anomaly')
ylabel('C')
subplot(2,1,2)
bar(time,oi,1)
title('Southern oscillation index')
axis([1950 2005 -4 4])
grid on
