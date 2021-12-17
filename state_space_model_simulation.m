%% Simulation of the waveStar using the state space model
close all; clc;
load('./output/WaveStar_matlabWorkspace.mat')
controller_init();
dt=mean(diff(output.wave.time));                %Sampling time
time            = output.bodies( 1 ).time;
positionArm     = output.bodies( 2 ).position;
velocityArm     = output.bodies( 2 ).velocity;
accelerationArm = output.bodies( 2 ).acceleration;
excM = computedExMoment.signals.values;

%%%%%% Simulation %%%%%%%%%%%%%%%%%%%%%%%
finalTime = time(end);
kT=round(finalTime/dt);                  %Number of simulation steps
%Preallocation 
Xk=zeros(nx,kT);                    %Matrix to store the state values from the simulation
Uk=zeros(nu,kT);                    %Matrix to store the input values from the simulation
Yk=zeros(ny,kT);                    %Matrix to store the measurement values from the simulation

%Main For Loop
k_ini=1;          %Starting Point of For Loop
   for k=k_ini:kT-1
       Uk(:,k)=0*Xk(2,k);                   %No control      
       %System Simulation
       Xk(:,k+1) = Ad*Xk(:,k) + Bd*Uk(:,k) + Bd*excM(k,1);    %States
       Yk(:,k) = Cd*Xk(:,k);                                    %Outputs
   end
figure('Name','Float Displacement, Velocity and Excitation Moment','Units','Normalized','OuterPosition', [0 0 1 1] );
subplot( 3, 1, 1 );    plot( time( 1 : length( Uk ) ), Xk( 1, : ), 'k-');                                  title('Angular displacement');    ylabel('Angular displacement [rad]');  hold on;  grid on;  grid minor;
subplot( 3, 1, 2 );    plot( time( 1 : length( Uk ) ), Xk( 2, : ), 'k-');                                  title('Angular Velocity');               ylabel('Angular Velocity [rad/s]');         hold on;  grid on;  grid minor;
subplot( 3, 1, 3 );    plot( time( 1 : length( Uk ) ), excM( 1 : length( Uk ), 1 ),'k-');	title('Excitation Moment'); xlabel('Time [s]'); ylabel('Moment [Nm]');  hold on;  grid on;  grid minor;      
      
figure('Name','WecSim vs SS-model Arm position comparison','Units','Normalized','OuterPosition', [0 0 1 1] );
plot( time( 1 : length( Yk ) ), Yk( 1, : ), 'k-' );  title( 'Arm angular displacement' ); ylabel('Angular displacement [rad]'); hold on; grid on; grid minor;
plot( time( 1 : length(Yk)), positionArm( 1 : length( Yk ), 5 ) , 'r' );
legend('State-Space Model', 'wecSim Arm-position ')

figure('Name','WecSim vs SS-model Arm velocity comparison','Units','Normalized','OuterPosition', [0 0 1 1] );
plot( time( 1 : length( Yk ) ), Yk( 2, : ), 'k-' );  title( 'Arm angular velocity' ); ylabel('Angular displacement [rad]'); hold on; grid on; grid minor;
plot( time( 1 : length(Yk)), velocityArm( 1 : length( Yk ), 5 ), 'r' );
legend('State-Space Model', 'wecSim Arm-position ')
