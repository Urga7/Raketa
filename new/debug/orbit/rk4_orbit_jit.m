function [t, trajectory] = rk4_orbit_jit(f, f_orbit, interval, Y0, param, h)
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

%pripravimo vrednosti Y
trajectory = zeros(length(Y0), interval(2)/h);
Y = Y0;

in_orbit = false;
omega_orbit = 0;
time_orbit = 0;
crashed = false;
t = 0;
k = 0;

%pozenemo Runge-Kutta metodo
while(t < interval(2))

	%poracunamo vrednosti k1, ..., k4 in...
  if in_orbit
    k1 = h*f_orbit(t, Y);
	  k2 = h*f_orbit(t + h/2, Y + k1/2);
	  k3 = h*f_orbit(t + h/2, Y + k2/2);
	  k4 = h*f_orbit(t + h, Y + k3);
  else
    k1 = h*f(t, Y, fuel, t0, omega);
	  k2 = h*f(t + h/2, Y + k1/2, fuel, t0, omega);
	  k3 = h*f(t + h/2, Y + k2/2, fuel, t0, omega);
	  k4 = h*f(t + h, Y + k3, fuel, t0, omega);
  end

	%... dodamo utezeno povprecje teh vrednosti Y
  if crashed
    trajectory(:, k + 1) = Y;
  else
    Y = Y + (k1 + 2*k2 + 2*k3 + k4)/6;
	  trajectory(:, k + 1) = Y;
  end

  pos = [Y(1); Y(2)];
	pos_norm = norm(pos);

  angle_relative = max(0, (t-t0)*omega);
	angle_norm = get_angle(pos, angle_relative);

	if !in_orbit && pos_norm - earth_radius >= iss_height

      vel = norm(Y(3:4))

      pos_norm-iss_height-earth_radius
      rad2deg(angle_norm)

      omega_orbit = vel / pos_norm;
      in_orbit = true;
      time_orbit = t
  end

  if !crashed && pos_norm - earth_radius < 0
    fprintf("Crashed\n");
    crashed = true;
  end


  k = k + 1;
  t = t + h;

end

