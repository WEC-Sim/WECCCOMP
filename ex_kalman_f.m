function y = ex_kalman_f(u, Ad,Bd,ctrlInput,Q,R) 
%#codegen

% Initialize state transition matrix and Input To State Matrix
A = [Ad, Bd;
     zeros(1, size(Ad,1)) , 1 ];
B = [Bd;0];

% Measurement matrix
H = [ 1, 0, 0, 0, 0;
      0, 1, 0, 0, 0];

% Initial conditions
persistent x_est p_est
if isempty(x_est)
    x_est = zeros(size(A,2), 1);
    p_est = Q;
end

% Predicted state and covariance
x_prd = A * x_est + B * ctrlInput;
p_prd = A * p_est * A' + Q;

% Estimation
S = H * p_prd' * H' + R;
B = H * p_prd';
klm_gain = (S \ B)';

% Estimated state and covariance
x_est = x_prd + klm_gain * (u - H * x_prd);
p_est = p_prd - klm_gain * H * p_prd;

% Compute the estimated measurements
y = x_est;
end