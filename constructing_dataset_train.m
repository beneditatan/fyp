%creatingtrain data


%3/9/2015
%vincent - this whole .m is for eqn 1-7


clear all           %clear all data
clc                 %clear screen
%files=dir('F:\Dropbox\projectwork\Emotiv\Emotiv premium libraries v3.0.0.41\Examples\EpocExamples\examples_DotNet\bin\x86\left_allsensors\*.csv')

%files=dir('F:\Dropbox\projectwork\5FYP\c prog\examples_DotNet\bin\x86\outputLeft_train\*.csv');
files=dir('/Users/student3/Desktop/fyp/outputLeft_train/*.csv');

dat1=[];dat2=[];

for i= 1 : length(files)    %-3  why minus 3 here
 
    %filename=['F:\Dropbox\projectwork\5FYP\c prog\examples_DotNet\bin\x86\outputLeft_train\' files(i).name];
    filename = ['/Users/student3/Desktop/fyp/outputLeft_train/' files(i).name];
    T=csvread(filename,1,0);
    T=T(11:90,4:17);           %T=T(11:100,4:17); 4/9-now 100 can  - depends on the no of files in the dir
   
    %baseline correction
    B=mean(T);
    for j=1:size(T,2)
       T(:,j)=abs(T(:,j)- B(j));
    end  

    dat1(:,:,i)=T;   %3-dimensional matrix of the T of every file
    clear filename 
end



clear files T B j


%files=dir('F:\Dropbox\projectwork\Emotiv\Emotiv premium libraries v3.0.0.41\Examples\EpocExamples\data1\*.csv');
 
files=dir('/Users/student3/Desktop/fyp/outputRight_train/*.csv');

                           %why here never -3  - 2/9/2015  
for i= 1 : length(files)
 
    filename=['/Users/student3/Desktop/fyp/outputRight_train/' files(i).name];
    T1=csvread(filename,1,0);
    T1=T1(11:90,4:17); 
    
    %baseline correction
    B=mean(T1);
    for j=1:size(T1,2)
        T1(:,j)=abs(T1(:,j)- B(j));
    end
    
    dat2(:,:,i)=T1;
    clear filename
  
end
clear files T1 B



%  %baseline correction
%   B=mean(dat1);
%     for j=1:size(dat1,2)
%         dat2(:,j)=abs(dat1(:,j)- B(j));
%     end    

%frequency preprocessing

low=8;high=30;order=5;s=128;
dat1=eegButterFilter(dat1, low, high, order,s);
dat2=eegButterFilter(dat2, low, high, order,s);



%applying CSP

%Averaged caovariance matrix
%calculating covaraince matricees for each trial 


     %covariance matrix for every T(file)
     %left
     %c_1 is also 3 dimensional
    for i = 1:size(dat1,3) 
        c_1(:,:,i)=dat1(:,:,i)'*dat1(:,:,i)/trace(dat1(:,:,i)*dat1(:,:,i)');
    end


    %right
    for i = 1:size(dat2,3)
        c_2(:,:,i)=dat2(:,:,i)'*dat2(:,:,i)/trace(dat2(:,:,i)*dat2(:,:,i)');
    end


%averaging the covaraince matricees over all trails for each filterbank
%zeros matrix
c1=zeros(size(dat1,2),size(dat1,2));                                               
c2=zeros(size(dat2,2),size(dat2,2));
    
    
siz=0;train_label=[];

%for each T(file) in dat1
%composite spatial covariance
for i = 1:size(dat1,3)          
                                                               
        temp1=c_1(:,:,i);          
        c1=c1+temp1;
        siz=siz+1;
        train_label=[train_label;1]; %vvertical concatenation     
end
%train_label = [1;1;1;1;1;1;1;1]; %means -> left
%mean(c1)
c1=c1./siz;


siz=0;          %clear siz

for i = 1:size(dat2,3)          %same as above function
    
        temp2=c_2(:,:,i);
        c2=c2+temp2;
        siz=siz+1;
        train_label=[train_label;2];
end
c2=c2./siz;                     %divide by the siz parameter  ./ and / is the same

%traub_label = [2;2;2;2] %means -> right


%applying CSP
result=CSP(c1,c2);


%cancatenting dat1 and dat2
%concatenation along the depth/3rd dimension

