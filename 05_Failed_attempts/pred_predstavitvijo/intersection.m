function P = intersection(A, B)
% Returns the intersection point of the line segments A and B in a plane,
% or an empty column, if the line segments do not intersect.
% A = [A1, A2], A1 and A2 are position vectors of points on the first line segment.
% B = [B1, B2], B1 and B2 are position vectors of points on the second line segment.
% P contains all the position vectors (columns) of the intersections.
% T = [t; u] holds the ratios between the intersection point to the starting
% point of the line segment and the length of the line segment.

% Compute the parameters of intersection
T = [A(:, 2) - A(:, 1), -(B(:, 2) - B(:, 1))]\(B(:, 1) - A(:, 1));

% Compute the intersecton point and return it
P = A(:, 1) + T(1)*(A(:, 2) - A(:, 1));

