function [done] = maxGenTerm(ops,bPop,endPop)
% function [done] = maxGenTerm(ops,bPop,endPop)
%
% Returns 1, i.e. terminates the GA when the maximal_generation is reached.
%
% ops    - a vector of options [current_gen maximum_generation]
% bPop   - a matrix of best solutions [generation_found solution_string]
% endPop - the current generation of solutions

currentGen = ops(1);
maxGen     = ops(2);
done       = currentGen >= maxGen; 