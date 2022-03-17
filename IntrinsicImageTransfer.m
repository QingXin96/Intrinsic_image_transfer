function [T, M0] = IntrinsicImageTransfer(S,C,param)

    %% Step1: Image to Vectors
    [X_s, P]                =  ImageToVector(S,param);
    [X_c]                   =  ImageToVector(C,param);

    %% Step2: Computer Illumiantion Filter Kernel Matrix
    bias                    = param.bias;
    scale                   = param.scale;
    
    k1                       = param.filter.k1; 
    delta_s                 = param.filter.delta_s;
    delta_r                 = param.filter.delta_r;
    filter_mode           = param.filter.mode;
    W                       = SolveGaussian_Weights(X_s, P, k1, delta_s, delta_r, filter_mode, scale, bias);

    %% Step3: Computer Locally Linear Embedding Matrix
    tol                      = param.LLE.tol; 
    k2                      = param.LLE.k2; 
    [M, M0]               = SolveLLE_Weights(X_s, P, k2, tol);

    %% Step4: Image Reconmstrction
    alpha                 = param.alpha;
    beta                   = param.beta;
    gamma              = param.gamma;
    Y                       = SolveLLE_Embedding(X_c, X_s, W, M, alpha, beta, gamma);
    T                       = VectorToImage(Y, S, S, param);
    T                       = max(min(T,1),0);

end