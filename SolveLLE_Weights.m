function [result, M] = SolveLLE_Weights(X,P,K,tol)

    % X = data as D x N matrix (D = dimensionality, N = #points)
    % K = number of neighbors
    
    [N,D] = size(P);
    fprintf(1,'Step2: LLE running on %d points in %d dimensions\n',N,D);

    % STEP1: COMPUTE PAIRWISE DISTANCES & FIND NEIGHBORS 
    fprintf(1,'-->Finding %d nearest neighbours.\n',K);
    t1                  = tic;
    nnidx               = knnsearch(P,P,'k',K+1);
    neighborhood        = nnidx(:,2:K+1);
    currentindex        = repmat(nnidx(:,1),1,K);

    % STEP2: SOLVE FOR RECONSTRUCTION WEIGHTS
    fprintf(1,'-->Solving for reconstruction weights.\n');

    if(K>D) 
      fprintf(1,'   [note: K>D; regularization will be used : %f]\n',tol); 
    end
    
    w0 = zeros(N,K);
    for ii=1:N
       z = X(currentindex(ii,:),:)-X(neighborhood(ii,:),:);     % shift ith pt to origin
       c = z*z';                                                % local covariance
       c = c + tol*eye(K);%*max(10e-2,trace(c));                             % regularlization (K>D)
       w = c\ones(K,1);
       w0(ii,:) = w/sum(w);                                     % enforce sum(w)=1
    end;

    W  = sparse(currentindex(:), neighborhood(:),w0(:),N,N);

    % ----------------------------------------------------------------------
    % STEP 3: COMPUTE EMBEDDING FROM EIGENVECTS OF COST MATRIX M=(I-W)'(I-W)
    fprintf(1,'-->Computing embedding.\n');
    % wo do not compute the eigenvalues but take the whole matrix instead
    I = sparse(1:N,1:N,ones(1,N),N,N);  
    M = (I-W);
    result = M'*M;
    
    fprintf(1,['...took ' num2str(toc(t1)) 's.\n'] );

end
