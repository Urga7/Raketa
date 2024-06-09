function alpha = get_angle(pos, vel)
%Calculates the angle of the rocket's velocity,
%relative to the line between the rocket's position
%and the center of the earth

dot_product = dot(pos, vel);
norms_product = norm(pos) * norm(vel);
cos_alpha = max(-1, min(1, dot_product / norms_product));
alpha = acos(cos_alpha);
alpha = mod(alpha, 2*pi);








