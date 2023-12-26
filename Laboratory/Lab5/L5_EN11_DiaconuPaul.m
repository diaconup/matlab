%% Laboratory 5
%% We are doing for the identification data
clc
utstart('3');
u = [zeros(20, 1); 1.4*rand(600,1) - 0.7; zeros(20,1); 0.2*ustep(70)];
[vel, alpha, t] = run(u,'3',0.01);
plot(t,vel);


%% We are doing it for the identifcaiton
clc
clear all
load lab5_data.mat

y = vel(21:621);

M = 40;

len = length(y);
ryu=zeros(1,length(y));
ru=zeros(1,length(y));

for i=1:len
    ru_s = 0;
    ryu_s = 0;
        for k = 1:len-i
            ru_s = ru_s + u(k+i-1) * u(k);
            ryu_s = ryu_s + y(k+i-1) * u(k);
        end
    ru(i) = ru_s;
    ryu(i) = ryu_s;
end
ru = ru/len;
ryu = ryu/len;

Ru = zeros(len,M);
for i = 1:len
    for j = 1:M
        Ru(i,j) = ru(abs(j-i)+1);
    end     
end

H = Ru \ ryu';
    
yaprox = conv(H,u);
yaprox = yaprox(1:length(u));
y_tr = vel';
error = 1/length(vel)* sum((vel'-yaprox).^2);

figure;
hold
plot(t,vel);
plot(t,yaprox)