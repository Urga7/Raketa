function [Y_prime] = derivative_orbit(t, Y)

%CONSTANTS:
G = 6.67 * 1e-11; % [m^3 / (kg * s^2)]
earth_mass = 5.97 * 1e24; % [kg]

%Position and velocity
x = Y(1);
y = Y(2);
pos_norm = norm([x; y]);
vel = [Y(3); Y(4)];

%Calculate the force of gravity
r2 = x^2 + y^2;
g_norm = -((G * earth_mass) / r2);
g = [g_norm * (x / pos_norm); g_norm * (y / pos_norm)];

%In orbit, there is only the force of
%gravity acting on the rocket. Other forces
%are negligible at this height.
accel = g;

Y_prime = [vel; accel];
