function alpha = get_angle(pos, vel)

  vector = vel;
  dot_product = dot(pos, vector);
  norms_product = norm(pos) * norm(vector);

  cos_alpha = max(-1, min(1, dot_product / norms_product));
  alpha = acos(cos_alpha);

  alpha = mod(alpha, 2*pi);








