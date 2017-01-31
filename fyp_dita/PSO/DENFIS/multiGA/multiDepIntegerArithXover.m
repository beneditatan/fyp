function [c1,c2] = multiDepIntegerArithXover(p1,p2,bounds,Ops)
% Arith crossover takes two parents P1,P2 and performs an interpolation
% along the line formed by the two parents.
%
% function [c1,c2] = multiDepIntegerArithXover(p1,p2,bounds,Ops)
% p1      - the first parent ( [solution string function value] )
% p2      - the second parent ( [solution string function value] )
% bounds  - the bounds matrix for the solution space
% Ops     - Options matrix for arith crossover [gen]

% Pick a random mix amount
a = rand;

% Create the children
c1 = round(p1(1)*a + p2(1)*(1-a));
c2 = round(p1(1)*(1-a) + p2(1)*a); 
