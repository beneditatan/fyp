



%baselining of a trial

for i=1:6               %why till 6 - 6 gives the discriminate better - is a magic number - see the ankit paper 

fname = sprintf('outfile%d.csv', i);             %not printf but rather Format data into string

%T = csvread('F:\Dropbox\projectwork\Emotiv\Emotiv premium libraries v3.0.0.41\Examples\EpocExamples\examples_DotNet\bin\x86\left_allsensors\fname',1,0);
T = csvread('C:\YHWHCprog\examples_DotNet\bin\x86\outputLeft\fname',1,0);
%T = csvread('C:\YHWHCprog\examples_DotNet\bin\x86\fname',1,0);

end

A=T(:,4:17);            %4:17 meaning i take the column 4 to 17, with starting from 1

B=mean(A);

for i=1:size(A,2)       %2 means take the column of A only
    A(:,i)=abs(A(:,i)- B(i));
end





%frequency preprocessing


%applying CSP


%svm train and test

%dir('F:\Dropbox\projectwork\Emotiv\Emotiv premium libraries v3.0.0.41\Examples\EpocExamples\examples_DotNet\bin\x86\left_allsensors');
files= dir('C:\YHWHCprog\examples_DotNet\bin\x86\outputLeft\*.csv');   %amended original: dir('C:\YHWHCprog\examples_DotNet\bin\x86\outputLeft');  
%dir('C:\YHWHCprog\examples_DotNet\bin\x86\');

for file = files'
    csv = load(file.name);
    % Do some stuff
end