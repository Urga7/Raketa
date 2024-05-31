function [t, Y] = rk4(f, interval, Y0, h)
%[t, Y] = rk4(f, [t0, tk], Y0, h) resi DE
%Y' = f(t, Y) pri zacetnem pogoju Y(t0) = Y0 s standardno
%Runge-Kutta metodo 4. reda s korakom h na intervalu [t0, tk].

%pripravimo vrstico casov t
t = interval(1):h:interval(2);

%pripravimo vrednosti Y
Y = zeros(length(Y0), length(t));
Y(:, 1) = Y0;

%pozenemo Runge-Kutta metodo
for k = 1:(length(t) - 1)
	%poracunamo vrednosti k1, ..., k4 in...
	k1 = h*f(t(k), Y(:, k));
	k2 = h*f(t(k) + h/2, Y(:, k) + k1/2);
	k3 = h*f(t(k) + h/2, Y(:, k) + k2/2);
	k4 = h*f(t(k) + h, Y(:, k) + k3);
	%... dodamo utezeno povprecje teh vrednosti Y
	Y(:, k + 1) = Y(:, k) + (k1 + 2*k2 + 2*k3 + k4)/6;
end
