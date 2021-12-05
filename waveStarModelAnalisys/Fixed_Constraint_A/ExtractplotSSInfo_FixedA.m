clearvars; close all; clc;

%  load('results\Output_noWave.mat')
%  load('results\Output_wave4.mat')
%  load('results\Output_wave5.mat')
  load('results\Output_wave6.mat')
 
time=output.constraints(2).time;
position=output.constraints(2).position;
velocity=output.constraints(2).velocity;
acceleration=output.constraints(2).acceleration;
forces=output.constraints(2).forceConstraint;

fig1=figure();fig1.Name='Positions';
    subplot(3,2,1); plot(time,position(:,1),'k');   title('x');
    subplot(3,2,2); plot(time,position(:,4),'k');   title('Roll');  
    subplot(3,2,3); plot(time,position(:,2),'k');   title('y');  
    subplot(3,2,4); plot(time,position(:,5),'k');   title('Pitch'); 
    subplot(3,2,5); plot(time,position(:,3),'k');   title('z');
    subplot(3,2,6); plot(time,position(:,6),'k');   title('Yaw');
fig2=figure();fig2.Name='Velocities';
    subplot(3,2,1); plot(time,velocity(:,1),'k');   title('x');
    subplot(3,2,2); plot(time,velocity(:,4),'k');   title('Roll');  
    subplot(3,2,3); plot(time,velocity(:,2),'k');   title('y');  
    subplot(3,2,4); plot(time,velocity(:,5),'k');   title('Pitch'); 
    subplot(3,2,5); plot(time,velocity(:,3),'k');   title('z');
    subplot(3,2,6); plot(time,velocity(:,6),'k');   title('Yaw');
fig3=figure();fig3.Name='Accelerations';
    subplot(3,2,1); plot(time,acceleration(:,1),'k');   title('x');
    subplot(3,2,2); plot(time,acceleration(:,4),'k');   title('Roll');  
    subplot(3,2,3); plot(time,acceleration(:,2),'k');   title('y');  
    subplot(3,2,4); plot(time,acceleration(:,5),'k');   title('Pitch'); 
    subplot(3,2,5); plot(time,acceleration(:,3),'k');   title('z');
    subplot(3,2,6); plot(time,acceleration(:,6),'k');   title('Yaw');
fig4=figure();fig4.Name='Forces';
    subplot(3,2,1); plot(time,forces(:,1),'k');   title('x');
    subplot(3,2,2); plot(time,forces(:,4),'k');   title('Roll');  
    subplot(3,2,3); plot(time,forces(:,2),'k');   title('y');  
    subplot(3,2,4); plot(time,forces(:,5),'k');   title('Pitch'); 
    subplot(3,2,5); plot(time,forces(:,3),'k');   title('z');
    subplot(3,2,6); plot(time,forces(:,6),'k');   title('Yaw');
% MODE is a six-element array of indices, assigned for each body, 
% where I=1,2,3 correspond to the surge, sway and heave translational modes along the body-Axed (x,y,z) axes, 
% and I=4,5,6 to the roll, pitch and yaw rotational modes around the same axes, respectively.
% clear fig1 fig2 fig3 fig4

%% Save sea state information
FA_ss6=struct();

FA_ss6.time=output.wave.time;
FA_ss6.elevation=output.wave.elevation;
FA_ss6.Tp=wave.T;
FA_ss6.Hm0=wave.H;
FA_ss6.gamma=wave.gamma;
FA_ss6.exM=forces(:,5);

% save('SeaStates\seaStates.mat', 'FA_ss1')
% save('SeaStates\seaStates.mat', 'FA_ss2','-append')
% save('SeaStates\seaStates.mat', 'FA_ss3','-append')
% save('SeaStates\seaStates.mat', 'FA_ss4','-append')
% save('SeaStates\seaStates.mat', 'FA_ss5','-append')
% save('SeaStates\seaStates.mat', 'FA_ss6','-append')

% clear all; close all; clc

%% Plot wave elevation and excitation Moment
% close all; clc; clear all; 
load('SeaStates\seaStates.mat');
 
 fig5=figure();fig5.Name='Sea States'; fig5.ToolBar='none'; fig5.Units='Normalized'; fig5.OuterPosition=[0 0 1 1];
    subplot(3,2,1); yyaxis left; plot(ss1.time,ss1.elevation,'k');  ylabel('Wave Elavation [m]'); title('Sea State 1, H02'); hold on;
                               yyaxis right; plot(ss1.time,ss1.exM,'r'); ylabel('Excitation Moment [Nm]')
    subplot(3,2,2); yyaxis left;  plot(ss2.time,ss2.elevation,'k'); ylabel('Wave Elavation [m]'); title('Sea State 2, H02'); hold on;
                               yyaxis right; plot(ss2.time,ss2.exM,'r'); ylabel('Excitation Moment [Nm]')
    subplot(3,2,3); yyaxis left;  plot(ss3.time,ss3.elevation,'k'); ylabel('Wave Elavation [m]');  title('Sea State 3, H06'); hold on;
                               yyaxis right; plot(ss3.time,ss3.exM,'r'); ylabel('Excitation Moment [Nm]')
    subplot(3,2,4); yyaxis left;  plot(ss4.time,ss4.elevation,'k'); ylabel('Wave Elavation [m]'); title('Sea State 4, H06'); hold on;
                               yyaxis right; plot(ss4.time,ss4.exM,'r'); ylabel('Excitation Moment [Nm]')                    
    subplot(3,2,5); yyaxis left;  plot(ss5.time,ss5.elevation,'k'); ylabel('Wave Elavation [m]'); title('Sea State 5, H10'); hold on;
                               yyaxis right; plot(ss5.time,ss5.exM,'r'); ylabel('Excitation Moment [Nm]')
    subplot(3,2,6); yyaxis left;  plot(FA_ss6.time,FA_ss6.elevation,'k'); ylabel('Wave Elavation [m]'); title('Sea State 6, H10'); hold on;
                               yyaxis right; plot(FA_ss6.time,FA_ss6.exM,'r'); ylabel('Excitation Moment [Nm]')                              
% clear fig5

