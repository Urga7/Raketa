function [t, Y] = euler(f, interval, Y0, h)
% [t, Y] = euler(f, [t0, tk], Y0, h) solves the DE
% Y' = f(t, Y) at initial condition Y(t0) = Y0 using Euler's method
% with step size h on the interval [t0, tk].

%Array of values for each time step
t = interval(1):h:interval(2);

%Array to store the position at each time step
Y = zeros(length(Y0), length(t));
Y(:, 1) = Y0;

%Run Eulers method
for k = 2:length(t)
	Y(:, k) = Y(:, k-1) + h*f(t(k-1), Y(:, k-1));
end
