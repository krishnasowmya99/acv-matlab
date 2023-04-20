
function kalmanFilterForTracking

showDetections();

showTrajectory();
frame            = [];  
detectedLocation = [];  
trackedLocation  = [];  
label            = '';  
utilities        = [];  


function trackSingleObject(param)

  utilities = createUtilities(param);

  isTrackInitialized = false;
  while hasFrame(utilities.videoReader)
    frame = readFrame(utilities.videoReader);

    [detectedLocation, isObjectDetected] = detectObject(frame);

    if ~isTrackInitialized
      if isObjectDetected
       
        initialLocation = computeInitialLocation(param, detectedLocation);
        kalmanFilter = configureKalmanFilter(param.motionModel, ...
          initialLocation, param.initialEstimateError, ...
          param.motionNoise, param.measurementNoise);

        isTrackInitialized = true;
        trackedLocation = correct(kalmanFilter, detectedLocation);
        label = 'Initial';
      else
        trackedLocation = [];
        label = '';
      end

    else
     
      if isObjectDetected % The ball was detected.
      
        predict(kalmanFilter);
        trackedLocation = correct(kalmanFilter, detectedLocation);
        label = 'Corrected';
      else 
        trackedLocation = predict(kalmanFilter);
        label = 'Predicted';
      end
    end

    annotateTrackedObject();
  end 
  
  showTrajectory();
end

param = getDefaultParameters(); 
trackSingleObject(param);
param = getDefaultParameters();         
param.motionModel = 'ConstantVelocity';  
param.initialEstimateError = param.initialEstimateError(1:2);
param.motionNoise          = param.motionNoise(1:2);
trackSingleObject(param); 
param = getDefaultParameters();  
param.initialLocation = [0, 0]; 
param.initialEstimateError = 100*ones(1,3); 
trackSingleObject(param); 


param = getDefaultParameters();
param.segmentationThreshold = 0.0005; 
param.measurementNoise      = 12500;                                       
trackSingleObject(param); 

function param = getDefaultParameters
  param.motionModel           = 'ConstantAcceleration';
  param.initialLocation       = 'Same as first detection';
  param.initialEstimateError  = 1E5 * ones(1, 3);
  param.motionNoise           = [25, 10, 1];
  param.measurementNoise      = 25;
  param.segmentationThreshold = 0.05;
end

function showDetections()
  param = getDefaultParameters();
  utilities = createUtilities(param);
  trackedLocation = [];

  idx = 0;
  while hasFrame(utilities.videoReader)
    frame = readFrame(utilities.videoReader);
    detectedLocation = detectObject(frame);
    
    annotateTrackedObject();

    idx = idx + 1;
    if idx == 40
      combinedImage = max(repmat(utilities.foregroundMask, [1,1,3]), im2single(frame));
      figure, imshow(combinedImage);
    end
  end 
  uiscopes.close('All'); 
end


function [detection, isObjectDetected] = detectObject(frame)
  grayImage = rgb2gray(im2single(frame));
  utilities.foregroundMask = step(utilities.foregroundDetector, grayImage);
  detection = step(utilities.blobAnalyzer, utilities.foregroundMask);
  if isempty(detection)
    isObjectDetected = false;
  else
    
    detection = detection(1, :);
    isObjectDetected = true;
  end
end


function annotateTrackedObject()
  accumulateResults();
  
  combinedImage = max(repmat(utilities.foregroundMask, [1,1,3]), im2single(frame));

  if ~isempty(trackedLocation)
    shape = 'circle';
    region = trackedLocation;
    region(:, 3) = 5;
    combinedImage = insertObjectAnnotation(combinedImage, shape, ...
      region, {label}, 'Color', 'red');
  end
  step(utilities.videoPlayer, combinedImage);
end


function showTrajectory
  
  uiscopes.close('All'); 
  
  
  figure; imshow(utilities.accumulatedImage/2+0.5); hold on;
  plot(utilities.accumulatedDetections(:,1), ...
    utilities.accumulatedDetections(:,2), 'k+');
  
  if ~isempty(utilities.accumulatedTrackings)
    plot(utilities.accumulatedTrackings(:,1), ...
      utilities.accumulatedTrackings(:,2), 'r-o');
    legend('Detection', 'Tracking');
  end
end


function accumulateResults()
  utilities.accumulatedImage      = max(utilities.accumulatedImage, frame);
  utilities.accumulatedDetections ...
    = [utilities.accumulatedDetections; detectedLocation];
  utilities.accumulatedTrackings  ...
    = [utilities.accumulatedTrackings; trackedLocation];
end


function loc = computeInitialLocation(param, detectedLocation)
  if strcmp(param.initialLocation, 'Same as first detection')
    loc = detectedLocation;
  else
    loc = param.initialLocation;
  end
end


function utilities = createUtilities(param)

  utilities.videoReader = VideoReader("Circlee.mp4");
  utilities.videoPlayer = vision.VideoPlayer('Position', [100,100,500,400]);
  utilities.foregroundDetector = vision.ForegroundDetector(...
    'NumTrainingFrames', 10, 'InitialVariance', param.segmentationThreshold);
  utilities.blobAnalyzer = vision.BlobAnalysis('AreaOutputPort', false, ...
    'MinimumBlobArea', 70, 'CentroidOutputPort', true);

  utilities.accumulatedImage      = 0;
  utilities.accumulatedDetections = zeros(0, 2);
  utilities.accumulatedTrackings  = zeros(0, 2);
end
end
