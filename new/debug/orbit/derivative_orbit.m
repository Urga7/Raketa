function [Y_prime] = derivative_orbit(t, Y, time_orbit, t0, omega, omega_orbit)

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

pos_init = [Y(1); Y(2)];
pos_norm = norm(pos_init);
x = Y(1);
y = Y(2);
vel_init = [Y(3); Y(4)];
vel_norm = norm(vel_init);

fuel = 0;
mass = dry_mass + fuel;
r2 = x^2 + y^2;
g_norm = -((G * earth_mass) / r2);
g = [g_norm * (x / pos_norm); g_norm * (y / pos_norm)];

%angle = max(0, pi/2 + ((t - time_orbit) * 0.0011314));
angle = max(0, (time_orbit - t0) * omega) + ((t - time_orbit) * omega_orbit);
%rad2deg(get_angle(pos_init, angle));

accel = g;

vel = [vel_norm * sin(angle); vel_norm * cos(angle)];

Y_prime = [vel; accel];
