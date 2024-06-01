function y = mapping(x)
fuel = x(1);
t0 = x(2);
omega = x(3);
%fprintf("%d\n%d\n%d\n", fuel, t0, omega);

f = @derivative;

%CONSTANTS
earth_radius = 6.37 * 1e6; % [m]
iss_height = 408000; % [m]

%FIXED PARAMETERS
h = 0.1;

%fukncija mapping(x) resi DE
%Y' = f(t, Y) pri zacetnem pogoju Y(t=0) = Y0 in zacetnimi parametri x
%s standardno Runge-Kutta metodo 4. reda s korakom h na intervalu [t=0, t=k].

%pripravimo vrednosti Y
pos_init = [0;earth_radius];
vel_init = [0;0];
Y = [pos_init; vel_init];
t = 0;

%pozenemo Runge-Kutta metodo
while(true)

	%poracunamo vrednosti k1, ..., k4 in...
	k1 = h*f(t, Y, fuel, t0, omega);
	k2 = h*f(t + h/2, Y + k1/2, fuel, t0, omega);
	k3 = h*f(t + h/2, Y + k2/2, fuel, t0, omega);
	k4 = h*f(t + h, Y + k3, fuel, t0, omega);
	%... dodamo utezeno povprecje teh vrednosti Y
	Y = Y + (k1 + 2*k2 + 2*k3 + k4)/6;


	pos = [Y(1); Y(2)];
	pos_norm = norm(pos);

	angle_relative = max(0, (t-t0)*omega);
	angle_norm = get_angle(pos, angle_relative);

	%preverimo ce je raketa prisla do ISS, ce je strmoglavila ali ce se je zacela obracati proti zemlji
	if pos_norm - earth_radius >= iss_height || pos_norm - earth_radius < 0 || angle_norm > pi/2

		vel = [Y(3); Y(4)];
		vel_norm = norm(vel);

		distance_error = (pos_norm-(earth_radius+iss_height))^2;
		angle_error = (angle_norm - pi/2)^2;
		velocity_error = (vel_norm - 7665)^2;


		fprintf("fuel: %d\nt0: %d\nomega: %d\n\n", fuel, t0, omega);
		fprintf("distance: %d\nangle: %d\nvelocity: %d\n-------------\n", pos_norm-earth_radius, rad2deg(angle_norm), vel_norm);
		%fprintf("distance error: %d\nangle error: %d\nvelocity error: %d\n\n", distance_error, angle_error, velocity_error);

		y = [distance_error; angle_error; velocity_error];

		break;


	end

	t = t + h;

end

