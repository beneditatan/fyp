function [parent] = multiFloatUnifMutation(parent,bounds,Ops)
% Uniform mutation changes one of the parameters of the parent
% based on a uniform probability distribution.
%
% function [newSol] = multiFloatUnifMutation(parent,bounds,Ops)
% parent  - the first parent ( [solution string function value] )
% bounds  - the bounds matrix for the solution space
% Ops     - Options for multiFloatUnifMutation [gen #UnifMutations]

df = bounds(2) - bounds(1); 	% Range of the variables
parent = bounds(1) + rand * df; % Now mutate that point
