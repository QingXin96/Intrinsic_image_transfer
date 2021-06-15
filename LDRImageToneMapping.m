clc
clear
close all

%% ..........................Load image ...............................
addpath ./src
res_size = 0.6;
add_noise  = 0;
process_type = 2;

if (process_type==0)
    [filename, pathname]  = uigetfile({'*.*','img-files (*.*)'},'Pick a file','MultiSelect', 'on');
    S                     = imresize(im2double(imread([pathname, filename{1}])),res_size);
    C                     = imresize(im2double(imread([pathname, filename{2}])),res_size);
elseif(process_type==1)
    [filename, pathname]  = uigetfile({'*.*','img-files (*.*)'},'Pick a file','MultiSelect', 'on');
    S                     = imresize(max(0,min(1,im2double(imread([pathname, filename])))),res_size);
    Sr                    = imresize(S,1);
    Cr                    = tonemap_LDR(Sr,'clahe');
    C                     = imresize(Cr,1);
elseif(process_type==2)
    [filename, pathname]  = uigetfile({'*.*','img-files (*.*)'},'Pick a file','MultiSelect', 'on');
    S                     = imresize(im2double(imread([pathname, filename])),res_size); %S=cat(3,S,S,S);
    C                     = tonemap_LDR(S,'clahe');
end

if (add_noise)
    C                     = imnoise(S,'gaussian',0,0.005);
end
S                         = max(0,min(1,S));
C                         = max(0,min(1,C));
% C = (C+S)/2;
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
    
[T, M]                   =  IntrinsicImageTransfer(S,C,C,param);

%% Evaluation: Computer PSNR and SSIM
S                        =  min(1,max(0,S));
C                        =  min(1,max(0,C));
T                        =  min(1,max(0,T));

figure,imshow([S C T])

% mean_val1                =  mean(mean(C(:)));
% mean_val2                =  mean(mean(T(:)));
% psnr1                    =  compute_psnr(uint8(255*S),uint8(255*C));
% psnr2                    =  compute_psnr(uint8(255*S),uint8(255*T));
% [mssim1, ssim_map1]      =  compute_ssim(rgb2gray(S),rgb2gray(C),'Exponents',[0.01,1,1]);
% [mssim2, ssim_map2]      =  compute_ssim(rgb2gray(S),rgb2gray(T),'Exponents',[0.01,1,1]);
% [tmqi_Q1, tmqi_S1, tmqi_N1] = TMQI(uint8(255*S),uint8(255*C));
% [tmqi_Q2, tmqi_S2, tmqi_N2] = TMQI(uint8(255*S),uint8(255*T));
% 
% figure,imshow([S C T])
% figure,imshow([S C])
% figure,imshow([S T])
% figure,imshow([C T])
% figure,imshow([10*(T-C)+0.5])
% 
% [rows,cols,layers]=size(S);
% S1 = reshape(im2double(S),rows*cols,3);
% C1 = reshape(im2double(C),rows*cols,3);
% T1 = reshape(im2double(T),rows*cols,3);
% 
% a1 = sum((T1-C1).*(T1-C1),2);
% a2 = sum((M*T1).*(M*T1),2);
% a3 = sum((T1-S1).*(T1-S1),2);
% 
% figure,
% subplot(3,1,1),plot(a1,'b'),title(['Illumintion Loss E^l = ' num2str(sum(a1))]),
% % xlabel('Pixel Postion in 1D '),
% ylabel('error'),ylim([0,1]) 
% subplot(3,1,2),plot(a2,'g'),title(['Reflectance Loss E^r = ' num2str(sum(a2))]),
% % xlabel('Pixel Postion in 1D '),
% ylabel('error'),ylim([0,1]) 
% subplot(3,1,3),plot(a3,'r'),title(['Content Loss E^t = ' num2str(sum(a3))]),
% xlabel('Pixel Postion in 1D '),
% ylabel('error'),ylim([0,1]) 
% 
