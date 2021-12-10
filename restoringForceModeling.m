% This script computes the approximation for the restoring hydrostatic
% stiffness coefficien Khs
Laf = 0.5487;               % Distance from pivot point A to the Cg of the float [m]
Laa = 0.1177;               % Distance from pivot point A to the Cg of the Arm [m]
grav = 9.80665;             % Standard acceleration due to gravity [m s^-2]
rho = 1000;                 % Water density [kg m^-3]
Floatmass = 3.0750;         % Float mass [kg]
FloatMoIy = 0.0014;         % Float moment of inertia around y-axis [kg*m^2]
Armmass = 1.1570;           % Arm mass [kg]
ArmMoIy = 0.0606;           % Arm moment of inertia around y-axis [kg*m^2]
dispVol= 0.0034;            % Displaced volume at equilibrium [m^-3]

% Restoring hydrostatic stiffness coefficient Khs [Nm rad^-1]
Kh = dispVol*rho*grav*Laf - Armmass*grav*Laa - Floatmass*grav*Laf

%Check: 
% WaveStar/Float/Hydrodynamic Body/Hydrostatic Restoring Force Calculation/
% Linear and Nonlinear Restoring Force Variant Subsystem/Linear Hydrostatic Restoring Force/Net Buoyancy Force

% Net vertical buoyancy force at equilibrium [N]
F_buoyancy = [0 0 grav * rho * dispVol];
% Vector from the centre of buoyancy to the centre of gravity of the float
% [m]. Values taken from body(1).cb and body(1).cg 
vectorBG = [0.001292 -0.001174 -0.039195] - [0.0511 0 0.0533];
% Cross product between the vectorBG and the buoyancy force at equilibrium
% to add Rotational buoyancy force
rotBuoyancyC = cross(vectorBG,F_buoyancy)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
