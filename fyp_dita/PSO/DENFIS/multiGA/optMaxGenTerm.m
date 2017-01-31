function [done] = optMaxGenTerm(ops,bPop,endPop)
% function [done] = optMaxGenTerm(ops,bPop,endPop)
%
% Returns 1, i.e. terminates the GA, when either the maximal_generation is
% reached or when the optimal function val is found.
%
% ops    - a vector of options [maximum_generation optimal epsilon]
% bPop   - a matrix of best solutions [generation_found solution_string]
% endPop - the current generation of solutions

currentGen = ops(1);
maxGen     = ops(2);
optimal    = ops(3);
epsilon    = ops(4);
fitIndex   = size(endPop,2);
bestSolVal = max(endPop(:,fitIndex));
done       = (currentGen >= maxGen) | ((optimal - bestSolVal) <= epsilon);