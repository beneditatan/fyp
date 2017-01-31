function [x] = parse(inStr)
% parse is a function which takes in a string vector of blank separated text
% and parses out the individual string items into a n item matrix, one row
% for each string.
%
% function [x] = parse(inStr)
% x     - the return matrix of strings
% inStr - the blank separated string vector

sz=size(inStr);
strLen=sz(2);
x=blanks(strLen);
wordCount=1;
last=0;
for i=1:strLen,
  if inStr(i) == ' '
    wordCount = wordCount + 1;
    x(wordCount,:)=blanks(strLen);
    last=i;
  else
    x(wordCount,i-last)=inStr(i);
  end
end
