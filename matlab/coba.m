

filename_left = 'D:\fyp\outfile16_left.csv';
filename_right = 'D:\fyp\outfile16_right.csv';
%matrix dimension

left = csvread(filename_left, 1,0);
left = left(1:92,4:17);

right = csvread(filename_right, 1,0);
right = right(1:92,4:17);

%disp(left);
%disp(right);
output = fopen('D:\fyp\output.txt', 'w');
result = CSP(left, right);
disp(result);
res_real = real(result);
res_imag = imag(result);

adjacent = [res_real res_imag];

fprintf(output,'%d',adjacent);
fclose(output);

