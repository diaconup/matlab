%% Laboratory 6
%% We taking the data from the motor
% Our port was 5
clc
utstart('5');
u_zeros = zeros(20,1);
u_rand = 1.4*rand(200,1) - 0.7;
ustep = 0.4*ustep(70);
u = [u_zeros; u_rand; u_zeros; ustep];
[vel, alpha, t] = run(u,'5',0.01);
plot(t,vel);

%% Prediction part
clc
clear all

%We load because we saved in order to have them home
load lab6_data.mat

identification_y = vel(22:221);
identification_u = u(22:221);
identification_t = t(22:221);

%We took a value for na=nb between 10 and 15
na = 14;
nb = 14;

%We initialized the dimensions for the matrix Phi
len_y = length(identification_y);
Phi_matrix_iden = zeros(len_y,na+nb);


%The algorithm to form the Phi matrix
for i=1:len_y
    if i<na
    for j=1:i-1
        Phi_matrix_iden(i,j)=-identification_y(i-j);
        Phi_matrix_iden(i,nb+j)=identification_u(i-j);
    end
    else 
    for j=1:nb-1
        Phi_matrix_iden(i,j)=-identification_y(i-j);
        Phi_matrix_iden(i,nb+j)=identification_u(i-j);
    end
    end
end

%We form both Theta and Yhat vectors
Theta = Phi_matrix_iden \ identification_y';
Y_hat_values = Phi_matrix_iden * Theta;


%Here we plot identification vs aproximation
hold
plot(identification_t,identification_y);
plot(identification_t, Y_hat_values);

%We calculate the error for the prediction for identification
Error_prediction = 1/length(identification_y)*sum((identification_y'-Y_hat_values).^2)
title("Prediction error for identification =",num2str(round(Error_prediction)));
hold off;
%% Prediction for the validation values
 
clc
validation_y = vel(251:length(vel));
validation_u = u(251:length(u));
validation_t = t(251:length(t));

%Same steps we initialize our Phi matrix for validation
len_val = length(validation_y);
Phi_matrix_val=zeros(len_val,na+nb);

for i=1:len_val
    if i<na
    for j=1:i-1
        Phi_matrix_val(i,j)=-validation_y(i-j);
        Phi_matrix_val(i,nb+j)=validation_u(i-j);
    end
    else 
    for j=1:nb-1
        Phi_matrix_val(i,j)=-validation_y(i-j);
        Phi_matrix_val(i,nb+j)=validation_u(i-j);
    end
    end
end

%We form Yhat vector for validation with the same Theta
yaprox_val=Phi_matrix_val*Theta;


%Here we plot identification vs aproximation
hold
plot(validation_t,validation_y);
plot(validation_t, yaprox_val);

len_aprox = length(yaprox_val);

%We calculate the error for the prediction for validation
Error_prediction=1/length(validation_y)*sum((validation_y'-yaprox_val).^2)
title("Prediction error for validation =",num2str(round(Error_prediction)));
hold off;

%% Simulation part

Phi_matrix_sim = zeros(1,na+nb);

for i=1:len_aprox
Y_simulation(i)=(Theta')*Phi_matrix_sim';
    if i<na
    for j=1:i-1
        Phi_matrix_sim(j)=-yaprox_val(i-j);
        Phi_matrix_sim(nb+j)=validation_u(i-j);
    end
    else 
    for j=1:nb-1
        Phi_matrix_sim(j)=-yaprox_val(i-j);
        Phi_matrix_sim(nb+j)=validation_u(i-j);
    end
    end
end


%Here we plot our aproximation to the simulated values
hold
plot(yaprox_val(1:length(Y_simulation)));
plot(Y_simulation);

ysim_transposed = Y_simulation';

%We calculate the error for simulation
Error_simulation=1/length(yaprox_val)*sum((yaprox_val-ysim_transposed).^2)
title("Simulation error =",num2str(round(Error_simulation)));
hold off;
