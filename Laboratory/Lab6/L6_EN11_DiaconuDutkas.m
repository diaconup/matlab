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

%%
clc
clear all
load lab6_data.mat

yid = vel(22:221);
uid = u(22:221);
tid = t(22:221);

na = 14;
nb = 14;

len = length(yid);

Phi=zeros(len,na+nb);

for i=1:len
    if i<na
    for j=1:i-1
        Phi(i,j)=-yid(i-j);
        Phi(i,nb+j)=uid(i-j);
    end
    end
    if i>=na 
    for j=1:nb-1
        Phi(i,j)=-yid(i-j);
        Phi(i,nb+j)=uid(i-j);
    end
    end
end


Theta=Phi\yid';
yaprox=Phi*Theta;
figure;
hold
plot(tid,yid);
plot(tid, yaprox);


mse=1/length(yid)*sum((yid'-yaprox).^2)
title("Prediction id =",num2str(round(mse)));
hold off;
%%
clc
yval = vel(251:length(vel));
uval = u(251:length(u));
tval = t(251:length(t));

na = 14;
nb = 14;

len_val = length(yval);

Phi_val=zeros(len_val,na+nb);

for i=1:len_val
    if i<na
    for j=1:i-1
        Phi_val(i,j)=-yval(i-j);
        Phi_val(i,nb+j)=uval(i-j);
    end
    end
    if i>=na 
    for j=1:nb-1
        Phi_val(i,j)=-yval(i-j);
        Phi_val(i,nb+j)=uval(i-j);
    end
    end
end


yaprox_val=Phi_val*Theta;
figure;
hold
plot(tval,yval);
plot(tval, yaprox_val);


mse=1/length(yval)*sum((yval'-yaprox_val).^2)
title("Prediction id =",num2str(round(mse)));
hold off;

%%

N=length(yaprox_val);
ysim=zeros(N,1);
Phi_sim=zeros(1,na+nb);

for i=2:N
ysim(i)=(Theta')*Phi_sim';
    if i<na
    for j=1:i-1
        Phi_sim(j)=-yaprox_val(i-j+1);
        Phi_sim(na+j)=uval(i-j+1);
    end
    end
    if i>=na 
    for j=1:na-1
        Phi_sim(j)=-yaprox_val(i-j+1);
        Phi_sim(na+j)=uval(i-j+1);
    end
    end
end

figure;
hold
plot(yaprox_val(1:length(ysim)));
plot(ysim);

mse_sim=1/length(yaprox_val)*sum((yaprox_val-ysim).^2)
title("Simulation id =",num2str(round(mse_sim)));
hold off;
