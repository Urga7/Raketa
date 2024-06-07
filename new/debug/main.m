x0 = [3100; 5; 0.017];
F = @mapping;
tol = 1e-7;
maxit = 1000000;
format long g;
broyden(x0, F, tol, maxit)
