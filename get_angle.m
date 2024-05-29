function alpha = get_angle(pos, vel, angle)

A = [pos, pos + vel];
B = [[0; 0], pos];
C = intersection(A, B);

k1 = (B(2) - A(2)) / (B(1) - A(1));
k2 = (C(2) - A(2)) / (C(1) - A(1));

alpha = atan(abs((k1 - k2) / (1 + k1 * k2)));
