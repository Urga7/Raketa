function rocket()
%CALCULATES THE TRAJECTORY OF A ROCKET
%AND PLOTS THE RESULTS

%CONSTANTS
earth_radius = 6.37 * 1e6; % [m]

%FIXED PARAMETERS
t_start = 0;
t_end = 8000;
interval = [t_start, t_end];
pos_init = [0; earth_radius];
vel_init = [0; 0];
Y0 = [pos_init; vel_init];

%ADJUSTABLE STARTING PARAMETERS
fuel = 4200;
t0 = 25;
omega = 0.04;
param = [fuel, t0, omega];

%TIME STEP
dt = 1;

%SOLVE THE DE USING EULER AND RK4
[t_rk, Y_rk] = rk4(@derivative, interval, Y0, param, dt);
[t_euler, Y_euler] = euler(@derivative, interval, Y0, param, dt);

%PLOT THE RESULTS
figure;
hold on;
axis equal;
xlim([-1.5*earth_radius 1.5*earth_radius]);
ylim([-1.5*earth_radius 1.5*earth_radius]);
rectangle('Position', [-earth_radius, -earth_radius, 2*earth_radius, 2*earth_radius], 'Curvature', [1, 1], 'FaceColor', [0.8, 0.8, 0.8]);
plot(Y_rk(1, :), Y_rk(2, :));
plot(Y_euler(1, :), Y_euler(2, :));

%PARAMETERS FOR A SUCCESSFUL TAKEOFF AND ORBIT
%fuel = 5601;
%t0 = 22.0441;
%omega = 0.0350585;
%dt = 1;
