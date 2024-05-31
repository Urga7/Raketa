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
mu = 1;

%pripravimo priblizek za J v x0 (enostranske koncne diference)
Fx0 = feval(F, x0);
for j = 1:n
    jac(:, j) = (feval(F, x0 + delta*e(:, j)) - feval(F, x0 - delta*e(:, j))) / (2*delta);
end

for k = 1:maxit
	%poracunamo d = x - x0
	d = -jac\Fx0;
  d = mu * d;
	x = x0 + d;

  x(x<0)=0;

  %if(norm(d) < tol)
	%	break;
	%end

  %norm_jac = norm(jac);
  %tol_d = [1000; 0.01; 0.25] / norm_jac;

  %if all(abs(d) <= tol_d)
  %      break;
  %end

  %popravimo priblizek za J (Broydenov popravek ranga 1 v x)
  Fx = feval(F, x);

  if all(abs(Fx) < [1000; 0.01; 0.25])
       break;
  end

  dF = Fx - Fx0;
  v = dF - jac * d;
  denom = v' * d;
  if abs(denom) > 1e-10
    jac = jac + (v * v') / denom;
  else
    mu = mu / 2;
  end

  if norm(Fx) < norm(Fx0)
    mu = min(1.5 * mu, 2);
  else
    mu = 0.5 * mu;
  end

	%nova x0 in Fx0
	x0 = x;
	Fx0 = Fx;
end
