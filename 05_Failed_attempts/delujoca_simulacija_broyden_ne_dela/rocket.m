function rocket()

%CONSTANTS
earth_radius = 6.37 * 1e6; % [m]

%FIXED PARAMETERS
t_start = 0;
t_end = 8000;
interval = [t_start, t_end];
pos_init = [0; earth_radius];
vel_init = [0; 0];
Y0 = [pos_init; vel_init];
dt = 0.1;

%STARTING PARAMETERS
fuel = 5560;
t0 = 22.0441;
omega = 0.0350585;
param = [fuel, t0, omega];

format short g;
[t_rk, Y_rk] = rk4_orbit(@derivative, @derivative_orbit, interval, Y0, param, dt);

figure;
hold on;
axis equal;
xlim([-1.5*earth_radius 1.5*earth_radius]);
ylim([-1.5*earth_radius 1.5*earth_radius]);
rectangle('Position', [-earth_radius, -earth_radius, 2*earth_radius, 2*earth_radius], 'Curvature', [1, 1], 'FaceColor', [0.8, 0.8, 0.8]);
plot(Y_rk(1, :), Y_rk(2, :));
