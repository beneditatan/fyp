function [parent] = multiNonUnifMutation(parent,bounds,Ops)
% Multi-Non uniform mutation changes all of the parameters of the parent
% based on a non-uniform probability distribution.  This Gaussian
% distribution starts wide, and narrows to a point distribution as the
% current generation approaches the maximum generation.
%
% function [newSol] = multiNonUnifMutate(parent,bounds,Ops)
% parent  - the first parent ( [solution string function value] )
% bounds  - the bounds matrix for the solution space
% Ops     - Options for multiNonUnifMutation 
%          [gen #MultiNonUnifMutations maxGen b]


cg=Ops(1); 				% Current Generation
mg=Ops(3); 				% Maximum Number of Generations
b=Ops(4);                               % Shape parameter
df = bounds(:,2) - bounds(:,1); 	% Range of the variables
numVar = size(parent,2)-1; 		% Get the number of variables
% Now mutate that point
md = round(rand(1,numVar));
for i = 1:numVar
  if md(i)
    parent(i)=parent(i)+delta(cg,mg,bounds(i,2)-parent(i),b);
  else
    parent(i)=parent(i)-delta(cg,mg,parent(i)-bounds(i,1),b);
  end
end
