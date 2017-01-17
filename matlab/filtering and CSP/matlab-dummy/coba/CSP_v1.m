function [result] = CSP(varargin)               %http://www.mathworks.com/help/matlab/ref/varargin.html
%input = E, matrix of 1 trial of NxT
%this function is called once for each trial left and right

    if (nargin ~= 2)
        disp('Must have 2 classes for CSP!')        %? referring to left and right?
    end
    
    Rsum=0;
    C = zeros(1, nargin);     %array of averaged normalised spatial covariance matrix over the trials of each group
    E = 0;
    %finding the covariance of each class and composite covariance
     for i = 1:nargin 
         %mean here?
         E = varargin{1};
         %Ramoser equation (1)
         C{i} = (E*E')/trace(E*E'));
         %no calculation to average C over trials?
         %Ramoser equation (2)
         Rsum=Rsum+C{i};
     end
     
%{
    for i = 1:nargin
              
        %mean here?
        %R{i} = ((varargin{i}*varargin{i}')/trace(varargin{i}*varargin{i}'));%instantiate me before the loop!
        %Ramoser equation (2)
        R{i}=varargin{i};
        
        Rsum=Rsum+R{i};
    end
 %}  
  
    %   Find Eigenvalues and Eigenvectors of RC
    %   Sort eigenvalues in descending order
    [EVecsum,EValsum] = eig(Rsum);                                  %EVecsum is Uc - eigenvectors , landa c is the diagonal matrix of eigen values
    [EValsum,ind] = sort(diag(EValsum),'descend');                  %highest on top, gives feature veectors to optimal discriminate the 2 popoulations
    EVecsum = EVecsum(:,ind);                                    %ind will just be increment of matrix pos i.e. 1,2,3... and this ind is a matrix also
                                                                          %i.e.  y=1
                                                                          %        2
                                                                          %        3
    
    
    
    %   Find Whitening Transformation Matrix - Ramoser Equation (3)
        W = sqrt(inv(diag(EValsum))) * EVecsum';                    %diag(EValsum) is the landa c, EVecsum is Uc
    
    
    for k = 1:nargin
        S{k} = W * C{k} * W';                       %Whiten Data Using Whiting Transform - Ramoser Equation (4)
    end
    
    
    
    % Ramoser equation (5)
   % [U{1},Psi{1}] = eig(S{1});
   % [U{2},Psi{2}] = eig(S{2});
    
   
    %generalized eigenvectors/values
    [B,D] = eig(S{1},S{2});                         %1 and 2 cos only have 2 classess
    % Simultanous diagonalization
			% Should be equivalent to [B,D]=eig(S{1});
    
    %verify algorithim
    %disp('test1:Psi{1}+Psi{2}=I')
    %Psi{1}+Psi{2}
    
    
    
    
    
    
    %sort ascending by default
    
    
    %[Psi{1},ind] = sort(diag(Psi{1})); U{1} = U{1}(:,ind);
    %[Psi{2},ind] = sort(diag(Psi{2})); U{2} = U{2}(:,ind);
    [D,ind]=sort(diag(D));                          %verify again this diag -why sort again
    B=B(:,ind);
    
    %Resulting Projection Matrix-these are the spatial filter coefficients
    result = (B'*W);                                %here B' is B eigenvector , W is P      and result is matric w    in eqn 5
end