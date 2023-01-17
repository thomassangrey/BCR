clear all;
close all;

% Grid size

    M = 60;
    N = 50;
    

% PARAMETERS
    % Coriolis parameter
    f = 10^(-4);
    % gravity
    g = 10;
    % reference depth
    h0 = 100;
    % deformation radius
    R = sqrt(g*h0)/f;
% Domain size
    Lx = 12*R;
    Ly = 10*R;
    
% Periodic conditions on x require a ghost point on each side
    dx = Lx/(M-2);
% Impermeability in y direction two points are used for land
    dy = Ly/(N-2);


% Final time here one displacement 
    TF=1*Lx/sqrt(g*h0)
% Time step based on gravity wave speed
    dt=0.1/sqrt(g*h0)/sqrt((1/dx^2+1/dy^2))
    t=0
% Number of time steps as a function of time step and Final time

    Nsteps = floor(TF/dt);
% Coordinates of cell centers
    for i=1:M
        x(i) = (i-1/2)*dx;
    end
    % Zero in j=1+1/2. First line is a land point
    for j=1:N
        y(j) = (j-3/2)*dy;
    end
    
% RESOLUTION AND PLOT

% Declare arrays
    % velocities
    u = zeros(M,N);
    v = zeros(M,N);
    % New velocities
    unp=u;
    vnp=v;
    % transports
    hu=u;
    hv=v;
    % Elevation
    zeta = zeros(M,N);
    % Topography
    h=h0*ones(M,N);
    % Land-sea mask
    issea=ones(M,N);
    
% Staggered C-grid:
% u(i,j) is in i-1/2
% v(i,j) is in j-1/2

    
    
    % Initial situation: a full wave
    kx = 2*pi/Lx;
    % Small amplitude. For larger amplitudes, nonlinearities appear
    AMPLI=0.0001
    for j=1:N
        for i=1:M
            u(i,j) = AMPLI*sqrt(g*h0) * exp(-y(j)/R) * sin(kx*(x(i)-dx/2));
        end
    end
    
    for i=1:M
        for j=1:N
            zeta(i,j) = AMPLI*h0 * exp(-y(j)/R) * sin(kx*x(i));
        end
    end
    % Total water depth including elevation
    htot=h+zeta;
    % Solid boundary in south and north
    issea(:,1)=0;
    issea(:,N)=0;
    
    
    % Show initial elevation
    pcolor(x,y,zeta')
    shading flat
    colorbar
    title ('To start press any key')
    pause
% Make Nsteps time steps


for nn=1:Nsteps
    
  %%% Defining transports from velocities using actual total depth (nonlinear)
   for i=2:M
        for j=1:N
            hu(i,j) = u(i,j)*(htot(i,j)+htot(i-1,j))/2;
        end
    end
    hu(1,:)=hu(M-1,:);
    for i=1:M
        for j=2:N
            hv(i,j) = v(i,j)*(htot(i,j)+htot(i,j-1))/2;
        end
    end
    hv(:,1)=0;

    
    % New elevation, updated immediately since local and never needing any neighbour zeta
    
    for i=2:M-1
        for j=2:N-1
            % divergence of transport leads to elevation change
            zeta(i,j) = zeta(i,j) - dt/dx * (hu(i+1,j)-hu(i,j)) - dt/dy * (hv(i,j+1)-hv(i,j));
        end
    end
    % periodicity
    zeta(1,:)=zeta(M-1,:);
    zeta(M,:)=zeta(2,:);
    zeta(:,1)=0;
    zeta(:,N)=0;
    % Total height
    htot=h+zeta;
    
    
    
  %%% New velocity values with fractional-step approach on coriolis
    
    if mod(nn,2) == 1
        multipas = [1 2];
    elseif mod(nn,2) == 0
        multipas = [2 1];
    end
    
    for k=1:2
    if multipas(k) == 1
        
        for i=2:M-1
            for j=1:N-1
                % Coriolis
                work = u(i,j) + f*dt/4 * (v(i,j+1) + v(i,j) + v(i-1,j+1) + v(i-1,j));
                % and elevation gradient
                unp(i,j) = work - g*dt/dx * (zeta(i,j) - zeta(i-1,j));
                % applying a mask on sea-land interfaces
                unp(i,j)=unp(i,j)*issea(i,j)*issea(i-1,j);
            end
        end
        % update and periodic conditions
        u = unp;
        u(1,:)=u(M-1,:);
        u(M,:)=u(2,:);
        u(:,N)=0;
        
        
    elseif multipas(k) == 2
        
        for i=2:M-1
            for j=2:N
                % Coriolis
                work = v(i,j) - f*dt/4 * (u(i+1,j) + u(i+1,j-1) + u(i,j) + u(i,j-1));
                % and elevation gradient
                vnp(i,j) = work - g*dt/dy * (zeta(i,j) - zeta(i,j-1));
                % applying a mask on sea-land interfaces
                vnp(i,j)=vnp(i,j)*issea(i,j)*issea(i,j-1);
            end
        end
        
        % update and periodic conditions
        
        v = vnp;
        v(1,:)=v(M-1,:);
        v(:,1)=0;
        v(M,:)=v(2,:);
       
        
    end
    end

% Plot
    % update time
    t=t+dt
    % Every once in a while make a plot
    if mod(nn,10)==0
    pcolor(x,y,zeta')
    shading flat
    colorbar
    title(['Elevation at time: ',num2str(t)])
    pause(0.0001);
    end

end

