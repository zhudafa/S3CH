function x = prox_l0(b,lambda)

% min_x lambda*||x||_0+0.5*||x-b||_2^2

x = b.*(abs(b)>sqrt(2*lambda)); 