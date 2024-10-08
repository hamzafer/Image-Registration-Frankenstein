%% Case 3. HARD
clear all
clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% a) Load images
im3ref=imread('im3_ref.jpg');
im3sen=imread('im3_sen.jpg');

% b) Select one of the planes (for instance, the red plane, but you can try
% which one works better)
channel = 3; % Change this value to 2 for green, 3 for blue to test different channels
fixed = im3ref(:,:,channel);
moving = im3sen(:,:,channel);

% c) Show the initial misalignment problem using the imshowpair function
figure, imshowpair(fixed, moving, 'montage'), title('Initial Misalignment - Red Plane');

%d) Find the appropriate transform and solve the registration problem

%D1) Here we can try with different feature types and see which one is the best

ptsref  = detectSIFTFeatures(fixed);
ptsmov = detectSIFTFeatures(moving);

[featfixed,  validPtsfixed]  = extractFeatures(fixed, ptsref);
[featmov, validPtsmoving] = extractFeatures(moving, ptsmov);
%%
indexPairs = matchFeatures(featfixed, featmov,'Unique',true);
%indexPairs = matchFeatures(featfixed, featmov, 'Unique', true, 'MaxRatio', 0.6, 'MatchThreshold', 10.0, 'Metric', 'SAD');

%D2) Show the matched CP sets, selecting the valid points

matchedfixed  = validPtsfixed(indexPairs(:,1));
matchedmov= validPtsmoving(indexPairs(:,2));

figure;
showMatchedFeatures(fixed, moving, matchedfixed, matchedmov, 'montage');
title('Matched Points Before Registration');

%%
% D3) Obtain the transformation from the matched CP sets
[tform2, inliermov, inlierfixed] = estimateGeometricTransform(...
    matchedmov, matchedfixed, 'projective');

%D4) Register the two images
outputView = imref2d(size(fixed));
moving_reg = imwarp(moving, tform2, 'OutputView', outputView);

figure, imshowpair(fixed,moving_reg,'falsecolor');
title('Registration Output');

%%
%e) How would you evaluate the quality? Can you use intensity-based
%metrics? If so, complete the corresponding code here
pix_orig=fixed(:);
pix_reg=moving_reg(:);

% Calculate the number of pixels
n = length(pix_orig);  % Number of pixels

% RMSE
RMSE = sqrt(sum((double(pix_orig) - double(pix_reg)).^2) / n);

% Relative RMSE, assuming an 8-bit image (maximum value of RMSE = 255)
RMSE_rel = RMSE / 255;

% Print RMSE metrics
fprintf('RMSE: %f\n', RMSE);
fprintf('Relative RMSE: %f\n', RMSE_rel);

%%
%e2) Discuss an alternative for evaluating the registration quality using manually extracted key points in both
%original and registered images (10 key points, for instance)

% Manually select control points for accuracy evaluation
% cpselect(moving_reg,fixed);
% save 'CP_manual_proj_case3.mat' fixedPoints movingPoints;
%%
load 'CP_manual_proj_case3.mat'
%%
%Compute the average euclidean distance between original and registered image's key
%points.
figure, ax=axes;
imshow(fixed)
hold on
plot(fixedPoints(:,1), fixedPoints(:,2), 'ro');
plot(movingPoints(:,1),movingPoints(:,2),'bx');
legend(ax, ' Original', 'Registered');
title(ax, "Original and Registered Key Point Locations")

diff = fixedPoints - movingPoints;
acc_projc3= (1/(size(fixedPoints,1)-1))*sum(sqrt((diff(:,1).^2+diff(:,2).^2)));

% Print CP manual evaluation
fprintf('Manual CP Euclidean error: %f\n', acc_projc3);

%%

%E3) Other possibility: automatically extract CPs in original and registered
%image, using a different feature so as not to obtain the same CP locations used
%to estimate the transform previously

CPs_eval_ref = detectSURFFeatures(fixed);
CPs_eval_reg = detectSURFFeatures(moving_reg);

[CPs_eval_ref_feat,  CPs_eval_ref_ext]  = extractFeatures(fixed,  CPs_eval_ref);
[CPs_eval_reg_feat,  CPs_eval_reg_ext]  = extractFeatures(moving_reg,  CPs_eval_reg);

[indexPairs,matchmetric] = matchFeatures(CPs_eval_ref_feat, CPs_eval_reg_feat, 'Unique',true);
matched_set_ref=CPs_eval_ref_ext(indexPairs(:,1));
matched_set_reg=CPs_eval_reg_ext(indexPairs(:,2));

diff = matched_set_ref.Location-matched_set_reg.Location;
CP_Loc_error_euclidean = (1/(size(matched_set_ref,1)-1))*sum(sqrt((diff(:,1).^2+diff(:,2).^2)));

