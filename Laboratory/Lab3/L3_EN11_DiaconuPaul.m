%%
%This section loads the data for First Order Element
clc
clear variables
load("lab3_order1_5.mat");

%% 
% Firstly we are doing it for the first order element
% We do it for the identification data
clc
identification_interval = 100;

identification_y = data.y(1:identification_interval);
identification_u = data.u(1:identification_interval);
time_id = t(1:100);

yss = mean(identification_y(80:identification_interval))
uss = 4; %we found from the plot
y0 = 0;
u0 = 0;

%Once we found the values from the plot we compute the gain
K = (yss - y0) / (uss - u0)

% 0.632*(yss-y0) = 1.25
% at 1.25 we have t1=4 from the graph;
t0 = 0;
t1 = 3.6; 
T = t1 - t0

TransferF_id = tf(K,[T 1])
Yhat_id = lsim(TransferF_id,identification_u,time_id);

hold on;

plot(time_id,identification_y)
plot(time_id,Yhat_id)

error_stationary = sum(identification_y - Yhat_id)^2 / 100;
title("Error is: ", num2str(error_stationary));

%%
% We do it for the validation data
clc
validation_interval = 500;

validation_y = data.y(201:validation_interval);
validation_u = data.u(201:validation_interval);
time_val=t(201:500);

% Here we compute the transfer function 
Yhat_val = lsim(TransferF_id,validation_u,time_val);

% Plotting the graphs and our aproximation
hold on;

plot(time_val,validation_y)
plot(time_val,Yhat_val)

% Computing the validation error

error_stationary = sum(validation_y - Yhat_val)^2 / 300;
title("Error is: ", num2str(error_stationary));


%%
%This section loads the data for Second Order Element
clc
clear variables
load("lab3_order2_5.mat");

%%
% Secondly we are doin it for the second order element
% We do it for the identification data
clc
identification_interval = 100;

identification_y2 = data.y(1:identification_interval);
identification_u2 = data.u(1:identification_interval);
time_id2 = t(1:100);

%plot(time_id2,identification_y2)

% For K(gain) we need yss and uss
yss = mean(identification_y2(80:100));
uss = 0.5;
y0 = 0;
u0 = 0;

%Once we found the values from the plot we compute the gain
K = (yss - y0) / (uss - u0)

%We now need to find the overshoot
yt1 = 1.6;
M = (yt1-yss) / (yss-y0)

zetta_function = log(1/M)/sqrt(pi^2+log(M^2))

T0 = 2.2 - 0.7;
wn_frequency = (2*pi) / (T0*sqrt(1-zetta_function^2))

% Here we compute the transfer function for identification data 
TransferuF2_id = tf(K*wn_frequency^2,[1 2*zetta_function*wn_frequency wn_frequency^2])
Y_hat2 = lsim(TransferuF2_id,identification_u2,time_id2);

% Plotting the graphs and our aproximation
hold on

plot(time_id2,identification_y2);
plot(time_id2,Y_hat2);

% Computing the identification error

error_stationary = sum(identification_y2 - Y_hat2)^2 / 100;
title("Error is: ", num2str(error_stationary));


%%
% We do it for the validation data
clc
validation_interval = 500;

validation_y2 = data.y(201:validation_interval);
validation_u2 = data.u(201:validation_interval);
time_val2 = t(201:500);

% Here we compute the transfer function for validation data 

TransferF2_val = tf(K*wn_frequency^2,[1 2*zetta_function*wn_frequency wn_frequency^2])
Yhat_val2 = lsim(TransferF2_val,validation_u2,time_val2);


% Plotting the graphs and our aproximation
hold on;

plot(time_val2,validation_y2)
plot(time_val2,Yhat_val2)

% Computing the validation error
error_stationary = sum(validation_y2 - Yhat_val2)^2 / 300;
title('Error is : ',num2str(error_stationary));