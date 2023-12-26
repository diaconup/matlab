function [phipol] = Poly(l1,m)
phipol = [];
L = [];
exp = [];
for i=1:m
    % With the help of the recursive function, we construct the exponent
    % matrix which is comprised of concatenated matrices whose line sum is
    % equal to i
    exp = [exp; generateExponents(length(l1),i,[])];
end
i = 1;
% We create the polynomial matrix which contains the terms of the
% polynomials with order <= m
while(i<=length(exp(:,1)))
    Prod = 1;
    for j = 1:length(l1)
        Prod = Prod * l1(j)^exp(i,j);
    end
    phipol = [phipol Prod];
    i = i+1;
end
end