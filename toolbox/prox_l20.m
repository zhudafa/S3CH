function X = prox_l20(B,lambda)

% min_X lambda*||X||_{2,0}+0.5*||X-B||_2^2

X = zeros(size(B));
for i = 1 : size(X,1)
    nxi = norm(B(i,:));
    if nxi > sqrt(2*lambda)  
        X(i,:) = B(i,:);
    end
end