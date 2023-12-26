clear all;
close all;
clc;

data = load('iddata-15.mat');

uId = data.id.InputData;
yId = data.id.OutputData;

uVal = data.val.InputData;
yVal = data.val.OutputData;

subplot 221
plot(uId);grid;shg
title("Identification Input Data")
subplot 222
plot(yId);grid;shg
title("Identification Output Data")

subplot 223
plot(uVal);grid;shg
title("Validation Input Data")
subplot 224
plot(yVal);grid;shg
title("Validation Output Data")

na = 1;
nb = 1;
m = 5;

phi = [];
for i = 1:length(uId)
    phia = [];
    phib = [];
    for j = 1:na
        if i-j>0
            phia = [phia yId(i-j)];
        else
            phia = [phia 0];
        end
    end

    for j = 1:nb
        if i-j>0
            phib = [phib uId(i-j)];
        else
            phib = [phib 0];
        end
    end
    phi = [phi; phia phib];
end

Phi = [];
for I = 1:length(phi)
     Phi = [Phi; Poly(phi(I,:),m)];
end


% Prediction
theta = Phi \ yId;
yhatId = Phi* theta;

phipred = [];
for i = 1:length(uVal)
    phia = [];
    phib = [];
    for j = 1:na
        if i-j>0
            phia = [phia yVal(i-j)];
        else
            phia = [phia 0];
        end
    end

    for j = 1:nb
        if i-j>0
            phib = [phib uVal(i-j)];
        else
            phib = [phib 0];
        end
    end
    phipred = [phipred; phia phib];
end

Phi = [];
for I = 1:length(phi)
     Phi = [Phi; Poly(phipred(I,:),m)];
end
yhat = Phi * theta;


% Simulation part
ytilde = [];
phisim = [];
for i = 1:length(uVal)
    phia = [];
    phib = [];
    for j = 1:na
        if i-j>0
            phia = [phia -ytilde(i-j)];
        else
            phia = [phia 0];
        end
    end
    for j = 1:nb
        if i-j>0
            phib = [phib uVal(i-j)];
        else
            phib = [phib 0];
        end
    end
    phisim = [phisim; phia phib];
    ytilde = [ytilde Phi*theta];
end

Phi = [];
for I = 1:length(phi)
     Phi = [Phi; Poly(phisim(I,:),m)];
end
thetaH = linsolve(Phi,yVal);
yHat2 = Phi * thetaH;

%MSEs
MSE = 0;
mse_id = 0;
for i = 1:length(yhatId)
    MSE = MSE + (yhatId(i)-yId(i)).^2;
end
mse_id = 1/length(yhatId) * MSE;

MSE = 0;
mse_pred = 0;
for i = 1:length(yhat)
    MSE = MSE + (yhat(i)-yVal(i)).^2;
end
mse_pred = 1/length(yhat) * MSE;

MSE2 = 0;
for i = 1:length(yHat2)
    MSE2 = MSE2 + (yHat2(i)-yVal(i)).^2;
end
mse_sim = 1/length(yHat2) * MSE2;


%Subplots
%Prediction identification
figure
subplot 221
hold on
plot(yhatId,'r')
plot(yId,'k')
grid;shg
hold off
legend('Yhat_{id}','Y_{id}')
title('Pred id, MSE = ', mse_id)

%
subplot 222
hold on
plot(yhat,'r')
plot(yVal,'k')
hold off
grid;shg
legend('Yhat','Y_{val}')
title('Prediction, MSE = ', mse_pred)

subplot 223 
hold on
plot(yhatId,'m')
plot(yId,'r')
grid;shg
hold off
legend('Yhat_{id}','Y_{id}')
title('Sim id, MSE = ', mse_id)

subplot 224
hold on
plot(yHat2,'m')
plot(yVal,'r')
hold off
grid;shg
legend('Yhat_{sim}','Y_{val}')
title('Simulation, MSE = ', mse_sim)


%All the functions that we need in order to run
