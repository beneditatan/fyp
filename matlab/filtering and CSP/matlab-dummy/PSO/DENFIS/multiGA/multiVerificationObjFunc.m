function [fitness] = multiVerificationObjFunc(u, opts)
% This objective function was used to verify the capabilities of
% the multiple variable representation possibilities of the
% multiGA code

global UY UY1 UY2 kmax nxi nyi par uy1 uy2

par(1)  =   u(1); % P0
par(2)  =   u(2); % Q0
par(3)  =   u(3); % R0  
par(4)  =   u(9);    %skip threshold
par(5)  =   u(4);    %adding novelty threshold
par(6)  =   0.9;    % min of adding error threshold
par(7)  =   u(5);    %initial adding error threshold
par(8)  =   u(6);    %initial learning error threshold
par(9)  =   u(7);    %decay factor
par(10) =   u(8);   %overlap factor 
par(11) =   25;   %limit of neurons for processing

generation = opts(1);

% Model development
for i=1:7
    kmax(i)=20;
end
ny=length(nyi);
[y,w,k,P]=ssafis(UY,nxi,nyi,kmax,par);

% Testing with same training samples........
[y]=ssafis(uy1,nxi,nyi,kmax,[],w);

conf = zeros(ny,ny);
for i = 1 : size(uy1,2)
    c = uy2(1,i);
    [te,cap] = max(y(:,i));
    conf(c,cap) = conf(c,cap) + 1;
end
%Training Efficiency
tra=sum(diag(conf))/size(uy1,2);

%Testing ........
[yt]=ssafis(UY1,nxi,nyi,kmax,[],w);
conft = zeros(ny,ny);
for i = 1 : size(UY1,2)
    c = UY2(1,i);
    [te,cap] = max(yt(:,i));
    conft(c,cap) = conft(c,cap) + 1;
end
%Testing Efficiency
tes=sum(diag(conft))/size(UY1,2);

% Maximize the fittness
if tra < 0.94
    fitness = tra;
else
    fitness = 1 + tes;
end