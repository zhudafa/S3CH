function X = prox_l21(B,lambda)

% min_X lambda*||X||_{2,1}+0.5*||X-B||_2^2

X = zeros(size(B));
for i = 1 : size(X,1)
    nxi = norm(B(i,:));
    if nxi > lambda  
        X(i,:) = (1-lambda/nxi)*B(i,:);
    end
end