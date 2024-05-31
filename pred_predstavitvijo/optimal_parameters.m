function [opt_fuel_cap, opt_tilt_start, opt_tilt_speed] = optimal_parameters(dt, simulation_duration)

best_airtime = 0;
fuel_cap = 2500;
for tilt_start = 10 : 80
  for tilt_speed = 0 : 0.05 : 0.1
    [~, airtime, ~] = rocket(fuel_cap, tilt_start, tilt_speed, 0, dt, simulation_duration);
    if airtime > best_airtime
      best_airtime = airtime;
      opt_fuel_cap = fuel_cap;
      opt_tilt_start = tilt_start;
      opt_tilt_speed = tilt_speed;
    end
  end
end


