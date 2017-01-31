% Script used for optimizing the EMRAN Parameters......
format short g
clc
clear all;
close all;

% define Global variables..........................................
global UY UY1 UY2 kmax nxi nyi par uy1 uy2 Nmax ny
nyi=[20:26];
nxi=[1:19];
ny=size(nyi,2);
load('../../../dataset/seg.tra1');
UY = seg;
% UY(:,end)=UY(:,end)+1;
load('../../../dataset/seg.tes');
UY1= seg;
% UY1(:,end)=UY1(:,end)+1;

% Define the type ( 3 - integer 4- real), lower bound and upper bound of design variables
designVectorProps = [
    2   2        2               % online training
    4   0.01     2              % dthr
    2   14      50           % rules
    2   0      2                % epochs
    2   1       2               % higher order fis
    2   1     1               % disp
    ];

% Initialize the Population.........................................
initPop = multiinitializega(25, designVectorProps, 'DENFIS_multiVerificationObjFunc', [100]);

% RCGA call to obtain best solution............................
[bestSol, endPop, bestPop, traceInfo] = multiga(designVectorProps, ...
                                                'DENFIS_multiVerificationObjFunc', ...
                                                [100], ...
                                                initPop, ...
                                                [1E-6 1], ...
                                                ['maxGenTerm'], ...
                                                [50], ...
                                                ['normGeomSelect'], ...
                                                [0.08], ...
                                                [0.6 10], ...
                                                ['multiSimpleXover'], ...
                                                ['multiSimpleXover'], ...
                                                ['multiDepIntegerArithXover multiDepIntegerArithXover multiDepIntegerArithXover multiDepIntegerHeuristicXover multiDepIntegerHeuristicXover multiDepIntegerHeuristicXover multiDepIntegerHeuristicXover multiDepIntegerHeuristicXover multiDepIntegerHeuristicXover multiDepIntegerHeuristicXover multiDepIntegerHeuristicXover multiDepIntegerHeuristicXover multiDepIntegerHeuristicXover multiSimpleXover'], ...
                                                ['multiFloatArithXover multiFloatArithXover multiFloatArithXover multiFloatHeuristicXover multiFloatHeuristicXover multiFloatHeuristicXover multiFloatHeuristicXover multiFloatHeuristicXover multiFloatHeuristicXover multiFloatHeuristicXover multiFloatHeuristicXover multiFloatHeuristicXover multiFloatHeuristicXover multiSimpleXover'], ...
                                                [0], ...
                                                [0], ...
                                                [0; 0; 0; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 0], ...
                                                [0; 0; 0; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 0], ...
                                                [0.05 4], ...
                                                ['multiBinaryMutation'], ...
                                                ['multiIndepIntegerMutation'], ...
                                                ['multiDepIntegerGaussMutation'], ...
                                                ['multiFloatGaussMutation'], ...
                                                [1], ...
                                                [1], ...
                                                [0.02 5], ...
                                                [0.15 5]);

disp('Design variable vector for the minimum value found:');
disp(bestSol(1:6));
disp('corresponding to the objective function value of:');
fprintf(1, '%.2f\n', bestSol(7));
