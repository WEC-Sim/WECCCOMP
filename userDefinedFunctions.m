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

ii = find(Output_power.time==0);   
t = Output_power.time;
t_end = round( t( end ) / 5 )*5;
p = Output_power.signals.values;
energy_gen = Output_energy.signals.values;
mp = mean( p( ii : end ) );
mp_s = num2str( mp );
E_extr = num2str( energy_gen(end) );
min_power = min(p);
max_power = max(p);

switch(controllerType)
    case 1
        txtEnergy = [ ' Resistive, ','  prop gain = ', num2str(prop_gain), '   SS = ', num2str(SeaState),'  Energy Extracted = ',  E_extr, ' J'];
        txtPower = [ 'Resistive  ', 'Mean Power = ', mp_s, ' w,','  Energy Extracted = ',  E_extr, ' J'];
    case 2
        txtEnergy = [ ' NMPC, Np = ', num2str(Np), '      SS = ', num2str(SeaState),'  Energy Extracted = ',  E_extr, ' J'];
        txtPower = [ ' NMPC ', '   Mean Power = ', mp_s, ' w,','  Energy Extracted = ',  E_extr, ' J'];
end 


fig1=figure('Name','Energy and Power','Units','Normalized','OuterPosition',[0 0 1 1],'DefaultAxesFontSize',14);
subplot(2,1,1);
        plot(t, energy_gen,'k-','LineWidth',1);  hold on;   grid on;    grid minor;  box on;
        xlabel('Time [s]')
        ylabel('Energy [J]')
        su1 = title( txtEnergy );    su1.FontSize = 16;    set(gca, 'LooseInset', [0,0,0,0]);  
subplot(2,1,2)
    plot( t, p,'-b','LineWidth',1); hold on; grid on; 
    plot( [ 0, t( end ) ], mp*[ 1, 1 ], 'r--', 'LineWidth', 2 ); hold on;  
    xlabel('Time [s]')
    ylabel( 'Power [w]' ); 
    su2 = title( txtPower );    su2.FontSize = 16;    set(gca, 'LooseInset', [0,0,0,0]);   
    

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
% figure('Name','Excitation moment using wecSim-calculation and KF-estimation','Units','Normalized','OuterPosition', [0 0 1 1] );
% plot(computedExMoment.time,computedExMoment.signals.values,'k-');  hold on;   grid on;    grid minor;  box on;
% estimated_exMoment = squeeze(estimated_states.signals.values(5,1,:));
% plot(estimated_states.time,estimated_exMoment, 'r--')
% legend('Computed', 'Estimated')
% excitationWave_GoF = goodnessOfFit(computedExMoment.signals.values,estimated_exMoment,'NRMSE')
% txt = ['excitation moment GoF = ',num2str(excitationWave_GoF)];
% text(20, -15 ,txt,'Color','red','FontSize',14)
% 
% 
% figure('Name','Arm Position using wecSim-calculation and KF-estimation','Units','Normalized','OuterPosition', [0 0 1 1] );
% plot(motor_pos_rot.time,motor_pos_rot.signals.values,'k-');  hold on;   grid on;    grid minor;  box on;
% estimated_armposition = squeeze(estimated_states.signals.values(1,1,:));
% plot(estimated_states.time,estimated_armposition, 'r--')
% legend('Computed', 'Estimated')
% armPosition_GoF = goodnessOfFit(motor_pos_rot.signals.values,estimated_armposition,'NRMSE')
% txt = ['Arm position GoF = ',num2str(armPosition_GoF)];
% text(20, -0.1 ,txt,'Color','red','FontSize',14)
% 
% figure('Name','Arm Velocity using wecSim-calculation and KF-estimation','Units','Normalized','OuterPosition', [0 0 1 1] );
% plot(motor_vel_rot.time,motor_vel_rot.signals.values,'k-');  hold on;   grid on;    grid minor;  box on;
% estimated_armvelocity = squeeze(estimated_states.signals.values(2,1,:));
% plot(estimated_states.time,estimated_armvelocity, 'r--')
% legend('Computed', 'Estimated')
% armVelocity_GoF = goodnessOfFit(motor_vel_rot.signals.values,estimated_armvelocity,'NRMSE')
% txt = ['Arm position GoF = ',num2str(armVelocity_GoF)];
% text(20, -0.5 ,txt,'Color','red','FontSize',14)
% 
% Output_energy.signals.values(end)
% prop_gain