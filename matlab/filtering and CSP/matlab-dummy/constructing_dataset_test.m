clear all           %clear all data
clc                 %clear screen

load('result.mat');
files=dir('F:\Dropbox\projectwork\5FYP\c prog\examples_DotNet\bin\x86\outputLeft_test\*.csv');

dat1=[];dat2=[];

for i= 1 : length(files)    %-3  why minus 3 here
 
    filename=['F:\Dropbox\projectwork\5FYP\c prog\examples_DotNet\bin\x86\outputLeft_test\' files(i).name];  
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


keyboard

clear files T B j


%files=dir('F:\Dropbox\projectwork\Emotiv\Emotiv premium libraries v3.0.0.41\Examples\EpocExamples\data1\*.csv');
 
files=dir('F:\Dropbox\projectwork\5FYP\c prog\examples_DotNet\bin\x86\outputRight_test\*.csv');

                           %why here never -3  - 2/9/2015  
for i= 1 : length(files)
 
    filename=['F:\Dropbox\projectwork\5FYP\c prog\examples_DotNet\bin\x86\outputRight_test\' files(i).name];
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

keyboard


low=8;high=30;order=5;s=128;
dat1=eegButterFilter(dat1, low, high, order,s);
dat2=eegButterFilter(dat2, low, high, order,s);

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

    for i = 1:size(dat,3)   
        temp1=z(:,:,i);
        temp1=temp1';
        f_test(:,i)=log(var(temp1));           %tn temp1 already transpose
    end

   
f_test=f_test';                                                          %transpose
f_test=[f_test(:,1:3) f_test(:,12:14)]; 
  








