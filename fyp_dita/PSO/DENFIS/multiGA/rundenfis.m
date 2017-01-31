clear all
clc

parameter.trainmode = 1;
parameter.dthr = .01;
parameter.mofn =30;
parameter.ecmepochs =2;
parameter.mlpepochs =3;
parameter.dispmode =1;

load ('../../../dataset/seg.tra');
train = real(seg)';
train = [train(:,1:2) train(:,4:end)];
load ('../../../dataset/seg.tes');
test = real(seg)';
test = [test(:,1:2) test(:,4:end)];
nxi = [1:18];
nx=size(nxi,2);
nyi = [19:25];
tran = [];
tess = [];
tr_time=0;
neurons = 0;
for i=1:size(nyi,2)
    dat(i,:,:) = [train(:,nxi) train(:,nx+i)];
    dat1(:,:)=dat(i,:,:);
    star_time(i)=cputime;
    tre(i) = denfis(dat1,parameter);
    stop_time(i) = cputime;
    tes(i) = denfiss(test,tre(i));
    tran = [tran;tre(i).Out];
    tess = [tess;tes(i).Out];
    tr_time= tr_time + tre(i).TrainTime;
    neurons = neurons + tre(i).NumNeuron;
end

conf =zeros(size(nyi,2),size(nyi,2));
conft =zeros(size(nyi,2),size(nyi,2));
[~,c]= max(tran);
[~,cap] = max(tess);

for i=1:size(train,1)
%     k=train1(i,end);
    [~,k]=max(train(i,nyi)');
    conf(k,c(i)) = conf(k,c(i)) + 1;
end
for i= 1: size(test,1)
    conft(test(i,end),cap(i)) = conf(test(i,end),cap(i)) + 1;    
end

tro = sum(diag(conf))/sum(sum(conf))*100;
tra = mean(diag(conf)./sum(conf')')*100;
teo = sum(diag(conft))/sum(sum(conft))*100;
tea = mean(diag(conft)./sum(conft')')*100;

disp('train overall train average')
display([tro tra])

disp('test overall test average')
display([teo tea])

disp('train time neurons')
display([tr_time neurons])