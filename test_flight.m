fuel_capacity = 2500; % [kg]
tilt_start_time = 100; % [s] Time at which the angle of the rocket start changing linearly
tilt_speed = 0.001; % [rad / s]
initial_angle = 1; % [deg]
dt = 0.1; % [s] Time step
simulation_duration = 10000; % [s]
show_plot = true;
real_time = false;

tic;
[max_altitude, airtime, top_speed] = rocket(fuel_capacity, tilt_start_time, tilt_speed, initial_angle, dt, simulation_duration, show_plot, real_time)
toc

