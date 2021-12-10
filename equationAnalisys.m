% Kinematic values
close all; clc;
time            = output.bodies( 1 ).time;
position        = ( output.bodies( 1 ).position.' - [ body(1).cg; 0; 0; 0 ] );     %zero the position so position vector starts at [0,0,0,0,0,0]
velocity        = output.bodies( 1 ).velocity;
acceleration    = output.bodies( 1 ).acceleration;
positionArm     = output.bodies( 2 ).position;
velocityArm     = output.bodies( 2 ).velocity;
accelerationArm = output.bodies( 2 ).acceleration;
ptoM            = output.ptos.forceActuation( :, 3 );

%   Forces
forceTotal              = output.bodies( 1 ).forceTotal;
forceExcitation         = output.bodies( 1 ).forceExcitation;
forceRadiationDamping   = output.bodies( 1 ).forceRadiationDamping;
forceAddedMass          = output.bodies( 1 ).forceAddedMass;
forceRestoring          = output.bodies( 1 ).forceRestoring;
forceLinearDamping      = output.bodies( 1 ).forceLinearDamping;

kh              = body( 1 ).hydroForce.linearHydroRestCoef( 5, : );
khc             = cross( [ 0, 0, 9.81*1000*body( 1 ).dispVol ], body( 1 ).cb - body( 1 ).cg );
inf_addedMass   = body( 1 ).hydroForce.fAddedMass( 5, : );
linearDamping   = body( 1 ).hydroForce.linearDamping( 5, : );

 % Plots Comparing Restoring, added mass and linear damping moments
figure('Name','Restoring and Added Mass Moments','Units','Normalized','OuterPosition', [0 0 1 1] );
subplot( 3, 1, 1 );     plot( time, forceRestoring( :, 5 ), 'k' );      hold on;         grid on;        grid minor;        box on;
                        plot( time, kh*position + khc( 2 ), '--r' );    title('Restoring moment');xlabel('time [s]');ylabel('Restoring moment [Nm]'); 
subplot( 3, 1, 2 );     plot( time, forceAddedMass( :, 5 ), 'k' );      hold on;         grid on;        grid minor;        box on;
                        plot( time, inf_addedMass*acceleration', '--r' );    title('Added Mass moment');    xlabel('time [s]');     ylabel('Added Mass moment [Nm]');
subplot( 3, 1, 3 );     plot( time, forceLinearDamping( :, 5 ), 'k' );      hold on;         grid on;        grid minor;        box on;
                        plot( time, linearDamping*velocity', '--r' );    title('Linear Damping moment');      xlabel('time [s]');     ylabel('Linear Damping moment [Nm]');

% WecSim wave elevation vs wecSim Arm position comparison
figure('Name','WecSim wave vs wecSim Arm position comparison','Units','Normalized','OuterPosition', [0 0 1 1] );
ti          = find(time==0);
tf          = find(time==25);
yyaxis left
plot( time( ti : tf ), output.wave.elevation( ti : tf), 'k-' );  
title( 'Wave Elevation and arm displacement along time' ); 
ylabel('wave elevation [m]'); hold on; grid on; grid minor;
ylim([-0.10 0.10])

yyaxis right
plot( time( ti : tf), positionArm( ti : tf, 5 ) - 0.0118162, 'r' );
ylabel('Arm position [rad]')
ylim([-0.2 0.2])
legend('wave elevation', 'Arm-position ')