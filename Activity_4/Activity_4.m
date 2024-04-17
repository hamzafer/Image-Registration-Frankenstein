% Class exercise 4. BLANK CODE
clc
clear all
close all
%% Step 1. Execute your Activity 3 code, and get the matched CP sets for the reference and sensed images using the Matlab Features
im_orig=imread('coin.png'); 
rc = imref2d(size(im_orig));
CPs_Matlab_orig_det = detectSIFTFeatures(im_orig);
[CPs_Matlab_orig_feat,  CPs_Matlab_orig_ext]  = extractFeatures(im_orig, CPs_Matlab_orig_det);

tform = affine2d([1 0 0; -0.3 1 0; 0 0 1]);
[im_t,Rtr] = imwarp(im_orig, tform);
rt = imref2d(size(im_t));

CPs_Matlab_t_det= detectSIFTFeatures(im_t);
[CPs_Matlab_t_feat,  CPs_Matlab_t_ext]  = extractFeatures(im_t,  CPs_Matlab_t_det);

[indexPairs,matchmetric] = matchFeatures(CPs_Matlab_orig_feat, CPs_Matlab_t_feat,'Unique',true,'MaxRatio',0.45);
matched_set_ref = CPs_Matlab_orig_ext(indexPairs(:,1));
matched_set_sen = CPs_Matlab_t_ext(indexPairs(:,2));
%% Step 2. Estimate the trasnform using both CP sets and the function estimateGeometricTransform . Read the function documentation first
% Change the transform type according to the problem tackled
tform_est = estgeotform2d(matched_set_sen, matched_set_ref, "affine");
%% Step 3. Register the image with the estimated transform from Step 1. 
% Set the original image frame for visualization
outputView = imref2d(size(im_orig));
im_reg  = imwarp(im_t, tform_est, OutputView = outputView);

%% Step 4. Show the overlap plot of the original and registered images, and visually evaluate the result
figure, imshowpair(im_orig,im_reg,"falsecolor");


%% Step 5. If the result does not look satisfactory, try one or several of the following approaches:

% a) Try to exclude outliers in the matching process (use the transformation estimation to get the subset of inliers that match

% [tform_est,inliers_sen, inliers_ref] = estimateGeometricTransform2d(...
    %COMPLETE THE ARGUMENT LIST HERE: CP SETS AND TRANSFORM TYPE);

% Repeat now the tform estimation using inliers only, then steps 3 and 4
% and see if the quality improves; show the inliers and check that they do
% not contain incorrect matches

% tform_est = estimateGeometricTransform2d(...
    %COMPLETE THE ARGUMENT LIST HERE: inlier CP SETS AND TRANSFORM TYPE);
% figure,ax=axes;
% showMatchedFeatures(im_orig,im_t,inliers_ref,inliers_sen,'montage','Parent',ax);

% b) Try to refine further the estimation procedure: add additional
% parameters to the call of the estimateGeometricTransform function (see
% the documentation: you can set MaxNumTrials, Confidence and MaxDistance
% parameters

% [tform_est,inliers_sen, inliers_ref] = estimateGeometricTransform2d(...
    %COMPLETE THE ARGUMENT LIST HERE WITH CP SETS, TRANSFORM TYPE AND ADDITIONAL PARAMETERS);;

% Repeat now steps 3 and 4 and see if the quality improves

% c) Try to get more matched CPs from activities 2 and 3 (change Feature
% type, change matching parameters as illustrated in activity 3)

%Repeat now steps 5, 3 and 4 and see if the quality improves

%% 
%Second Transformation

im_orig=imread('coin.png'); 
rc = imref2d(size(im_orig));
CPs_Matlab_orig_det = detectBRISKFeatures(im_orig);
[CPs_Matlab_orig_feat,  CPs_Matlab_orig_ext]  = extractFeatures(im_orig, CPs_Matlab_orig_det);
T2 = ([cosd(10) sind(10) 0; -sind(10) cosd(10) 0; 10 10 1]);
Tform_rigid = affine2d(T2);
[im_rigid, Rri] = imwarp(im_orig, Tform_rigid);
CPs_Matlab_t_det2= detectBRISKFeatures(im_rigid);
[CPs_Matlab_t_feat2,  CPs_Matlab_t_ext2]  = extractFeatures(im_rigid,  CPs_Matlab_t_det2);
[indexPairs,~] = matchFeatures(CPs_Matlab_orig_feat, CPs_Matlab_t_feat2,'Unique',true,'MaxRatio',0.6);

matched_set_ref=CPs_Matlab_orig_ext(indexPairs(:,1));
matched_set_sen=CPs_Matlab_t_ext2(indexPairs(:,2));

tform_est2 = estgeotform2d(matched_set_sen, matched_set_ref, "affine");

outputView = imref2d(size(im_orig));
im_reg2  = imwarp(im_rigid, tform_est2, OutputView = outputView);

figure, imshowpair(im_orig,im_reg2,"falsecolor");

