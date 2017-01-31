function [x,endPop,bPop,traceInfo] = multiga(varOps,evalFN,evalOps,...
startPop,opts,termFN,termOps,selectFN,selectOps,xOverProp,xOverFNs1,xOverFNs2,...
xOverFNs3,xOverFNs4,xOverOps1,xOverOps2,xOverOps3,xOverOps4,mutProp,mutFNs1,...
mutFNs2,mutFNs3,mutFNs4,mutOps1,mutOps2,mutOps3,mutOps4)
% GA run a genetic algorithm
% function [x,endPop,bPop,traceInfo]=ga(varOps,evalFN,evalOps,startPop,opts,
%                                       termFN,termOps,selectFN,selectOps,
%                                       xOverFNs,xOverOps,mutFNs,mutOps)
%                                
% Output Arguments:
%   x            - the best solution found during the course of the run
%   endPop       - the final population 
%   bPop         - a trace of the best population
%   traceInfo    - a matrix of best and means of the ga for each generation
%
% Input Arguments (sorry about the length of this list):
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
%   startPop     - a matrix of solutions that can be initialized
%                  from multiinitializega.m
%   opts         - [epsilon display] change required to consider two 
%                  solutions different, display is 1 to output progress 0 for
%                  quiet. ([1e-6 0])
%   termFN       - name of the .m termination function (['maxGenTerm'])
%   termOps      - options string to be passed to the termination function
%                  ([100]).
%   selectFN     - name of the .m selection function (['normGeomSelect'])
%   selectOpts   - options string to be passed to select after
%                  select(pop,#,opts) ([0.08])
%   xOverProp    - [prop num] prop - Probability of crossover for a single
%                  digit (i.e., once the pair has been selected for
%                  crossover)
%                  num - Number of crossovers to perform per generation
%                  (i.e., the number of pairs that are picked out for
%                  crossover)
%   xOverFNs1    - a string containing blank separated names of Xover.m
%                  files (['multiSimpleXover']) to be used for binary digits
%                  (repeat name of crossover functions to increase the
%                  probability for that function to be chosen)
%   xOverFNs2    - a string containing blank separated names of Xover.m
%                  files (['multiSimpleXover']) to be used for independent
%                  integer digits
%   xOverFNs3    - a string containing blank separated names of Xover.m
%                  files (['multiDepIntegerArithXover
%                  multiDepIntegerHeuristicXover multiSimpleXover']) to
%                  be used for dependent integer digits
%   xOverFNs4    - a string containing blank separated names of Xover.m
%                  files (['multiFloatArithXover multiFloatHeuristicXover
%                  multiSimpleXover']) to be used for floating point digits
%   xOverOps1    - A matrix of options to pass to the corresponding Xover.m
%                  ([0]) to be used for binary digits
%   xOverOps2    - A matrix of options to pass to the corresponding Xover.m
%                  ([0]) to be used for independent integer digits
%   xOverOps3    - A matrix of options to pass to the corresponding Xover.m
%                  ([0; 3; 0]) to be used for dependent integer digits
%   xOverOps4    - A matrix of options to pass to the corresponding Xover.m
%                  ([0; 3; 0]) to be used for floating point digits
%   mutProp      - [prop num] prop - Probability of mutation for a single
%                  digit (i.e., once the individual has been selected for
%                  mutation)
%                  num - Number of mutations to perform per generation
%                  (i.e., the number of individuals that are picked out for
%                  mutation)
%   xmutFNs1     - a string containing blank separated names of Mutation.m
%                  files (['multiBinaryMutation']) to be used for binary
%                  digits (repeat name of mutation functions to increase
%                  the probability for that function to be chosen)
%   xOverFNs2    - a string containing blank separated names of Mutation.m
%                  files (['multiIndepIntegerMutation']) to be used for
%                  independent integer digits
%   xOverFNs3    - a string containing blank separated names of Mutation.m
%                  files (['multiDepIntegerBoundaryMutation
%                  multiDepIntegerNonUnifMutation
%                  multiDepIntegerUnifMutation
%                  multiDepIntegerGaussMutation']) to be used for dependent
%                  integer digits
%   xOverFNs4    - a string containing blank separated names of Mutation.m
%                  files (['multiFloatBoundaryMutation
%                  multiFloatNonUnifMutation multiFloatUnifMutation
%                  multiFloatGaussMutation']) to be used for floating point
%                  digits
%   mutOps1      - A matrix of options to pass to the corresponding
%                  Mutation.m ([1]) to be used for binary digits
%   mutOps2      - A matrix of options to pass to the corresponding
%                  Mutation.m ([1]) to be used for independent integer
%                  digits
%   mutOps3      - A matrix of options to pass to the corresponding
%                  Mutation.m ([0 0; termOps(1) 3; 0 0; 0.8 4]) to be used
%                  for dependent integer digits
%   mutOps4      - A matrix of options to pass to the corresponding
%                  Mutation.m ([0 0; termOps(1) 3; 0 0; 0.8 4]) to be used
%                  for floating point digits


n=nargin;
if n<2 | n==6 | (n>9 & n<18) | (n>18 & n<27)
  disp('Insufficient arguments') 
end
if n>27
  disp('Too many arguments') 
end
if n<3 %Default evalation opts.
  evalOps=[];
end
if n<5
  opts = [1e-6 0];
end
if isempty(opts)
  opts = [1e-6 0];
end

if n<27 %Default mutation information
  mutFNs4=['multiFloatBoundaryMutation multiFloatNonUnifMutation multiFloatUnifMutation multiFloatGaussMutation'];
  mutOps4=[0 0; termOps(1) 3; 0 0; 0.8 4];
  mutFNs3=['multiDepIntegerBoundaryMutation multiDepIntegerNonUnifMutation multiDepIntegerUnifMutation multiDepIntegerGaussMutation'];
  mutOps3=[0 0; termOps(1) 3; 0 0; 0.8 4];
  mutFNs2=['multiIndepIntegerMutation'];
  mutOps2=[1];
  mutFNs1=['multiBinaryMutation'];
  mutOps1=[1];
  mutProp=[0 0];
end
if n<17 %Default crossover information
  xOverFNs4=['multiFloatArithXover multiFloatHeuristicXover multiSimpleXover'];
  xOverOps4=[0; 3; 0];
  xOverFNs3=['multiDepIntegerArithXover multiDepIntegerHeuristicXover multiSimpleXover'];
  xOverOps3=[0; 3; 0];
  xOverFNs2=['multiSimpleXover'];
  xOverOps2=[0];
  xOverFNs1=['multiSimpleXover'];
  xOverOps1=[0];
  xOverProp=[0 0];
end
if n<9 %Default select opts only i.e. roullette wheel.
  selectOps=[];
end
if n<8 %Default select info
  selectFN=['normGeomSelect'];
  selectOps=[0.08];
end
if n<6 %Default termination information
  termOps=[100];
  termFN='maxGenTerm';
end
if n<4 %No starting population passed given
  startPop=[];
end
if isempty(startPop) %Generate a population at random
  startPop=multiinitializega(80,varOps,evalFN,evalOps,opts(1));
end

for noType = 1:4
  eval(['xOverFNs', int2str(noType), ' = parse(xOverFNs', int2str(noType), ');']);
  eval(['mutFNs',   int2str(noType), ' = parse(mutFNs',   int2str(noType), ');']);
end

xZomeLength  = size(startPop,2); 	%Length of the xzome=numVars+fitness
numVar       = xZomeLength-1; 		%Number of variables
popSize      = size(startPop,1); 	%Number of individuals in the pop
endPop       = zeros(popSize,xZomeLength); %A secondary population matrix
c1           = zeros(1,xZomeLength); 	%An individual
c2           = c1;                  	%An individual
for noType = 1:4
  eval(['numXOvers', int2str(noType), ' = size(xOverFNs', int2str(noType), ',1);']); 	%Number of Crossover operators
  eval(['numMuts',   int2str(noType), ' = size(mutFNs',   int2str(noType), ',1);']); 	%Number of Mutation operators
end
epsilon      = opts(1);                 %Threshold for two fitness to differ
oval         = max(startPop(:,xZomeLength)); %Best value in start pop
bFoundIn     = 1; 			%Number of times best has changed
done         = 0;                       %Done with simulated evolution
gen          = 1; 			%Current Generation Number
collectTrace = (nargout>3); 		%Should we collect info every gen
display      = opts(2);                 %Display progress
if xOverProp == [0 0]
   xOverProp  = [0.6 round(popSize / 2)];
end
if mutProp   == [0 0]
   mutProp    = [0.1 round(popSize / 20)];
end
numOfXOvers  = xOverProp(2);
xOverProp    = xOverProp(1);
numOfMut     = mutProp(2);
mutProp      = mutProp(1);

while (~done)
  %Elitist Model
  [bval,bindx] = max(startPop(:,xZomeLength)); %Best of current pop
  best =  startPop(bindx,:);

  if collectTrace
    traceInfo(gen,1)=gen; 		          %current generation
    traceInfo(gen,2)=startPop(bindx,xZomeLength);       %Best fittness
    traceInfo(gen,3)=mean(startPop(:,xZomeLength));     %Avg fittness
    traceInfo(gen,4)=std(startPop(:,xZomeLength)); 
  end
  
  if ( (abs(bval - oval)>epsilon) | (gen==1)) %If we have a new best sol
    if display
      fprintf(1,'\n%d %f\n',gen,bval);          %Update the display
    end

    bPop(bFoundIn,:)=[gen startPop(bindx,:)]; %Update bPop Matrix
    
    bFoundIn=bFoundIn+1;                      %Update number of changes
    oval=bval;                                %Update the best val
  else
    if display
      fprintf(1,'%d ',gen);	              %Otherwise just update num gen
    end
  end
  
  endPop = feval(selectFN,startPop,[gen selectOps]); %Select
  
% select random digits to perform crossover  	
  	
  for xOverNo = 1:numOfXOvers
    a = floor(rand * popSize) + 1; 	 % pick mom
    b = floor(rand * popSize) + 1; 	 % pick pop
    for mPoint = 1:numVar % iterate over digits
      if rand <= xOverProp % should this digit be crossed?
        digitType = varOps(mPoint, 1);
        eval(['xOverFNno = floor(rand * numXOvers', int2str(digitType), ') + 1;']);
        eval(['xOverFN = deblank(xOverFNs', int2str(digitType), '(xOverFNno,:));']); % pick a random xOver func
        eval(['[c1(mPoint) c2(mPoint)] = ', xOverFN, '([endPop(a, mPoint) endPop(a, xZomeLength)], ', ...
          '[endPop(b, mPoint) endPop(b, xZomeLength)], varOps(mPoint, 2:3), ', ...
          '[gen xOverOps', int2str(digitType), '(xOverFNno,:)]);']); % crossover
      else
        c1(mPoint) = endPop(a, mPoint);   
        c2(mPoint) = endPop(b, mPoint);   
      end
     end
  
  	if c1(1:numVar)==endPop(a,(1:numVar)) %Make sure we created a new 
  	  c1(xZomeLength)=endPop(a,xZomeLength); %solution before evaluating
  	elseif c1(1:numVar)==endPop(b,(1:numVar))
  	  c1(xZomeLength)=endPop(b,xZomeLength);
  	else 
  	  c1(xZomeLength) = feval(evalFN, c1, [gen evalOps]);
  	end
  	if c2(1:numVar)==endPop(a,(1:numVar))
  	  c2(xZomeLength)=endPop(a,xZomeLength);
  	elseif c2(1:numVar)==endPop(b,(1:numVar))
  	  c2(xZomeLength)=endPop(b,xZomeLength);
  	else 
  	  c2(xZomeLength) = feval(evalFN, c2, [gen evalOps]);
  	end      
  	
  	endPop(a,:)=c1;
  	endPop(b,:)=c2;
  end

% end of crossover code

% select random digits to perform mutation
    
  for mutNo = 1:numOfMut
    a = floor(rand * popSize) + 1;
    for mPoint = 1:numVar % iterate over digits
      if rand <= mutProp % should this digit be mutated?
        digitType = varOps(mPoint, 1);
        eval(['mutFNno = floor(rand * numMuts', int2str(digitType), ') + 1;']);
        eval(['mutFN = deblank(mutFNs', int2str(digitType), '(mutFNno,:));']); % pick a random mut func
        eval(['c1(mPoint) = ', mutFN, '(endPop(a, mPoint), varOps(mPoint, 2:3), [gen mutOps', ...
              int2str(digitType), '(mutFNno,:)]);']); % mutate
      else
        c1(mPoint) = endPop(a, mPoint);
      end
    end
    if c1(1:numVar) == endPop(a,(1:numVar)) % did a mutation occur?
  	   c1(xZomeLength) = endPop(a, xZomeLength); % no: copy the old value
    else
      c1(xZomeLength) = feval(evalFN, c1, [gen evalOps]); % yes: evaluate the individual
    end
    endPop(a,:)=c1; % copy to current end population
  end

% end of mutation code

  gen=gen+1;
  done=feval(termFN,[gen termOps],bPop,endPop); %See if the ga is done
  startPop=endPop; 			%Swap the populations
  
  [bval,bindx] = min(startPop(:,xZomeLength)); %Keep the best solution
  startPop(bindx,:) = best; 		%replace it with the worst
  save best best;
end

[bval,bindx] = max(startPop(:,xZomeLength));
if display 
  fprintf(1,'\n%d %f\n',gen,bval);	  
end

x=startPop(bindx,:);
if opts(2)==0 %binary
  x=b2f(x,bounds,bits);
  bPop(bFoundIn,:)=[gen b2f(startPop(bindx,1:numVar),bounds,bits)...
      startPop(bindx,xZomeLength)];
else
  bPop(bFoundIn,:)=[gen startPop(bindx,:)];
end

if collectTrace
  traceInfo(gen,1)=gen; 		%current generation
  traceInfo(gen,2)=startPop(bindx,xZomeLength); %Best fittness
  traceInfo(gen,3)=mean(startPop(:,xZomeLength)); %Avg fittness
end






