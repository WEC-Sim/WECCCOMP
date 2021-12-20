%%%%% Load WEC model parameters 
clearvars; close all; clc;
clear NMPC_AC NMPC_IP observer_kf

% Select the sea state to simulate: 
%      Hm0 [m]  Tp [s]  Gamma [-]   Simulated time [s]
% SS4= 0.0208   0.988     3.3       98.8
% SS5= 0.0625   1.412     3.3       141.2
% SS6= 0.1042   1.836     3.3       183.6

SeaState = 6;
% Define is states are estimated or full knowledge are considered
estates_estimated = 'KF'; %    'KF';  'No'
% Define which solution to simulate
simulate_Res    = 0;                               % Resistive controller
simulate_NMPC   = 1;                               % NMPC
% Define the solver to used with quadprog
Solver = 'Interior-Point'; % 'Active-Set';
switch(SeaState)
    case 4 ;        load('../waveData/Moments4.mat'); 
                    dominantPeriod = 0.988;
                    Simulated_time = 100;
    case 5 ;        load('../waveData/Moments5.mat');
                    dominantPeriod = 1.412;   
                    Simulated_time = 150;
    case 6 ;        load('../waveData/Moments6.mat');
                    dominantPeriod = 1.836;   
                    Simulated_time = 200;
    otherwise;      prop_gain = 0;
end 
dt      = mean(diff(time));
run( '..\controller_init.m' );  

%%%%%%%%%% NMPC Setting %%%%%%%%%%%%%%%%%%%%%%%
%Augmented system to include the previous control input in the state vector
A   = blkdiag( Ad, 0 );                            %Augmented State Transition Matrix
Bw  = [ Bd;
        0 ];                                       %Augmented Wave Input Matrix
Bu  = [ Bd;
        1 ];                                       %Augmented Input Matrix
nxa = size( A, 1 );                                %Augmented State Size
nya = 2;

%% %%%%%%%%%%%%%%%%%%%% Simulation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
kT              = round( Simulated_time / dt );    %Number of simulation steps
PTO_Efficiency = zeros(2,kT);                      % Store the value of the efficiency at every simulation time.
                                                   % Row 1 for resistive, row 2 for mpc and row 3 for nmpc             
options = optimoptions('quadprog','Display','off');
toplot = zeros( 2, 1 );                             % To define which solution to plot
        
if simulate_Res ==1                                 % Preallocation a resitive controller (proportional to the velocity)
        Xk_res      = zeros( nx, kT );              % Store the state values from the simulation
        Uk_res      = zeros( nu, kT );              % Store the input values from the simulation
        Yk_res      = zeros( nya, kT );             % Store the measurement values from the simulation
        estimated_states  =  zeros( nx + 1, kT );
        measurement   =   zeros( 2, kT );
        Energy_Res  = zeros( 1, kT );
        Power_Res   = zeros( 1, kT ); 
elseif simulate_NMPC ==1                                %Preallocation NMPC with efficiency
        Xk_NMPC     = zeros( nx, kT );
        Uk_NMPC     = zeros( nu, kT );
        Yk_NMPC     = zeros( nya, kT );
        estimated_states  =  zeros( nx + 1, kT );
        measurement   =   zeros( 2, kT );
        Energy_NMPC = zeros( 1, kT );
        Power_NMPC  = zeros( 1, kT );
        %Initial guesses
        Ubar = zeros( Np*nu, 1 );
        Xbar = zeros( ( Np + 1 )*nxa, 1 );
end
        
