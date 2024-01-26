function [C1,W_SSCN,groups1,time3] = S3CHPAM(X,delta,T,K_kk,loss,maxiter,nCluster,lambda1_ll,beta1_iii,rho1,rho2,rho3,tol)
[D,N] = size(X);
    count=zeros(1,N);
    idxcell=cell(1,T+1);
    for t=1:T
        a=rand(1,N);
        a=a>delta;
        idx=find(a>0);
        count(idx)=count(idx)+1;
        idxcell{t}=idx;
    end
    if all(count)
        T_all=T;
    else
        id1=find(count<1);
        a=rand(1,N);
        a=a>delta;
        idx=find(a>0);
        idx=union(idx,id1);
        count(idx)=count(idx)+1;
        idxcell{T+1}=idx;
        T_all=T+1;
    end
   
    time3=0;
    time4=0;
    B = cell(1, T_all);
   B1 = cell(1, T_all);
    E = zeros(D, N);
    C1 = sparse(N,N);
    
    %err1 = 10*thr1;
    %PAM iterations
   for iter=1:maxiter
       Bk = B;
       Ek = E;
       C1k = C1;
    for t = 1: T_all
        tic
       % updating B
       X_all = X-E;
       if iter==1
           Bk{t}=zeros(size(C1));
       else
           Bk{t}=Bk{t};
       end  
       C_final1 = beta1_iii*C1+rho1*Bk{t};
       C_final1=C_final1(idxcell{t},:);
       B{t} = S3CNOMP_PAM(X_all, X_all(:,idxcell{t})*(1/(1-delta)), idxcell{t}, beta1_iii/2, C_final1,K_kk, 1e-6); 
       time_tmp1=toc;
       time4=max(time_tmp1,time4);
    end
   % updating E
   tic
   R = zeros(D,N);
   for t= 1:T_all
Xi = zeros(D,N);
Xi(:,idxcell{t}) = X_all(:,idxcell{t})*(1/(1-delta));
       R = R + (Xi * B{t});
   end
  if strcmp(loss,'l1')
        E = prox_l1(X - (1/T_all) * R+rho2*Ek,2*lambda1_ll/(1+rho2));
  elseif strcmp(loss,'l21')
        E = prox_l21(X - (1/T_all) * R+rho2*Ek,2*lambda1_ll/(1+rho2));
  elseif strcmp(loss,'l2')
        E = (X - (1/T_all) * R+rho2*Ek)/(1+2*lambda1_ll/(1+rho2));
   else
        error('not supported loss function');
  end
   time_tmp1=toc;
        time3=time3+time_tmp1+time4;
%updating  C
S = sparse (N,N);
for t= 1: T_all
    tic
    S=S + B{t};
end
time_tmp1=toc;
        time3=time3+time_tmp1;
C1 = (beta1_iii*(1/T_all) * S+rho3*C1k)/(beta1_iii+rho3);
C1 = C1 - diag(diag(C1));
      time_tmp1=toc;
        time3=time3+time_tmp1;  
        chgC    = norm(C1k-C1,"fro");
        if iter > maxiter
        if chgC < tol
            break;
        end
    end
   end
    %CN = CNMat(1:data_num,:);
    tic
    C1(1:N+1:end) = 0;
    W_SSCN = abs(C1) + abs(C1');
    groups1 = SpectralClustering(W_SSCN, nCluster);
    %groups1 = SpectralClustering(W_SSCN, nCluster, 'Eig_Solver', 'eigs');
     time_tmp1=toc;
       time3=time3+time_tmp1;   