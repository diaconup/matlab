%% Laboratory 8
%% We taking the data from the motor
% we dont include the PRBS function since it is the same as in the previous
% lab
clc
utstart('3');
u1 = PRBS(200,3,-0.7,0.7);
u2 = PRBS(200,10,-0.7,0.7);
uzeros = zeros(20, 1);
ustep = 0.4*ustep(70);
u = [uzeros; u1'; uzeros; u2'; zeros(20,1); ustep];
[vel, alpha, t] = run(u,'3',0.01);
plot(t,vel);
%%
clc
clear all
load ("lab8.mat");


%Maximum values from the last lab 
identification_y = vel(1:442);
identification_u = u(1:442);
% initializing our nk na and nb values with 14 and 2 respectively
na = 14;
nb = 14;
nk = 2;

%Default settings for our problem
N = length(identification_y); % taking the length of the identification 
alfa = 0.1; % the alpha values was given in the lab
threshold = 10^-5; % the threshold value was given in the lab
max_length = 50; % the max length we took as 50
sample_time = 0.01; % the sample rate is given in the lab as 10ms

%Initialisations for the needed variables
ef_derivate = zeros(1,N); % initialization of ef derivative
eb_derivate = zeros(1,N); % initialization of eb derivative
v_derivate = zeros(1,2); % initialization of v derivative
hessian_matrix = zeros(2,2); % initialization of hessian matrix
e_derivate = zeros(1,N); % initialization of e derivative
Theta_matrix_one = [1; 1]; % initialization of the theta matrix

% in this loop we are calculating the derivatives with the formulas given
% in the course and the final theta matrix
for i = 1:max_length    
    f = Theta_matrix_one(1); % initialization of f
    b = Theta_matrix_one(2); % initialization of b

    % in this loop we calculate only the e ef eb derivatives
    for k = 1+nk:N
        e_derivate(k)=-f*e_derivate(k-1)+identification_y(k)+f*identification_y(k-1)-b*identification_u(k-nk);
        ef_derivate(k)=-f*ef_derivate(k-1)+identification_y(k-1);
        eb_derivate(k)=-f*eb_derivate(k-1)-identification_u(k-nk);
    end
    % now with the derivatives calculated we are able to calculate v
    % derivative, the hessian and detheta matrix and the final theta matrix
    detheta = [ef_derivate;eb_derivate];
    v_derivate(1) = 2/N * (sum(e_derivate.*ef_derivate));
    v_derivate(2) = 2/N * (sum(e_derivate.*eb_derivate));
    hessian_matrix = (2/N) * (hessian_matrix + detheta * detheta');
    Theta_matrix_two = Theta_matrix_one;
    Theta_matrix_one = Theta_matrix_two-(alfa*inv(hessian_matrix)*v_derivate');

    % comparisson to know if we got a good enough theta matrix exiting the
    % main for loop if we do
    if (norm(Theta_matrix_two-Theta_matrix_one)<=threshold)
        break;
    end
end

%We are taking the data from the intervals
vel_transposed = vel';
% creating the model for the validation data
model_val = iddata(vel_transposed,u,sample_time);

%Taking what we needed from Theta Matrix
f=Theta_matrix_one(1,1); % assigning the values for f from theta matrix
b=Theta_matrix_one(2,1); % assigning the values for b from theta matrix
B_matrix=[zeros(1,nk), b]; % creating the final B matrix with the nk that we took and the b values taken from theta
F_matrix=[1 f]; % creating the final F matrix with the nk that we took and the f values taken from theta

%case of OE
% we initialize every matrix with 1 since we do not need them in the OE
% mode
A_matrix=1;
C_matrix=1;
D_matrix=1;
% using idpoly to create our OE model
OE = idpoly(A_matrix,B_matrix,C_matrix,D_matrix,F_matrix,0,sample_time);
% using compare to see how good our OE model is on our validation data
compare(OE,model_val);