clear all;
close all;

% Number of grid points in x and y direction

M=180;
N=90;

% Domain with and length
LY=100000;
LX=3*LY;

% Grid spacing: periodic in x with two ghost points
%               dirichlet in y
dx=LX/(M-2);
dy=LY/(N-1);
% Velocity scale
U=1;
% Dissipation rate
dissrate=0.00000;
% Diffusion parameter
AH=0.05;
% Biharminic diffusion
BH=10*dx*dy;
% Deformation radius
R=LY/4/sqrt(2);


% Time step based on velocity scale and grid

dt=min(dx,dy)/U*0.05;

% Best guess on overrelaxation parameter
MM=1/(sqrt(0.5/(M*M)+0.5/(N*N)))
optsur=2/(1+1.5*pi/MM)

% Beta term
beta=0;

% Number of time steps
NSTEPS=50001;


% For color maps
val0=zeros(15,1);
vali=[0.5:0.5/14:1].';
vald=[1:-0.5/14:0.5].';
values = [0.:(1-0.)*1/31:1].';
valuesb = [1:-(1-0.)*1/31:0.].';
valuesd=ones(32,1);
valuesc=zeros(64,1);
gray = [values values values];
bluered=[ [val0' values' valuesd' vald']' [val0' values' valuesb' val0']' [vali' valuesd' valuesb' val0']'];
% End color maps

% Perturbation mode nnn
nnn=1;
for ic=1:M
    for jc=1:N
        % Grid coordinates
        xx(ic,jc)=(ic-M/2)*dx;
        yy(ic,jc)=(jc-1)*dy-LY/2;
        % Wavenumber of perturbation
        kx=2*nnn*pi/LX;
        aaa=sqrt((-kx^2-pi^2/LY^2+1/R^2)/(kx^2+pi^2/LY^2+1/R^2));
        % Phase of unstable perturbation
        phi=atan(aaa);
        % Perturbation 
        psi1p(ic,jc)=U*LY*0.05*sin(pi*(yy(ic,jc)+LY/2)/LY)*cos(kx*xx(ic,jc)+phi);
        psi2p(ic,jc)=U*LY*0.05*sin(pi*(yy(ic,jc)+LY/2)/LY)*cos(kx*xx(ic,jc)-phi);
    end
end
% Perturbation of vorticity from streamfunction perturbation
omp1=bcpert(laplacian(psi1p,dx,dy))-(psi1p-psi2p)/(2*R^2);
omp2=bcpert(laplacian(psi2p,dx,dy))+(psi1p-psi2p)/(2*R^2);


% Plot to start
pcolor(psi1p');
colormap(bluered);
colorbar;
title('Press key to start')
pause

% Old values for extrapolation of best guesses on psi
psiold1=psi1p;
psiold2=psi2p;

% Loop on time
for n=0:NSTEPS-1
    
    
    % Maximum number of iterations.
    NIT=N+M;
    % relative error allowed
    rlimi=0.000001;
    extra=1;
    % Update psi by inverting poisson equation
    [work1,work2,nit,relerr]=inversepoissonbc(omp1,omp2,psi1p+extra*(psi1p-psiold1),psi2p+extra*(psi2p-psiold2),dx,dy,R,NIT,rlimi,optsur);
    psiold1=psi1p;
    psiold2=psi2p;
    psi1p=work1;
    psi2p=work2;
    % diagnostics
    errtime(n+1)=relerr;
    niter(n+1)=nit;
    % Full streamfunction
    psi1=psi1p-U*yy;
    psi2=psi2p+U*yy;
    
   
    
    
    % Now advect voricity with predictor corrector method
    % Predictor
    % Total vorticity
    om1=omp1+(beta+2*U/(2*R^2))*yy;
    om2=omp2+(beta-2*U/(2*R^2))*yy;
    jacob=arakawa(psi1,om1,dx,dy);
    lap=laplacian(omp1,dx,dy);
    % Update of perturbation
    omp1w=(omp1-dt*jacob+AH*dt*lap-BH*dt*laplacian(lap,dx,dy))/(1+dt*dissrate);
    omp1w=bcpertom(omp1w);
    % Same for region 2
    jacob=arakawa(psi2,om2,dx,dy);
    lap=laplacian(omp2,dx,dy);
    omp2w=(omp2-dt*jacob+AH*dt*lap-BH*dt*laplacian(lap,dx,dy))/(1+dt*dissrate);
    omp2w=bcpertom(omp2w);
    % Corrector: same as predictor but with guess omp1w and omp2w
    om1=omp1w+(beta+2*U/(2*R^2))*yy;
    om2=omp2w+(beta-2*U/(2*R^2))*yy;
    jacob=arakawa(psi1,om1,dx,dy);
    lap=laplacian(omp1w,dx,dy);
    omp1=(omp1-dt*jacob+AH*dt*lap-BH*dt*laplacian(lap,dx,dy))/(1+dt*dissrate);
    omp1=bcpertom(omp1);
    jacob=arakawa(psi2,om2,dx,dy);
    lap=laplacian(omp2,dx,dy);
    omp2=(omp2-dt*jacob+AH*dt*lap-BH*dt*laplacian(lap,dx,dy))/(1+dt*dissrate);
    omp2=bcpertom(omp2);
% Every 5 step, make a nice plot
    if mod(n,5)==0
        
        close all;
        figure('Position',[1 1 1200 600]);
        set(gcf,'PaperPositionMode','auto');
        
        subplot(2,2,1);
        pcolor(xx',yy',real(om1)');
        caxis([-0.0004 0.0004]);
        shading('interp');
        axis equal;
        axis off;
        title 'Layer 1 PV';
        colormap(bluered);
        %colorbar('horiz')
        
        subplot(2,2,2);
        pcolor(xx',yy',real(om2)');
        caxis([-0.0004 0.0004]);
        shading('interp');
        axis equal;
        axis off;
        title 'Layer 2 PV';
        %colorbar('horiz')
        
        subplot(2,2,3);
        pcolor(xx',yy',real(psi1)');
        caxis([-U*LY U*LY]);
        shading('interp')
        [MMM IIIND]=max(psi1p);
        [MMAX JIND]=max(MMM);
        IIND=IIIND(JIND);
        [MMM IIIND2]=max(psi2p);
        [MMAX JIND2]=max(MMM);
        IIND2=IIIND2(JIND2);
        hold on;
        plot(xx(IIND,JIND),yy(IIND,JIND),'+',xx(IIND2,JIND2),yy(IIND2,JIND2),'o')
        hold off;
        axis equal;
        axis off;
        title 'Streamfunction layer 1';
        %colorbar('horiz');
        
        subplot(2,2,4);
        %pcolor(xx',yy',real(psi2)');
        pcolor(xx',yy',real((psi2-psi1)/2)');
        caxis([-U*LY U*LY]);
        shading('interp');
        axis equal;
        axis off;
        
        hold on;
        for j=1:N
            ccc(j)=0;
            xxx(j)=(j-1)*dy-LY/2;
        end
        for i=2:M-1
           for j=1:N
               ccc(j)=ccc(j)+(psi2(i,j)-psi1(i,j))/2./(M-2);
           end
        end
        plot(ccc/U/LY*LX/4,xxx);
        hold off;
        
        title 'Interface position';
        %title 'Streamfunction layer 2'
        %colorbar('horiz')
        pause(0.001)
        % Every 100 steps save plot
        if mod(n,100)==0
        %    tutut=['./bc' num2str(10000+n) '.eps']
        %    print('-dps','-r200',tutut)
            aaaa= [ './bc' num2str(10000+n) '.png'];
            print('-dpng', aaaa);
        end
        
        pause(0.01)
        
    end
    
end


%exit
