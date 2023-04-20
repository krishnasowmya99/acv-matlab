clc;
clear all;
close all;
noiseimg=imread("noise.jpg");
figure;imshow(noiseimg);
red_channel = noiseimg(:, :, 1);
green_channel = noiseimg(:, :, 2);
blue_channel = noiseimg(:, :, 3);
%using median filter
red_channel = medfilt2(red_channel, [3 3]);
green_channel = medfilt2(green_channel, [3 3]);
blue_channel = medfilt2(blue_channel, [3 3]);
ClearImg1 = cat(3, red_channel, green_channel, blue_channel);
%using mean filter
mf = ones(3, 3)/9;
ClearImg2 = imfilter(noiseimg,mf);

subplot(2, 2, 1);
imshow(noiseimg);
title('Noisy Image');

subplot(2, 2, 2);
imshow(ClearImg1);
title('Image After Noise Removal using median filter');

subplot(2,2,3);
imshow(ClearImg2);
title('Image After Noise Removal using mean filter');
