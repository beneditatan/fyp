function[newPop] = tournSelect(oldPop,options)
% Performs a tournament selection.
%
% function[newPop] = tournSelect(oldPop,options)
% newPop  - the new population selected from the oldPop
% oldPop  - the current population
% options - options to normGeomSelect [gen tournament_size]

tournSize=options(2); 			% Get the number of tournaments
e = size(oldPop,2); 			% xZome length
n = size(oldPop,1); 			% number in Population
newPop = zeros(n,e); 			% Create the memory for newPop
tourns=floor(rand(tournSize,n)*n)+1; 	% Schedule of tournaments
% Determine the winner of the tournaments
[c b]=max(reshape(oldPop(tourns,e),tournSize,n));
newPop=oldPop(diag(tourns(b,:)),:); 	% Copy the winners in to newPop

