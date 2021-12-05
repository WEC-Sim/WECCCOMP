% Kinematic values
clc;close all;
time = output.bodies( 1 ).time;
position = ( output.bodies( 1 ).position.' - [ body(1).cg; 0; 0; 0 ] );     %zero the position so position vector starts at [0,0,0,0,0,0]
velocity = output.bodies( 1 ).velocity;
acceleration = output.bodies( 1 ).acceleration;
positionArm = output.bodies( 2 ).position;
velocityArm = output.bodies( 2 ).velocity;
accelerationArm = output.bodies( 2 ).acceleration;
ptoM = output.ptos.forceActuation( :, 3 );

%Moments
forceTotal = output.bodies( 1 ).forceTotal;
forceExcitation = output.bodies( 1 ).forceExcitation;
forceRadiationDamping = output.bodies( 1 ).forceRadiationDamping;
forceAddedMass = output.bodies( 1 ).forceAddedMass;
forceRestoring = output.bodies( 1 ).forceRestoring;
forceLinearDamping = output.bodies( 1 ).forceLinearDamping;

kh                        = body( 1 ).hydroForce.linearHydroRestCoef( 5, : );
khc                      = cross( [ 0, 0, 9.81*1000*body( 1 ).dispVol ], body( 1 ).cb - body( 1 ).cg );
inf_addedMass = body( 1 ).hydroForce.fAddedMass( 5, : );
linearDamping  = body( 1 ).hydroForce.linearDamping( 5, : );

 % Plots Comparing Restoring, added mass and linear damping moments
figure('Name','Restoring and Added Mass Moments','Units','Normalized','OuterPosition', [0 0 1 1] );
subplot( 3, 1, 1 );     plot( time, forceRestoring( :, 5 ), 'k' );      hold on;         grid on;        grid minor;        box on;
                        plot( time, kh*position + khc( 2 ), '--r' );    title('Restoring moment');xlabel('time [s]');ylabel('Restoring moment [Nm]'); 
subplot( 3, 1, 2 );     plot( time, forceAddedMass( :, 5 ), 'k' );      hold on;         grid on;        grid minor;        box on;
                        plot( time, inf_addedMass*acceleration', '--r' );    title('Added Mass moment');    xlabel('time [s]');     ylabel('Added Mass moment [Nm]');
subplot( 3, 1, 3 );     plot( time, forceLinearDamping( :, 5 ), 'k' );      hold on;         grid on;        grid minor;        box on;
                        plot( time, linearDamping*velocity', '--r' );    title('Linear Damping moment');      xlabel('time [s]');     ylabel('Linear Damping moment [Nm]');

%% Excitation Force
% Mex= -xFex * sin(position + initial_Position)*Larm - zFex*cos(position + initial_Position)*Larm + Mex,pitch
L_AB = 0.412; 
L_AC = 0.2;
L_BC_neutral = 0.381408;
Larm = 0.54875;
alpha0 = acos( ( L_BC_neutral^2 - L_AB^2 - L_AC^2 ) / ( -2*L_AC*L_AB ) );   % Computed using the dimensions AB, BC and BC.
theta0 = deg2rad( 26.985 ); 
xFex = output.bodies( 1 ).forceExcitation( :, 1 );
zFex = output.bodies( 1 ).forceExcitation( :, 3 );
zMex = output.bodies( 1 ).forceExcitation( :, 5 );
theta = position( 5, : )';

exM = (-Larm*xFex.*sin(theta0-theta) - zFex*Larm.*cos(theta0-theta) + zMex);

figure('Name','Excitation forces and Moment','Units','Normalized','OuterPosition', [0 0 1 1] );
subplot(4,1,1);     plot(time,xFex,'k');    title('X-ExcForce');    xlabel('time [s]');     ylabel('X-ExcForce [N]');       grid on;    grid minor;     box on;
subplot(4,1,2);     plot(time,zFex,'k');    title('Z-ExcForce');    xlabel('time [s]');     ylabel('Z-ExcForce [N]');       grid on;    grid minor;     box on;
subplot(4,1,3);     plot(time,zMex,'k');  title('Z-ExcMoment');     xlabel('time [s]');     ylabel('Z-ExcMoment [Nm]');     grid on;    grid minor;     box on;
subplot(4,1,4);     plot(time,exM,'k');    title('A-ExcMoment');    xlabel('time [s]');     ylabel('A-ExcMoment [Nm]');     grid on;    grid minor;     box on;

figure('Name','Normalised excitation moment and wave elevation','Units','Normalized','OuterPosition', [0 0 1 1] );
plot( time, exM ./ max( exM ), 'k' );  hold on;   grid on;    grid minor;  box on;
plot( output.wave.time, output.wave.elevation ./ max( output.wave.elevation ), 'r' );

%% Load WEC model parameters
Model_Parameters();
dt=mean(diff(time));                %Sampling time

%%%%%% State Space Matrices for the Linear system %%%%%%%%%%%%%%%%%%%%%%%
Ac = [0,1,0,0;-Khs./Jt,-(Dr+bv)./Jt,-Cr./Jt;[0;0],Br,Ar];      
Bc = [0;1/Jt;0;0];                                                                                                                      
Cc = [1,0,0,0;0,1,0,0];
Dc = [0;0];
%Form State Space
sysC = ss(Ac,Bc,Cc,Dc);             %Declares Continuous State Space
%Discretize using ZOH
sysD = c2d(sysC,dt,'zoh');          %Declares discrete State Space

% WEC discrete Model System
Ad = sysD.A;                        %Discrete State Transition Matrix
Bd = sysD.B;                        %Discrete Input To State Matrix
Cd = sysD.C;                        %Discrete Output Matrix
Dd = sysD.D;                        %Discreete Input To Output Matrix
nx=size(Ad,1);                      %Number of States  
nu=size(Bd,2);                      %Number of Inputs  
ny=size(Cd,1);                      %Number of Outputs

%%%%%% Simulation %%%%%%%%%%%%%%%%%%%%%%%
Time=time(end);
kT=round(Time/dt);                  %Number of simulation steps
%Preallocation 
Xk=zeros(nx,kT);                    %Matrix to store the state values from the simulation
Uk=zeros(nu,kT);                    %Matrix to store the input values from the simulation
Yk=zeros(ny,kT);                    %Matrix to store the measurement values from the simulation

%Main For Loop
k_ini=1;          %Starting Point of For Loop
   for k=k_ini:kT-1
       Uk(:,k)=0;                   %No control      
       %System Simulation
       Xk(:,k+1) = Ad*Xk(:,k) + Bd*K3*Uk(:,k) - Bd*exM(k,1);    %States
       Yk(:,k) = Cd*Xk(:,k);                                    %Outputs
   end
figure('Name','Float Displacement, Velocity and Excitation Moment','Units','Normalized','OuterPosition', [0 0 1 1] );
subplot( 3, 1, 1 );    plot( time( 1 : length( Uk ) ), Xk( 1, : ), 'k-');                                  title('Angular displacement');    ylabel('Angular displacement [rad]');  hold on;  grid on;  grid minor;
subplot( 3, 1, 2 );    plot( time( 1 : length( Uk ) ), Xk( 2, : ), 'k-');                                  title('Angular Velocity');               ylabel('Angular Velocity [rad/s]');         hold on;  grid on;  grid minor;
subplot( 3, 1, 3 );    plot( time( 1 : length( Uk ) ), exM( 1 : length( Uk ), 1 ),'k-');	title('Excitation Moment'); xlabel('Time [s]'); ylabel('Moment [Nm]');  hold on;  grid on;  grid minor;      
      
figure('Name','WecSim vs SS-model Arm position comparison','Units','Normalized','OuterPosition', [0 0 1 1] );
plot( time( 1 : length( Yk ) ), -Yk( 1, : ), 'k-' );  title( 'Arm angular displacement' ); ylabel('Angular displacement [rad]'); hold on; grid on; grid minor;
plot( time( 1 : length(Yk)), positionArm( 1 : length( Yk ), 5 ) - 0.0118162, 'r' );
legend('State-Space Model', 'wecSim Arm-position ')

figure('Name','WecSim vs SS-model Arm velocity comparison','Units','Normalized','OuterPosition', [0 0 1 1] );
plot( time( 1 : length( Yk ) ), -Yk( 2, : ), 'k-' );  title( 'Arm angular velocity' ); ylabel('Angular displacement [rad]'); hold on; grid on; grid minor;
plot( time( 1 : length(Yk)), velocityArm( 1 : length( Yk ), 5 ), 'r' );
legend('State-Space Model', 'wecSim Arm-position ')


% %   NOTE: sign for arm angular position and velocity from the state space
% formulation are opposite the sign of wecSim results.

%%

figure('Name','WecSim wave vs wecSim Arm position comparison','Units','Normalized','OuterPosition', [0 0 1 1] );
kf = 2000;
yyaxis left
plot( time( 1 : kf ), output.wave.elevation( 1 : kf), 'k-' );  
title( 'Wave Elevation and arm displacement along time' ); 
ylabel('wave elevation [m]'); hold on; grid on; grid minor;
ylim([-0.04 0.04])

yyaxis right
plot( time( 1 : kf), positionArm( 1 : kf, 5 ) - 0.0118162, 'r' );
ylabel('Arm position [rad]')
ylim([-0.2 0.2])
legend('wave elevation', 'Arm-position ')

%%
 
%%%   To save to the important information from each sea state
%     From 1 to 6
noWave=struct();
noWave.time=output.wave.time;
noWave.elevation=output.wave.elevation;
noWave.Tp=waves.T;
noWave.Hm0=waves.H;
noWave.gamma=waves.gamma;
noWave.exM=exM;

% Kinematics
noWave.buoyposition = ( output.bodies( 1 ).position.' - [ body(1).cg; 0; 0; 0 ] );
noWave.buoyvelocity = output.bodies( 1 ).velocity;
noWave.buoyacceleration = output.bodies( 1 ).acceleration;
noWave.positionArm = output.bodies( 2 ).position;
noWave.positionArm(:,5) = noWave.positionArm(:,5) - 0.0118162;
noWave.velocityArm = output.bodies( 2 ).velocity;
noWave.accelerationArm = output.bodies( 2 ).acceleration;

%Moments
noWave.forceTotal = output.bodies( 1 ).forceTotal;
noWave.forceExcitation = output.bodies( 1 ).forceExcitation;
noWave.forceRadiationDamping = output.bodies( 1 ).forceRadiationDamping;
noWave.forceAddedMass = output.bodies( 1 ).forceAddedMass;
noWave.forceRestoring = output.bodies( 1 ).forceRestoring;
noWave.forceLinearDamping = output.bodies( 1 ).forceLinearDamping;
noWave.ptoM = output.ptos.forceActuation( :, 3 );
figure
plot(noWave.time,noWave.positionArm(:,5))
%Save results
save('noWave.mat','noWave','-mat')


% wave = [output.wave.time, output.wave.elevation];
% save('wave6.mat','wave','-mat')
