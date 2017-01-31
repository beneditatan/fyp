function [parent] = multiDepIntegerUnifMutation(parent,bounds,Ops)
% Uniform mutation changes one of the parameters of the parent
% based on a uniform probability distribution.
%
% function [newSol] = multiDepIntegerUnifMutation(parent,bounds,Ops)
% parent  - the first parent ( [solution string function value] )
% bounds  - the bounds matrix for the solution space
% Ops     - Options for multiDepIntegerUnifMutation [gen #UnifMutations]


df = bounds(2) - bounds(1); 	% Range of the variables
parent = round(bounds(1) + rand * df); % Now mutate that point
