function [parent] = multiIndepIntegerMutation(parent,bounds,Ops)
% changes an iit (integer digit) randomly
%
% function [newSol] = multiIndepIntegerMutation(parent,bounds,Ops)
% parent  - the first parent ( [solution string function value] )
% bounds  - the bounds matrix for the solution space
% Ops     - Options for multiIndepIntegerMutation [gen force]
%           force = 1: try until digit is mutated
%           force = 0: allow parent to be returned unaltered


numOfPossVals = bounds(2) - bounds(1) + 1;
newval = floor(rand * numOfPossVals) + bounds(1);
if Ops(2) == 1
  if bounds(2) > bounds(1) % prevent endless loop
    while newval == parent % always mutate
      newval = floor(rand * numOfPossVals) + bounds(1);
    end
  end
end
parent = newval;