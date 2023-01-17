clear all;
close all;
% PARAMETERS

f=0.0001;     % Coriolis frequency
N0=0.001;      % Lower bound of Brunt Vaisala frequency for analytical profile
N1=0.01;      % Upper bound of Brunt Vaisala frequency
H=200;        % Depth
PW=5;         % Half of analytical pycnocline width
PD=50;        % Pycnocline depth of analytical profile

KHS=0.01;     % KHS=l^2+m^2: square of horizontal wavenumber
KM=150;        % Number of calculation points including surface and bottom point

% Look at modes im1 to im2 (just adapt)

im1=1;

% Only three modes are plotted together so do not change the following line
im2=im1+2;

% Resulting grid spacing

DZ=H/(KM-1);  % Grid spacing


% Stratification profile and depth of discrete point k

for k=1:KM
    z(k)=-H+(k-1)*DZ;
    NS(k)=N0^2+(N1^2-N0^2)/cosh(z(k)/5+10); 
end

subplot(1,1,1)    
plot(NS,z)                      % show profile
title('N^2 profile, hit any key to continue')
pause
figure

eps=DZ^2*KHS;         % epsilon of the theory
% Be careful about the limits..., now KM-2 is the real size of the problem, surface and bottom being eliminated
for k=1:KM-2,
    al(k)=eps*(NS(k+1)/f^2); % part of the diagnal of B
end

% Filling in of (KM-2)x(KM-2) square matrix B

for i=1:KM-2,
    for j=1:KM-2,
        B(i,j)=0;
    end
    im=max(1,i-1);       %for first line
    ip=min(KM-2,i+1);    %for last line
    B(i,im)=-1;          %rubbush if i=1
    B(i,ip)=-1;          %rubbish if i=KM-2
    B(i,i)=2+al(i);      % but corrected in both cases since then im=i or ip=i
end

% Same fo matrix C

for i=1:KM-2,
    for j=1:KM-2,
        C(i,j)=0;
    end
    im=max(1,i-1);
    ip=min(KM-2,i+1);
    C(i,im)=-1;
    C(i,ip)=-1;
    C(i,i)=2+eps;
end

% Several ways to calcule eigenvalues
% transformation into classic problem
A=B*inv(C);
[Wt,lambda]=eig(A);
W=inv(C)*Wt;

% Or use of generalized eigenvalue solver
[Wb,lambdab]=eig(B,C,'qz');

% Preparation of outputs including first and last grid point

for i=1:KM-2,
    we(i)=(KHS*N1^2+f^2*(i*pi/H)^2)/(KHS+(i*pi/H)^2); %exact solution for constant N (put N1=N0)
    wc(i)=f^2*lambda(i,i);                                %numerical solution
end

% for comparison with constant N^2 case

x1(1)=log10(f^2);
x2(1)=x1(1);
x1(2)=log10(N1^2);
x2(2)=x1(2);

subplot(1,1,1)    
plot(log10(wc),log10(we),'r.',x1,x2)                      % show regression with exact solution (only relevant for constant N)
title('Comparison of \omega with constant N solutions')
ylabel('Numerical value of log (\omega^2)')
xlabel('Exact value with constant N')
figure


idel=im2-im1+1;



for imode=im1:im2   % loop on modes asked for
    
    for i=1:KM-2
        WM(i+1)=W(i,imode);     %spatial function method Aw=lw
        WMB(i+1)=Wb(i,imode);   %spatial function method Bw=lCw
        om(i+1)=f^2*lambda(imode,imode);  %omega square
    end
    
    WM(1)=0;             %filling of boundary conditions
    WM(KM)=0;
    om(1)=om(2);
    om(KM)=om(KM-1);
    WMB(1)=0;
    WMB(KM)=0;
    
    fname=[ 'mode' int2str(imode) '.ps'];
    tname=[' eigenvalue ' , int2str(imode), ' : \omega^2=', num2str(sqrt(wc(imode)))];
    subplot(idel,2,1+2*(imode-im1))
    plot(WMB,z)
    legend('w',3)
    ylabel('z')
    subplot(idel,2,2+2*(imode-im1))
    plot(log10(NS),z,log10(om),z)
    axis([-8 -4 -200 0])
    title(tname)
    legend('log(N^2)','log(\omega^2)',3)
    ylabel('z')
    
end

