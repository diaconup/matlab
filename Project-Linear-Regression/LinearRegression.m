clc
clear all
load proj_fit_01.mat
x1Id = id.X{1,1};
x2Id = id.X{2,1};
y_id = id.Y;

x1_val = val.X{1,1};
x2_val = val.X{2,1};
y_val = val.Y;

%n = 25;
y_reshape = reshape(y_id,1,[]);
y_reshape_transposed = y_reshape';

y_reshape_val = reshape(y_val,1,[]);
y_reshape_transposed_val = y_reshape_val';

nr = 1;
%We found out that the best MSE is at 23
for n = 1:30
    X = zeros(n);
    P = pascal_triangle(n);
    phi_id = zeros(length(x1Id)*length(x2Id),nnz(P));
    pos = 1;
    for e1 = 1:length(x1Id) 
        for e2 = 1:length(x2Id)
            X = zeros(n);
            for i = 1:n
                p2 = 0;
                for p1 = i-1:-1:0
                    X(i,p2+1) = X(i,p2+1) + x1Id(e1)^(p1) * x2Id(e2)^(p2);
                    if X(i,p2+1) == 0
                        X(i,p2+1) = 's';
                    end
                    p2 = p2 + 1;
                end
            end
            X = transpose(X);
            X = X(:);
            X = transpose(X);
            X = X(X~=0);
            X(X=='s') = 0;
            for i = 1:length(X)
                phi_id(pos,i) = phi_id(pos,i) + X(i);
            end
            pos = pos + 1;
        end
    end
  % Aici se termina phi_id
  X = zeros(n);
P = pascal_triangle(n);
phi_val = zeros(length(x1_val)*length(x2_val),nnz(P));
pos = 1;
y_reshape = reshape(y_val,1,[]);

for e1 = 1:length(x1_val) 
    for e2 = 1:length(x2_val)
        X = zeros(n);
        for i = 1:n
            p2 = 0;
            for p1 = i-1:-1:0
                X(i,p2+1) = X(i,p2+1) + x1_val(e1)^(p1) * x2_val(e2)^(p2);
                if X(i,p2+1) == 0
                    X(i,p2+1) = 's';
                end
                p2 = p2 + 1;
            end
        end
        X = transpose(X);
        X = X(:);
        X = transpose(X);
        X = X(X~=0);
        X(X=='s') = 0;
        for i = 1:length(X)
            phi_val(pos,i) = phi_val(pos,i) + X(i);
        end
        pos = pos + 1;
    end
end

  %Aici se termina phi_val

    theta = phi_id \ y_id(:);
    y_hat = phi_id * theta; 
    y_hat_val = phi_val * theta;
    MSE(nr) = (1/1681)*sum((y_hat-y_reshape_transposed).^2);
    MSE_val(nr) = (1/5041)*sum((y_hat_val-y_reshape_transposed_val).^2);
    nr = nr + 1;
end

%Now we plot for the best n = 23
for n = 1:23
    X = zeros(n);
    P = pascal_triangle(n);
    phi_id = zeros(length(x1Id)*length(x2Id),nnz(P));
    pos = 1;
    for e1 = 1:length(x1Id) 
        for e2 = 1:length(x2Id)
            X = zeros(n);
            for i = 1:n
                p2 = 0;
                for p1 = i-1:-1:0
                    X(i,p2+1) = X(i,p2+1) + x1Id(e1)^(p1) * x2Id(e2)^(p2);
                    if X(i,p2+1) == 0
                        X(i,p2+1) = 's';
                    end
                    p2 = p2 + 1;
                end
            end
            X = transpose(X);
            X = X(:);
            X = transpose(X);
            X = X(X~=0);
            X(X=='s') = 0;
            for i = 1:length(X)
                phi_id(pos,i) = phi_id(pos,i) + X(i);
            end
            pos = pos + 1;
        end
    end
  % Aici se termina phi_id
  X = zeros(n);
P = pascal_triangle(n);
phi_val = zeros(length(x1_val)*length(x2_val),nnz(P));
pos = 1;
y_reshape = reshape(y_val,1,[]);

for e1 = 1:length(x1_val) 
    for e2 = 1:length(x2_val)
        X = zeros(n);
        for i = 1:n
            p2 = 0;
            for p1 = i-1:-1:0
                X(i,p2+1) = X(i,p2+1) + x1_val(e1)^(p1) * x2_val(e2)^(p2);
                if X(i,p2+1) == 0
                    X(i,p2+1) = 's';
                end
                p2 = p2 + 1;
            end
        end
        X = transpose(X);
        X = X(:);
        X = transpose(X);
        X = X(X~=0);
        X(X=='s') = 0;
        for i = 1:length(X)
            phi_val(pos,i) = phi_val(pos,i) + X(i);
        end
        pos = pos + 1;
    end
end

  %Aici se termina phi_val

    theta = phi_id \ y_id(:);
    y_hat = phi_id * theta; 
    y_hat_val = phi_val * theta;
    nr = nr + 1;
end

figure
mesh(reshape(y_hat,[41,41]),'FaceColor','green')
hold
mesh(y_id,'FaceColor','red')

figure
mesh(reshape(y_hat_val,[71,71]))
hold
mesh(y_val,'FaceColor','red')

figure
plot(MSE_val)
hold
plot(MSE)