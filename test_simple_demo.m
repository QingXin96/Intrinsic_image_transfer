clc
clear
close all

%%  load data
S                    = im2double(imread(['./imgs/content1.png']));
C                    = im2double(imread(['./imgs/exemplar1.png']));

S                    = max(0,min(1,S));
C                    = max(0,min(1,C));

[rows, cols, layers] = size(S);
Px             	     = repmat([1:rows]',1,cols);
Py             	     = repmat([1:cols], rows,1); 
P                    = [Px(:),Py(:)];
    
X                    = reshape(S,[rows*cols,layers]);
Y                    = reshape(C,[rows*cols,layers]);

bias                 = 1/255;
X1                   = log((1-bias)*X+bias);
Y1                   = log((1-bias)*Y+bias);

[N,~]                = size(X);

%% Step1: computing filtering kernel weight matrix
fprintf(1,'Step1: Computing the filtering kernel.\n');

K                    = 49;
nnidx                = knnsearch(P,P,'k',K);
ccidx                = repmat(nnidx(:,1),1,K);

p                    = P(nnidx(:),:)-P(ccidx(:),:);
x                    = X1(nnidx(:),:)-X1(ccidx(:),:);

mode                 = 'gf';
delta_s              = 2.0;
delta_r              = 0.2;
if(strcmp(mode,'gf'))
    delta_s2         = 2*delta_s^2; 
    w                = exp(-((sum(p.*p,2)/delta_s2)));
elseif(strcmp(mode,'bf'))
    delta_s2         = 2*delta_s^2;          
    delta_r2         = 2*delta_r^2;
    w                = exp(-((sum(p.*p,2)/delta_s2)+(sum(x.*x,2)/delta_r2)));
else
    delta_s2         = 2*delta_s^2;          
    delta_r2         = 2*delta_r^2;
    w                = exp(-((sum(p.*p,2)/delta_s2)+(sum(x.*x,2)/delta_r2)));
end
w                    = reshape(w,[N,K]);
w                    = w./repmat(sum(w,2),1,K);
W1                   = sparse(ccidx(:),nnidx(:),w(:),N,N);
U                    = W1'*W1;

%% Step2: computing LLE encoding weight matrix
fprintf(2,'Step2: computing LLE encoding weight matrix.\n');

neighborhood        = nnidx(:,2:K);
currentindex        = repmat(nnidx(:,1),1,K-1);

tol= 1.0e-3;
w0 = zeros(N,K-1);
w1 = zeros(K,K-1);

for ii=1:N
   z = X1(currentindex(ii,:),:)-X1(neighborhood(ii,:),:);                 % shift ith pt to origin
   c = z*z';                                                % local covariance
   c = c + tol*eye(K-1);%trace(c);                % regularlization (K>D)
   w1 = c\ones(K-1,1);
   w0(ii,:) = w1/sum(w1);                                   % enforce sum(w)=1
end
I   = sparse(1:N,1:N,ones(1,N),N,N); 
W2  = sparse(currentindex(:), neighborhood(:),w0(:),N,N);
M   = (I-W2);
V   =  M'*M;

%% Step3: Solve Equation A*x = b
fprintf(2,'Step3: Solve Equation A*x = b.\n');
alpha               =  1.0; 
beta                =  1000;
gamma               =  0.0;
A =  alpha*U+beta*V+gamma*sparse(1:N,1:N,1);
b =  alpha*U*Y+gamma*X;
Z =  A\b;

R =  reshape(min(max(0,Z),1),[rows,cols,layers]);
figure, imshow([S, C, R])
