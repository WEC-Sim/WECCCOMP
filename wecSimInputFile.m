%% WaveStar model with WAMIT data for WECCCOMP
% Author: Kelley Ruehl, Sandia National Laboratories
%
%% Simulation Data
simu = simulationClass();                       % Create the Simulation Variable
    simu.simMechanicsFile = 'WaveStar_LinRot.slx';         % Specify Simulink Model File
    simu.dt = 0.01;                                 % Simulation Time-Step [s]
    simu.rampTime = 8*5;                         	% Wave Ramp Time Length [s]
    simu.endTime = 8*20;                            % Simulation End Time [s]
    simu.CITime = 2;                                % Convolution Time [s]
    simu.explorer = 'on';                           % explorer on
    simu.solver = 'ode45';                          % turn on ode45
    simu.domainSize = 5;
    simu.ssCalc = 1;

%% Wave Information  
%% No Wave
% waves = waveClass('noWave');
%     waves.T = 1.5;  
%     
%% Regular Waves  
waves = waveClass('regularCIC');                % Initialize waveClass
    waves.H = 0.25;                                  % Wave Height [m]
    waves.T = 1.5;                                   % Wave Period [s]

%% Irregular Waves  
% waves = waveClass('irrregular');                % Initialize waveClass
%     waves.H = 0.25;                                  % Wave Height [m]
%     waves.T = 1.5;                                   % Wave Period [s]
%     
    
    
%% Body Data
%% Float and Arm EC - ROTATE
body(1) = bodyClass('hydroData/wavestar.h5');     % Initialize bodyClass
    body(1).mass = 4.004;                           % Define mass [kg] - from exp   
%     body(1).mass = 'equilibrium';                 	% Define mass [kg] -> 4.4463 kg  
    body(1).momOfInertia = [1 1 1];                	% Moment of Inertia [kg*m^2] - from exp     
    body(1).geometryFile = 'geometry/FloatArm.stl'; % Geometry File

%% Frame - FIXED
body(2) = bodyClass('');                      	% Initialize bodyClass
    body(2).geometryFile = 'geometry/Frame.stl'; 	% Geometry File
    body(2).nhBody = 1;                             % Turn non-hydro body on
    body(2).name = 'Frame';                         % Specify body name
    body(2).mass = 999;                            	% Define mass [kg] - FIXED  
    body(2).momOfInertia = [999 999 999];           % Moment of Inertia [kg*m^2] - FIXED 
    body(2).dispVol = 0;                            % Specify Displaced Volume  
    body(2).viz.color = [0 0 0];
    body(2).viz.opacity = 0.5;
    body(2).cg = [0 0 0];                           % Specify Cg 

%% BC Rod - TRANSLATE
body(3) = bodyClass('');                     	% Initialize bodyClass
    body(3).geometryFile = 'geometry/BC.stl';       % Geometry File
    body(3).nhBody = 1;                             % Turn non-hydro body on
    body(3).name = 'BC';                            % Specify body name
    body(3).mass = 0.001;                           % Define mass [kg]   
    body(3).momOfInertia = [0.001 0.001 0.001];     % Moment of Inertia [kg*m^2]      
    body(3).dispVol = 0;                            % Specify Displaced Volume  
    body(3).cg = [0 0 0];                           % Specify Cg 
    
%% Motor - ROTATE
body(4) = bodyClass('');                     	% Initialize bodyClass
    body(4).geometryFile = 'geometry/Motor.stl'; 	% Geometry File
    body(4).nhBody = 1;                             % Turn non-hydro body on
    body(4).name = 'Motor';                         % Specify body name
    body(4).mass = 0.001;                           % Define mass [kg]   
    body(4).momOfInertia = [0.001 0.001 0.001];     % Moment of Inertia [kg*m^2]     
    body(4).dispVol = 0;                            % Specify Displaced Volume  
    body(4).cg = [0 0 0];                           % Specify Cg 
    
%% PTO and Constraint Parameters
%% A - Revolute
constraint(1) = constraintClass('A');       % Initialize constraintClass
    constraint(1).loc = [-0.43 0 0.27];            	% Constraint Location [m]

%% B - Revolute
constraint(2) = constraintClass('B');       % Initialize constraintClass
    constraint(2).loc = [-0.43 0 0.682];          	% Constraint Location [m]    
 
%% Linear Motor
pto(1) = ptoClass('PTO');                   % Initialize ptoClass
    pto(1).loc = [-0.43 0 0.682];                     % PTO Location [m]
    pto(1).orientation.z = [182/450.4087 0 412/450.4087];  % PTO orientation
% UPDATE pto values, made up for now (Fpto max = 200 N)
    pto(1).c = 1000;
    
%% C - Revolute
constraint(3) = constraintClass('C');       % Initialize constraintClass
    constraint(3).loc = [-0.614 0 0.355];            % Constraint Location [m]

%% Frame - Fixed
constraint(4) = constraintClass('Fixed');   % Initialize constraintClass
    constraint(4).loc = [-0.43 0 1.5];               % Constraint Location [m]




