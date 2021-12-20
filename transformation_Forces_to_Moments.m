%% Transformation of the excitation, radiation and restoring Force to its respective moments around
% the pivot point A
% Mexc= -excForce_x * LAfloat * sin( actualPosition + initialPosition ) - excForce_z * LAfloat * cos( actualPosition + initialPosition ) + excM,pitch
% Mrad= -radForce_x * LAfloat * sin( actualPosition + initialPosition ) - radForce_z * LAfloat * cos( actualPosition + initialPosition ) + radM,pitch
% Mres= -resForce_x * LAfloat * sin( actualPosition + initialPosition ) - resForce_z * LAfloat * cos( actualPosition + initialPosition ) + resM,pitch
close all; clc;
controller_init();
load('./waveData/WaveStar_SS4_noControl.mat')
timePlot        = output.bodies( 1 ).time;
dt              = mean(diff(timePlot));                %Sampling time
positionArm     = output.bodies( 2 ).position;
velocityArm     = output.bodies( 2 ).velocity;
accelerationArm = output.bodies( 2 ).acceleration;
% excM = computedExMoment.signals.values;
ti          = find(output.wave.time==30);
tf          = find(output.wave.time==35);

% Kinematics
theta   = output.bodies( 2 ).position( :, 5 );
Dtheta  = output.bodies( 2 ).velocity( :, 5 );

% Kinetics
% Excitation forces
xFexc       = output.bodies( 1 ).forceExcitation( :, 1 );
zFexc       = output.bodies( 1 ).forceExcitation( :, 3 );
pitchMexc   = output.bodies( 1 ).forceExcitation( :, 5 );

% Radiation damping forces
xFrad       = output.bodies( 1 ).forceRadiationDamping( :, 1 );
zFrad       = output.bodies( 1 ).forceRadiationDamping( :, 3 );
pitchMrad   = output.bodies( 1 ).forceRadiationDamping( :, 5 );

% Restoring forces
xFres       = output.bodies( 1 ).forceRestoring( :, 1 );
zFres       = output.bodies( 1 ).forceRestoring( :, 3 );
pitchMres   = output.bodies( 1 ).forceRestoring( :, 5 );

% Moments around pivot point A
excM = -xFexc .* LAfloat .* sin( Theta0 + theta ) - zFexc .* LAfloat .* cos( Theta0 + theta ) + pitchMexc ;  % Excitation moment
radM = -xFrad .* LAfloat .* sin( Theta0 + theta ) - zFrad .* LAfloat .* cos( Theta0 + theta ) + pitchMrad ;   % Radiation damping moment
resM = -xFres .* LAfloat .* sin( Theta0 + theta ) - zFres .* LAfloat .* cos( Theta0 + theta ) + pitchMres ;   % Restoring moment

time = timePlot;
% save('Moments4.mat',"time","dt","theta","Dtheta","excM","radM","resM",'-mat')
timePlot = time;
% Plots
plotforces = 0;
if plotforces == 1
figure('Name','Excitation forces and Moment','Units','Normalized','OuterPosition', [0 0 1 1] );
        subplot(5,1,1);     plot(timePlot(ti:tf),xFexc(ti:tf),'k');      
                            title('X-excForce');   ylabel('[N]');   grid on;    grid minor;  box on;
                            ylim([-1.2*max(max(xFexc), abs(min(xFexc))) 1.2*max(max(xFexc), abs(min(xFexc)))]);
        subplot(5,1,2);     plot(timePlot(ti:tf),zFexc(ti:tf),'k');      
                            title('Z-excForce');   ylabel('[N]');   grid on;    grid minor;   box on;
                            ylim([-1.2*max(max(zFexc), abs(min(zFexc))) 1.2*max(max(zFexc), abs(min(zFexc)))]);
        subplot(5,1,3);     plot(timePlot(ti:tf),pitchMexc(ti:tf),'k');  
                            title('Pitch-excMoment');     ylabel('[Nm]');     grid on;    grid minor;     box on;
                            ylim([-1.2*max(max(pitchMexc), abs(min(pitchMexc))) 1.2*max(max(pitchMexc), abs(min(pitchMexc)))]);
        subplot(5,1,4);     plot(timePlot(ti:tf),excM(ti:tf),'k');    
                            title('A-excMoment');         ylabel('[Nm]');     grid on;    grid minor;     box on;
                             ylim([-1.2*max(max(excM), abs(min(excM))) 1.2*max(max(excM), abs(min(excM)))]);
        subplot(5,1,5);     yyaxis left;  plot( timePlot(ti:tf), output.wave.elevation(ti:tf), 'k', 'LineWidth',2 );
                            xlabel('time [s]');  ylabel('[m]');     grid on;    grid minor;     box on;
                            ylim([-1.2*max(output.wave.elevation) 1.2*max(output.wave.elevation)]);
                            yyaxis right; plot( timePlot(ti:tf), theta(ti:tf), 'b' );     ylabel('[rad]');
                            ylim([-1.2*max(max(theta), abs(min(theta))) 1.2*max(max(theta), abs(min(theta)))]);
                            legend('Wave elevation','Arm position - theta')
