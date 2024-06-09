function alpha = trajectory_angle(pos, angle)

  vector = [sin(angle); cos(angle)];

  alpha = acos(dot(pos, vector) / (norm(pos) * norm(vector)));

  alpha = mod(alpha, 2*pi);