%% Main For Loop         
        k_ini = 2;                                                 % Starting Point of For Loop
        for k = k_ini : kT - 1                         
            Future_exMom = excM( k : k + Np - 1, 1 );             % Buoy Future Force Vector
            
            if simulate_Res == 1     %%%%%%%%%%%% Resitive controller (proportional to the velocity) %%%%%%%%%%%%                             
                switch estates_estimated
                    case 'KF' 
                        Uk_res( :, k ) = -prop_gain*estimated_states( 2, k );
                        % System Simulation
                        Xk_res( :, k + 1) = Ad*Xk_res( :, k ) + Bd*excM( k, 1 ) + Bd*Uk_res( :,k );    %States    
                        measurement(:,k+1) = Xk_res( 1:2, k + 1);
                        estimated_states( :, k + 1 ) = observer_kf( Uk_res( :,k ), measurement(:,k+1), Ad, Bd,  Qkf, Rkf );
                        v_res = estimated_states( 2, k + 1 );
                    case 'No'
                        Uk_res( :, k ) = -prop_gain*Xk_res( 2, k );
                        % System Simulation
                        Xk_res( :, k + 1) = Ad*Xk_res( :, k ) + Bd*excM( k, 1 ) + Bd*Uk_res( :,k );    %States    
                        v_res = Xk_res( 2, k + 1 );
                end
                u_res = Uk_res( :, k );
                if u_res*v_res<0
                    effi_res = eta_generator;
                else
                    effi_res = eta_motoring;
                end                                 
                PTO_Efficiency( 1, k ) = effi_res;
                Power_Res( :, k ) = - effi_res*v_res*u_res;
                Energy_Res( :, k ) = Energy_Res( :, k - 1 ) + dt*Power_Res( :, k );          %Energy absorbed
         
            elseif simulate_NMPC == 1     %%%%%%%%%%%%   NMPC Control  with efficiency  (with efficiency = we ) %%%%%%%%%%%%
                % Compute augmented state
                toplot(2,1) = 1;                                          % Variable use to check if figures are to be plotted
                Xwe_aug = [ Xk_NMPC( :, k );
                            Uk_NMPC( :, k - 1 ) ];                  % Augmented with the previous control input U_k-1
                % Implement Non-linear MPC
                switch Solver
                    case 'Active-Set' 
                         Ubar = NMPC_AS( Xwe_aug, Future_exMom, A, Bu, Bw, R_ctrl, Np,offset_eff, scaler_eff, alpha_efft, qnl, Umax, Umin);
                    case 'Interior-Point'
                         Ubar = NMPC_IP( Xwe_aug, Future_exMom, A, Bu, Bw, R_ctrl, Np,offset_eff, scaler_eff, alpha_efft, qnl, Umax, Umin);
                end
             
                % Select first input
                Uk_NMPC( :, k ) = Ubar( 1 : nu );
                switch estates_estimated
                    case 'KF' 
                       [Xwe_aug, Yk_NMPC( :, k ), ~, ~ ] = simulate_and_linearise( Xwe_aug, Uk_NMPC( :, k ), excM( k, 1 ), A, Bu, Bw, offset_eff, scaler_eff, alpha_efft);
                       measurement(:,k+1) = Xwe_aug( 1:2, 1);
                       estimated_states( :, k + 1 ) = observer_kf( Uk_NMPC( :, k ), measurement(:,k+1), Ad, Bd,  Qkf, Rkf );
                       Xk_NMPC( :, k + 1 ) = estimated_states( 1 : end-1, k + 1 );
                       v_nmpc = estimated_states( 2, k + 1 );
                    case 'No'
                       [Xwe_aug, Yk_NMPC( :, k ), ~, ~ ] = simulate_and_linearise( Xwe_aug, Uk_NMPC( :, k ), excM( k, 1 ), A, Bu, Bw, offset_eff, scaler_eff, alpha_efft);
                       Xk_NMPC( :, k + 1 ) = Xwe_aug(1:end-1,1);
                       v_nmpc = Xk_NMPC( 2, k + 1 );
                end              
                u_nmpc = Uk_NMPC( :, k );
                if u_nmpc*v_nmpc < 0
                    effi_nmpc = eta_generator;
                else
                    effi_nmpc = eta_motoring;
                end
                PTO_Efficiency( 3, k ) = effi_nmpc;
                Power_NMPC( :, k ) = - effi_nmpc*v_nmpc*u_nmpc;
                Energy_NMPC( :, k ) = Energy_NMPC( :, k - 1 ) + dt*Power_NMPC( :, k );          %Energy absorbed
            end            
        end

%% %% Plot_Results
close all;
       
ii = find(time==0);   
t = time(1:kT);
t_end = round( t( end ) / 5 )*5;
if simulate_Res == 1
        pos = Xk_res(1,1:kT);
        v = Xk_res(2,1:kT);
        u = Uk_res(1,1:kT);
        p = Power_Res(1,1:kT-1);
        energy_gen = Energy_Res( :, end - 1 );
        fprintf('\n Extracted Energy = %.4f, \n Prop. Gain = %.2f,  \n', energy_gen, prop_gain)
