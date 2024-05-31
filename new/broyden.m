function x = broyden(x0, F, tol, maxit)
%x = broyden(x0, F, tol, maxit) vrne resitev
%enacbe F(x) = 0, ki jo poisce z Broydenovo metodo
%metodo. x0 je zacetni priblizek, F funkcija, tol
%toleranca in maxit najvecje st. iteracij.

%velikost podatkov
n = length(x0);

%standardni bazni vektorji R^n
e = eye(n);

%izberemo korak
delta = sqrt(tol);

%pripravimo priblizek za J v x0 (enostranske koncne diference)
Fx0 = feval(F, x0);
for j = 1:n
	jac(:,j) = (feval(F, x0 + delta*e(:,j)) - Fx0)/delta;
end

for k = 1:maxit
	%poracunamo d = x - x0
	d = -jac\Fx0;
	x = x0 + d;
	if(norm(d) < tol)
		break;
	end
	%popravimo priblizek za J (Broydenov popravek ranga 1 v x)
	Fx = feval(F, x);
	dF = Fx - Fx0;
	jac = jac + 1/(d'*d)*(dF - jac*d)*d';
	%nova x0 in Fx0
	x0 = x;
	Fx0 = Fx;
end
