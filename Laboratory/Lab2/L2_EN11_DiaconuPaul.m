%% Laboratory 2
% First we load our sets of data
clc
clear all
load lab2_15.mat

%% For identification data
clc
id_input = id.X;
id_output = id.Y;

plot(id_input,id_output);

n = 20;
len = length(id_input);

Phi_matrix = zeros(length(id_input), n);

for i=1:len
    for j=1:n
        Phi_matrix(i, j) = id_input(i)^(j-1);
    end
end

id_output_transposed = id_output';
Theeta = Phi_matrix \ id_output_transposed;
Y_hat = Phi_matrix * Theeta;

Mean_Squared_Error = sum((id_output' - Y_hat).^2) / len;
hold on
plot(id_input,Y_hat);
title('Error = ', num2str(Mean_Squared_Error));
legend('Function','Approximation');
%%

% %% For validation data
% clc
% %Extract into a variable
% val_input = val.X;
% val_output = val.Y;
% 
% Phi_matrix2 = zeros(length(val_input), 20);
% 
% len = length(val_input);
% 
% %Making through the same idea the phi_matrix2 then the
% %MSE vector which contains the minimum error
% n = 20;
% 
% for k = 2:n
%     for i = 1:len
%         for j = 1:k
%             Phi_matrix2(i,j) = val_input(i)^(j-1);
%         end
%     end
%     
%     val_output_transposed = val_output';
%     Theeta = Phi_matrix2 \ val_output_transposed;
%     
%     Y_hat = Phi_matrix2 * Theeta;
% 
% 
%         MSE_sum=0;
%         for i = 1:len
%             MSE_sum = MSE_sum + ((val_output_transposed(i) - Y_hat(i)).^2);
%         end
%         MSE(k)=MSE_sum*(1/len);
% end
% 
% plot(MSE);
% %we found out from the graph that the minimum value of the error is 4 for
% %my case

%% Validation after we found out the minimum value
val_input = val.X;
val_output = val.Y;

%j will be four because we only need four columns
len = length(val_input);
    for i = 1:len
        for j = 1:n
            Phi_matrix2(i,j) = val_input(i)^(j-1);
        end
    end
    
val_output_transposed = val_output';
Theeta2 = Phi_matrix2 \ val_output_transposed;
    
Y_hat = Phi_matrix2 * Theeta2;

plot(val_output);
hold
plot(Y_hat);
shg;grid
legend('True Value','Approximated')



