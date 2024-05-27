function Y = rocket_derivative(time, Y, has_fuel = true, tilting = true)

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

% TODO
tilt_speed = 0.003;

pos_init = [Y(1); Y(2)];
vel_init = [Y(3); Y(4)];
fuel_init = Y(5);

pos_derivative = vel_init;
vel_derivative = 0;
fuel_derivative = 60;

if has_fuel && tilting
  % TODO: FIX COURSE CORRECTION (ANGLE)
    vel_derivative = [norm(((-(0.5 * base_air_density * (1 / exp((sqrt(pos_init(1)^2 + pos_init(2)^2) - earth_radius) / 8200)) * (sqrt(vel_init(1)^2 + vel_init(2)^2) * vel_init) * cross_section_area * drag_coeficient) / (dry_mass + fuel_init) ...
          + [-((G * earth_mass) / sqrt(pos_init(1)^2 + pos_init(2)^2)^2) * (pos_init(1) / sqrt(pos_init(1)^2 + pos_init(2)^2)); -((G * earth_mass) / sqrt(pos_init(1)^2 + pos_init(2)^2)^2) * (pos_init(2) / sqrt(pos_init(1)^2 + pos_init(2)^2))] ...
          + [fuel_consumption * fuel_ejection_speed * (1 / (dry_mass + fuel_init)) * sin(tilt_speed * time); fuel_consumption * fuel_ejection_speed * (1 / (dry_mass + fuel_init)) * cos(tilt_speed * time)]))) * sin(tilt_speed * time); ...
         norm(((-(0.5 * base_air_density * (1 / exp((sqrt(pos_init(1)^2 + pos_init(2)^2) - earth_radius) / 8200)) * (sqrt(vel_init(1)^2 + vel_init(2)^2) * vel_init) * cross_section_area * drag_coeficient) / (dry_mass + fuel_init) ...
          + [-((G * earth_mass) / sqrt(pos_init(1)^2 + pos_init(2)^2)^2) * (pos_init(1) / sqrt(pos_init(1)^2 + pos_init(2)^2)); -((G * earth_mass) / sqrt(pos_init(1)^2 + pos_init(2)^2)^2) * (pos_init(2) / sqrt(pos_init(1)^2 + pos_init(2)^2))] ...
          + [fuel_consumption * fuel_ejection_speed * (1 / (dry_mass + fuel_init)) * sin(tilt_speed * time); fuel_consumption * fuel_ejection_speed * (1 / (dry_mass + fuel_init)) * cos(tilt_speed * time)]))) * cos(tilt_speed * time)];
end

Y = [pos_derivative; vel_derivative; fuel_derivative];
