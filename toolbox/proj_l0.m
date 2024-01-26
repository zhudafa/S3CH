function x = proj_l0(b,card)

% min_x 0.5*||x-b||_2^2
% s.t.  ||x||_0<=card

[~,idx]=sort(abs(b(:)),'descend');
x=zeros(size(b));
x(idx(1:card))=b(idx(1:card));