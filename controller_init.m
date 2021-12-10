% init file for the WecSim model of the Wavestart arm

McSat = 12;
xPcTs = 0.01;
%%%%%%% Model Parameters to build the Continous Matrices Ac, Bc and Cc for the Anaylisis of the WEC System
a_CAB_neutral = 1.170165;               % Angle CAB at equilibrium position
L_AB = 0.412;                           % Distance AB [m]
L_AC = 0.2;                             % Distance AC [m]
L_BC_neutral = 0.381408;                % Distance CB at equilibrium position [m]
LAfloat = 0.54875;                      % Distance from pivot point A to the Cg of the float [m]
J = 1.04;                               % Inertia of arm and float [kg m^2]
Jinf = 0.4805;                          % Added inertia [kg m^2]
Jt = J+Jinf;                            % Total inertia [kg m^2]
Khs = 92.33;                            % Hydrostatic stiffness coefficient [Nm rad^-1]
bv=1.8;                                 % Linear damping coefficient [N m (rad/s)^-1]
Ar = [-13.59,-13.35;8.0,0];             % State matrix for the radiation Moment impulse response realisation
Br=[8.0;0];                             % Input matrix for the radiation Moment impulse response realisation
Cr=[4.739,0.5];                         % Output matrix for the radiation Moment impulse response realisation
Dr=-0.1586;                             % Feedforward matrix for the radiation Moment impulse response realisation

r_Acc = 0.464;                          % "Moment arm" for accelerometer
Theta0 = deg2rad(26.9527);              % Inclination of accelerometer at neutral [rad], 23.4881deg used in WECCCOMP
grav = 9.80665;                         % Standard acceleration due to gravity [m s^-2]
AccCalib  = grav./(951.4/1000);
Acc0      = 3.5523;                     % Voltage at zero (horizontal arm and accelerometers)
fix = 30;                               % Frequency [Hz]
LPfreq.vel = fix;                       % Low Pass cut off freq in velocity filter [Hz]
HPfreq.vel = fix;                       % High pass cut off freq in velocity filter [Hz]

%%%%%% Kalman filter information
load('simulationData\stateSpaceMatrices.mat')
% covariance of process Q
Qp   =    5e-6;                           % Variance for the arm position
Qv =    5e-6;                              % Variance for the arm velocity
Qr1 =    5e-6;                            % Variance for the radiation internal state 1
Qr2 =    5e-6;                            % Variance for the radiation internal state 2
Qw  =   0.1;                              % Variance for the excitation moment
Qkf = blkdiag( Qp, Qv, Qr1, Qr2, Qw );
q = chol(Qkf,'lower');         
% covariance of measurement  R
Rp = 6e-6;
Rv = 6e-6;
Rkf = blkdiag( Rp, Rv );
r = chol( Rkf, 'lower' );

%%%%%%  Controller information 
% Resistive controller ===> Proportional to the arm angular velocity.
% cc = 16.70; 
cc = 0;

%%%%%%%  Select Information to plot %%%%%%%%%%%%%%
%    1 = Plot; 0 = No plot
plotPTO = 0; 
plotConstraints = 0;
plotBodyPosition = 0;
plotFloatForces = 0;
plotPosWaveForceFloat = 0;      % Plot Float Motion Analysis
