function alpha = get_angle(pos, vel, angle)

A_len = pos(2);
B_len = norm(pos);
C_len = pos(1);

cosGamma = (A_len^2+B_len^2-C_len^2) / (2* A_len * B_len);
gamma = acos(cosGamma);
alpha = angle - gamma;

