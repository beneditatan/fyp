function [parent] = multiBinaryMutation(parent,bounds,Ops)
% Binary mutation changes a bit
%
% function [newSol] = multiBinaryMutation(parent,bounds,Ops)
% parent  - the first parent ( [solution string function value] )
% bounds  - the bounds matrix for the solution space
% Ops     - Options for binary mutation [gen force]
%           force = 1: always mutate
%           force = 0: pick 0 or 1 randomly

if Ops(2) == 1
  parent = round(rand);
else
  parent = ~parent; % invert bit
end