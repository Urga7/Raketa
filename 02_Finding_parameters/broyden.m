function x = broyden(x0, F, tol, maxit)
%x = broyden(x0, F, tol, maxit) returns the solution
%to the equation F(x) = 0, which it finds using the Broyden's method.
%x0 is the initial guess, F is the function, tol is the tolerance and
%maxit is the maximum number of iterations allowed.

%Size of the input parameters
n = length(x0);

%Standard base vectors R^n
e = eye(n);

%Step size
delta = sqrt(tol);

%Approximation for J in x0 (forward finite differences)
Fx0 = feval(F, x0);
for j = 1:n
	jac(:,j) = (feval(F, x0 + delta*e(:,j)) - Fx0)/delta;
end

for k = 1:maxit
	%Calculate d = x - x0
	d = -jac\Fx0;
	x = x0 + d;

  %Correct negative values
  x(x<0)=0;

  %Evaluate the function at x
  Fx = feval(F, x);

  %Check for convergence
	if all(abs(Fx) < [10000; 0.1 ; 40])
    break;
  end

	%Approximate J (Broyden's correction of order 1 in x)
	dF = Fx - Fx0;
	jac = jac + 1/(d'*d)*(dF - jac*d)*d';

	%Update x0 and Fx0
	x0 = x;
	Fx0 = Fx;
end
