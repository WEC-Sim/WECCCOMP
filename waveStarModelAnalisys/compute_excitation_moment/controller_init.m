% init file for the WecSim model of the Wavestart arm

mc = 0;     %Proportional to the acceleration
cc = 0;     %Proportional to velocitty
kc = 0;     %Proportional to position

McSat = inf;
xPcTs = 0.100;

a_CAB_neutral = 1.170165;
L_AB = 0.412; 
L_AC = 0.2;
L_BC_neutral = 0.381408;
r_Acc = 0.464; % "Moment arm" for accelerometer

Theta0 = 23.4881/180*pi;        % Inclination of accelerometer at neutral (rad)
grav = 9.81;
AccCalib  = grav./(951.4/1000);
Acc0      = 3.5523; % Voltage at zero (horizontal arm and accelerometers)

fix = 10;
LPfreq.vel = fix; % Low Pass cut off freq in Hz
HPfreq.vel = fix; % High pass cut off freq in velocity filter (Hz)
