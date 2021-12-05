close all; clc;
time = output.bodies( 1 ).time;
positionArm = output.bodies( 2 ).position;
velocityArm = output.bodies( 2 ).velocity;
figure
title('motor pos rot and Arm position along time')
yyaxis left
plot(motor_pos_rot.time, motor_pos_rot.signals.values)
ylim([-0.4 0.4])
yyaxis right
plot(time,positionArm(:,5))
ylim([-0.4 0.4])
legend('motor pos rot','Arm position')

figure
title('motor vel rot and Arm velocity along time')
yyaxis left
plot(motor_vel_rot.time, motor_vel_rot.signals.values)
ylim([-1 1])
yyaxis right
plot(time,velocityArm(:,5))
ylim([-1 1])
legend('motor pos rot','Arm position')

%%
figure
plot(Output_power.time, Output_power.signals.values)
figure
plot(time,velocityArm(:,5))
plot(Output_energy.time, Output_energy.signals.values)
