function[sst,oi,time]=soiread(istofilter)
% Function providing SST and OI indexes as a function of time.
% when istofilter==1 a time filter is applied
SSTOI=dlmread('sstoi19512006.dat')
SOI=dlmread('soislps19512005.dat')
for i=1:660
    time(i)=1951+(i-1)/12;
    sst(i)=SSTOI(i,10);
end
for ii=1:55
    for jj=1:12
        i=(ii-1)*12+jj;
    oi(i)=SOI(ii,jj+1);
end
end
if istofilter==1
    sst=filter([1/3 1/3 1/3],1,sst);
    oi=filter([1/3 1/3 1/3],1,oi);
end