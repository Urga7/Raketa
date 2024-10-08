function y = mapping(x)
	fuel = x(1);
	t0 = x(2);
	omega = x(3);

  %fprintf("%d\n%d\n%d\n", fuel, t0, omega);

	f = @derivative;

	%CONSTANTS
	earth_radius = 6.37 * 1e6;
	iss_height = 408000;

	%FIXED PARAMETERS
	h = 0.1;

	%[t, Y] = rk4(f, [t0, tk], Y0, h) resi DE
	%Y' = f(t, Y) pri zacetnem pogoju Y(t0) = Y0 s standardno
	%Runge-Kutta metodo 4. reda s korakom h na intervalu [t0, tk].

	%pripravimo vrednosti Y
  	pos_init = [0;earth_radius];
  	vel_init = [0;0];
	Y = [pos_init; vel_init];
	t = 0;

	%pozenemo Runge-Kutta metodo
	while(true)
		t = t + h;
		%poracunamo vrednosti k1, ..., k4 in...
		k1 = h*f(t, Y, fuel, t0, omega);
		k2 = h*f(t + h/2, Y + k1/2, fuel, t0, omega);
		k3 = h*f(t + h/2, Y + k2/2, fuel, t0, omega);
		k4 = h*f(t + h, Y + k3, fuel, t0, omega);
		%... dodamo utezeno povprecje teh vrednosti Y
		Y = Y + (k1 + 2*k2 + 2*k3 + k4)/6;


		pos = [Y(1); Y(2)];
		pos_norm = norm(pos);
    	vel = [Y(3); Y(4)];
    	angle_norm = (alpha(pos_init, max(0, (t-t0)*omega)));


		if pos_norm - earth_radius >= iss_height || pos_norm - earth_radius <= 0 || angle_norm > pi/2


		  	vel_norm = norm(vel);

			  distance_error = 0;
      		angle_error = abs(angle_norm^2 - (pi/2)^2);
      		velocity_error = abs(vel_norm^2 - 7665^2);

      		fprintf("distance error: %d\nangle error: %d\nvelocity error: %d\n\n", distance_error, angle_error, velocity_error);

			y = [distance_error; angle_error; velocity_error];

     		break;

		end

	end

