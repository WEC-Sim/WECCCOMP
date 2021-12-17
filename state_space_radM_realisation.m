%% % Compute radiation force using state space
% Ar = [-13.59,-13.35;8.0,0]; Br=[8.0;0]; Cr=[4.739,0.5]; Dr=-0.1586;
close all; clc;
load('Data_Syst_Ident_radMoment.mat')
ti = find(time==0);
tf = find(time==60);
% Select the sea state data
inpV    = Dtheta4;
radmom  = radM4;
% Select the state space realisation
Ar = ss4_nx2.A;             % State matrix for the radiation Moment impulse response realisation
Br = ss4_nx2.B;             % Input matrix for the radiation Moment impulse response realisation
Cr = ss4_nx2.C;             % Output matrix for the radiation Moment impulse response realisation
Dr = ss4_nx2.D;             % Feedforward matrix for the radiation Moment impulse response realisation

%%% Uncomment to save the matrices selected for the radiation moment
%%% realisation:
save('radM_matrices42.mat',"Ar","Br","Cr","Dr",'-mat')
sysC    = ss(Ar,Br,Cr,Dr);          
sysD    = c2d(sysC,dt,'zoh');
radM_SS = lsim(sysD,inpV,time);

figure('Name','Normalised excitation moment and wave elevation','Units','Normalized','OuterPosition', [0 0 1 1] );
        plot( time(ti:tf), radmom(ti:tf), 'k'  );  hold on;   grid on;    grid minor;  box on;
        plot( time(ti:tf), radM_SS(ti:tf), 'b' );  hold on;   grid on;    grid minor;  box on;
        ylim([-1.5*max(radmom) 1.2*max(radmom)])
        legend('radM-wecsim', 'radM-SS','Location', 'best')

% fit6_ss6_nx5 = 
goodnessOfFit(radmom,radM_SS,'NRMSE') 
