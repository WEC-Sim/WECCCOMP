% init file for the WecSim model of the Wavestart arm
close all; clc;
clear observer_kf ; %To clear the persistent variables defined in the function observer_kf
clear extrPower ;   %To clear the persistent variables defined in the function extrPower
clear RTI_NMPC;     %To clear the persistent variables defined in the function RTI_NMPC
clear Simu_Linearise
McSat = 12;
if exist("simu.dt","var")
    xPcTs = simu.dt;
    dt    = simu.dt;
else
    dt    =  10/1000;
    xPcTs = dt;
end
%%
%%%%% Model Parameters to build the Continous Matrices Ac, Bc and Cc for the Anaylisis of the WEC System
a_CAB_neutral   = 1.170165;               % Angle CAB at equilibrium position
L_AB            = 0.412;                  % Distance AB [m]
L_AC            = 0.2;                    % Distance AC [m]
L_BC_neutral    = 0.381408;               % Distance CB at equilibrium position [m]
LAfloat         = 0.54875;                % Distance from pivot point A to the Cg of the float [m]
J               = 1.04;                   % Inertia of arm and float [kg m^2]
Jinf            = 0.4805;                 % Added inertia [kg m^2]
Jt              = J + Jinf;               % Total inertia [kg m^2]
Khs             = 92.33;                  % Hydrostatic stiffness coefficient [Nm rad^-1]
bv              = 1.8;                    % Linear damping coefficient [N m (rad/s)^-1]
%%%%%%%% State Space Matrices for the Linear system %%%%%%%%%%%%%%%%%%%%%%%
% load('radM_matrices42.mat')                 % Load state-space model matrices for the radiation moment around point A.
% load('radM_matrices52.mat')                 % Load state-space model matrices for the radiation moment around point A.
% load('radM_matrices62.mat')                 % Load state-space model matrices for the radiation moment around point A.
load('radM_matrices_WECCCOMP.mat')                 % Load state-space model matrices for the radiation moment around point A.

nx_radM = size(Ar,2);

Ac      = [0,                1,             zeros(1,nx_radM);
           -Khs./Jt,          -(Dr+bv)./Jt,  -Cr./Jt;
           zeros(nx_radM,1),  Br,            Ar];      
nx      = size(Ac,1);
Bc      = [ 0; 1/Jt; zeros(nx_radM,1) ];                                                                                                                      
Cc      = [1,zeros(1, nx - 1);
           0,1,zeros(1, nx - 2)];
Dc      = zeros(size(Cc,1),size(Bc,2));
sysC    = ss(Ac,Bc,Cc,Dc);                  %Declares Continuous State Space
sysD    = c2d(sysC,dt,'zoh');               %Declares discrete State Space
% WEC discrete Model System
Ad      = sysD.A;                           %Discrete State Transition Matrix
Bd      = sysD.B;                           %Discrete Input To State Matrix
Cd      = sysD.C;                           %Discrete Output Matrix
Dd      = sysD.D;                           %Discreete Input To Output Matrix
nx      = size(Ad,1);                       %Number of States  
nu      = size(Bd,2);                       %Number of Inputs  
ny      = size(Cd,1);                       %Number of Outputs

clear Ac Bc Cc Dc sysC sysD

r_Acc   = 0.464;                            % "Moment arm" for accelerometer
Theta0  = deg2rad(26.9527);                 % Inclination of accelerometer at neutral [rad], 23.4881deg used in WECCCOMP
grav    = 9.80665;                          % Standard acceleration due to gravity [m s^-2]
AccCalib= grav./(951.4/1000);
Acc0    = 3.5523;                           % Voltage at zero (horizontal arm and accelerometers)
fix     = 30;                               % Frequency [Hz]
LPfreq.vel = fix;                           % Low Pass cut off freq in velocity filter [Hz]
HPfreq.vel = fix;                           % High pass cut off freq in velocity filter [Hz]

%%%%%%%%%% Kalman filter information    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% covariance of process Q
Qp      = 5e-6;                             % Variance for the arm position
Qv      = 5e-6;                             % Variance for the arm velocity
QradM   = 5e-6*eye(nx_radM);                % Variance for the radiation internal states
QexcM      = 0.35;                              % Variance for the excitation moment
Qkf     = blkdiag( Qp, Qv, QradM, QexcM );     % Covariance of process Q for the Kalman filter
q       = chol(Qkf,'lower');                
% covariance of measurement  R
Rp      = 6e-6;
Rv      = 6e-6;
Rkf     = blkdiag( Rp, Rv );
r       = chol( Rkf, 'lower' );

%%%%%%%%%%% Controller information    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Resistive controller ===> Proportional to the arm angular velocity.
switch(SeaState)
    case 4 ;        cc = 5.30;
    case 5 ;        cc = 10.50;   % Proportial gain for sea state 5 that offers the maximum energy extracted = 18.2770
    case 6 ;        cc = 16.70;    % Proportial gain for sea state 6 that offers the maximum energy extracted = 55.1943 
    otherwise;      cc = 0;
end 
Np  = 100;
qnl = [ 0, 1;
        1, 0 ];
r_ctrl  = 0.9;               % input penalisation
R_ctrl  = r_ctrl*eye( Np*nu );

% Constraints
Umax    = 12;    %Input Constraints
Umin    = -Umax;

% Efficiency Parameters, approximation using tanh:
% St = offset_eff + scaler_eff*tanh( alpha_eff*u.*v );
eta_generator   = 0.7;
eta_motoring    = 1 / 0.7;
scaler_eff      = 1*( eta_motoring - eta_generator ) / 2;   
offset_eff      = ( eta_motoring + eta_generator ) / 2;
alpha_efft      = 1000;



%%%%%%%%%%%  Select Information to plot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    1 = Plot; 0 = No plot
plotPTO                 = 0; 
plotConstraints         = 0;
plotBodyPosition        = 0;
plotFloatForces         = 0;
plotPosWaveForceFloat   = 0;      % Plot Float Motion Analysis

%%%%%%%%%%%  Clear Variables %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear Ac Bc Cc Dc sysC sysD Qp Qv QradM QexcM Rp Rv

