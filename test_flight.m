fuel_capacity = 2500; % [kg]
tilt_start_time = 50; % [s] Time at which the angle of the rocket start changing linearly
tilt_speed = 0.001; % [rad / s]
initial_angle = 0; % [deg]
dt = 10; % [s] Time step
simulation_duration = 10000; % [s]
show_plot = false;
real_time = false;

tic;
[max_altitude, airtime, top_speed] = rocket(fuel_capacity, tilt_start_time, tilt_speed, initial_angle, dt, simulation_duration, show_plot, real_time)
toc

