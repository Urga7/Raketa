function [Y_prime] = derivative_orbit(t, Y)

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

x = Y(1);
y = Y(2);
pos_norm = norm([x; y]);
vel_init = [Y(3); Y(4)];
vel_norm = norm(vel_init);

mass = dry_mass;
r2 = x^2 + y^2;
g_norm = -((G * earth_mass) / r2);
g = [g_norm * (x / pos_norm); g_norm * (y / pos_norm)];

accel = g;

Y_prime = [vel_init; accel];
