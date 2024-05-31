x0 = [3000; 0; 0.012];
F = @mapping;
tol = 1e-8;
maxit = 1000000;
broyden(x0, F, tol, maxit)
