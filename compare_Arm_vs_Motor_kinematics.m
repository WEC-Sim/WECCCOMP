% This file compares the motor rotational position with the angular
% position of the Arm. it does the same for the velocity.
close all; clc;
load('./output/WaveStar_matlabWorkspace.mat')
time = output.bodies( 1 ).time;
positionArm = output.bodies( 2 ).position;
velocityArm = output.bodies( 2 ).velocity;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure; title('Motor rot. position and Arm angular position along time')
yyaxis left
            plot(motor_pos_rot.time, motor_pos_rot.signals.values)
            ylabel('Pos. [rad]')
            ymax = max(max(motor_pos_rot.signals.values), abs(min(motor_pos_rot.signals.values)));
            ylim([-1.2*ymax 1.2*ymax]);
yyaxis right
            plot(time,positionArm(:,5))
            xlabel('Time [s]')
            ylabel('Pos. [rad]')
            ymax = max(max(positionArm(:,5)), abs(min(positionArm(:,5))));
            ylim([-1.2*ymax 1.2*ymax]);
legend('motor pos rot','Arm position', 'Location','best')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure; title('Motor rot. velocity and Arm angular velocity along time')
yyaxis left
            plot(motor_vel_rot.time, motor_vel_rot.signals.values)
            ylabel('Vel. [rad/s]')
            ymax = max(max(motor_vel_rot.signals.values), abs(min(motor_vel_rot.signals.values)));
            ylim([-1.2*ymax 1.2*ymax]);
yyaxis right
            plot(time,velocityArm(:,5))
            xlabel('Time [s]')
            ylabel('Vel. [rad/s]')
            ymax = max(max(velocityArm(:,5)), abs(min(velocityArm(:,5))));
            ylim([-1.2*ymax 1.2*ymax]);
legend('motor vel rot','Arm velocity','Location','best')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure; 
plot(motorlinear_po.time, motorlinear_po.signals.values(:,3));title('Motor linear displacement');
xlabel('Time [s]')
ylabel('Displacement [m]')
Motor_disp =  max(motorlinear_po.signals.values(:,3)) - min(motorlinear_po.signals.values(:,3));
txt = ['Motor displacement = ',num2str(Motor_disp),' [m]'];
ymax = max(max( motorlinear_po.signals.values(:,3) ), abs(min( motorlinear_po.signals.values(:,3) )));
ylim([-1.2*ymax 1.2*ymax]);
text(20, 0 ,txt,'Color','red','FontSize',14)

