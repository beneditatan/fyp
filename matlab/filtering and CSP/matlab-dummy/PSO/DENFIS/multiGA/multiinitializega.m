function [pop] = multiinitializega(num, varOps, evalFN, evalOps, options)
% function [pop]=multiinitializega(populationSize, variableOps, evalFN,
%                                  evalOps, options)
%    multiinitializega creates a matrix of random numbers with 
%    a number of rows equal to the populationSize and a number
%    columns equal to the number of rows in bounds plus 1 for
%    the f(x) value which is found by applying the evalFN.
%    This is used by the ga to create the population if it
%    is not supplied.
%
% pop            - the initial, evaluated, random population 
% populationSize - the size of the population, i.e., the number to create
%   varOps       - a matrix which contains the bounds and type of each
%                  variable, i.e.
%                  [type1 var1_low var1_high; type2 var2_low var2_high; ....]
%                  Types are defined as follows:
%                  1 - binary variable (boundaries should be 0 and 1)
%                  2 - independent integer
%                  3 - dependent integer (representing a real-life number,
%                      not a set of options)
%                  4 - floating point variable
%   evalFN       - the name of the evaluation .m function, as a string 
%   evalOps      - options to pass to the evaluation function ([NULL])
%   options      - options to the initialize function, i.e.,
%                  [prec] prec is the precision of the variables
%                  defaults [1e-6]

if nargin<5
  options=[1e-6];
end
if nargin<4
  evalOps=[];
end

types        = varOps(:,1);
numVars      = size(types, 1);
numVars1     = numVars + 1;

% initialize with zeros
pop = zeros(num, numVars1);
% prepare objective function call
for individual = 1:num % number of individuals
	for variable = 1:numVars % number of variables in a chromosome
    	switch types(variable)
    		case 1 % binary
    			pop(individual, variable) = round(rand);
    		case {2, 3} % integer (dependency is irrelevant during initialization)
    			pop(individual, variable) = floor(rand * ...
    				(varOps(variable, 3) - varOps(variable, 2) + 1)) + ...
    				varOps(variable, 2);
			case 4 % float
				pop(individual, variable) = (rand * ...
    				(varOps(variable, 3) - varOps(variable, 2))) + ...
    				varOps(variable, 2);
		end
	end
	pop(individual, numVars1) = feval(evalFN, pop(individual,1:numVars), [0 evalOps]);
end
