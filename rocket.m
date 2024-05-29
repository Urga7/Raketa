function [max_altitude, airtime, top_speed] = rocket(fuel_capacity, tilt_start_time, tilt_speed, initial_angle, initial_vel, initial_position, dt, simulation_duration, show_plot = false, realtime = false)

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
base_air_density = 1.20; % [kg / m^3] at 20 deg C, sea level.
iss_height = 408000; % [m]

% INITIAL CONDITIONS:
time = 0;
vel = initial_vel;
pos = initial_position;
fuel = fuel_capacity;
angle = initial_angle; % [rad] (positive = clockwise)

% PLOT INITIALISATION:
if show_plot
  figure;
  hold on;
  axis equal;
  xlim([-2*earth_radius 2*earth_radius]);
  ylim([-3*earth_radius 3*earth_radius]);
  rectangle('Position', [-earth_radius, -earth_radius, 2*earth_radius, 2*earth_radius], 'Curvature', [1, 1], 'FaceColor', [0.8, 0.8, 0.8]);
  rocket_length = 400000;
  rocket_plot = plot([pos(1), pos(1) + rocket_length * sin(angle)], ...
                     [pos(2), pos(2) + rocket_length * cos(angle)], 'b-', 'LineWidth', 2);
  speed_text = text(-1.6*earth_radius, 1.8*earth_radius, 'Speed: 0 m/s', 'FontSize', 12);
end

% RETURN VALUES INITIALISATION
max_altitude = 0;
airtime = simulation_duration;
top_speed = 0;

while time < simulation_duration

  dist = sqrt(pos(1)^2 + pos(2)^2);
  if dist < earth_radius
     airtime = time;
     if show_plot
       fprintf('Crashed!\n');
       set(speed_text, 'String', sprintf('Speed: %.2f m/s', 0));
     end
     return;
  end

  if time >= tilt_start_time
    angle += tilt_speed * dt;
  end

  if dist - earth_radius > max_altitude
    max_altitude = dist - earth_radius;
  endif

  g_size = (G * earth_mass) / dist^2;
  g_x = -g_size * (pos(1) / dist);
  g_y = -g_size * (pos(2) / dist);
  air_density = base_air_density * (1 / exp((dist - earth_radius) / 8200));
  drag = -(0.5 * air_density * (sqrt(vel(1)^2 + vel(2)^2) * vel) * cross_section_area * drag_coeficient) / (dry_mass + fuel);
  accel = drag + [g_x; g_y];

  if fuel > 0
    thrust = fuel_consumption * fuel_ejection_speed * (1 / (dry_mass + fuel));
    accel += [thrust * sin(angle); thrust * cos(angle)];
    fuel -= fuel_consumption * dt;
  end

  vel += accel * dt;
  vel = [norm(vel) * sin(angle); norm(vel) * cos(angle)];
  pos += vel * dt;

  if norm(vel) > top_speed
    top_speed = norm(vel);
  end

  if dist - earth_radius >= iss_height
    airtime = time;
    fprintf('Kot: %.1f\n', (angle * 180) / pi);
    fprintf('Hitrost: %.1f\n', vel);
    return;
  end

  if show_plot
    set(rocket_plot, 'XData', [pos(1), pos(1) + rocket_length * sin(angle)], ...
                     'YData', [pos(2), pos(2) + rocket_length * cos(angle)]);
    set(speed_text, 'String', sprintf('Speed: %.2f m/s', norm(vel)));
    drawnow;
  end

  time += dt;
  if realtime
    pause(dt);
  end

end

