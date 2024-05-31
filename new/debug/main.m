x0 = [3050; 0; 0.012];
F = @mapping;
tol = 1e-7;
maxit = 1000000;
broyden(x0, F, tol, maxit)
