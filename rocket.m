function [max_altitude] = rocket(fuel_capacity, tilt_start_time, tilt_speed, dt, simulation_duration)

% FIXED PARAMETERS:
dry_mass = 800; % [kg]
engine_speed = 60; % [kg / s]
fuel_ejection_speed = 5500; % [m / s]
cross_section_area = 0.5; % [m^2]
drag_coeficient = 0.2;

% CONSTANTS:
G = 6.67 * 1e-11; % [m^3 / (kg * s^2)]
earth_mass = 5.97 * 1e24; % [kg]
earth_radius = 6.37 * 1e6; % [m]
base_air_density = 1.20; % [kg / m^3] at 20 deg C, sea level. (constant?)

% INITIAL CONDITIONS:
time = 0;
vel = [0; 0];
pos = [0; earth_radius];
fuel = fuel_capacity;
angle = 0;

% PLOT INITIALISATION:
figure;
hold on;
axis equal;
xlim([-2*earth_radius 2*earth_radius]);
ylim([-3*earth_radius 3*earth_radius]);
rectangle('Position', [-earth_radius, -earth_radius, 2*earth_radius, 2*earth_radius], 'Curvature', [1, 1], 'FaceColor', [0.8, 0.8, 0.8]);
rocket_length = 800000;
rocket_plot = plot([pos(1), pos(1) + rocket_length * sin(angle)], ...
                   [pos(2), pos(2) + rocket_length * cos(angle)], 'b-', 'LineWidth', 2);
speed_text = text(-1.6*earth_radius, 1.8*earth_radius, 'Speed: 0 m/s', 'FontSize', 12);

% RETURN VALUES INITIALISATION
max_altitude = 0;

while time < simulation_duration

  dist = sqrt(pos(1)^2 + pos(2)^2);
  if dist < earth_radius
     fprintf('Crashed!\n');
     return;
  end

  if dist - earth_radius > max_altitude
    max_altitude = dist - earth_radius
  endif

  g = (G * earth_mass) / dist^2;
  g_x = -g * (pos(1) / dist);
  g_y = -g * (pos(2) / dist);
  air_density = base_air_density * (1 / exp((dist - earth_radius) / 800));
  drag = (0.5 * air_density * (sqrt(vel(1)^2 + vel(2)^2) * vel) * cross_section_area * drag_coeficient) / (dry_mass + fuel);
  accel_x = -drag(1) + g_x;
  accel_y = -drag(2) + g_y;

  if fuel > 0
    thrust = engine_speed * fuel_ejection_speed * (1 / (dry_mass + fuel));
    accel_x += thrust * sin(angle) * dt;
    accel_y += thrust * cos(angle) * dt;
    fuel -= engine_speed * dt;
  end

  vel(1) += accel_x * dt;
  vel(2) += accel_y * dt;
  pos(1) += vel(1) * dt;
  pos(2) += vel(2) * dt;

  if time >= tilt_start_time
    angle += tilt_speed * dt;
  end

  set(rocket_plot, 'XData', [pos(1), pos(1) + rocket_length * sin(angle)], ...
                   'YData', [pos(2), pos(2) + rocket_length * cos(angle)]);
  set(speed_text, 'String', sprintf('Speed: %.2f m/s', norm(vel)));
  drawnow;
  fprintf('Acceleration x: %.2f m/s^2\n', accel_x);
  fprintf('Acceleration y: %.2f m/s^2\n', accel_y);

  time += dt;
  %pause(dt);

end

