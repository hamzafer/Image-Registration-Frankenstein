%% Case 4. Real World problem
clear all
clc
% a) Load images
im4ref=imread('im4_ref.jpg');
im4sen=imread('im4_sen.jpg');

% Convert to grayscale if they are RGB
fixed = rgb2gray(im4ref); 
moving = rgb2gray(im4sen);

% b) Show the initial misalignment problem using imshowpair function
figure, imshowpair(fixed, moving, 'montage'), title('Initial Misalignment');
%%
% c) Detecting and extracting features using SURF
ptsFixed = detectSURFFeatures(fixed);
ptsMoving = detectSURFFeatures(moving);

[featuresFixed, validPtsFixed] = extractFeatures(fixed, ptsFixed);
[featuresMoving, validPtsMoving] = extractFeatures(moving, ptsMoving);

% d) Match features
[indexPairs,matchmetric] = matchFeatures(featuresFixed, featuresMoving, 'Unique',true,'MaxRatio',0.55);
matched_set_ref=validPtsFixed(indexPairs(:,1));
matched_set_reg=validPtsMoving(indexPairs(:,2));

% Show the results Using showMatchedFeatures function
figure, ax=axes;
showMatchedFeatures(fixed, moving, matched_set_ref, matched_set_reg,'montage','Parent',ax);
title(ax, 'Candidate point matches');
legend(ax, 'Matched points Ref','Matched points Registered');
%%

% e) Estimate geometric transformation using matched points
[tform, inlierMoving, inlierFixed] = estimateGeometricTransform(...
    matched_set_reg, matched_set_ref, 'projective'); 

% f)Apply the transformation to the moving image
outputView = imref2d(size(fixed));
movingRegistered = imwarp(moving, tform, 'OutputView', outputView);

% Show the registered image
figure, imshowpair(fixed, movingRegistered, 'falsecolor'), title('Registered Images');
%%
% g) Evaluate the registration quality

% Manually select control points for accuracy evaluation
%cpselect(movingRegistered, fixed);
%save 'CP_manual_proj_case4.mat' fixedPoints movingPoints;
%%
load 'CP_manual_proj_case4.mat' % Contains fixed_points, moving_points

%%
%Compute the average euclidean distance between original and registered image's key
%points. 
figure, ax=axes;
imshow(fixed)
hold on
plot(fixedPoints(:,1), fixedPoints(:,2), 'ro');
plot(movingPoints(:,1),movingPoints(:,2),'bx');
legend(ax, ' Original', 'Registered');
title(ax, "Original and Registered CP locations")

diff = fixedPoints - movingPoints;
acc_projc4= (1/(size(fixedPoints,1)-1))*sum(sqrt((diff(:,1).^2+diff(:,2).^2)));

%%
%Other possibility: automatically extract CPs in original and registered
%image, using a different feature so as not to obtain the same CP locations used
%to estimate the transform previously

rng(5)

CPs_eval_ref = detectKAZEFeatures(fixed);
CPs_eval_reg = detectKAZEFeatures(movingRegistered);

[CPs_eval_ref_feat,  CPs_eval_ref_ext]  = extractFeatures(fixed,  CPs_eval_ref);
[CPs_eval_reg_feat,  CPs_eval_reg_ext]  = extractFeatures(movingRegistered,  CPs_eval_reg);

[indexPairs,matchmetric] = matchFeatures(CPs_eval_ref_feat, CPs_eval_reg_feat, 'Unique',true,'MaxRatio',0.4);
matched_set_ref=CPs_eval_ref_ext(indexPairs(:,1));
matched_set_reg=CPs_eval_reg_ext(indexPairs(:,2));

diff = matched_set_ref.Location-matched_set_reg.Location;
CP_Loc_error_euclidean = (1/(size(matched_set_ref,1)-1))*sum(sqrt((diff(:,1).^2+diff(:,2).^2)));

% Show the results Using showMatchedFeatures function
figure, ax=axes;
showMatchedFeatures(fixed, movingRegistered, matched_set_ref, matched_set_reg,'montage','Parent',ax);
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

