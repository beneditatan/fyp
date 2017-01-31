function [parent] = multiFloatNonUnifMutation(parent,bounds,Ops)
% Multi-Non uniform mutation changes all of the parameters of the parent
% based on a non-uniform probability distribution.  This Gaussian
% distribution starts wide, and narrows to a point distribution as the
% current generation approaches the maximum generation.
%
% function [newSol] = multiFloatNonUnifMutation(parent,bounds,Ops)
% parent  - the first parent ( [solution string function value] )
% bounds  - the bounds matrix for the solution space
% Ops     - Options for multiFloatNonUnifMutation 
%          [gen maxGen b]

cg=Ops(1); 				% Current Generation
mg=Ops(2); 				% Maximum Number of Generations
b=Ops(3);                               % Shape parameter
df = bounds(2) - bounds(1); 	% Range of the variable
% Now mutate that point
md = round(rand);
if md == 1
  parent=parent+delta(cg,mg,bounds(2)-parent,b);
else
  parent=parent-delta(cg,mg,parent-bounds(1),b);
end
