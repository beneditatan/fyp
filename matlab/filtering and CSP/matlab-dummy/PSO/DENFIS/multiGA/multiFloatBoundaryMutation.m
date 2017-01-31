function [parent] = multiFloatBoundaryMutation(parent,bounds,Ops)
% Boundary Mutation changes one of the parameters of the parent and changes it
% randomly either to its upper or lower bound.
%
% function [newSol] = multiFloatBoundaryMutation(parent,bounds,Ops)
% parent  - the first parent ( [solution string function value] )
% bounds  - the bounds matrix for the solution space
% Ops     - Options for multiFloatBoundaryMutation [gen #BndMutations]


b = round(rand)+1; 			% Pick which bound to move to
parent = bounds(b); 		% Now mutate that point


