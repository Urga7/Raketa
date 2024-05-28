function [max_altitude, airtime, top_speed] = rocketRK(fuel_capacity, tilt_start_time, tilt_speed, initial_angle, dt, simulation_duration, show_plot = false, realtime = false)

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
base_air_density = 1.20; % [kg / m^3] at 20 deg C, sea level_init.

% INITIAL CONDITIONS:
time = 0;
vel = [0; 0];
pos = [0; earth_radius];
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

  if fuel > 0 && time >= tilt_start_time
    k1 = dt*rocket_derivative(time, [pos; vel; fuel], true, true, tilt_speed);
    k2 = dt*rocket_derivative(time + dt/2, [pos; vel; fuel] + k1/2, true, true, tilt_speed);
    k3 = dt*rocket_derivative(time + dt/2, [pos; vel; fuel] + k2/2, true, true, tilt_speed);
    k4 = dt*rocket_derivative(time + dt, [pos; vel; fuel] + k3, true, true, tilt_speed);
  end
  if fuel > 0 && time < tilt_start_time
    k1 = dt*rocket_derivative(time, [pos; vel; fuel], true);
    k2 = dt*rocket_derivative(time + dt/2, [pos; vel; fuel] + k1/2, true);
    k3 = dt*rocket_derivative(time + dt/2, [pos; vel; fuel] + k2/2, true);
    k4 = dt*rocket_derivative(time + dt, [pos; vel; fuel] + k3, true);
  end
  if fuel <= 0
    k1 = dt*rocket_derivative(time, [pos; vel; fuel], false);
    k2 = dt*rocket_derivative(time + dt/2, [pos; vel; fuel] + k1/2, false);
    k3 = dt*rocket_derivative(time + dt/2, [pos; vel; fuel] + k2/2, false);
    k4 = dt*rocket_derivative(time + dt, [pos; vel; fuel] + k3, false);
  end

  pos += (k1(1:2) + 2*k2(1:2) + 2*k3(1:2) + k4(1:2)) / 6;
  vel += (k1(3:4) + 2*k2(3:4) + 2*k3(3:4) + k4(3:4)) / 6;
  fuel += (k1(5) + 2*k2(5) + 2*k3(5) + k4(5)) / 6;

  if time > tilt_start_time
    vel = [norm(vel) * sin(tilt_speed * time); norm(vel) * cos(tilt_speed * time)];
  end

  dist = norm(pos);
  if dist < earth_radius
     airtime = time;
     if show_plot
       set(speed_text, 'String', sprintf('Speed: %.2f m/s', 0));
       fprintf('Crashed!\n');
     end
     return;
  end

  if dist - earth_radius > max_altitude
    max_altitude = dist - earth_radius;
  endif

  if norm(vel) > top_speed
    top_speed = norm(vel);
  end

  if show_plot
    set(rocket_plot, 'XData', [pos(1), pos(1) + rocket_length * sin(tilt_speed * time)], ...
                     'YData', [pos(2), pos(2) + rocket_length * cos(tilt_speed * time)]);
    set(speed_text, 'String', sprintf('Speed: %.2f m/s', norm(vel)));
    drawnow;
  end

  time += dt;
  if realtime
    pause(dt);
  end

end
