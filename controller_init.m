% init file for the WecSim model of the Wavestart arm

mc = 0;
cc = 100e6;
kc = 0;

McSat = inf;
xPcTs = 0.001;

a_CAB_neutral = 1.2925; %1.170165; % Measurements 2015-04-16
L_AB = 17; %0.412;
L_AC = 7.2801;%0.2;
L_BC_neutral = 16.5529; % 0.381408;
r_Acc = 0.464; % "Moment arm" for accelerometer


Theta0 = 23.4881/180*pi;        % Inclination of accelerometer at neutral (rad)
grav = 9.82;
AccCalib  = grav./(951.4/1000);
Acc0      = 3.5523; % Voltage at zero (horizontal arm and accelerometers)


fix = 30;
LPfreq.vel = fix; % Low Pass cut off freq in Hz
HPfreq.vel = fix; % High pass cut off freq in velocity filter (Hz)