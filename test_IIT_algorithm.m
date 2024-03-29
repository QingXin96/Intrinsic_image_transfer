clc
clear
close all

S                     = im2double(imread(['./imgs/swan_src.png']));
C                     = im2double(imread(['./imgs/swan_clahe.png']));
S                     = max(0,min(1,S));
C                     = max(0,min(1,C));

%% Intrinsic image transfer

para.logarithm          =  1;
para.color_transfer     =  0;
para.bias               =  1/255; % for 8 bit image
para.scale              =  1.0;
para.color_space        =  'rgb'; 
para.color_exemplar     =  'original';

% paraetes for Gauss/Bilateral filter
para.filter.k1          =  49;   
para.filter.delta_s     =  2.0;
para.filter.delta_r     =  0.2;
para.filter.mode        =  'gf';

% paraetes for LLE encoding
para.LLE.tol            =  1e-5; 
para.LLE.k2             =  49; 

% Global paraetes
para.alpha              =  0.9;
para.beta               =  100;
para.gamma              =  0.1;

[T, M]                  =  IntrinsicImageTransfer(S,C,para);
T                       = max(0,min(1,T));

figure, imshow(imresize([S C T],1,'nearest'))
