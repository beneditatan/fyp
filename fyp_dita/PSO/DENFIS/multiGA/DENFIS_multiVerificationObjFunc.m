function [fitness] = DENFIS_multiVerificationObjFunc(u, opts)
% This objective function was used to verify the capabilities of
% the multiple variable representation possibilities of the
% multiGA code

global UY UY1 UY2 kmax nxi nyi Nmax par uy1 uy2 k ny


% Gama  =   u(1); % P0
% Deltamax  =   u(2); % Q0
% Deltamin  =   u(3); % R0  
% Overlap  =   u(4);    %skip threshold
% Min_Goal  =   u(5);    %adding novelty threshold
% Min_GoalP  =   u(6);    % min of adding error threshold

% par=u(1:12);
% Nmax=u(13);
parameter.trainmode = u(1);
parameter.dthr = u(2);
parameter.mofn = u(3);
parameter.ecmepochs =u(4);
parameter.mlpepochs = u(5);
parameter.dispmode = u(6);

generation = opts(1);

% Model development

tre = denfis(UY,parameter);
tes1 = denfiss(UY1,tre);
ny = 7;
conf = zeros(ny,ny);
conft = zeros(ny,ny);

c = uint8(round(tre.Out))+1;
ct = uint8(round(tes1.Out))+1;
% keyboard
for i=1:size(UY,1)
    if (c(i)>ny), c(i) = ny; end
    conf(c(i),UY(i,end)+1) = conf(c(i),UY(i,end)+1) + 1;
end
for i= 1: size(UY1,1)
    if (ct(i)>ny), ct(i) = ny; end
    conft(ct(i),UY1(i,end)+1) = conf(ct(i),UY1(i,end)+1) + 1;    
end


tra=sum(diag(conf))/sum(sum(conf));
tes=sum(diag(conft))/sum(sum(conft));

% Maximize the fittness
if tra < .70
    fitness = tra;
else
    fitness = 1 + tes;
    k=par;
end