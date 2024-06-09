function [t, Y] = rk4(f, interval, Y0, param, h)
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

%pozenemo Runge-Kutta metodo
for k = 1:(length(t) - 1)

	%poracunamo vrednosti k1, ..., k4 in...
	k1 = h*f(t(k), Y(:, k), fuel, t0, omega);
	k2 = h*f(t(k) + h/2, Y(:, k) + k1/2, fuel, t0, omega);
	k3 = h*f(t(k) + h/2, Y(:, k) + k2/2, fuel, t0, omega);
	k4 = h*f(t(k) + h, Y(:, k) + k3, fuel, t0, omega);
	%... dodamo utezeno povprecje teh vrednosti Y
	Y(:, k + 1) = Y(:, k) + (k1 + 2*k2 + 2*k3 + k4)/6;

  pos = [Y(1, k+1); Y(2, k+1)];
	pos_norm = norm(pos);

  angle_relative = max(0, (t(k+1)-t0)*omega);
	angle_norm = get_angle(pos, angle_relative);

	if abs(pos_norm - earth_radius - iss_height) <= 20 %|| pos_norm - earth_radius < 0 || angle_norm > pi/2
      rad2deg(angle_norm)
      pos_norm-earth_radius
      norm(Y(3:4,k+1))
      return;
  end

end

