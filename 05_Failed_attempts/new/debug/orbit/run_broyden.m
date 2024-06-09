% x0: [fuel, t0, omega]
x0 = [5560; 22.0441; 0.0350585];
F = @mapping;
tol = 1e-8;
maxit = 10;
format long g;
broyden_experimental(x0, F, tol, maxit)
