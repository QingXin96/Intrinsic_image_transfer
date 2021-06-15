function Y = SolveLLE_Embedding(C,S,W,M,alpha,beta,gamma)

%% ---------------- solve A*x = b ----------------%%

[n,~] = size(M);
[m,d] = size(C);
fprintf(1,'Computing LLE Embedding on %d points in %d dimensions\n',n,d);

% W=sparse(1:m,1:m,1);
if(m==n)
    fprintf(1,'-->Solve Equation A*x = b.\n');
    t1= tic;

    A =  alpha*W+beta*M+gamma*sparse(1:m,1:m,1);
    b =  alpha*W*C+gamma*S;

%     if exist('ichol','builtin')
%         fprintf('Using preconditioner ....\n');
%         tol = 1e-6;
%         maxit = 20000;
% %         L = ichol(A, struct('type','ict','droptol',0.1));   
% %         [Y, flag] = pcg(A, b,tol,maxit, L, L'); 
%         [Y, flag] = pcg(A, b,tol,maxit,[],[],alpha*C+gamma*S);
%         fprintf('flag = %d :',flag);
%         switch(flag)
%             case 0 
%                 disp(' PCG: converged to the desired tolerance TOL within MAXIT iterations');
%             case 1 
%                 disp(' PCG: iterated MAXIT times but did not converge.');
%             case 2 
%                 disp(' PCG: preconditioner M was ill-conditioned.');
%             case 3 
%                 disp(' PCG: stagnated (two consecutive iterates were the same.');
%             case 4 
%                 disp(' PCG: one of the scalar quantities calculated during PCG became too small or too large to computing.');
%         end
%     else
            Y = A\b;
%     end
    
    fprintf(1,['...Solve time took ' num2str(toc(t1)) 's.\n'] );
    % Y=reshape(Y,[rows,cols]);

end
end