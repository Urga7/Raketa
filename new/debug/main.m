x0 = [3267.9; 13.06; 0.0146417];
F = @mapping;
tol = 1e-9;
maxit = 1000000;
format long g;
broyden(x0, F, tol, maxit)
