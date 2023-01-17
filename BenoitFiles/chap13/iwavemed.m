clear all
close all

timetowait=0.01
[f, NS, z]=nsmed(0,12,33,42);  % use average profile of med sea in box (0:12)x(33,42)



%

% Stratification profile and depth of discrete point k

kdim=size(NS);
KM=kdim(2);
DZ=z(KM)-z(KM-1); % assuming uniform DZ
N1=sqrt(max(NS));

H=max(abs(z));

% If you want to compare to the constant N case, uncomment line
%NS(1:KM)=N1

subplot(1,1,1)    
plot(NS,z)                      % show profile
title('profile, hit space to continue')
pause

% See iwave.m for more details on parameters
for jm=1:100
    
    % Look at different values of kx^2+ky^2
    KHS=100*0.9^jm/H^2;
    
    
    
    eps=DZ^2*KHS;         % epsilon of the theory
    % Be careful about the limits..., now KM-2 is the real size of the problem, surface and bottom being eliminated
    for k=1:KM-2
        al(k)=eps*(NS(k+1)/f^2); % part of the diagnal of B
    end
    
    % Filling in of (KM-2)x(KM-2) square matrix B
    % slightly changed to take into account that lambda is near 1 and lambda=1+x into equations modifies B
    % then x is called lambda again
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
    % transformation into classic probel
	A=B*inv(C);
	[Wt,lambda]=eig(A);
	W=inv(C)*Wt;
    
    % Or use of generalized eigenvalue solver
    % [Wb,lambdab]=eig(B,C,'chol');
    
    mymode=W(:,1);
    % Try to have the same sign during animation
    if mymode(10)<0
        mymode=-mymode
    end
    plot(mymode,z(2:100))
    
    title([ 'Fundamental mode for log k^2= ', num2str(log10(KHS))])
    pause(timetowait)
    
    % From the solution, show the Deformation radius 13.25 and 13.26
    ll(jm)=max(diag(lambda)) ;
    
    ghi=(ll(jm)*f^2-f^2)/KHS;
    rossby(jm)=sqrt(ghi)/f;
    kh(jm)=KHS;
    % In case you look at the constant N^2 case, you can also calculate the exact value
    rossbye(jm)=sqrt((NS(1)-f^2)/(KHS+pi*pi/H/H))/f;
    
end

plot(log10(kh),rossby/1000,'b.')
xlabel('log(kx^2+ky^2)')
ylabel('Rossby radius in km')

% Plot the mode for the last value of kx^2+ky^2