% Show the results Using showMatchedFeatures function
figure, ax=axes;
showMatchedFeatures(fixed, moving_reg, matched_set_ref, matched_set_reg,'montage','Parent',ax);
title(ax, 'Candidate point matches');
legend(ax, 'Matched points Ref','Matched points Registered');

% Show the results using a plot of CP locations with different symbols
figure, ax=axes;
imshow(fixed)
hold on
plot(matched_set_ref.Location(:,1), matched_set_ref.Location(:,2), 'ro');
plot(matched_set_reg.Location(:,1),matched_set_reg.Location(:,2),'bx');
legend(ax, ' Original', 'Registered');
title(ax, "Original and Registered CP locations")


% Print CP automatic evaluation
fprintf('Automatic CP Euclidean error: %f\n', CP_Loc_error_euclidean);

%E4) Discuss the evaluation metrics' values found, and determine if the result is acceptable
%or not. Try to explain the differences found between the three evaluation
%alternatives tested

%% Experiment 2: Using Different Feature Detectors
clear all;
clc;

% a) Load images
im3ref = imread('im3_ref.jpg');
im3sen = imread('im3_sen.jpg');

% b) Select the red channel for this experiment
fixed = im3ref(:,:,1); % Using red channel
moving = im3sen(:,:,1);

% c) Initialize detector type
detectorType = 'KAZE'; % Change to 'ORB' or 'KAZE'

% d) Feature detection and matching based on selected detector
if strcmp(detectorType, 'ORB')
    ptsRef  = detectORBFeatures(fixed);
    ptsMov = detectORBFeatures(moving);
elseif strcmp(detectorType, 'KAZE')
    ptsRef  = detectKAZEFeatures(fixed);
    ptsMov = detectKAZEFeatures(moving);
end

[featuresRef,  validPtsRef]  = extractFeatures(fixed, ptsRef);
[featuresMov, validPtsMov] = extractFeatures(moving, ptsMov);

% Matching features
indexPairs = matchFeatures(featuresRef, featuresMov, 'Unique', true);
matchedRef = validPtsRef(indexPairs(:,1));
matchedMov = validPtsMov(indexPairs(:,2));

% Show matched features
figure;
showMatchedFeatures(fixed, moving, matchedRef, matchedMov, 'montage');
title([detectorType ' Matched Points']);

% e) Estimate geometric transformation and register the images
[tform, inlierMov, inlierRef] = estimateGeometricTransform(matchedMov, matchedRef, 'affine');

% f) Apply transformation and display registered image
registered = imwarp(moving, tform, 'OutputView', imref2d(size(fixed)));
figure, imshowpair(fixed, registered, 'falsecolor');
title([detectorType ' Registration Output']);

% g) Compute Intensity-based Metric (RMSE)
fixedPixels = fixed(:);
registeredPixels = registered(:);

% Calculate RMSE
RMSE = sqrt(mean((double(fixedPixels) - double(registeredPixels)).^2));

% Calculate Relative RMSE, assuming an 8-bit image (maximum value of RMSE = 255)
relativeRMSE = RMSE / 255;

% Print RMSE metrics
fprintf('%s RMSE: %f\n', detectorType, RMSE);
fprintf('%s Relative RMSE: %f\n', detectorType, relativeRMSE);


%% Experiment 3: Using Affine Transformations
clear all;
clc;

% a) Load images
im3ref = imread('im3_ref.jpg');
im3sen = imread('im3_sen.jpg');

% b) Select the red channel for this experiment
fixed = im3ref(:,:,1);
moving = im3sen(:,:,1);

% c) Feature detection using SIFT as it is the best from what we have
% experimented
ptsRef  = detectSIFTFeatures(fixed);
ptsMov = detectSIFTFeatures(moving);

[featuresRef, validPtsRef]  = extractFeatures(fixed, ptsRef);
[featuresMov, validPtsMov] = extractFeatures(moving, ptsMov);

% Matching features
indexPairs = matchFeatures(featuresRef, featuresMov, 'Unique', true);
matchedRef = validPtsRef(indexPairs(:,1));
matchedMov = validPtsMov(indexPairs(:,2));

% Show matched features
figure;
showMatchedFeatures(fixed, moving, matchedRef, matchedMov, 'montage');
title('Matched Points Using SIFT with Affine Transformation');

% d) Estimate affine geometric transformation and apply it
tformAffine = estimateGeometricTransform(matchedMov, matchedRef, 'affine');

% Apply transformation and display registered image
registeredAffine = imwarp(moving, tformAffine, 'OutputView', imref2d(size(fixed)));
figure, imshowpair(fixed, registeredAffine, 'falsecolor');
title('Affine Registration Output');

% e) Calculate intensity-based metric (RMSE)
fixedPixels = fixed(:);
registeredAffinePixels = registeredAffine(:);

