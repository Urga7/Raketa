function [Y_prime] = derivative(t, Y, fuel_capacity, t0, omega)

% FIXED PARAMETERS:
dry_mass = 800; % [kg]
fuel_consumption = 60; % [kg / s]
fuel_ejection_speed = 5500; % [m / s]
cross_section_area = 0.5; % [m^2]
drag_coeficient = 0.2;

% CONSTANTS:
G = 6.67 * 1e-11; % [m^3 / (kg * s^2)]
earth_mass = 5.97 * 1e24; % [kg]
earth_radius = 6.37 * 1e6; % [m]
base_air_density = 1.20; % [kg / m^3] at 20 deg C, sea level_init.

angle = max(0, (t - t0) * omega);
x = Y(1);
y = Y(2);
pos_norm = norm([x; y]);
vel_init = [Y(3); Y(4)];
vel_norm = norm(vel_init);

fuel = max(0, fuel_capacity - t * fuel_consumption);
mass = dry_mass + fuel;

height = pos_norm - earth_radius;
air_density = base_air_density / (exp(height) * 8200);
drag = -(0.5 * air_density * (vel_norm * vel_init) * cross_section_area * drag_coeficient) / mass;

r2 = x^2 + y^2;
g_norm = -((G * earth_mass) / r2);
g = [g_norm * (x / pos_norm); g_norm * (y / pos_norm)];

thrust_norm = 0;
if fuel > 0
  thrust_norm = (fuel_consumption * fuel_ejection_speed) / mass;
end
thrust = [thrust_norm * sin(angle); thrust_norm * cos(angle)];

accel = drag + g + thrust;

Y_prime = [vel_init; accel];