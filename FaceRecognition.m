clc;
clear all;
close all;
faceDetector = vision.CascadeObjectDetector();
pointTracker = vision.PointTracker('MaxBidirectionalError', 2);

cam = webcam();
videoFrame = snapshot(cam);
frameSize = size(videoFrame);
videoPlayer = vision.VideoPlayer('Position', [100 100 [frameSize(2), frameSize(1)]+30]);

runLoop = true;
numPts = 0;
frameCount = 0;

while runLoop && frameCount < 400

    videoFrame = snapshot(cam);
    videoFrameGray = rgb2gray(videoFrame);
    frameCount = frameCount + 1;

    if numPts < 10
        bbox = faceDetector.step(videoFrameGray);

        if ~isempty(bbox)
            points = detectMinEigenFeatures(videoFrameGray, 'ROI', bbox(1, :));

            xyPoints = points.Location;
            numPts = size(xyPoints,1);
            release(pointTracker);
            initialize(pointTracker, xyPoints, videoFrameGray);

            oldPoints = xyPoints;

            bboxPoints = bbox2points(bbox(1, :));

           bboxPolygon = reshape(bboxPoints', 1, []);

            videoFrame = insertShape(videoFrame, 'Polygon', bboxPolygon, 'LineWidth', 3);

            videoFrame = insertMarker(videoFrame, xyPoints, '+', 'Color', 'white');
        end

    else
        [xyPoints, isFound] = step(pointTracker, videoFrameGray);
        visiblePoints = xyPoints(isFound, :);
        oldInliers = oldPoints(isFound, :);

        numPts = size(visiblePoints, 1);

        if numPts >= 10
            [xform, inlierIdx] = estimateGeometricTransform2D(oldInliers, visiblePoints, 'similarity', 'MaxDistance', 4);
            oldInliers    = oldInliers(inlierIdx, :);
            visiblePoints = visiblePoints(inlierIdx, :);

            bboxPoints = transformPointsForward(xform, bboxPoints);

          
            bboxPolygon = reshape(bboxPoints', 1, []);

            videoFrame = insertShape(videoFrame, 'Polygon', bboxPolygon, 'LineWidth', 3);

            videoFrame = insertMarker(videoFrame, visiblePoints, '+', 'Color', 'white');

            oldPoints = visiblePoints;
            setPoints(pointTracker, oldPoints);
        end

    end

    step(videoPlayer, videoFrame);

    runLoop = isOpen(videoPlayer);
end

clear cam;
release(videoPlayer);
release(pointTracker);
release(faceDetector);