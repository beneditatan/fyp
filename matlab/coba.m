

%filename_left = 'Macintosh HD\Users\student3\Desktop\fyp\outfile16_left.csv';
filename_left = '/Users/student3/Desktop/fyp/outfile16_left.csv';
filename_right = '/Users/student3/Desktop/fyp/outfile16_right.csv';
%matrix dimension

left = csvread(filename_left, 1,0);
left = left(1:92,4:17);

right = csvread(filename_right, 1,0);
right = right(1:92,4:17);

%disp(left);
%disp(right);
output = fopen('/Users/student3/Desktop/fyp/output.txt', 'w');
result = CSP(left, right);
disp(result);
res_real = real(result);
res_imag = imag(result);

adjacent = [res_real res_imag];

%fprintf(output,'%d',adjacent);
%fclose(output);

