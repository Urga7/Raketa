% CONSTANTS:
G = 6.67 * 1e-11; % [m^3 / (kg * s^2)]
earth_mass = 5.97 * 1e24; % [kg]
earth_radius = 6.37 * 1e6; % [m]
base_air_density = 1.20; % [kg / m^3] at 20 deg C, sea level.

fuel_capacity = 3054; % [kg]
tilt_start_time = 33; % [s] Time at which the angle of the rocket start changing linearly
tilt_speed = 0.02008; % [rad / s]
initial_angle = 0; % [deg]
initial_position = [0; earth_radius];
initial_vel = [0; 0];
dt = 0.1; % [s] Time step
simulation_duration = 100000; % [s]
show_plot = false;
real_time = false;

%[max_altitude, airtime, top_speed] = rocketRK(fuel_capacity, tilt_start_time, tilt_speed, initial_angle, initial_vel, initial_position, dt, simulation_duration, show_plot, real_time);
%return;

it = 0
for tilt_speed = 0.02: 0.000001 : 0.023
  it += 1
  [max_altitude, airtime, top_speed] = rocketRK(fuel_capacity, tilt_start_time, tilt_speed, initial_angle, initial_vel, initial_position, dt, simulation_duration, show_plot, real_time);
end

