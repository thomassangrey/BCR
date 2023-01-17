function[err]= spectralekman(N)

% Wind stress solution isol=1
% Pressure gradient solution isol=2
isol=2


% PARAMETERS
% viscosity
nu=0.01;
% depth
h=100;
% Coriolis parameter
f=0.0001;
% wind stress in y direction
tauy=0;
% wind stress in x direction
if isol==1
taux=10^(-6)*10*10*1
else 
taux=0
end
% pressure gradient in y direction
if isol==2
pressy=9.81*1/1000000*1
else
pressy=0
end
% pressure gradient in x dirction
pressx=0;

% Number of points for plotting the solution
KM=400;
% Resulting ekman layer depth
dek=sqrt(2*nu/f);

% RESOLUTION and PLOT

% Eigenvalues and eigenmodes
for j=1:N
    s(j)=2*sqrt(2*h)/(pi*(2*j-1));
    phih(j)=sqrt(2/h)*(-1)^(j-1);
    eigen(j)=(2*j-1)^2*pi*pi*nu/(4*h*h);
    FX(j)=-pressx*s(j)+taux*phih(j);
    FY(j)=-pressy*s(j)+tauy*phih(j);
    % stationnary solution for the coefficients
    a(j)=(eigen(j)*FX(j)+f*FY(j))/(eigen(j)^2+f^2);
    b(j)=(eigen(j)*FY(j)-f*FX(j))/(eigen(j)^2+f^2);
end

for k=1:KM
    U(k)=0;
    V(k)=0;
end
% From coefficients, calculate solution
for k=1:KM
    z(k)=(k-1)*h/(KM-1);
    U(k)=0;
    V(k)=0;
    uex(k)=0;
    vex(k)=0;
    for j=N:-1:1
        U(k)=U(k)+a(j)*sqrt(2/h)*sin( (2*j-1)*pi/2*z(k)/h);
        V(k)=V(k)+b(j)*sqrt(2/h)*sin( (2*j-1)*pi/2*z(k)/h);
    end
end


for k=1:KM
    % Exact solution 
    % You need to edit ekmanh.m to check which exact solution is provided (wind-stress or pressure gradient solution)
    [uex(k),vex(k)]=ekmanh(h/dek,z(k)/dek,isol);
    % If the exact solution is the wind-stress solution, 
    if isol==1
    uex(k)=uex(k)*taux/nu*dek;
    vex(k)=vex(k)*taux/nu*dek;
    end
    if isol==2
    % Scaling for the pressure gradient solution
    uex(k)=-(1+uex(k))*pressy/f;
    vex(k)=-vex(k)*pressy/f;
    end
end
plot(uex,z,vex,z,U,z,'-.',V,z,'-.')
xlabel('Velocity: exact solution and spectral solution');
ylabel('z');

figure
% Calculate error
err=0;
for k=1:KM
    err=err+(U(k)-uex(k))^2+(V(k)-vex(k))^2;
end
err=sqrt(err/KM);
for kk=1:N;
    aa(kk)=log(a(kk)*a(kk));
    xx(kk)=log(kk);
end
bar(xx,aa+40);
xlabel('log(j)');
ylabel('log(a_j^2)');



