function Y = SolveLLE_Embedding(C,S,W,M,alpha,beta,gamma)

%% ---------------- solve A*x = b ----------------%%

    [n,~] = size(M);
    [m,d] = size(C);
    
    fprintf(1,'Step3: Solve Equation A*x = b.\n');
    
    t1= tic;
    A =  alpha*W+beta*M+gamma*sparse(1:m,1:m,1);
    b =  alpha*W*C+gamma*S;
    Y = A\b;
    
    fprintf(1,['...Solve time took ' num2str(toc(t1)) 's.\n'] );
  
end