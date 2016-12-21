filename = 'D:\fyp\matlab\extract raw signal\EDFTest.csv';

%matrix dimension
c = 14;
r = 11;
p = 10;

R1 = 1;
R2 = 10;
C1 = 2;
C2 = 15;
for i = 1:p
    A(:,:,i) = csvread(filename, R1,C1,[R1,C1,R2,C2]);
    E(:,:,i) = A(:,:,i)';
    R1 = R1+r;
    R2 = R2+r;
    disp(i)
    disp(E(:,:,i))
end