dat=cat(3, dat1, dat2);         



%calculating the z matrix for training
%I should loop here for all the data points
%(samples,channels,trails,filterbands)

    for i = 1:size(dat,3)
        temp=dat(:,:,i)'; %both left and right
        z(:,:,i)=result(:,:)*temp;  %times E (trial matrix/the csv file)
    end


f=[];f1=[];f2=[];

%Section D

%variance of one channel/sum of variance of all channel                    %%eqn 7
%should get (channels, trails, filterbank)
%feature extraction for training data

    for i = 1:size(dat,3)   
        temp1=z(:,:,i);
        temp1=temp1';
        f_train(:,i)=log(var(temp1));         %each column is a feature of each E/csv file  
    end
    
    
    
    
 %train and test features
                                                                           %%not sure

f_train=f_train';        %each row is a feature of each E/csv file         %transpose
%only take 1st to 3rd column and 12th to 14th column from each row 
%concatenate horizontally
%the first size(dat1,3) row belong to left
%the second size(dat2,3) row belong to right 
f_train=[f_train(:,1:3) f_train(:,12:14)];   



%training a svm
%svmstruct=svmtrain(f_train,train_label','kernel_function','rbf');               %http://www.mathworks.com/help/stats/svmtrain.html

clear c_1 c_2 dat dat1 dat2 f f1 f2 high i j low
clear order s siz temp temp1 temp2 z c1 c2

%save 'svm_train' 'svmstruct' 'result';
%save ('result', 'result');




% clear all           %clear all data
% clc                 %clear screen
% 
% load('result.mat');
files=dir('/Users/student3/Desktop/fyp/outputLeft_test/*.csv');

dat1=[];dat2=[];

for i= 1 : length(files)    %-3  why minus 3 here
 
    filename=['/Users/student3/Desktop/fyp/outputLeft_test/' files(i).name];  
    T=csvread(filename,1,0);
    T=T(11:90,4:17);           %T=T(11:100,4:17); 4/9-now 100 can  - depends on the no of files in the dir
   
    %baseline correction
    B=mean(T);
    for j=1:size(T,2)
       T(:,j)=abs(T(:,j)- B(j));
    end  

    dat1(:,:,i)=T;
    clear filename 
end



clear files T B j


%files=dir('F:\Dropbox\projectwork\Emotiv\Emotiv premium libraries v3.0.0.41\Examples\EpocExamples\data1\*.csv');
 
files=dir('/Users/student3/Desktop/fyp/outputRight_test/*.csv');

                           %why here never -3  - 2/9/2015  
for i= 1 : length(files)
 
    filename=['/Users/student3/Desktop/fyp/outputRight_test/' files(i).name];
    T1=csvread(filename,1,0);
    T1=T1(11:90,4:17); 
    
    %baseline correction
    B=mean(T1);
    for j=1:size(T1,2)
        T1(:,j)=abs(T1(:,j)- B(j));
    end
    
    dat2(:,:,i)=T1;
    clear filename
  
end
clear files T1 B




low=8;high=30;order=5;s=128;
dat1=eegButterFilter(dat1, low, high, order,s);
dat2=eegButterFilter(dat2, low, high, order,s);

test_label=[];


for i=1:size(dat1,3)
    test_label=[test_label;1];
end
 for i=1:size(dat2,3)
    test_label=[test_label;2];
end   
    

%cancatenting dat1 and dat2
dat=cat(3, dat1, dat2);         %cat three dimension


%calculating the z matrix for training
%I should loop here for all the data points
%(samples,channels,trails,filterbands)


for i = 1:size(dat,3)
    temp=dat(:,:,i)';
    z(:,:,i)=result(:,:)*temp;
end

%variance of one channel/sum of variance of all channel                    %%eqn 7
%should get (channels, trails, filterbank)

%feature extraction
    for i = 1:size(dat,3)   
        temp1=z(:,:,i);
        temp1=temp1';
        f_test(:,i)=log(var(temp1));           %tn temp1 already transpose
    end

   
f_test=f_test';                                                          %transpose
f_test=[f_test(:,1:3) f_test(:,12:14)]; 

keyboard


train=[f_train train_label];
%train = [feature -> class]

test=[f_test test_label];

%A1 contains the feature
save 'dataset\A1' train test;








