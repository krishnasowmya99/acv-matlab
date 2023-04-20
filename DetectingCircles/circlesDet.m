clc;
clear all;
close all;

TestImg = imread("mcwCb.png");
figure;imshow(TestImg);

d = imdistline;
delete(d);
number_of_circles = 0;

radRange = [40,70];

[centers,radii] = imfindcircles(TestImg,radRange,"ObjectPolarity","bright","Sensitivity",0.8,Method="PhaseCode")
brightCircles=length(centers)
number_of_circles=number_of_circles+brightCircles
viscircles(centers,radii);
[centersDark,radiiDark]= imfindcircles(TestImg,radRange,"ObjectPolarity","dark","Sensitivity",0.94,Method="PhaseCode",EdgeThreshold=0.1)
darkCircles=length(centersDark)
viscircles(centersDark,radiiDark,'Color','b');
number_of_circles=number_of_circles+darkCircles

