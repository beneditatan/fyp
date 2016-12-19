%poll the folder in every 1 sec
% the out of synch problem can be solved by ensuring consecutive LL or consecutive RR

% t = timer('TimerFcn', @mycallback, 'Period', 1.0, 'ExecutionMode', 'fixedSpacing');
% DIR_TO_READ = 'F:\Dropbox\projectwork\Emotiv\Emotiv premium libraries v3.0.0.41\Examples\EpocExamples\examples_DotNet\bin\x86';
% DIR_TO_MOVE_PROCESSED = 'F:\Dropbox\projectwork\Emotiv\Emotiv premium libraries v3.0.0.41\Examples\EpocExamples\data_test';
% t = timer('TimerFcn', @XBeePoll, 'Period', 1.0, 'ExecutionMode', 'fixedSpacing');
%3/9/2015
%vincent - this whole .m is for eqn 6-7
% function doit
%
% t=timer('TimerFcn', @fun, 'ExecutionMode', 'fixedRate', 'Period', 1);
%     function  fun(obj,event)
clear all
%files=dir('F:\Dropbox\projectwork\Emotiv\Emotiv premium libraries v3.0.0.41\Examples\EpocExamples\examples_DotNet\bin\x86\*.csv');

%files=dir('C:\YHWHCprog\examples_DotNet\bin\x86\outputLeft\*.csv');
files=dir('F:\Dropbox\projectwork\5FYP\c prog\examples_DotNet\bin\x86\*.csv');   %correct

load('MODEL.mat');
load('result.mat');

%load('svm_train.mat');
%get the csv file and get the data of one trial (aim to classify that one trial using your model to left-right)
%T = csvread('F:\Dropbox\projectwork\Emotiv\Emotiv premium libraries v3.0.0.41\Examples\EpocExamples\examples_DotNet\bin\x86\outfile.csv',1,0);
%for i= 1 : length(files)

while 1
    %filename=['F:\Dropbox\projectwork\Emotiv\Emotiv premium libraries v3.0.0.41\Examples\EpocExamples\examples_DotNet\bin\x86\' files(i).name];
    
    filename=['F:\Dropbox\projectwork\5FYP\c prog\examples_DotNet\bin\x86\' files.name];
    
    %if file name is empty...we continue
    
    
    
    T=csvread(filename,1,0);       %csvread(filename,R1,C1) , Row offset 1 and Column offset 0
    %remove file from the folder
    %delete('F:\Dropbox\projectwork\5FYP\c prog\examples_DotNet\bin\x86\outfile.csv')
    
    %delete(filename)
    
    T=T(11:90,4:17);               %understand - 2/9        %try 90 working for 10 files. if 100, cannot
    
    %original - T=T(11:100,4:17);
    %baseline correction           %?
    B=mean(T);
    for j=1:size(T,2)               %For example, size(A,1) is the number of rows of A and size(A,2) is the number of columns of A.
        %A = [a b c ; a b d; d c b; c b a]; r = size(A, 2) gives 3
        T(:,j)=abs(T(:,j)- B(j));
    end
    
    dat=T;                   %?
    clear filename                  %tn
    clear files T B j
    
    %Do preprocessing           %section B
    
    low=8;high=30;order=5;s=128;     %8-30HZ freq band, attenuation in the stopband 250, order 5?
    dat=eegButterFilter(dat, low, high, order,s);           %http://www.mathworks.com/help/signal/ref/buttord.html
    
    %apply CSP
    
    %load train_info.mat;  %4/9/2015 latest must comment off
    
    %load result.mat; %4/9/2015
    
    Z_test=result*dat';                                     %p is result see egn 3?yes
    
    %section D
    
    keyboard
    %calculate varaiance
    f_test=log(var((Z_test)'));       %transpose of Z_test, why
    f_test=[f_test(:,1:3) , f_test(:,12:14)];    %?
    
    test=[f_test 2];
    
    teO = McIT2FIS_um1(test,MODEL);
    test_output = teO.OUTPUT;
    [~,test_label] = max(test_output');
    
    
    %code to write in the file which will be read by java
    
    label=test_label;
    
    switch label
        case 1                                                     %%C:\Users\tant0106\Documents\MATLAB\Emotive_output.txt          have to be here
            fileID = fopen('F:\Dropbox\projectwork\5FYP\matlab\filtering and CSP\matlab-dummy\Emotive_output1.txt','w');           %('C:\YHWHMatlab\matlab-dummy\Emotive_output.txt','w');  -original
            fprintf(fileID,'left');
            fclose(fileID);
            %break;
        case 2
            fileID = fopen('F:\Dropbox\projectwork\5FYP\matlab\filtering and CSP\matlab-dummy\Emotive_output1.txt','w');       %C:\Users\tant0106\Documents\MATLAB\Emotive_output.txt
            %C:\Users\tant0106\Documents\MATLAB
            fprintf(fileID,'right');                        %should i change to right?  - 2/9 - original is push
            fclose(fileID);
            %break;
        otherwise
            fprintf('Invalid grade\n' );
            %break;
    end
    
    clear dat      
    
end


%classify data using SVM

%load svmstruct.mat; %4/9/2015

%label=svmclassify(svmstruct,f_test)                     %http://www.mathworks.com/help/stats/svmclassify.html

%write the action and               classifiability percentage to a file
%keyboard  -cannot insert this keyword here, if not cant write properly
% switch label
%     case 1                                                     %%C:\Users\tant0106\Documents\MATLAB\Emotive_output.txt          have to be here
%         fileID = fopen('C:\Users\tant0106\Documents\MATLAB\Emotive_output.txt','w');           %('C:\YHWHMatlab\matlab-dummy\Emotive_output.txt','w');  -original
%         fprintf(fileID,'left');
%         fclose(fileID);
%         %break;
%     case 2
%         fileID = fopen('C:\Users\tant0106\Documents\MATLAB\Emotive_output.txt','w');       %C:\Users\tant0106\Documents\MATLAB\Emotive_output.txt
%         %C:\Users\tant0106\Documents\MATLAB
%         fprintf(fileID,'right');                        %should i change to right?  - 2/9 - original is push
%         fclose(fileID);
%         %break;
%     otherwise
%         fprintf('Invalid grade\n' );
%         %break;
% end
% 
% 
% clear dat

%end  %end of the fun



% start(t)
% pause(3)
% stop(t)
% delete(t)
% end