% Calculate RMSE
RMSE = sqrt(mean((double(fixedPixels) - double(registeredAffinePixels)).^2));

% Calculate Relative RMSE, assuming an 8-bit image (maximum value of RMSE = 255)
relativeRMSE = RMSE / 255;

% Print RMSE metrics
fprintf('Affine RMSE: %f\n', RMSE);
fprintf('Affine Relative RMSE: %f\n', relativeRMSE);


%% Experiment 4: Grid of Control Points
clear all;
clc;

% Load images
im3ref = imread('im3_ref.jpg');
im3sen = imread('im3_sen.jpg');

% Select the red channel
fixed = im3ref(:,:,1);
moving = im3sen(:,:,1);

% Detect features using a chosen method
ptsRef = detectSIFTFeatures(fixed);
ptsMov = detectSIFTFeatures(moving);

% Match features
[featuresRef, validPtsRef] = extractFeatures(fixed, ptsRef);
[featuresMov, validPtsMov] = extractFeatures(moving, ptsMov);
indexPairs = matchFeatures(featuresRef, featuresMov, 'Unique', true);

matchedRef = validPtsRef(indexPairs(:,1));
matchedMov = validPtsMov(indexPairs(:,2));

% Estimate transformation using your chosen method
tform = estimateGeometricTransform(matchedMov, matchedRef, 'projective');

% Apply transformation
registered = imwarp(moving, tform, 'OutputView', imref2d(size(fixed)));

% Generate a grid of points across the fixed image
gridSize = 50; % Size of the grid
[xGrid, yGrid] = meshgrid(1:gridSize:size(fixed,2), 1:gridSize:size(fixed,1));
gridPoints = [xGrid(:) yGrid(:)];

% Transform grid points using the estimated transformation
transformedGridPoints = transformPointsForward(tform, gridPoints);

% Display original and transformed grid points on the images
figure;
imshow(fixed); hold on;
plot(gridPoints(:,1), gridPoints(:,2), 'ro');
title('Original Image with Grid Points');  % Title for the original image with grid

figure;
imshow(registered); hold on;
plot(transformedGridPoints(:,1), transformedGridPoints(:,2), 'go');
title('Registered Image with Transformed Grid Points');  % Title for the registered image with transformed grid

% Calculate distances between original grid points and transformed grid points for evaluation
distances = sqrt(sum((gridPoints - transformedGridPoints).^2, 2));
meanGridPointError = mean(distances);
maxGridPointError = max(distances);

% Print grid point evaluation results
fprintf('Mean Grid Point Error: %f pixels\n', meanGridPointError);
fprintf('Max Grid Point Error: %f pixels\n', maxGridPointError);

%% Last Experiment: Enhanced SIFT Registration
clear all;
clc;

% a) Load images
im3ref = imread('im3_ref.jpg');
im3sen = imread('im3_sen.jpg');

% b) Select one of the planes (red plane for this example)
channel = 3; % Change this value to 2 for green, 3 for blue to test different channels
fixed = im3ref(:,:,channel);
moving = im3sen(:,:,channel);

% c) Show the initial misalignment using imshowpair
figure, imshowpair(fixed, moving, 'montage'), title('Initial Misalignment - Blue Plane');

% d) Feature detection and extraction
ptsRef = detectSIFTFeatures(fixed);
ptsMov = detectSIFTFeatures(moving);

[featuresRef, validPtsRef] = extractFeatures(fixed, ptsRef);
[featuresMov, validPtsMov] = extractFeatures(moving, ptsMov);

% e) Feature matching with adjusted MaxRatio to reduce false matches
indexPairs = matchFeatures(featuresRef, featuresMov, 'Unique', true, 'MaxRatio', 0.5, 'MatchThreshold', 10.0);

matchedRef = validPtsRef(indexPairs(:,1));
matchedMov = validPtsMov(indexPairs(:,2));

% f) Show matched control points
figure;
showMatchedFeatures(fixed, moving, matchedRef, matchedMov, 'montage');
title('Matched Points Before Registration');

% g) Estimate geometric transformation using projective model
[tform, inlierMov, inlierRef] = estimateGeometricTransform(matchedMov, matchedRef, 'projective');

% h) Apply transformation and display registration output
outputView = imref2d(size(fixed));
registered = imwarp(moving, tform, 'OutputView', outputView);

figure, imshowpair(fixed, registered, 'falsecolor');
title('Registration Output');

% i) Calculate intensity-based metrics (RMSE)
pixOrig = fixed(:);
pixReg = registered(:);
RMSE = sqrt(mean((double(pixOrig) - double(pixReg)).^2));
relativeRMSE = RMSE / 255;  % Assuming an 8-bit image scale

% Print RMSE metrics
fprintf('Enhanced SIFT RMSE: %f\n', RMSE);
fprintf('Enhanced SIFT Relative RMSE: %f\n', relativeRMSE);
