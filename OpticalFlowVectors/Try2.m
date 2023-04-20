clc;clear all;close all;
sourceClip = VideoReader("DemoVid.mp4",'CurrentTime',11);
disp("Total number of frames in the clip:")
num_of_frames = sourceClip.NumFrames
frame1 = readFrame(sourceClip);
figure;imshow(frame1);title("1st frame");
for i=1:10
    frame2 = readFrame(sourceClip);
end
figure;imshow(frame2);title("2nd frame");
frame = {frame1, frame2};
opticFlow = opticalFlowLK('NoiseThreshold',0.009);
h = figure;
movegui(h);
hViewPanel = uipanel(h,'Position',[0 0 1 1],'Title','Plot of Optical Flow Vectors');
hPlot = axes(hViewPanel);
for i=1:2
    frameRGB = readFrame(sourceClip);
    frameGray = im2gray(frameRGB);
    flow = estimateFlow(opticFlow,frameGray);
    imshow(frameRGB)
    hold on
    plot(flow,'DecimationFactor',[5 5],'ScaleFactor',10,'Parent',hPlot);
    hold off
    pause(10^-3)
end
