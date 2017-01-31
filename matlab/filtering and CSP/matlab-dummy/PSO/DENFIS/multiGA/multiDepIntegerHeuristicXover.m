function [c1,c2] = multiDepIntegerHeuristicXover(p1,p2,bounds,Ops)
% Heuristic crossover takes two parents P1,P2 and performs an extrapolation
% along the line formed by the two parents outward in the direction of the
% better parent.
%
% function [c1,c2] = multiDepIntegerHeuristicXover(p1,p2,bounds,Ops)
% p1      - the first parent ( [solution string function value] )
% p2      - the second parent ( [solution string function value] )
% bounds  - the bounds matrix for the solution space
% Ops     - Options for heuristic crossover, [gen number_of_retries]


retry=Ops(2); 				% Number of retries
i=0;
good=0;
b1=bounds(1);
b2=bounds(2);
% Determine the best and worst parent
if(p1(2) > p2(2))
  bt = p1(1); 
  wt = p2(1);
else
  bt = p2(1);
  wt = p1(1);
end
while i<retry
  % Pick a random mix amount
  a = rand;
  % Create the child
  c1 = round(a * (bt - wt) + bt);
  
  % Check to see if child is within bounds
  if (c1 <= b2 & (c1 >= b1))
    i = retry;
    good=1;
  else
    i = i + 1;
  end
end

% If new child is not feasible just return the new children
if(~good) 
  c1 = wt;
end

% Crossover functions return two children therefore return the best
% and the new child created
c2 = bt;

