clc
clear
close all

%% ..........................Load image ...............................
path                  = './';
S                     = im2double(imread([path, 'swan_src.png']));
C                     = im2double(imread([path, 'swan_clahe.png']));
S                     = max(0,min(1,S));
C                     = max(0,min(1,C));
figure,imshow([S, C])

%%
param.logarithm          =  1;
param.color_transfer     =  0;
param.scale              =  1.0;
param.color_space        =  'rgb'; 
param.color_exemplar     =  'original';

param.filter.k1          =  49;   % lle neighborss
param.filter.delta_s     =  2.0;
param.filter.delta_r     =  0.2;
param.filter.mode        =  'gf';

param.LLE.tol            =  1e-5; 
param.LLE.k2             =  25; % lle neighborss

param.alpha              =  0.95;
param.beta               =  100;
param.gamma              =  0.05;
    
[T, M]                   =  IntrinsicImageTransfer(S,C,param);

figure,imshow([S C T])




