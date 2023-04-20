clc;clear all;close all;

A = imread("coins.jpg");
figure;imshow(A)
number_of_circles = 0;
d = imdistline;
disp(d)
delete(d)
radius = [30,75];

[centers,radii] = imfindcircles(A,radius,"ObjectPolarity","dark","Sensitivity",0.9)

viscircles(centers,radii);
number_of_circles = number_of_circles + length(centers); 
disp('total number of circles in this image :')
disp(number_of_circles)