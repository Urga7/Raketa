F = @error_function;
tol = 1e-8;
maxit = 300;
format long g;

%INITIAL GUESS (has to be very percise for the method to work)
x0 = [5600; 26; 0.036];
broyden(x0, F, tol, maxit);
