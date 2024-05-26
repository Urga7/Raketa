fuel_capacity = 2500; % [kg]
angle = 0; % [rad] (positive = couter-clockwise ?)
tilt_start_time = 100; % [s] Time at which the angle of the rocket start changing linearly
tilt_speed = 0.003; % [rad / s]
dt = 0.1; % [s] Time step
simulation_duration = 5000; % [s]

max_altitude = rocket(fuel_capacity, tilt_start_time, tilt_speed, dt, simulation_duration)
