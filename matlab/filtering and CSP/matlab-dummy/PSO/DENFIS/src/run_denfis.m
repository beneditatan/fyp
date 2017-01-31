clear all;
close all
clc
%comment unwanted data sets
nyi=[1:6];
nxi=[7];
load('C3.mat')
UY=train;
UY1=test;
% load ('../../local safis/dataSet/Classification/UCI/glass.tra');
% UY=real(glass);
% load ('../../local safis/dataSet/Classification/UCI/glass.tra1'); uy1=glass;%uy1(10,:)=uy1(10,:)+1;
% uy2=uy1(nyi(1),:);
% load ('../../local safis/dataSet/Classification/UCI/glass.tes');UY1=glass;%UY1(10,:)=UY1(10,:)+1;
% UY2=UY1(nyi(1),:);
 ny=length(nyi);
Nmax    = 40;
par =[1.0728      0.34335       1.2257  7.0105e-009        0.644     0.096896      0.36437      0.53072           31     0.049533   1    1];

% par(1)  =   1.4378;    % P0
% par(2)  =   1.1132;   % Q0
% par(3)  =   1.0807;    % R0  
% par(4)  =   4.7563e-10;    % Minimum Goal
% par(5)  =   0.8078;    % Maximum error threshold
% par(6)  =   0.26819;    % Minimum error threshold
% par(7)  =   0.52642;    % Decay rate
% par(8)  =   0.5263;    % Overlap factor
% par(9)  =   12;   % Pruning window
% par(10) =   0.06191;     % Pruning threshold 
% par(11) =   1;       % Update only nearest neuron
% par(12) =   1;       % Prune neurons or not....

 %UY = [UY UY];
nx=size(nxi,2);
[tem L] = max(UY(nyi,:));
UY=UY(1:nx+1,:);
UY(nx+1,:)= L;
UY=UY';
tre = denfis(UY);
% Testing with same training samples........

conf = zeros(ny,ny);
for i = 1 : size(uy1,1)
    ctrain(i) = uy2(1,i);
    captrain(i) = tre.Out(1,i);  captrain(i)=uint8(round(captrain(i)));
    if (captrain(i)>ny), captrain(i) = ny; end;
    conf(ctrain(i),captrain(i)) = conf(ctrain(i),captrain(i)) + 1;
end
%Training Efficiency
conf
disp('Overall Efficiency')
sum(diag(conf))/size(uy1,1)

%Testing ........
tes = denfiss(UY1,tre);
conft = zeros(ny,ny);
for i = 1 : size(UY1,1)
    ctest(i) = UY2(1,i);
    captest(i) = uint8(round(tes.Out(1,i)));
    if (captest(i)>ny), captest(i)=ny; end
    conft(ctest(i),captest(i)) = conft(ctest(i),captest(i)) + 1;
end
%Testing Efficiency
conft

disp('Overall Efficiency')
sum(diag(conft))/size(UY1,1)
