%%
%This section loads the data for First Order Element
clc
clear variables
load("lab4_order1_6.mat");

%%
% Firstly we are doing it for the first order element
% We do it for the identification data
clc

identification_y1 = data.y(1:100);
identification_u1 = data.u(1:100);
time_id1 = t(1:100);

% For K(gain) we need yss and uss
% using y0 + 0.368(ymax − y0) computing t2;
t2 = 5.28; 
t1 = 3.72;
T0 = t2 - t1;

%We take the average of the precised interval
yss = mean(identification_y1(1:10));
uss = mean(identification_u1(1:10));

%After we have what we need we can calculate the gain
K = yss / uss;

%Formulas from the course for the states matrix
A = -1 / T0;
B = K / T0;  
C = 1;
D = 0;

% Here we compute the transfer function 
TransferF_FirstOrder = ss(A,B,C,D);
Yhat_1order_validation=lsim(TransferF_FirstOrder,identification_u1,time_id1,yss);

% Plotting the graphs and our aproximation
hold on;
plot(time_id1,identification_y1);
plot(time_id1,Yhat_1order_validation);

% Computing the identification error
ess = 1/100 * sum(identification_y1-Yhat_1order_validation)^2;
title("Error is: ", num2str(ess));
%%  We do it for validation data
clc

validation_y1 = data.y(101:330);
validation_u1 = data.u(101:330);
time_val1 = t(101:330);

Yhat_1order_validation=lsim(TransferF_FirstOrder,validation_u1,time_val1,yss);

%Plotting the graphs and our aproximation
hold on;
plot(time_val1,validation_y1);
plot(time_val1,Yhat_1order_validation)

% Computing the validation error
interval = 330-100;
ess = 1/interval * sum(validation_y1 - Yhat_1order_validation)^2;
title("Error is: ", num2str(ess));
%%
%This section loads the data for Second Order Element
clc
clear variables
load("lab4_order2_6.mat");

%%
%Secondly we are doing it for the second order element
% We do it for the identification data
clc

identification_y2 = data.y(1:130);
identification_u2 = data.u(1:130);
time_id2 = t(1:130);

% For K(gain) we need yss and uss
%We take the average of the precised interval
yss = mean(identification_y2(1:10));
uss = mean(identification_u2(1:10));

%from the plot we can deduce t3 and t1
t3 = 3.4;
t1 = 1.52;
T0 = t3 - t1;

K = yss / uss;
y0 = yss;

Ts = 0.04;

k00 = 1.2;
k01 = 2.12;
k02 = 3.24;

A_plus = sum(identification_y2(31:54) - y0)*Ts;
A_minus = sum(y0-identification_y2(55:82))*Ts;

Overshoot_M = A_minus / A_plus;

tita = log(1/Overshoot_M) / sqrt(pi^2+log(Overshoot_M^2));
omega_n = (2 * pi) / (T0 * sqrt(1 - tita^2));

A = [0 1; -(omega_n^2) -(2*(tita*omega_n))];
B = [0; K*omega_n^2];
C = [1 0];
D = 0;

TransferF_SecondOrder = ss(A,B,C,D);
Yhat_2order_identification = lsim(TransferF_SecondOrder,identification_u2,time_id2, [yss 0]);

%Plotting the graphs and our aproximation
hold on;
plot(time_id2,identification_y2);
plot(time_id2,Yhat_2order_identification);

% Computing the identification error
interval = 130;
ess = 1/interval * sum(identification_y2-Yhat_2order_identification)^2;
title("Error is: ", num2str(ess));

%% For validation data
% We do it for the validation data
clc

validation_y2 = data.y(130:330);
validation_u2 = data.u(130:330);
time_val2 = t(130:330);

% Validation plot for the system
Yhat_2order_validation = lsim(TransferF_SecondOrder,validation_u2,time_val2,[yss 0]);

%Plotting the graphs and our aproximation
hold on;
plot(time_val2,validation_y2);
plot(time_val2,Yhat_2order_validation)

% Computing the identification error
interval = 330 - 130;
ess = 1/interval * sum(validation_y2-Yhat_2order_validation)^2
title("Error is: ", num2str(ess));