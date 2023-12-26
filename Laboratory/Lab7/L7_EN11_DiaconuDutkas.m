%% Laboratory 7
%% We taking the data from the motor
clc
utstart('3');
%u1 = PRBS(200,3,-0.7,0.7);
%u2 = PRBS(200,10,-0.7,0.7);
u = [zeros(20, 1); first_u'; zeros(20, 1); second_u'; zeros(20,1); 0.4*ustep(70)];
[vel, alpha, t] = run(u,'3',0.01);
plot(t,vel);

%% 
clc
clear all
load lab7_data.mat

%u1 = PRBS(200,3,-0.7,0.7);
%u2 = PRBS(200,10,-0.7,0.7);
%We are taking the intervals for the input and output
first_u = u(1:221);
second_u = u(1:442);
Sample_time = 0.01;
first_y = vel(1:221)';
second_y = vel(1:442)';
validation_y = vel';

%We are taking the data from the intervals
first_identification = iddata(first_y,first_u,Sample_time);
second_identification = iddata(second_y,second_u,Sample_time);
validation_data = iddata(validation_y,u,Sample_time);

na = 14;
nb = 14;
nk = 1;

First_model = arx(first_identification,[na nb nk]);
Second_model = arx(second_identification,[na nb nk]);

compare(First_model,Second_model,validation_data);


%%The function of PRBS which we generate our input
function result_matrix = PRBS(N,m,a,b)

Matrix_X = ones(1,m);
Matrix_X = Matrix_X';
%The maximum lenght of a PRBS for case of m
switch m
    case 3
        Matrix_A = [1,0,1];
    case 4
        Matrix_A = [1,0,0,1];
    case 5
        Matrix_A = [0,1,0,0,1];
    case 6
        Matrix_A = [1,0,0,0,0,1];
    case 7
        Matrix_A = [1,0,0,0,0,0,1];
    case 8
        Matrix_A = [1,1,0,0,0,0,1,1];
    case 9
        Matrix_A = [0,0,0,1,0,0,0,0,1];
    case 10
        Matrix_A = [0,0,1,0,0,0,0,0,0,1];
end

%We construct the identity matrix
Identity_Matrix = [];
for i = 1:m
    Identity_Matrix(i,i) = 1;
end

%Now we add it to our main matrix
Identity_Matrix(m,:) = [];
Matrix_A = [Matrix_A;Identity_Matrix];

Matrix_C = zeros(1,m);
Matrix_C(m) = 1;

for k = 1:N
    Matrix_U(k) = Matrix_C*Matrix_X;
    Matrix_U(k) = a + (b-a) * Matrix_U(k);
    Matrix_X = mod(Matrix_A*Matrix_X,2);
end

result_matrix = Matrix_U;
end