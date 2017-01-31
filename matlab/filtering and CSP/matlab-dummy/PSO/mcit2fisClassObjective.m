function fitness = mcit2fisClassObjective(controlParameters,train, test, maxRulesPerClass, requiredTrainAccuracy, requiredTestAccuracy)

MODEL=McIT2FIS_um1(train,maxRulesPerClass,controlParameters);
%MODEL = McIT2FIS(train,maxRulesPerClass,controlParameters);
% Testing on training data

%trO = McIT2FIS(train,MODEL); 
trO = McIT2FIS_um1(train,MODEL); 
train_output = trO.OUTPUT;
[~,train_label] = max(train_output');
conf_train = zeros(max(train(:,end)));
for sampCount = 1:size(train,1)
    conf_train(train(sampCount,end),train_label(1,sampCount)) = conf_train(train(sampCount,end),train_label(1,sampCount))+1;
end
train_overall = sum(diag(conf_train))/sum(sum(conf_train));
train_average = mean(diag(conf_train)./sum(conf_train')');
% if(train_overall < requiredTrainAccuracy)
%     fitness = train_overall; 
%     disp([train_overall train_average sum(MODEL.RULES_PER_CLASS)]);
%elseif(train_overall > requiredTrainAccuracy && train_average > requiredTrainAccuracy)
    % Testing on test data
    %teO = McIT2FIS(test,MODEL); 
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
%     if(test_overall>requiredTestAccuracy && test_average>requiredTestAccuracy)
%         fitness = 4+test_average;
%     else
%         fitness = 3+test_overall;
%     end
% else
   

% if(train_average>requiredTrainAccuracy)
%        fitness = 3 + test_average;
%        save good_result.mat 'MODEL' 'train' 'test';
%    elseif(train_overall>requiredTrainAccuracy)
%        fitness = 2 + train_average;
%    else
%        fitness = train_average;
%    end
       
if(train_overall>requiredTrainAccuracy)
       fitness = 3 + test_overall;
%       save good_result.mat 'MODEL' 'train' 'test';
   elseif(train_average>requiredTrainAccuracy)
       fitness = 2 + train_average;
   else
       fitness = train_average;
   end