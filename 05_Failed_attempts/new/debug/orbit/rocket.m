function rocket()

%CONSTANTS
earth_radius = 6.37 * 1e6; % [m]

%FIXED PARAMETERS
t_start = 0;
t_end = 4000;
interval = [t_start, t_end];
pos_init = [0; earth_radius];
vel_init = [0; 0];
Y0 = [pos_init; vel_init];
dt = 0.1;

%STARTING PARAMETERS
%fuel = 5560;
%t0 = 22.0441;
%omega = 0.0350585;

fuel = 5560;
t0 = 0;
omega = 0.0263778;
param = [fuel, t0, omega];

format short g;
%mapping(param)
[t_rk, Y_rk] = rk4_orbit(@derivative, @derivative_orbit, interval, Y0, param, dt);
%[t_rk, Y_rk] = rk4(@derivative, interval, Y0, param, dt);
%[t_euler, Y_euler] = euler(@derivative, interval, Y0, dt);

figure;
hold on;
axis equal;
xlim([-1.5*earth_radius 1.5*earth_radius]);
ylim([-1.5*earth_radius 1.5*earth_radius]);
rectangle('Position', [-earth_radius, -earth_radius, 2*earth_radius, 2*earth_radius], 'Curvature', [1, 1], 'FaceColor', [0.8, 0.8, 0.8]);
plot(Y_rk(1, :), Y_rk(2, :));
%plot(Y_euler(1, :), Y_euler(2, :));
