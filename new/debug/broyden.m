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
delta = (sqrt(tol));
mult = 1;

%pripravimo priblizek za J v x0 (centralne koncne diference)
Fx0 = feval(F, x0);
for j = 1:n
    jac(:, j) = (feval(F, x0 + delta*e(:, j)) - feval(F, x0 - delta*e(:, j))) / (2*delta);
end

for k = 1:maxit
	%poracunamo d = x - x0
	d = -jac\Fx0;
  d = mult * d;
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

  %preverimo konvergenco glede na pričakovane podatke
  if all(abs(Fx) < [4; 8e-5 ; 0.25])
       break;
  end

  %posodobimo jacobijevo matriko
  dF = Fx - Fx0;
  v = dF - jac * d;
  denominator = v' * d;

  %če bi delili z zelo majhno stevilko preskocimo in zmanjsamo korak
  if abs(denominator) > 1e-10
    jac = jac + (v * v') / denominator;
  else
    mult = mult / 2;
  end

  %če so podatki bolj ustrezni povečamo korak v nasprotnem primeru zmanjšamo
  if norm(Fx) < norm(Fx0)
    mult = min(1.5 * mult, 2.5);
  else
    mult = mult / 2;
  end



	%nova x0 in Fx0
	x0 = x;
	Fx0 = Fx;
end
