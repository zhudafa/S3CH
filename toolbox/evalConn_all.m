function [conn,conn_min,conn_max,conn_median,conn_mean] = evalConn_all(C, s)
% C \in R^N-by-N: symmetric affinity matrix
% s \in {1, 2, ... n}^N: group labels
% 
% conn: connectivity index
% conn = min_{i = 1,...,n} (second-least eigenvalue of L_i);
if ~issymmetric(C)
    warning('(evalConn) affinity matrix not symmetric')
end

s_val = unique(s);
n = length(s_val);

conn = [];
for in = 1:n
    % prepare data
    C_in = C(s == s_val(in), s == s_val(in));
    % conn
    if min(sum(C_in, 2)) < eps
        conn_in = 0.0;
    else
        OPTS.tol = 1e-3;
        [~, eig_in] = eigs( cnormalize(C_in, 1)', 2, 'LR', OPTS );
        conn_in = 1 - eig_in(2, 2);  
    end
    conn = [conn, conn_in];
end
conn_min=min(conn);
conn_max=max(conn);
conn_median=median(conn);
conn_mean=mean(conn);
end
