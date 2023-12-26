%% Laboratory 8
%% We taking the data from the motor
clc
utstart('6');
u1 = PRBS(300,3,-0.8,0.8);
uzeros = zeros(20, 1);
ustep = 0.3*ustep(70);
u = [uzeros; u1'; uzeros; ustep];
[vel, alpha, t] = run(u,'6',0.01);
plot(t,vel);
%%
clc
clear all
load("lab9_data.mat");
Ts = 0.01; % the sampling time

% taking the identification data from the motor
identification_y = vel(1:321)';
identification_u = u(1:321);

% taking the validation data from the motor
validation_y = vel(322:length(vel))';
validation_u = u(322:length(u));

% creeating a model with the taken data for identification and validation
validation_model = iddata(validation_y,validation_u,Ts);
identification_model = iddata(identification_y,identification_u,Ts);

% initializing na,nb and nk with the same valuse as we used in previous
% labs
na=14; nb=14; nk=1;

% creating the arx moden and the yhat
model_arx = arx(identification_model,[na nb nk]);
model_yhat = sim(model_arx,identification_u);

% taking the lenght of the model in the variable N
N=length(model_yhat);

% initializing our phi tildae matrxi and our phi tilade final matrix with
% zeros
Phi_tildae_matrix=zeros(na+nb,na+nb);
Phi_tildae_final_matrix=zeros(na+nb,na+nb);

% in this variable we will calculate the final sum with the given formula
Y_final_sum=0;

for i=1:N
    Z_matrix=zeros(1,na+nb); % initializing the Z matrix with zeros
    Phi_matrix=zeros(1,na+nb); % initializing the Phi matrix with zeros
    % we do the same proccess as we did in the lab with the ARX
    for j=1:na
        if i-j>0
            Z_matrix(j)=model_yhat(i-j);
            Z_matrix(j+na)=identification_u(i-j);
            
            Phi_matrix(j)=-identification_y(i-j);
            Phi_matrix(j+na)=identification_u(i-j);
        end
    end
    % transposing the Z matrix to be able to calculate in the formula
    Z_matrix=Z_matrix';

    % Using the formulas given in the course to calculate our Phi tildae
    % and the Y tildae matrices
    Phi_tildae_matrix=Z_matrix*Phi_matrix;
    Y_thilda=Z_matrix*identification_y(i);

    % calculating the final phi tildae matrix  
    Phi_tildae_final_matrix=Phi_tildae_final_matrix+Phi_tildae_matrix;
    
    % calculating the final Y value
    Y_final_sum=Y_final_sum+Y_thilda;
end

% dividing the matrix by the lenght of our model, like in the formula
Phi_tildae_final_matrix=Phi_tildae_final_matrix/N;
% dividing the Y sum by N, like in the formula
Y_final_sum=Y_final_sum/N;

% calculating the theta matrix
Theta_matrix=Phi_tildae_final_matrix\Y_final_sum;
% transposing theta matrix
Theta_tran=Theta_matrix';

% creating the A and B matrix using the values in the theta matrix
A_matrix=[1 Theta_tran(1:na)];
B_matrix=[0 Theta_tran(na+1:na+nb)];

% creating our variables using the idpoly function and the matrices we just
% created
instrumental_variables=idpoly(A_matrix,B_matrix,[],[],[],0,Ts);

% comparig the validation mode, with the arx, and the instrumental
% variables we just created
compare(validation_model,model_arx,instrumental_variables);
