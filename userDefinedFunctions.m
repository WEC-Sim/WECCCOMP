%% Script for plotting response and calculating power
close all
clear power power_eff

%% Plot waves
waves.plotEta(simu.rampTime);
hold on
plot([25 25],[1.5*min(waves.waveAmpTime(:,2)),1.5*max(waves.waveAmpTime(:,2))])
legend('\eta','rampTime','powerCalcTime')
try 
    waves.plotSpectrum();
catch
end
xlim([0 inf])

%% Plot RY response for Float
output.plotResponse(1,5);   
xlim([0 inf])

%% Plot RY forces for Float
plotForces(output,1,5)
xlim([0 inf])

%% Calculate and Plot Power 
figure('Name','Extracted "raw" Energy Power','Units','Normalized','OuterPosition', [0 0 1 1] );
plot(Output_energy.time,-Output_energy.signals.values,'k-');  hold on;   grid on;    grid minor;  box on;
xlabel('Time (s)')
ylabel('Energy (J)')

figure('Name','Output Power','Units','Normalized','OuterPosition', [0 0 1 1] );
plot(Output_power.time,-Output_power.signals.values,'k-');  hold on;   grid on;    grid minor;  box on;
xlim([25 inf])
xlabel('Time (s)')
ylabel('Power (W)')
title(['body' num2str(1) ' (' output.bodies(1).name ') Power'])


%% Calculate Evaluation Criteria (EC)
% % % % pto_force = output.ptos.forceInternalMechanics(ii:end,3);
% % % % pto_displacement = output.ptos.position(ii:end,3);
% % % % 
% % % % % f_98 = prctile(abs(pto_force),98);
% % % % f_max = 60;
% % % % % z_98 = prctile(abs(pto_displacement),98);
% % % % z_max = 0.08;
% % % % power_average = mean(power_eff);
% % % % power_abs_average = mean(abs(power_eff));
% % % % % P98 = prctile(abs(power_eff),98);
% % % % 
% % % % % EC = power_average/(2 + f_98/f_max + z_98/z_max - power_abs_average/P98);

%% Plot Excitation moment, Arm Position and Arm Velocity using wecSim-calculation and KF-estimation
figure('Name','Excitation moment using wecSim-calculation and KF-estimation','Units','Normalized','OuterPosition', [0 0 1 1] );
plot(computedExMoment.time,computedExMoment.signals.values,'k-');  hold on;   grid on;    grid minor;  box on;
estimated_exMoment = squeeze(estimated_states.signals.values(5,1,:));
plot(estimated_states.time,estimated_exMoment, 'r.')


figure('Name','Arm Position using wecSim-calculation and KF-estimation','Units','Normalized','OuterPosition', [0 0 1 1] );
plot(motor_pos_rot.time,motor_pos_rot.signals.values,'k-');  hold on;   grid on;    grid minor;  box on;
estimated_armposition = squeeze(estimated_states.signals.values(1,1,:));
plot(estimated_states.time,estimated_armposition, 'r.')


figure('Name','Arm Velocity using wecSim-calculation and KF-estimation','Units','Normalized','OuterPosition', [0 0 1 1] );
plot(motor_vel_rot.time,motor_vel_rot.signals.values,'k-');  hold on;   grid on;    grid minor;  box on;
estimated_armvelocity = squeeze(estimated_states.signals.values(2,1,:));
plot(estimated_states.time,estimated_armvelocity, 'r.')


