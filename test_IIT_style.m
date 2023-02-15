clc
clear
close all

S                     = im2double(imread('./imgs/content2.png'));
C                     = im2double(imread('./imgs/exemplar2.png'));
E                     = im2double(imread('./imgs/style2.png'));

S                     = max(0,min(1,S));
C                     = max(0,min(1,C));
E                     = max(0,min(1,E));

%% Intrinsic image transfer
para.logarithm          =  0;
para.color_transfer     =  0;
para.bias               =  1/255; % for 8 bit image in case of using logarithm
para.scale              =  1.0;
para.color_space        =  'rgb'; 
para.color_exemplar     =  'original';

% parameters for Gauss/Bilateral filter
para.filter.k1          =  49;   
para.filter.delta_s     =  2.0;
para.filter.delta_r     =  0.2;
para.filter.mode        =  'gf';

% parameters for LLE encoding
para.LLE.tol            =  1e-3; 
para.LLE.k2             =  49; 

% Global parameters
para.alpha              =  1.0;
para.beta               =  1000;
para.gamma              =  0; % not use in style transfer

[T, M]                  =  IntrinsicImageTransfer(S,C,para);
T                       = max(0,min(1,T));

figure,
subplot(221), imshow(S), title('Content')
subplot(222), imshow(E), title('Reference style')
subplot(223), imshow(T), title('Ours')
subplot(224), imshow(C), title('Exemplar')

