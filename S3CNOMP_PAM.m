% Input Arguments
% X_all                 -- data matrix D by N where each column is a data point.
% ind_1                 -- index of preserved columns 
% X                     -- data points corresponding to ind_1
% lambda                -- hyperparameter \lambda
% C_final               -- final coefficient matrix
% K                     -- termination by checking the number of nonzero 
%                       entries in c_j, i.e. S3COMP-C terminates if \|c_j\| >= K
% thr                   -- termination by checking the reconstruction error, 
%                       i.e. S3COMP-C terminates if \| x_j - X c_j \|_2^2 < thr

function C_t = S3CNOMP_PAM(X_all,X,ind_1,beta,C_final_t,K,thr)
MEMORY_TOTAL = 0.1 * 10^9; % memory available for double precision.
[~, N] = size(X_all);
blockSize = round(MEMORY_TOTAL / N);
M=size(X,2);
C=sparse(M,N);
%Xn = X; % assume that data is column normalized. If not, uncomment the following.
X_all_norm=cnormalize(X_all);
Xn = cnormalize(X);
S = ones(N, K); % Support set
t_vec = ones(N, 1) * K;
res = X_all_norm; % residual
I_index=zeros(M,N);
for t = 1:K
    for starti=1:blockSize:N 
        % partition the data to different blocks 
        endi=min(N,starti+blockSize-1);
        colindex=1:endi-starti+1;
        mask=(ind_1<=endi) & (ind_1>= starti);
        indexp=ind_1(mask);
        I = abs(X' * res(:, starti:endi)+beta*C_final_t(:,starti:endi));
        I1=sub2ind([M,N],find(mask~=0),indexp-starti+1);
        I(I1)=0;   
        I(I_index(:,starti:endi)==1)=0;    % add in 11/10
        [~, J] = max(I, [], 1);
        S(starti:endi, t) = J;
        I1=sub2ind([M,endi-starti+1],J,colindex);
        I_index_tmp=I_index(:,starti:endi);
        I_index_tmp(I1)=1;
        I_index(:,starti:endi)=I_index_tmp;
    end
    
    if t ~= K % not the last step. compute residual
        for iN = 1:N	 
            if t_vec(iN) == K % termination has not been reached
                B = X(:, S(iN, 1:t));
                C(S(iN, 1:t),iN) = (B'*B+beta*eye(size(B,2)))^(-1)*(B'*X_all_norm(:,iN)+beta* C_final_t(S(iN, 1:t),iN));
                res(:,iN)=X_all_norm(:,iN)-X*C(:,iN);                
                if sum( res(:, iN).^2 ) < thr
                    t_vec(iN) = t;
                end 
            end
        end
    end
    if sum(t_vec == K) == 0
        break;
    end
%     fprintf('Step %d in %d\n', t, K);
end
C_t=sparse(N,N);
for iN = 1:N
    C_t(ind_1(S(iN, :)),iN)=C(S(iN,:),iN);
end
clear C C_final_t
