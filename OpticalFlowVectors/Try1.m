clc;clear all;close all;
sourceClip = VideoReader('DemoVid.mp4','CurrentTime',5);
disp("Total number of frames in the clip:")
num_of_frames = sourceClip.NumFrames
opticFlow = opticalFlowLK('NoiseThreshold',0.009);
h = figure;
movegui(h);
hViewPanel = uipanel(h,'Position',[0 0 1 1],'Title','Plot of Optical Flow Vectors');
hPlot = axes(hViewPanel);
while hasFrame(sourceClip)
    frameRGB = readFrame(sourceClip);
    frameGray = im2gray(frameRGB);
    flow = estimateFlow(opticFlow,frameGray);
    imshow(frameRGB)
    hold on
    plot(flow,'DecimationFactor',[5 5],'ScaleFactor',10,'Parent',hPlot);
    hold off
    pause(10^-3)
end
