% x0: [fuel, t0, omega]
x0 = [5569; 22; 0.035];
F = @mapping;
tol = 1e-8;
maxit = 10;
format long g;
broyden_experimental(x0, F, tol, maxit)
