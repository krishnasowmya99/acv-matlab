clc;
clear all;
close all;
Img=imread("edge.jpg");
subplot(1,2,1);imshow(Img);
grImg=rgb2gray(Img);
subplot(1,2,2);imshow(grImg);
dImg=double(grImg);
%Directional Gradients Using Prewitt Method:
[Gx, Gy] = imgradientxy(dImg,'prewitt');
figure
imshowpair(Gx, Gy, 'montage');
title('Directional Gradients: x-direction, Gx (left), y-direction, Gy (right), using Prewitt method')

[Gx,Gy] = imgradientxy(dImg);
figure;imshowpair(Gx,Gy,'montage')
title('Directional Gradients Gx and Gy, Using Sobel Method');

%gradient magnitude and direction using the directional gradients:

[Gmag,Gdir] = imgradient(Gx,Gy);
figure;imshowpair(Gmag,Gdir,'montage');
title('Gradient Magnitude (Left) and Gradient Direction (Right)');


