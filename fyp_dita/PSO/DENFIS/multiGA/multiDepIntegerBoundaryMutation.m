function [parent] = multiDepIntegerBoundaryMutation(parent,bounds,Ops)
% Boundary Mutation - changes the digit randomly either to its upper or lower bound.
%
% function [newSol] = multiDepIntegerBoundaryMutation(parent,bounds,Ops)
% parent  - the first parent ( [solution string function value] )
% bounds  - the bounds matrix for the solution space
% Ops     - Options for boundaryMutation [gen #BndMutations]

b = round(rand)+1; 			% Pick which bound to move to
parent = bounds(b); 		% Mutate point

