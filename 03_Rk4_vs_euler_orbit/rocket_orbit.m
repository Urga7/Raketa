function rocket_orbit()
%Calculates the trajectory of a rocket in orbit

%CONSTANTS
earth_radius = 6.37 * 1e6; % [m]
iss_height = 408000; % [m]

%FIXED PARAMETERS
t_start = 0;
t_end = 30000;
interval = [t_start, t_end];
pos_init = [0; earth_radius + iss_height];
vel_init = [7665; 0];
Y0 = [pos_init; vel_init];

%TIME STEP
dt = 10;

%SOLVE THE DE USING EULER AND RK4
[t_rk, Y_rk] = rk4(@derivative_orbit, interval, Y0, dt);
[t_euler, Y_euler] = euler(@derivative_orbit, interval, Y0, dt);

%PLOT THE RESULTS
figure;
hold on;
axis equal;
xlim([-1.5*earth_radius 1.5*earth_radius]);
ylim([-1.5*earth_radius 1.5*earth_radius]);
rectangle('Position', [-earth_radius, -earth_radius, 2*earth_radius, 2*earth_radius], 'Curvature', [1, 1], 'FaceColor', [0.8, 0.8, 0.8]);
plot(Y_rk(1, :), Y_rk(2, :));
plot(Y_euler(1, :), Y_euler(2, :));
