function Y = rocket_derivative(time, Y, has_fuel = false, tilt_speed = 0)

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
vel_init = [Y(3); Y(4)];
fuel_init = Y(5);
angle_init = Y(6);

pos_derivative = vel_init;
vel_derivative = 0;
fuel_derivative = -fuel_consumption;
angle_derivative = tilt_speed;

if has_fuel
  vel_derivative = (-(0.5 * base_air_density * (1 / exp((sqrt(pos_init(1)^2 + pos_init(2)^2) - earth_radius) / 8200)) * (sqrt(vel_init(1)^2 + vel_init(2)^2) * vel_init) * cross_section_area * drag_coeficient) / (dry_mass + fuel_init) ...
               + [-((G * earth_mass) / sqrt(pos_init(1)^2 + pos_init(2)^2)^2) * (pos_init(1) / sqrt(pos_init(1)^2 + pos_init(2)^2)); -((G * earth_mass) / sqrt(pos_init(1)^2 + pos_init(2)^2)^2) * (pos_init(2) / sqrt(pos_init(1)^2 + pos_init(2)^2))] ...
               + [fuel_consumption * fuel_ejection_speed * (1 / (dry_mass + fuel_init)) * sin(angle_init); fuel_consumption * fuel_ejection_speed * (1 / (dry_mass + fuel_init)) * cos(angle_init)]);
end
if !has_fuel
  fuel_derivative = 0;
  vel_derivative = (-(0.5 * base_air_density * (1 / exp((sqrt(pos_init(1)^2 + pos_init(2)^2) - earth_radius) / 8200)) * (sqrt(vel_init(1)^2 + vel_init(2)^2) * vel_init) * cross_section_area * drag_coeficient) / (dry_mass) ...
               + [-((G * earth_mass) / sqrt(pos_init(1)^2 + pos_init(2)^2)^2) * (pos_init(1) / sqrt(pos_init(1)^2 + pos_init(2)^2)); -((G * earth_mass) / sqrt(pos_init(1)^2 + pos_init(2)^2)^2) * (pos_init(2) / sqrt(pos_init(1)^2 + pos_init(2)^2))]);
end

Y = [pos_derivative; vel_derivative; fuel_derivative; angle_derivative];
