function alpha = get_angle(pos, angle)

A = [0; pos(1)];
B = pos;

A_len = norm(A);
B_len = norm(B);

cosGamma = (A(1)*B(1) + A(2)*B(2)) / (A_len * B_len);

gamma = acos(cosGamma);

alpha = abs(mod(angle, pi) - gamma);

