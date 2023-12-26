% We use a function to construct a matrix which contains all possible
% exponents from a multinomial with n terms and order m
function exponents = generateExponents(n, rest, currExp)
% We give the base case condition, where we introduce the rest
% (A value which is decremented from m order), into a new line of exponents
    if n == 1
        exponents = [currExp, rest];
    else
        exponents = []
        for i = 0:rest
            % We generate through recursivity, all possible combinations of
            % exponents by continuously decrementing the number of term
            % till we get to the base case and also decrementing the rest
            % (rest-i + i = rest)
            subExp = generateExponents(n-1,rest-i,[currExp i]);
            % We construct a new line
            exponents = [exponents; subExp];
        end
    end
end