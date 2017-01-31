%  clc
%  clear all

addpath('/Users/student3/Desktop/fyp/matlab/filtering and CSP/matlab-dummy/PSO');
addpath('/Users/student3/Desktop/fyp/matlab/filtering and CSP/matlab-dummy/Source/');
global train test maxRulesPerClass requiredTrainAccuracy requiredTestAccuracy
requiredTrainAccuracy = 0.63; requiredTestAccuracy = 1;


load('A1');

%keyboard

mi = min([train;test]);ma = max([train;test]);
train(:,1:end-1) = 2*bsxfun(@rdivide,bsxfun(@minus,train(:,1:end-1),mi(1,1:end-1)),ma(1,1:end-1)-mi(1,1:end-1))-1;
test(:,1:end-1) = 2*bsxfun(@rdivide,bsxfun(@minus,test(:,1:end-1),mi(1,1:end-1)),ma(1,1:end-1)-mi(1,1:end-1))-1;


train=[train;train;train];
UY=train;
UY1=test;
 
designVectorProps = [
    4   0.01   0.05    % delete %con ed
    4   1.01      1.2% add ea
    4   0.04     0.7 % update el
    4   0.1      0.99  %gamma %con
    4   0.1     0.6 %novelty
    4   0.1     0.95     %kappa %con
    4   0.1      0.8   %eta
  ];



 maxRulesPerClass =28*ones(1,7);%[5 5 5];


  
[gbest,fit] = PS('mcit2fisClassObjective',designVectorProps,'max',	5,5,1);
display(['Best fitness value is ' num2str(fit) ', with parameters ' num2str(gbest)]);
% 
% disp('Second Run beginning...');
% designVectorProps = [
%     4   0.04    0.04    % delete %con
%     4   gbest(1,2)-0.1      gbest(1,2)+0.1% add
%     4   gbest(1,3)-0.1      gbest(1,3)+0.1% update
%     4   0.99     0.99     %gamma %con
%     4   gbest(1,5)-0.1      gbest(1,5)+0.1   %novelty
%     4   0.95      0.95     %kappa %con
%     4   gbest(1,7)-0.1      gbest(1,7)+0.1%eta
%   ];
% 
% [gbest,fit] = PS('mcit2fisClassObjective',designVectorProps,'max',10,10,1);

%display(['Best fitness value is ' num2str(fit) ', with parameters ' num2str(gbest)]);
%rmpath('PSO/','Source/');
   
   keyboard
   
controlParameters=gbest;
maxRulesPerClass=[28  28];
%maxRulesPerClass=[28 28 28 28];


%% TRAIN AND TEST THE NETWORK
MODEL=McIT2FIS_um1(train,maxRulesPerClass,controlParameters);

% Testing on training data


trO = McIT2FIS_um1(train,MODEL); 
train_output = trO.OUTPUT;
[~,train_label] = max(train_output');
conf_train = zeros(max(train(:,end)));
for sampCount = 1:size(train,1)
    conf_train(train(sampCount,end),train_label(1,sampCount)) = conf_train(train(sampCount,end),train_label(1,sampCount))+1;
end
train_overall = sum(diag(conf_train))/sum(sum(conf_train));
train_average = mean(diag(conf_train)./sum(conf_train')');

%test
    teO = McIT2FIS_um1(test,MODEL); 
    test_output = teO.OUTPUT;
    [~,test_label] = max(test_output');
    conf_test = zeros(max(train(:,end)));
    %keyboard
    for sampCount = 1:size(test,1)
        conf_test(test(sampCount,end),test_label(1,sampCount)) = conf_test(test(sampCount,end),test_label(1,sampCount)) + 1;
    end
    %keyboard
    test_overall = sum(diag(conf_test))/sum(sum(conf_test));
    test_average = mean(diag(conf_test)./sum(conf_test')');
    %keyboard
    disp([train_overall train_average test_overall test_average sum(MODEL.RULES_PER_CLASS)]);

%% DISPLAY DETAIL OF TRAINING AND TESTING
clc
fprintf('TRAINING COMPLETED in %f secs \n',MODEL.TRAIN_TIME);
fprintf('Added %d rules, updated %d times, deleted %d samples \n',sum(MODEL.RULES_PER_CLASS),MODEL.DELETE_UPDATE(1),MODEL.DELETE_UPDATE(2));
% fprintf('Training: overall = %.1f, average = %.1f; Testing: overall = %.1f, average = %.1f \n',train_overall,train_average,test_overall,test_average);
disp([sum(MODEL.RULES_PER_CLASS) train_average test_average]);


save ('MODEL','MODEL');
   
   
   
   
   
   
   
   
   
   
