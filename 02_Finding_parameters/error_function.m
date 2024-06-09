function y = error_function(x)
%Simulates the rocket takeoff with the given parameters x and
%returns the sum of squares of errors: height error,
%angle error and velocity error

%Extract parameters
fuel = x(1);
t0 = x(2);
omega = x(3);

f = @derivative;

%CONSTANTS
earth_radius = 6.37 * 1e6; % [m]
iss_height = 408000; % [m]

%FIXED PARAMETERS
h = 0.1;

%Initialise variables
pos_init = [0; earth_radius];
vel_init = [0; 0];
Y = [pos_init; vel_init];
t = 0;

%Simulate rocket takeoff with RK4
while(true)

	%Evaluate k1, ..., k4,
	k1 = h*f(t, Y, fuel, t0, omega);
	k2 = h*f(t + h/2, Y + k1/2, fuel, t0, omega);
	k3 = h*f(t + h/2, Y + k2/2, fuel, t0, omega);
	k4 = h*f(t + h, Y + k3, fuel, t0, omega);

	%Add weighted sum to Y
	Y = Y + (k1 + 2*k2 + 2*k3 + k4) / 6;

  %Calculate necessary values to check the status of the rocket
	pos = [Y(1); Y(2)];
	pos_norm = norm(pos);
  vel = [Y(3); Y(4)];
	angle_relative = get_angle(pos, vel);

	%Check if the rocket has reached the ISS height
  %or if it has tilted over 90 degrees
	if pos_norm - earth_radius >= iss_height || angle_relative > (pi/2 + 0.001)

		vel_norm = norm(vel);

    %Calculate the errors
		height_error = (pos_norm-(earth_radius+iss_height))^2;
		angle_error = (angle_relative - pi/2)^2;
		velocity_error = (vel_norm - 7664.9)^2;
    y = [height_error; angle_error; velocity_error];

    %Display feedback
		fprintf("fuel: %d\nt0: %d\nomega: %d\n\n", fuel, t0, omega);
		fprintf("distance: %d\nangle: %d\nvelocity: %d\n-------------\n", pos_norm-earth_radius, rad2deg(angle_relative), vel_norm);
		break;

	end

  %Increment time
	t = t + h;

end

