%% Function for training and testing of McCIT2FIS
function [varargout] = McIT2FIS_um(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% PBL based learning for Meta-Cognitive IT2FIS  %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%keyboard
%% Check if training or testing of the network
%keyboard
if(nargin == 3)
    train = true;               % Training phase
    UY = varargin{1};           % Training Data set; Dimension = No. of samples x (No. of features + Class label)
    NHN = varargin{2};        % Network parameters
    mcpar = varargin{3};        % Control parameters
elseif(nargin == 2)
    train  = false;
    UY    = varargin{1};
    MODEL   = varargin{2};
    nwpar = MODEL.NETWORK_PARAMETER;
    Cl = MODEL.CENTER_left;              % Centers of the rules
    Cr = MODEL.CENTER_right;             % Centers of the rules
    S = MODEL.WIDTH;               % Widths of the rules
    W = MODEL.OUTPUT_WEIGHT;             % Output weight of rules
    R = sum(MODEL.RULES_PER_CLASS);
    clear MODEL;
else
    error('Incorrect number of arguments');
end

if (train == true)
    %% Initialize the network parameters
    NIP = size(UY,2)-1;             % No. of input features
    NOP = max(UY(:,end));           % No. of output features
    Cl = zeros(sum(NHN),NIP);       % Left centers of rules
    Cr = zeros(sum(NHN),NIP);       % Right centers of rules
    S = zeros(sum(NHN),1);         %  width of rules
    W = zeros(sum(NHN),NOP);        % Output weight matrix
    
    %% Initialize the control parameters
    Ed      = mcpar(1);             % Delete magnitude threshold
    Ea      = mcpar(2);             % Add magnitude threshold
    El      = mcpar(3);             % Learn magnitude threshold
    gama    = mcpar(4);             % Decay factor
    En      = mcpar(5);             % Novelty threshold
    kappa   = mcpar(6);             % Intra-class overlap factor
    eta     = mcpar(7);             % Inter-class overlap factor
    %% Initialize the local variables used
    A = zeros(sum(NHN));            % Projection matrix
    B = zeros(sum(NHN),NOP);        % Output matrix
    TRA = true;                     % Train status checker
    flag = zeros(1,size(UY,1));     % Status of samples (0-unlearnt 1-learnt 2-deleted)
    R = zeros(1,NOP);               % Rules in each class
    Cmat = 2*eye(NOP)-1;% Coded class label
    w1 = zeros(1,sum(NHN)); %class labels of rules
    update_count = 0;               % Count number of samples employed in update
    cou = 5;
    %% Training phase start here
    Start_time = cputime;           % Record start of training time
    % Initialize the first rule of the network
    R(1,UY(1,end)) = 1;
    Cl(sum(R),:) = UY(1,1:NIP)-0.001;
    Cr(sum(R),:) = UY(1,1:NIP)+0.001;
    S(sum(R),1) =kappa *sqrt((1/NIP)*Cl(sum(R),:)*Cl(sum(R),:)');
    A(sum(R),sum(R)) = 1;  
    B(sum(R),:) = Cmat(UY(1,end),:);  
    W(1:sum(R),:) = pinv(A(1:sum(R),1:sum(R)))*B(1:sum(R),:);
    flag(1,1) = 1; w1(1,1) = UY(1,end);
    while TRA     % Continue learning rest of the samples
        [~,pre_samples] = find(flag == 0);  % Find the samples that are not learnt yet
        for SAMP = 1:length(pre_samples)
            x = UY(pre_samples(1,SAMP),1:NIP); c = UY(pre_samples(1,SAMP),end);
            [xmusq_lo,xmusq_up] = INFERENCE(x,Cl(1:sum(R),:),Cr(1:sum(R),:),S(1:sum(R),:));
            F_lo = exp(-xmusq_lo); F_up = exp(-xmusq_up); % Membership function
            F = (F_lo+F_up)/2;  phi = F./sum([F;eps]);      % Normalization layer
            ycap = phi'*W(1:sum(R),:); % Predicted output
            
            % Calculate predicted class label, knowledge, error in sample
            [~,ccap] = max(ycap);
            %SP=max(sum(F>0.01),1)/sum(R);
            SP = sum(F)/sum(R);
            yact = Cmat(c,:);
            Err = yact-ycap;
            %[Err ycap]
%             if(ycap(1,1)<1)
%                 keyboard
%             end
            % Calculate hinge error
            for b = 1:NOP
                if(yact(1,b)*ycap(1,b)>=1.0)
                    Err(1,b) = 0;
                end
            end
            % Maximum hinge-loss error
            Err_m = sqrt(max(Err.*Err));         
            
%           display([c ccap Err_m Ed Ea SP En El]);
            %keyboard
%             
            % Meta-cognitive learning strategies
            if(c == ccap && Err_m < Ed)
                flag(1,pre_samples(1,SAMP)) = 2;               % If delete criterion is satisfied
                continue;                       % Set flag to deleted and continue without learning
            end
            if((c~=ccap && (Err_m>Ea || max(phi) < 1e-01) && SP<En && R(1,c)<NHN(1,c))|| R(1,c) == 0)
                R(1,c) = R(1,c) + 1;            % Add a new rule to the network
                flag(1,pre_samples(1,SAMP)) = 1;
                w1(1,sum(R)) = c;%class labels of rules
                Ea = min(gama*Ea+(1-gama)*Err_m,2);  % Adapt add threshold
                Cl(sum(R),:) = x(1,:)-0.001; 
                Cr(sum(R),:) = x(1,:)+0.001;
                
                
                for Rcount = 1 : (sum(R) - 1)
                    xmusqll(Rcount,1) = sum((Cl(sum(R),:)-Cl(Rcount,:)).^2);
                    xmusqlr(Rcount,1) = sum((Cl(sum(R),:)-Cr(Rcount,:)).^2);
                    xmusqrr(Rcount,1) = sum((Cr(sum(R),:)-Cr(Rcount,:)).^2);
                    xmusqrl(Rcount,1) = sum((Cr(sum(R),:)-Cl(Rcount,:)).^2);
                end
                [~,nrS] = find(w1(1,1:sum(R)-1) == c);    % rules belonging to class c
                [~,nrI] = find(w1(1,1:sum(R)-1) ~= c);    % rules of other classes
          
                nrSD1 = min([xmusqll(nrS);xmusqlr(nrS)]);  % Find nearest distance to center of rules from current rule left-center belonging to same class
                nrID1 = min([xmusqll(nrI);xmusqlr(nrI)]);  % Find nearest distance to center of rules from current rule left-center belonging to diff class
                nrSD2 = min([xmusqrr(nrS);xmusqrl(nrS)]);  % Find nearest distance to center of rules from current rule right-center belonging to same class
                nrID2 = min([xmusqrr(nrI);xmusqrl(nrI)]);  % Find nearest distance to center of rules from current rule right-center belonging to diff class
                %keyboard
                if(isempty(nrSD1))          % If no rules belong to current rule class
                    S(sum(R),1) = eta*sqrt(min(nrID1,nrID2));
                elseif(isempty(nrID1))      % If no rules belong to other rule class
                    S(sum(R),1) = kappa*sqrt(min(nrSD1,nrSD2));
                else
                    if(min(nrSD1,nrSD2)<min(nrID1,nrID2))
                        S(sum(R),1) = kappa*sqrt(min(nrSD1,nrSD2));
                    else
                        S(sum(R),1) = eta*sqrt(min(nrID1,nrID2));
                    end
                end
                [~,l_samples] = find(flag == 1);
                [xmusq_up1,xmusq_lo1] = INFERENCE(UY(l_samples,1:NIP),Cl(1:sum(R),:),Cr(1:sum(R),:),S(1:sum(R),:));
                F_lo1 = exp(-xmusq_lo1); F_up1 = exp(-xmusq_up1);
                F = (F_lo1+F_up1)/2; phi1 = zeros(size(F));
                for samp = 1: size(xmusq_up1,2)
                    phi1(:,samp) = F(:,samp)./sum(F(:,samp));
                end
                A(1:sum(R),1:sum(R)) = phi1*phi1'; B(1:sum(R),:) = phi1*Cmat(UY(l_samples,end),:);
                try
                        W(1:sum(R),:) = pinv(A(1:sum(R),1:sum(R)))*B(1:sum(R),:);
                        %keyboard
                    W(1:sum(R),:) = pinv(A(1:sum(R),1:sum(R))+0.001*eye(sum(R)))*B(1:sum(R),:);
                catch ME
                          W(1:sum(R),:) = inv(A(1:sum(R),1:sum(R)))*B(1:sum(R),:);
                    W(1:sum(R),:) = inv(A(1:sum(R),1:sum(R))+0.001*eye(sum(R)))*B(1:sum(R),:);
                end
            elseif( c == ccap && Err_m>El)
                flag(1,pre_samples(1,SAMP)) = 1;              % Update the paramters of the network;
                update_count = update_count + 1;
                El = max(Ed,gama*El-(1-gama)*Err_m);
               
                A(1:sum(R),1:sum(R)) = A(1:sum(R),1:sum(R)) + phi*phi';
                B(1:sum(R),:) = B(1:sum(R),:) + phi*Cmat(c,:);
                %W(1:sum(R),:) = pinv(A(1:sum(R),1:sum(R)))*B(1:sum(R),:);
                W(1:sum(R),:) = W(1:sum(R),:)+pinv(A(1:sum(R),1:sum(R)))*phi*Err;
                % Else it will reserve for future consideration
            end  
        end

        %keyboard
          if(length(find(flag ==0)) == length(pre_samples))
            cou = cou -1;
            %             disp([En Ea El length(find(flag ==0))]);
            %             keyboard
            %En = 0.2*En;
            %El = max(0.2*El,Ed);
        else
            cou = 3;
        end
        if cou==0 || length(find(flag ==0)) ==0
            TRA = false; % Stop training if no sample is used in current epoch
           % save('p3file.mat','train_samp','TRERR');
        end
      
        
    end
    
    % Return value of training
    %keyboard
    MODEL.TRAIN_TIME = cputime-Start_time;
    MODEL.RULES_PER_CLASS = R;
    MODEL.CENTER_left = Cl; MODEL.CENTER_right = Cr;
    MODEL.WIDTH = S;
    MODEL.OUTPUT_WEIGHT = W; MODEL.USED = flag;
    MODEL.NETWORK_PARAMETER = [NIP NOP];
    MODEL.DELETE_UPDATE = [length(find(flag==2)) update_count];
    MODEL.flag = flag;
else                % TESTING OF THE NETWORK
    NIP = nwpar(1);
    [xmusq_lo,xmusq_up] = INFERENCE(UY(:,1:NIP),Cl(1:R,:),Cr(1:R,:),S(1:R,:));
    F_lo = exp(-xmusq_lo); F_up = exp(-xmusq_up);
    F = (F_lo+F_up)/2; phi = zeros(size(F));
    for samp = 1: size(xmusq_up,2)
        phi(:,samp) = F(:,samp)./sum(F(:,samp));
    end
    MODEL.OUTPUT = phi'*W(1:R,:);
end
varargout{1} = MODEL;
end

%% Function to find inference of McCIT2FIS
function [xmusq_lo,xmusq_up] = INFERENCE(x,C1,C2,S)
pre_samples = size(x,1);            % No. of samples
K = size(C1,1);                     % No. of rules
L = size(x,2);                      % No. of features
xmusq_lo = zeros(K,pre_samples);    % pre-initialize squared distance matrices
xmusq_up = zeros(K,pre_samples);

if(nargin == 3)
    S = ones(K,1);
end

for samp = 1:pre_samples
    for k = 1:K
        for l = 1:L
            if x(samp,l)<C1(k,l)
                xmusq_lo(k,samp) = xmusq_lo(k,samp) + ((x(samp,l)-C1(k,l))/S(k,1))^2;
            elseif x(samp,l)>C2(k,l)
                xmusq_lo(k,samp) = xmusq_lo(k,samp) + ((x(samp,l)-C2(k,l))/S(k,1))^2;
            else
                xmusq_lo(k,samp) = xmusq_lo(k,samp) + 0;
            end
            if x(samp,l)<(C1(k,l)+C2(k,l))/2
                xmusq_up(k,samp) = xmusq_up(k,samp) + ((x(samp,l)-C2(k,l))/S(k,1))^2;
            else
                xmusq_up(k,samp) = xmusq_up(k,samp) + ((x(samp,l)-C1(k,l))/S(k,1))^2;
            end
        end
    end
end
end

