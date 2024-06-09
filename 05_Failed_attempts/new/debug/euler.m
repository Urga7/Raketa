function [t, Y] = euler(f, interval, Y0, h)
%[t, Y] = euler(f, [t0, tk], Y0, h) resi DE
%Y' = f(t, Y) pri zacetnem pogoju Y(t0) = Y0 z Eulerjevo metodo
%s korakom h na intervalu [t0, tk].

%pripravimo vrstico casov t
t = interval(1):h:interval(2);

%pripravimo vrednosti Y
Y = zeros(length(Y0), length(t));
Y(:, 1) = Y0;

%pozenemo Eulerjevo metodo
for k = 2:length(t)
	Y(:, k) = Y(:, k-1) + h*f(t(k-1), Y(:, k-1));
end
