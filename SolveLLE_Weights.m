function [result, M] = SolveLLE_Weights(X,P,K,tol)

    % X = data as D x N matrix (D = dimensionality, N = #points)
    % K = number of neighbors
    
    [N,D] = size(P);
    fprintf(1,'Step2:LLE running on %d points in %d dimensions\n',N,D);

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
       c = c + eye(K,K)*tol;%*trace(c);                         % regularlization (K>D)
%        c = c + eye(K,K)*tol*trace(c);                         % regularlization (K>D)
%        
%        if(rank(c)<K)
%            w = ones(K,1);                                         % solve Cw=1
%            s = s+1;
%            if(s<5000 && mod(s,500)==1)
%                row = mod(ii,385);
%                col = floor(ii/385);
%                I0 = imread('swan.bmp');
%                I = I0;
%                I (row-1:row+1,col,1)=0;
%                I (row,col-1:col+1,2:3)=0;
%                I (row-21:row-19,col-20:col+20,2:3)=0;
%                I (row+19:row+21,col-20:col+20,2:3)=0;
%                I (row-20:row+20,col-21:col-19,2:3)=0;
%                I (row-20:row+20,col+19:col+21,2:3)=0;
%                figure,imshow([I0 I])
%            end
%        else
%            w = c\ones(K,1); 
%        end
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


% % 
% function [result] = SolveLLE_Weights(S,K,tol)
% % solves for optimal LLE-weights
% % based on code from: http://www.cs.nyu.edu/~roweis/lle/
%     [rows,cols,layers]  = size(S);
%     S(S<=0)             = eps;
%     S                   = -log(S);
%     Px                  = repmat([1:rows]',1,cols)/rows;
%     Py                  = repmat([1:cols], rows,1)/cols; 
%     P                   = [Px(:),Py(:)];
%     X                   = [P reshape(S,[rows*cols,layers])];
% 
% 
%     %-----------------------------------------------------------------------
%     % STEP1: COMPUTE PAIRWISE DISTANCES & FIND NEIGHBORS 
%     fprintf(1,'-->Finding %d nearest neighbours.\n',K);
%     t1                  = tic;
%     nnidx               = knnsearch(P,P,'k',K+1);
%     idx                 = nnidx(:,1);
%     nnidx               = nnidx(:,2:K+1);
%     ccidx               = repmat(idx,1,K);
% 
%     % ----------------------------------------------------------------------
%     % STEP2: SOLVE FOR RECONSTRUCTION WEIGHTS
%     fprintf(1,'-->Solving for reconstruction weights.\n');
%     [N,~]               = size(X);
%     w0                  = zeros(N,K);
%     for ii=1:N
%        z                = (X(nnidx(ii,:),:)-X(ccidx(ii,:),:));         % shift ith pt to origin
%        c                = z*z';                                        % local covariance
%        c                = c + eye(K,K)*tol*trace(c);                   % regularlization (K>D)
%        w                = c\ones(K,1);   
%        w0(ii,:)         = w/sum(w);
%     end;
%     W                   = sparse(ccidx(:),nnidx(:),w0(:),N,N);
% 
%     % ----------------------------------------------------------------------
%     % STEP 3: COMPUTE EMBEDDING FROM EIGENVECTS OF COST MATRIX M=(I-W)'(I-W)
%     % fprintf(1,'-->Computing embedding.\n');
%     % wo do not compute the eigenvalues but take the whole matrix instead
%     I = sparse(1:N,1:N,ones(1,N),N,N); 
%     M = I-W;
%     result = M'*M;
%     
% end