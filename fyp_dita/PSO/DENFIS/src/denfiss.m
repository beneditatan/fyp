%   Dynamic Evolving Neural-Fuzzy Inference System: DENFIS Simulating Function
%================================================================================
%=   Function Name:     denfiss.m                                               =
%=   Developer:         Qun Son                                                 =
%=   Date:              October, 20001                                          =
%=   Description:       Simulate the DENFIS trained by denfis                   =
%================================================================================
%
%    Syntax		 [Rresult] = denfiss(testingdata, Tresult)
%
% where testdata is the testing data set and Tresult is a structure produced 
% by the DENFIS training function, denfis.
% The output structure, Rresult, includes following several fields:
% Rresult.Out:		output of the DENFIS evaluation on testing data
% Rresult.Abe:		errors of the evaluation on testing data
