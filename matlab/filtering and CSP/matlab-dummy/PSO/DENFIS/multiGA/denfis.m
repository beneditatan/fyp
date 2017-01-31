%    Dynamic Evolving Neural-Fuzzy Inference System: DENFIS Training Function
%================================================================================
%=   Function Name:       denfis.m                                              =
%=   Algorithm Designer:  Qun Song                                              =
%=   Program Developer:   Qun Song                                              =
%=   Date:                October, 2001                                         =
%================================================================================
%
%       Syntax	[Tresult] = denfis(traindata, parameters);
%
% Here, traindata is the training data set, and parameters is a structure 
% including several fields described as next lines: 
%  parameters.trainmode:	set 1 for on-line training, 2 for off-line training
%                           (first-order TS FIS), and 3 for off-line training 
%                           (high-order TS FIS) (default: 1). 
%  parameters.dthr :		distance threshold (default: 0.1).    
%  parameters.mofn: 		the number of rules in a dynamic FIS (default: 3).
%  Parameters.ecmepochs : 	the number of epochs of clustering optimisation 
%                           (default: 0). 
%  parameters.mlpepochs:	the number of  epochs for creating a High-order TS 
%                           fuzzy rule (default: 10).
%  parameters.dispmode:	    1 for displaying the information of training 
%                           process in numeric and otherwise  displaying 
%                           nothing (default: 1).
%
% The output structure, Tresult, includes following fields:
% Tresult.Cent:			    rule nodes (centres of partitioned regions) in 
%                           input space
% Tresult.Fun or Net:	    functions of TSK fuzzy rules
% Tresult.Out:			    output of DENFIS evaluation on training data
% Tresult.Abe:			    absolute errors of the evaluation on training
%                           data
