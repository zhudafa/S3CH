function [X1,s1,sample_index] = bootstrap(X,s,p)
    N = size(X,2);
    sample_index = randperm(N, p*N);
    X1=X(:,sample_index);
    s1=s(sample_index);
end