figure('Name','Radiation dampins forces and Moment','Units','Normalized','OuterPosition', [0 0 1 1] );
        subplot(5,1,1);     plot(timePlot(ti:tf),xFrad(ti:tf),'k');      
                            title('X-radForce');   ylabel('[N]');   grid on;    grid minor;  box on;
                            ylim([-1.2*max(max(xFrad), abs(min(xFrad))) 1.2*max(max(xFrad), abs(min(xFrad)))]);
        subplot(5,1,2);     plot(timePlot(ti:tf),zFrad(ti:tf),'k');      
                            title('Z-radForce');   ylabel('[N]');   grid on;    grid minor;   box on;
                            ylim([-1.2*max(max(zFrad), abs(min(zFrad))) 1.2*max(max(zFrad), abs(min(zFrad)))]);
        subplot(5,1,3);     plot(timePlot(ti:tf),pitchMrad(ti:tf),'k');  
                            title('Pitch-radMoment');     ylabel('[Nm]');     grid on;    grid minor;     box on;
                            ylim([-1.2*max(max(pitchMrad), abs(min(pitchMrad))) 1.2*max(max(pitchMrad), abs(min(pitchMrad)))]);
        subplot(5,1,4);     plot(timePlot(ti:tf),radM(ti:tf),'k');    
                            title('A-radMoment');         ylabel('[Nm]');     grid on;    grid minor;     box on;
                             ylim([-1.2*max(max(radM), abs(min(radM))) 1.2*max(max(radM), abs(min(radM)))]);
        subplot(5,1,5);     yyaxis left;  plot( timePlot(ti:tf), output.wave.elevation(ti:tf), 'k', 'LineWidth',2 );
                            xlabel('time [s]');  ylabel('[m]');     grid on;    grid minor;     box on;
                            ylim([-1.2*max(output.wave.elevation) 1.2*max(output.wave.elevation)]);
                            yyaxis right; plot( timePlot(ti:tf), theta(ti:tf), 'b' );     ylabel('[rad]');
                            ylim([-1.2*max(max(theta), abs(min(theta))) 1.2*max(max(theta), abs(min(theta)))]);
                            legend('Wave elevation','Arm position - theta')
figure('Name','Restoring forces and Moment','Units','Normalized','OuterPosition', [0 0 1 1] );
        subplot(5,1,1);     plot(timePlot(ti:tf),xFres(ti:tf),'k');      
                            title('X-resForce');   ylabel('[N]');   grid on;    grid minor;  box on;
                            ylim([-1.2*max(resM) 1.2*max(resM)]);
        subplot(5,1,2);     plot(timePlot(ti:tf),zFres(ti:tf),'k');      
                            title('Z-resForce');   ylabel('[N]');   grid on;    grid minor;   box on;
                            ylim([-1.2*max(max(zFres), abs(min(zFres))) 1.2*max(max(zFres), abs(min(zFres)))]);
        subplot(5,1,3);     plot(timePlot(ti:tf),pitchMres(ti:tf),'k');  
                            title('Pitch-resMoment');     ylabel('[Nm]');     grid on;    grid minor;     box on;
                            ylim([-1.2*max(max(pitchMres), abs(min(pitchMres))) 1.2*max(max(pitchMres), abs(min(pitchMres)))]);
        subplot(5,1,4);     plot(timePlot(ti:tf),resM(ti:tf),'k');    
                            title('A-resMoment');         ylabel('[Nm]');     grid on;    grid minor;     box on;
                             ylim([-1.2*max(max(resM), abs(min(resM))) 1.2*max(max(resM), abs(min(resM)))]);
        subplot(5,1,5);     yyaxis left;  plot( timePlot(ti:tf), output.wave.elevation(ti:tf), 'k', 'LineWidth',2 );
                            xlabel('time [s]');  ylabel('[m]');     grid on;    grid minor;     box on;
                            ylim([-1.2*max(output.wave.elevation) 1.2*max(output.wave.elevation)]);
                            yyaxis right; plot( timePlot(ti:tf), theta(ti:tf), 'b' );     ylabel('[rad]');
                            ylim([-1.2*max(max(theta), abs(min(theta))) 1.2*max(max(theta), abs(min(theta)))]);
                            legend('Wave elevation','Arm position - theta')
end