function [t, Y] = rk4_orbit(f, f_orbit, interval, Y0, param, h)
%[t, Y] = rk4(f, [t0, tk], Y0, h) resi DE
%Y' = f(t, Y) pri zacetnem pogoju Y(t0) = Y0 s standardno
%Runge-Kutta metodo 4. reda s korakom h na intervalu [t0, tk].

%CONSTANTS
earth_radius = 6.37 * 1e6; % [m]
iss_height = 408000; % [m]

%STARTING PARAMETERS
fuel = param(1);
t0 = param(2);
omega = param(3);

%pripravimo vrstico casov t
t = interval(1):h:interval(2);

%pripravimo vrednosti Y
Y = zeros(length(Y0), length(t));
Y(:, 1) = Y0;

in_orbit = false;
omega_orbit = 0;
time_orbit = 0;
crashed = false;

%pozenemo Runge-Kutta metodo
for k = 1:(length(t) - 1)

	%poracunamo vrednosti k1, ..., k4 in...
  if in_orbit
    k1 = h*f_orbit(t(k), Y(:, k), time_orbit, t0, omega, omega_orbit);
    k2 = h*f_orbit(t(k) + h/2, Y(:, k) + k1/2, time_orbit, t0, omega, omega_orbit);
    k3 = h*f_orbit(t(k) + h/2, Y(:, k) + k2/2, time_orbit, t0, omega, omega_orbit);
    k4 = h*f_orbit(t(k) + h, Y(:, k) + k3, time_orbit, t0, omega, omega_orbit);
  else
    k1 = h*f(t(k), Y(:, k), fuel, t0, omega);
    k2 = h*f(t(k) + h/2, Y(:, k) + k1/2, fuel, t0, omega);
    k3 = h*f(t(k) + h/2, Y(:, k) + k2/2, fuel, t0, omega);
    k4 = h*f(t(k) + h, Y(:, k) + k3, fuel, t0, omega);
  end

	%... dodamo utezeno povprecje teh vrednosti Y
  if crashed
    Y(:, k + 1) = Y(:, k);
  else
	  Y(:, k + 1) = Y(:, k) + (k1 + 2*k2 + 2*k3 + k4)/6;
  end

  pos = [Y(1, k+1); Y(2, k+1)];
	pos_norm = norm(pos);

  angle_relative = max(0, (t(k + 1)-t0)*omega);
	angle_norm = get_angle(pos, angle_relative);

	if !in_orbit && (pos_norm - earth_radius - iss_height) <= 0
      %rad2deg(angle_norm)
      vel = norm(Y(3:4,k+1));
      omega_orbit = vel / pos_norm;
      in_orbit = true;
      time_orbit = t(k + 1);
  end

  if !crashed && pos_norm - earth_radius < 0
    fprintf("Crashed\n");
    crashed = true;
  end

end

