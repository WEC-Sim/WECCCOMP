% init file for the WecSim model of the Wavestart arm

McSat = 12;
xPcTs = 0.01;

a_CAB_neutral = 1.170165;
L_AB = 0.412; 
L_AC = 0.2;
L_BC_neutral = 0.381408;
Larm = 0.54875;

r_Acc = 0.464; % "Moment arm" for accelerometer

Theta0 = 23.4881/180*pi;        % Inclination of accelerometer at neutral (rad)
grav = 9.82;
AccCalib  = grav./(951.4/1000);
Acc0      = 3.5523; % Voltage at zero (horizontal arm and accelerometers)

fix = 30;
LPfreq.vel = fix; % Low Pass cut off freq in Hz
HPfreq.vel = fix; % High pass cut off freq in velocity filter (Hz)


%%%%%% Kalman filter information
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

load('simulationData\stateSpaceMatrices.mat')