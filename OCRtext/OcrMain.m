clc;
clear all;
close all;


I = imread('cp1.jpg');
% Set 'TextLayout' to 'Block' to instruct ocr to assume the image
% contains just one block of text.

BW = imbinarize(I);

results = ocr(BW,"TextLayout","Line","Language","English" );

results.Text
% results = ocr(BW,'TextLayout','Block');
% 
% results.Text