elseif simulate_NMPC == 1
        pos = Xk_NMPC(1,1:kT);
        v = Xk_NMPC(2,1:kT);
        u = Uk_NMPC(1,1:kT);
        p = Power_NMPC(1,1:kT-1);
        energy_gen = Energy_NMPC( :, end - 1 );
        fprintf('\n Max. Energy = %0.4f, Prediction horizon = %i \n ', energy_gen, Np );
end

mp = mean( p( ii : end ) );
mp_s = num2str( mp );
E_extr = num2str( energy_gen );
min_power = min(p);
max_power = max(p);


fig1=figure('Name','Control input and Power','Units','Normalized','OuterPosition',[0 0 1 1],'DefaultAxesFontSize',14);
figure(fig1)
t_fin = size(t,1);
inicia = 0;
final = t_end;
subplot(2,1,1);                                                               
      plot( t, u,'-b','LineWidth',1); hold on; grid on; 
      ylabel('Control input [Nm]');                                         
      xlim([0 t_end])
      xticks(inicia:10:final);     
      xticklabels({ })                                        
      ylim([-15 15]);
      yticks([-15,-12,-10,-5,0,5,10,12,15]);       
      yticklabels({'-15','-12', '-10', '-5', '0', '5', '10', '12','15' })
      plot( [ inicia, final ], 12*[ 1, 1 ], 'r--', 'LineWidth', 1 );
      plot( [ inicia, final ], -12*[ 1, 1 ], 'r--', 'LineWidth', 1 ); 
     if simulate_Res == 1
            txt = [ ' Resistive, ','  prop gain = ', num2str(prop_gain), '   SS = ', num2str(SeaState), '    States Estimated? ', estates_estimated];
     elseif simulate_NMPC == 1
            txt = [ ' NMPC, Np = ', num2str(Np), '      SS = ', num2str(SeaState), '    States Estimated? ', estates_estimated];
    end
    su3 = title( txt );
    su3.FontSize = 16;
    set(gca, 'LooseInset', [0,0,0,0]);          
subplot(2,1,2);                                                               
    plot( t(1:end-1), p,'-b','LineWidth',1); hold on; grid on; 
    plot( [ 0, t( end ) ], mp*[ 1, 1 ], 'r--', 'LineWidth', 2 ); hold on;  
    if simulate_Res == 1
    txt = [ 'Resistive  ', 'Mean Power = ', mp_s, ' w,','  Energy Extracted = ',  E_extr, ' J'];
    elseif simulate_NMPC == 1
    txt = [ ' NMPC ', '   Mean Power = ', mp_s, ' w,','  Energy Extracted = ',  E_extr, ' J'];
    end
    su3 = title( txt );
    su3.FontSize = 16;
    ylabel( 'Power [w]' ); 
    ylim([0.25*min(min_power,-max_power), 1.20*max_power]);  
    xlim([0 t_end])
    xticks(inicia:10:final);  
    xticklabels({'0',' ','20',' ','40',' ','60',' ','80 ',' ', '100',' ','120',' ','140',' ','160',' ','180 ',' '});
    set(gca, 'LooseInset', [0,0,0,0]);    

%%%   State estimation
fig2=figure('Units','Normalized','OuterPosition',[0 0 1 1]);
t = tiledlayout(3,1,'TileSpacing','compact');
Te = kT;

switch estates_estimated
    case 'KF' 
        postile = nexttile;
                plot( time(1:Te),  pos(1:Te), 'k-', 'LineWidth', 1);  grid on;   grid minor; hold on;   title('Arm position $\theta(t)$','Interpreter','Latex')
                plot( time(1:Te),  estimated_states( 1, 1:Te ), 'r--', 'LineWidth', 1); 
                legend("Real","Estimated")   
        veltile = nexttile;
                plot( time(1:Te),  v( 1:Te ), 'k-', 'LineWidth', 1);  grid on;   grid minor; hold on;   title('Arm Angular velocity $\dot(\theta)(t)$','Interpreter','Latex')
                plot( time(1:Te),  estimated_states( 2, 1:Te ), 'r--', 'LineWidth', 1); 
                legend("Real","Estimated")   
        thetatile = nexttile;
                plot( time(1:Te), excM( 1:Te, 1), 'k-', 'LineWidth', 1 );     grid on;   grid minor; hold on;   title('$\theta(t)$','Interpreter','Latex')                
                plot( time(1:Te),  estimated_states( 5, 1:Te ), 'r--', 'LineWidth', 1); 
                legend("Real","Estimated")        
    case 'No'
        
end


