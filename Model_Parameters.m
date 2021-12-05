%%%% Some dimensions of the WEC System %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
L_AB = 0.412;       %[m] 
L_AC = 0.2;       %[m]
L_BC_neutral = 0.381408;       %[m]
Larm = 0.54875;       %[m]

alpha0 = acos((L_BC_neutral^2 - L_AB^2 - L_AC^2)/(-2*L_AC*L_AB));           %alpha0 is the angle CAB, angle at pivot A at equilibrium
beta0  = acos((L_AC^2 - L_AB^2 - L_BC_neutral^2)/(-2*L_AB*L_BC_neutral));   %beta0 is the angle ABC, angle at joint B at equilibrium
phi0   = acos((L_AB^2 - L_AC^2 - L_BC_neutral^2)/(-2*L_AC*L_BC_neutral));   %phi0 is the angle ACB, angle at joint C at equilibrium
delta0 = deg2rad(26.985);       %angle between point A and the float CoG.
max_drive_disp=0.040;           %Maximum linear displacement for the electric drive
L_BC_min = L_BC_neutral - max_drive_disp;  % Minimum distance between points B anc C due to physical constraints on the electrical drive
L_BC_max = L_BC_neutral + max_drive_disp;  % Maximum distance between points B anc C due to physical constraints on the electrical drive
alpha_min = acos((L_BC_min^2-L_AB^2-L_AC^2)/(-2*L_AB*L_AC));  % Minimum angle BAC
beta_min  = acos((L_AC^2 - L_AB^2 - L_BC_min^2)/(-2*L_AB*L_BC_min));
phi_min   = acos((L_AB^2 - L_AC^2 - L_BC_min^2)/(-2*L_AC*L_BC_min));
alpha_max = acos((L_BC_max^2-L_AB^2-L_AC^2)/(-2*L_AB*L_AC));  % Maximum angle BAC
beta_max  = acos((L_AC^2 - L_AB^2 - L_BC_max^2)/(-2*L_AB*L_BC_max));
phi_max   = acos((L_AB^2 - L_AC^2 - L_BC_max^2)/(-2*L_AC*L_BC_max));   
%theta is the angle the line A-Float CoG forms with the horizontal line
theta_min= alpha_min - alpha0;          % Minimum arm angular displacement due to physical constraints on the electrical drive
theta_max= alpha_max - alpha0;         % Maximum arm angular displacement due to physical constraints on the electrical drive

%%%%%%% Parameters to build the Continous Matrices Ac, Bc and Cc for the Anaylisis of the WEC System
J = 1.04; %kg m^2
Jinf = 0.4805; %kg m^2
Jt = J+Jinf;
Khs = 92.33; %Nm rad^-1
bv=1.8; % Linear damping coefficient
Ar = [-13.59,-13.35;8.0,0];
Br=[8.0;0];
Cr=[4.739,0.5];
Dr=-0.1586;

%%%%%%%%%%%%%%%%%%% Constants used in the nonlinear function ptoM = f(theta,Fpto) %%%%%%%%%%%%%%%%%%%%%   
K1=L_AB*L_AC;
K2=L_AB^2+L_AC^2;
K3=( K1 / sqrt(K2-2*K1*cos(alpha0)) ) * sin(alpha0);

