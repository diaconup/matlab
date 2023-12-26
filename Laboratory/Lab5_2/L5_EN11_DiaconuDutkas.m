%% Laboratory 5
%% We taking the data from the motor
% Our port was 3
clc
utstart('3');
u_zeros = zeros(20,1);
u_rand = 1.4*rand(600,1) - 0.7;
ustep = 0.2*ustep(70);
u = [u_zeros; u_rand; u_zeros; ustep];
[vel, alpha, t] = run(u,'3',0.01);
plot(t,vel);


%% We are calculating it for the identification data
clc
clear all

%We load because we saved in order to have them home
load lab5_data.mat

% taking the values for u and y from the data from the DC motor
identification_y = vel(21:621);
identification_u = u(21:621);
identification_t = t(21:621);


% taking the degree
degree_M = 50;

% taking the length for the calculations
len_y = length(identification_y);

% initializing ryu and ru with zeros
ryu_values = zeros(1,length(identification_y));
ru_values = zeros(1,length(identification_y));

% initializing Ru with zeros it's dimensions
Ru_matrix = zeros(len_y,degree_M);

% calculating the ru and ryu with the formula from the course
for i=1:len_y
        for k = 1:len_y-i
            ru_values(i) = ru_values(i) + 1/len_y*(identification_u(k+i-1) * identification_u(k));
            ryu_values(i) = ryu_values(i) + 1/len_y*(identification_y(k+i-1) * identification_u(k));
        end
        % ru = ru/len;
        % ryu = ryu/len;
end

%Here we calculate the big Ru matrix
for i = 1:len_y
    for j = 1:degree_M
        Ru_matrix(i,j) = ru_values(abs(j-i)+1);
    end     
end

% calculating the vector H with the needed values
ryu_transposed = ryu_values';  
H_vector = Ru_matrix \ ryu_transposed;
    
% calculating yhat with conv function
Y_hat_values = conv(H_vector,identification_u);

% calculating MSE for our data
transposed_identification_y  = identification_y';
error_value = 1/len_y* sum((transposed_identification_y-Y_hat_values(1:length(identification_y))).^2);

% plotting our y vs the yhat calculated for identification
figure;shg
hold
plot(identification_t, identification_y);
plot(identification_t, Y_hat_values(1:len_y));
title('MSE = ', num2str(round(error_value)));


%% We are calculating it for the validation data
% taking the values for u and y from the data from the DC motor

validation_y = vel(651:length(vel));
validation_u = u(651:length(u));
validation_t = t(651:length(t));

% calculating yhat with conv function
Y_hat_val = conv(H_vector,validation_u);

% plotting our y vs the yhat calculated for validation
figure;shg
hold
plot(validation_t, validation_y);
plot(validation_t, Y_hat_val(1:length(validation_y)));
error_value_val = 1/length(validation_y)* sum((validation_y'-Y_hat_val(1:length(validation_y))).^2);
title('MSE = ', num2str(round(error_value_val)));