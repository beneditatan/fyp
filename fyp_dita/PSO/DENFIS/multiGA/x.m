clear all;
clc
close all;
% load('../../../daTASET/ion_tra1.mat');
% train = ION;
% train(:,end)=train(:,end)+1;
% load('../../../daTASET/ion_tes.mat');
% test= ION
load('C3.mat');
ll=[1:7];
train=train(:,ll);
test=test(:,ll);
%test(:,end)=test(:,end)+1;
% ll= [1:2 4:19];
% train=train(:,ll);
% test=test(:,ll);

parameter.trainmode = 2;
parameter.dthr = .001;
parameter.mofn =35;
parameter.ecmepochs =10;
parameter.mlpepochs =10;
parameter.dispmode =1;

%dthr,ecmeepoc,mlpepoch

%%%% Processing data using denfis
tre = denfis(train,parameter);
tes = denfiss(test,tre);

%%%% Calculating the efficiency
%ny = max(train(end,:));
ny = max(test(end,:));

ny =2;
conf = zeros(ny,ny);
conft = zeros(ny,ny);

c = uint8(round(tre.Out));
ct = uint8(round(tes.Out));
%keyboard
for i=1:size(train,1)
    if (c(i)>ny), c(i) = ny; end
    conf(train(i,end),c(i)) = conf(train(i,end),c(i)) + 1;
end
for i= 1: size(test,1)
    if (ct(i)>ny), ct(i) = ny; end
    conft(test(i,end),ct(i)) = conft(test(i,end),ct(i)) + 1;    
end


disp('training overall');
tro=sum(diag(conf))/sum(sum(conf))
disp('training average');
tra=sum(diag(conf)'./sum(conf'))'/ny
disp('testing overall');
teo=sum(diag(conft))/sum(sum(conft))
disp('testing average');
tea=sum(diag(conft)'./sum(conft'))'/ny
save('../parameters/gcm.mat','parameter','tea','teo','tro','tra','parameter','tre','tes');
% clear all
% load ../parameters/gcm.mat
clc
tre.TrainTime
tre.NumNeuron