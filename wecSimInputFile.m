%% WaveStar model with WAMIT data for WECCCOMP
%
%% Simulation Data
simu = simulationClass();                       % Create the Simulation Variable
    simu.simMechanicsFile = 'WaveStar.slx';     % Specify Simulink Model File
    simu.dt = 0.001;                            % Simulation Time-Step [s]
    simu.rampTime = 5*1.412;                    % Wave Ramp Time Length [s]
    simu.endTime = 25*1.412;                    % Simulation End Time [s]
    simu.CITime = 2;                            % Convolution Time [s]
    simu.explorer = 'on';                       % explorer on
    simu.solver = 'ode4';                       % turn on ode45
    simu.domainSize = 5;
    simu.ssCalc = 1;
    simu.mcrCaseFile = 'WECCCOMP_ss.mat';

%% Wave Information  
    controller_init
%% No Wave
% waves = waveClass('noWave');
%     waves.T = 0.79;
    
%% No Wave CIC
waves = waveClass('noWaveCIC');                % Initialize waveClass
    
%% Regular Waves  
% waves = waveClass('regularCIC');                % Initialize waveClass
%     waves.H             = 0.0625;               % Wave Height [m]
%     waves.T             = 1.412;                % Wave Period [s]
%     waves.wavegaugeloc  = 0.1;

%% Irregular Waves  
% waves = waveClass('irregular');                % Initialize waveClass
%     waves.H = 0.0625;                             	% Wave Height [m]
%     waves.T = 1.412;                            	% Wave Period [s]
%     waves.spectrumType = 'JS';                    	% Specify Wave Spectrum Type
%     waves.freqDisc = 'EqualEnergy';                 % Uses 'EqualEnergy' bins (default) 
%     waves.phaseSeed = 1;                            % Phase is seeded so eta is the same    
%     waves.gamma = 1;
%     waves.wavegaugeloc  = 0.1; 
    
%% Body Data
%% Float and Arm EC - ROTATE
body(1) = bodyClass('hydroData/wavestar.h5');     % Initialize bodyClass
%     body(1).mass = 4.004;                           % Define mass [kg] - from exp 4.004 kg
    body(1).mass = 'equilibrium';                 	% Define mass [kg] -> 4.0673 kg  
    body(1).momOfInertia = [0.2481 0.2481 0.2481]; 	% Moment of Inertia [kg*m^2] - from exp     
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
constraint(1) = constraintClass('A');           % Initialize constraintClass
    constraint(1).loc = [-0.438 0 0.302];       	% Constraint Location [m]

%% B - Revolute
constraint(2) = constraintClass('B');           % Initialize constraintClass
    constraint(2).loc = [-0.438 0 0.714];          	% Constraint Location [m]    
 
%% Linear Motor
pto(1) = ptoClass('PTO');                       % Initialize ptoClass
    pto(1).loc = [-0.438 0 0.714];                  % PTO Location [m]
    pto(1).orientation.z = [183.4398/379.5826 0 332.3142/379.5823];  % PTO orientation
    
%% C - Revolute
constraint(3) = constraintClass('C');           % Initialize constraintClass
    constraint(3).loc = [-0.6214398 0 0.3816858];	% Constraint Location [m]

%% Frame - Fixed
constraint(4) = constraintClass('Fixed');       % Initialize constraintClass
    constraint(4).loc = [-0.43 0 1.5];          	% Constraint Location [m]
