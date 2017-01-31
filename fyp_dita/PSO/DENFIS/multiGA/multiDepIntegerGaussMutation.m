function [parent] = multiDepIntegerGaussMutation(parent,bounds,Ops)
% The Gaussian mutation mutates the parameter with the probablity
% of a normal Gaussian distibution. If the new value is not within
% the given bounds, another value is picked. If the maximim number
% of retries is exceeded, the parent is returned.
%
% function [newSol] = multiDepIntegerGaussMutation(parent,bounds,Ops)
% parent  - the first parent ( [solution string function value] )
% bounds  - the bounds matrix for the solution space
% Ops     - Options for multiDepIntegerGaussMutation 
%          [gen stdDev/boundaryDelta numRetries]

cg=Ops(1);					% Current Generation
sd=Ops(2);					% The standard deviation of the Gauss function
							% 1 = width of variable range
nr=Ops(3);					% maximum number of retries
df = bounds(2) - bounds(1);	% Range of the variable
devfac = df * sd / 2;		% deviation factor
for tr = 1:nr
  nv = round(parent + randn * devfac);
  if nv > bounds(1) & nv < bounds(2)
    parent = nv;
    return;
  end
end
% no result: return parent