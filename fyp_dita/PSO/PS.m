function [xbest,fit] = PS(ObjFn,DesignProps,type,N,N_GER,isParallel)
% keyboard
%% Particle Swarm Optimizer with Parallel implementation
%% Written by Kartick. C2I, NTU.
%% ObjFn is the objective function
%% DesignProps (N x 2) is the design props N parameters, min and max values
%% type is minimize or maximize.
%% Pop is number of population
%% N_GER is iteration number
%% Code begins here

global train test maxRulesPerClass requiredTrainAccuracy requiredTestAccuracy

% Check turn on parallel implementation
if(isParallel)
    v = ver;
    if(any(strcmp('Parallel Computing Toolbox', {v.Name})))
        if(isempty(gcp('nocreate')))
%             matlabpool open 4;
        end
    end
end

PHI1 = 1.1;
PHI2 = 1.8;
N_PAR = size(DesignProps,1);
v = zeros(N,N_PAR);
[INT] = find(DesignProps(:,1) == 0);
X_MIN = DesignProps(:,2);
X_MAX = DesignProps(:,3);
xmax = X_MAX; xmin = X_MIN;
vmin = -(max(xmax)-min(xmin))/(N*5);
vmax =  (max(xmax)-min(xmin))/(N*5);
gBest = zeros(1,N_PAR);

W = 1.5;
if(strcmp(type,'min') == 1)
    gbestvalue = 1e3;
else
    gbestvalue = -1e3;
end

gaux = ones(N,1);

xBest = zeros(N,N_PAR);
fit = zeros(N,1);
fitBest = zeros(N,1);
nger = 1;

%% Initialize Particles and find initial fitness
x = initSwarm(N,N_PAR,X_MIN,X_MAX);
x(:,INT) = round(x(:,INT));
for j = 1:N
    fit(j) = feval(ObjFn,x(j,:),train, test, maxRulesPerClass, requiredTrainAccuracy, requiredTestAccuracy);
    fitBest(j) = fit(j);
end

if strcmp(type,'min') == 1
    [~,b] = min(fit);
else
    [~,b] = max(fit);
end

gBest = x(b,:);
gbestvalue = fit(b);
%keyboard
xBest = x;
disp('this is [0 gbestvalue]');
disp(['0' gbestvalue]);
%% Continue iteration
while(nger<=N_GER)
    i = 1;
    randnum1 = rand(N,N_PAR);
    randnum2 = rand(N,N_PAR);
    
    v = W.*v + randnum1.*(PHI1.*(xBest-x)) + randnum2.*(PHI2.*(gaux*gBest-x));
    
    v = ((v<=vmin).*vmin) + ((v>vmin).*v);
    v = ((v>=vmax).*vmax) + ((v<vmax).*v);
    
    x = x + v;
    x(:,INT) = round(x(:,INT));
    for j = 1: N
        for k = 1: N_PAR
            if(x(j,k)<X_MIN(k))
                x(j,k) = X_MIN(k);
            elseif(x(j,k)>X_MAX(k))
                x(j,k) = X_MAX(k);
            end
        end
    end
    
    while(i<2)
        for j = 1:N
            fit(j) = feval(ObjFn,x(j,:),train, test, maxRulesPerClass, requiredTrainAccuracy, requiredTestAccuracy);
            if(fit(j)<fitBest(j))
                fitBest(j) = fit(j);
                xBest(j,:) = x(j,:);
            end
        end
        
        if(strcmp(type,'min')==1)
            [~,b] = min(fit);
            if(fit(b)<gbestvalue)
                gBest = x(b,:);
                gbestvalue = fit(b);
            end
        else
            [~,b] = max(fit);
            if(fit(b)>gbestvalue)
                gBest = x(b,:);
                gbestvalue = fit(b);
            end
        end
        i = i + 1;
    end
    disp('this is nger gbestvalue');
    disp([nger gbestvalue]);
    nger = nger + 1;
end
xbest = gBest;
fit = gbestvalue;
end

function swarm = initSwarm(N,N_PAR,V_MIN,V_MAX)
swarm = zeros(N,N_PAR);
for i = 1:N
    for j = 1:N_PAR
        swarm(i,j) = rand(1,1)*(V_MAX(j)-V_MIN(j)) + V_MIN(j);
    end
end
end