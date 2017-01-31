function [c1,c2] = multiSimpleXover(p1,p2,bounds,Ops)
% Simple crossover takes two parents P1,P2 and performs simple single point
% crossover.  
%
% function [c1,c2] = multiSimpleXover(p1,p2,bounds,Ops)
% p1      - the first parent ( [solution string function value] )
% p2      - the second parent ( [solution string function value] )
% bounds  - the bounds matrix for the solution space
% Ops     - Options matrix for simple crossover [gen].

c1 = p2(1);
c2 = p1(1);
