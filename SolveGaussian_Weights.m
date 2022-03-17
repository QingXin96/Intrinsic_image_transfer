function M = SolveGaussian_Weights(X, P, K, delta_s, delta_r, mode, scale, bias)

    % X = data as D x N matrix (D = dimensionality, N = #points)
    % K = number of neighbors
    
    fprintf(1,'Step1: Computing the filtering kernel.\n');
    fprintf(1,'-->Finding %d nearest neighbours.\n',K);
    
    t1                   = tic;
    [N,~]                = size(X);
    nnidx                = knnsearch(P,P,'k',K);
    ccidx                = repmat(nnidx(:,1),1,K);

    X                    = (exp(-X)-bias)/scale;
    p                    = P(nnidx(:),:)-P(ccidx(:),:);
    x                    = X(nnidx(:),:)-X(ccidx(:),:);
    
    if(strcmp(mode,'gf'))
        delta_s2          = 2*delta_s^2; 
        w                    = exp(-((sum(p.*p,2)/delta_s2)));
    elseif(strcmp(mode,'bf'))
        delta_s2             = 2*delta_s^2;          
        delta_r2             = 2*delta_r^2;
        w                    = exp(-((sum(p.*p,2)/delta_s2)+(sum(x.*x,2)/delta_r2)));
    else
        delta_s2             = 2*delta_s^2;          
        delta_r2             = 2*delta_r^2;
        w                    = exp(-((sum(p.*p,2)/delta_s2)+(sum(x.*x,2)/delta_r2)));
    end
    w                    = reshape(w,[N,K]);
    w                    = w./repmat(sum(w,2),1,K);
    W                    = sparse(ccidx(:),nnidx(:),w(:),N,N);
    M                    = W'*W;
    
    fprintf(1,['...took ' num2str(toc(t1)) 's.\n'] );

end
