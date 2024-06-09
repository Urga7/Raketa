function [t, Y] = rk4(f, interval, Y0, param, h)
% [t, Y] = rk4(f, [t0, tk], Y0, h) solves the DE
% Y' = f(t, Y) at initial condition Y(t0) = Y0 using the standard
% 4th order Runge-Kutta method with step size h on the interval [t0, tk].

%CONSTANTS
earth_radius = 6.37 * 1e6; % [m]
iss_height = 408000; % [m]

%STARTING PARAMETERS
fuel = param(1);
t0 = param(2);
omega = param(3);

%Array of values for each time step
t = interval(1):h:interval(2);

%Array to store the position at each time step
Y = zeros(length(Y0), length(t));
Y(:, 1) = Y0;

%Run Runge-Kutta method
for k = 1:(length(t) - 1)

	%Evaluate k1, ..., k4
  k1 = h*f(t(k), Y(:, k), fuel, t0, omega);
  k2 = h*f(t(k) + h/2, Y(:, k) + k1/2, fuel, t0, omega);
  k3 = h*f(t(k) + h/2, Y(:, k) + k2/2, fuel, t0, omega);
  k4 = h*f(t(k) + h, Y(:, k) + k3, fuel, t0, omega);

	%Add the weighted average to Y
	Y(:, k + 1) = Y(:, k) + (k1 + 2*k2 + 2*k3 + k4) / 6;

  %Check if the rocket has crashed
  pos = [Y(1, k + 1); Y(2, k + 1)];
  if norm(pos) - earth_radius < 0
    while k < length(t)
      Y(:, k + 1) = Y(:, k);
      k += 1;
    end
    fprintf("Crashed\n");
    return;
  end

end

