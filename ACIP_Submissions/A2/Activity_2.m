% Class exercise 2.
clc
clear all
close all

%% Step 1. Implemented feature extraction. 

% 1.1. Read image and show it
im_orig=imread('coin.png');
rc = imref2d(size(im_orig));
figure(1), imshow(im_orig,rc),title('Original image');

%% Step 2. Extract features from the original image with a Matlab implemented feature

% 2.1. Feature detection
CPs_Matlab_orig_det = detectSIFTFeatures(im_orig);

% 2.2. Feature extraction
[CPs_Matlab_orig_feat,  CPs_Matlab_orig_ext]  = extractFeatures(im_orig, CPs_Matlab_orig_det);

% 2.3. The number of CPs is 60
target_n = 60; 
CPs_Matlab_orig_ext_str = CPs_Matlab_orig_ext.selectStrongest(target_n);

% 2.4. Plot extracted CPs along with the coin image
figure(2), imshow(im_orig,rc),title('Original image with CP extracted by SIFT')
hold on
plot(CPs_Matlab_orig_ext_str.Location(:,1),CPs_Matlab_orig_ext_str.Location(:,2),'bx','LineWidth',2); 


%% Step 3. Repeat the process with the transformed image from activity 1

% 3.1. Define the transform (ACTIVITY 1):
tform = affine2d([1 0 0; -0.3 1 0; 0 0 1]);

% 3.2. Apply YOUR TRANSFORM
[im_aff,Rtr] = imwarp(im_orig, tform);
rt = imref2d(size(im_aff));

% 3.3. Repeat the process of extraction with the Matlab feature you have selected.
CPs_Matlab_t_det_hor = detectSIFTFeatures(im_aff); % Horizontal shearing
[CPs_Matlab_t_feat,  CPs_Matlab_t_ext]  = extractFeatures(im_aff,  CPs_Matlab_t_det_hor);

% 3.4. Select the strongest CPs (within availability)
CPs_Matlab_t_ext_str=CPs_Matlab_t_ext.selectStrongest(target_n);

% 3.5. Show the final selected set
figure(3), imshow(im_aff,rt),title('Transformed image with CP extracted by SIFT | Horizontal shearing')
hold on
plot(CPs_Matlab_t_ext_str.Location(:,1),CPs_Matlab_t_ext_str.Location(:,2),'gx','LineWidth',2); 

% 4.1. Transformed (Rigid Transform)
T2 = ([cosd(10) sind(10) 0; -sind(10) cosd(10) 0; 10 10 1]);
Tform_rigid = affine2d(T2);
[im_rigid, Rri] = imwarp(im_orig, Tform_rigid);

% 4.2. Feature detection and extraction
CPs_Matlab_t_det_rig = detectSIFTFeatures(im_rigid); % Rigid Transformation
[CPs_Matlab_t_feat_rig, CPs_Matlab_t_ext_rig] = extractFeatures(im_rigid,  CPs_Matlab_t_det_rig);

% 4.3. Select the strongest CPs (within availability)
CPs_Matlab_t_ext_str_rig=CPs_Matlab_t_ext_rig.selectStrongest(target_n);

% 4.4. Show the final selected set
figure(4), imshow(im_rigid,Rri),title('Transformed image with CP extracted by SIFT | Rigid')
hold on
plot(CPs_Matlab_t_ext_str_rig.Location(:,1),CPs_Matlab_t_ext_str_rig.Location(:,2),'gx','LineWidth',2); 

%% Step 4. Comparison between the two CP distributions
figure(5), subplot(1,2,1); 
imshow(im_orig,rc)
hold on
plot(CPs_Matlab_orig_ext_str.Location(:,1),CPs_Matlab_orig_ext_str.Location(:,2),'bx','LineWidth',2);
title('Original CP set | SIFT');
subplot(1,2,2);
imshow(im_rigid,Rri);
hold on, plot(CPs_Matlab_t_ext_str_rig.Location(:,1),CPs_Matlab_t_ext_str_rig.Location(:,2),'gx','LineWidth',2);
title('CP set extracted after transform');
 

%% Step 5. BRISK Feature Detection and Extraction

% Original Image
% 5.1 Detect BRISK Features on Original Image
CPs_Matlab_orig_det = detectBRISKFeatures(im_orig);

% 5.2 Extract Features from Original Image
[CPs_Matlab_orig_feat, CPs_Matlab_orig_ext] = extractFeatures(im_orig, CPs_Matlab_orig_det);

% 5.3 Select the strongest CPs (targeting 60 as with SIFT)
target_n = 60; 
CPs_Matlab_orig_ext_str_br = CPs_Matlab_orig_ext.selectStrongest(target_n);

% 5.4 Plot extracted CPs along with the original coin image
figure(6), imshow(im_orig,rc), title('Original image with CP extracted by BRISK')
hold on
plot(CPs_Matlab_orig_ext_str_br.Location(:,1), CPs_Matlab_orig_ext_str_br.Location(:,2), 'bx', 'LineWidth',2);

% Sheared Transformation
% 5.5 Detect BRISK Features on Sheared Image
CPs_Matlab_t_det_br_shear = detectBRISKFeatures(im_aff);

% 5.6 Extract Features from Sheared Image
[CPs_Matlab_t_feat_br_shear, CPs_Matlab_t_ext_br_shear] = extractFeatures(im_aff, CPs_Matlab_t_det_br_shear);

% 5.7 Select the strongest CPs for Sheared Image
CPs_Matlab_t_ext_str_br_shear = CPs_Matlab_t_ext_br_shear.selectStrongest(target_n);

% 5.8 Show the final selected set on sheared transformed image
figure(7), imshow(im_aff, rt), title('Transformed image with CP extracted by BRISK | Horizontal Shearing')
hold on
plot(CPs_Matlab_t_ext_str_br_shear.Location(:,1), CPs_Matlab_t_ext_str_br_shear.Location(:,2), 'gx', 'LineWidth',2);

% Rigid Transformation
% 5.9 Detect BRISK Features on Rigidly Transformed Image
CPs_Matlab_t_det_br_rigid = detectBRISKFeatures(im_rigid);

% 5.10 Extract Features from Rigidly Transformed Image
[CPs_Matlab_t_feat_br_rigid, CPs_Matlab_t_ext_br_rigid] = extractFeatures(im_rigid, CPs_Matlab_t_det_br_rigid);

% 5.11 Select the strongest CPs for Rigidly Transformed Image
CPs_Matlab_t_ext_str_br_rigid = CPs_Matlab_t_ext_br_rigid.selectStrongest(target_n);

% 5.12 Show the final selected set on rigidly transformed image
figure(8), imshow(im_rigid, Rri), title('Transformed image with CP extracted by BRISK | Rigid')
hold on
plot(CPs_Matlab_t_ext_str_br_rigid.Location(:,1), CPs_Matlab_t_ext_str_br_rigid.Location(:,2), 'gx', 'LineWidth',2);

%% Step 6. Comparison between the two CP distributions
figure(8), subplot(1,2,1); 
imshow(im_orig,rc)
hold on
plot(CPs_Matlab_orig_ext_str_br.Location(:,1),CPs_Matlab_orig_ext_str_br.Location(:,2),'bx','LineWidth',2);
title('Original CP set | BRISK');
subplot(1,2,2);
imshow(im_rigid,Rri);
hold on, plot(CPs_Matlab_t_ext_str2.Location(:,1),CPs_Matlab_t_ext_str2.Location(:,2),'gx','LineWidth',2);
title('CP set extracted after transform');

%% Other methods for comparisons:

% SURF: Original Image
CPs_SURF_orig_det = detectSURFFeatures(im_orig);
[CPs_SURF_orig_feat, CPs_SURF_orig_ext] = extractFeatures(im_orig, CPs_SURF_orig_det);
CPs_SURF_orig_ext_str = CPs_SURF_orig_ext.selectStrongest(target_n);

% Plotting for the original image
figure, imshow(im_orig, rc), title('Original image with CP extracted by SURF');
hold on;
plot(CPs_SURF_orig_ext_str.Location(:,1), CPs_SURF_orig_ext_str.Location(:,2), 'bx', 'LineWidth', 2);
%%
% SURF: Transformed Image
CPs_SURF_t_det = detectSURFFeatures(im_rigid);
[CPs_SURF_t_feat, CPs_SURF_t_ext] = extractFeatures(im_rigid, CPs_SURF_t_det);
CPs_SURF_t_ext_str = CPs_SURF_t_ext.selectStrongest(target_n);

% Plotting for the transformed image
figure, imshow(im_rigid, Rri), title('Transformed image with CP extracted by SURF');
hold on;
plot(CPs_SURF_t_ext_str.Location(:,1), CPs_SURF_t_ext_str.Location(:,2), 'gx', 'LineWidth', 2);

%% Comparison between the two CP distributions for SURF
figure(9), subplot(1,2,1); 
imshow(im_orig,rc)
hold on
plot(CPs_SURF_orig_ext_str.Location(:,1), CPs_SURF_orig_ext_str.Location(:,2), 'bx', 'LineWidth', 2);
title('Original CP set | SURF');
subplot(1,2,2);
imshow(im_rigid,Rri);
hold on, plot(CPs_SURF_t_ext_str.Location(:,1), CPs_SURF_t_ext_str.Location(:,2), 'gx', 'LineWidth', 2);
title('CP set extracted after transform | SURF');

%%
% MSER: Original Image
CPs_MSER_orig_det = detectMSERFeatures(im_orig);
[CPs_MSER_orig_feat, CPs_MSER_orig_ext] = extractFeatures(im_orig, CPs_MSER_orig_det);
CPs_MSER_orig_ext_str = CPs_MSER_orig_ext.selectStrongest(target_n);

% Plotting for the original image
figure, imshow(im_orig, rc), title('Original image with CP extracted by MSER');
hold on;
plot(CPs_MSER_orig_ext_str.Location(:,1), CPs_MSER_orig_ext_str.Location(:,2), 'bx', 'LineWidth', 2);

%%
% MSER: Transformed Image
CPs_MSER_t_det = detectMSERFeatures(im_rigid);
[CPs_MSER_t_feat, CPs_MSER_t_ext] = extractFeatures(im_rigid, CPs_MSER_t_det);
CPs_MSER_t_ext_str = CPs_MSER_t_ext.selectStrongest(target_n);

% Plotting for the transformed image
figure, imshow(im_rigid, Rri), title('Transformed image with CP extracted by MSER');
hold on;
plot(CPs_MSER_t_ext_str.Location(:,1), CPs_MSER_t_ext_str.Location(:,2), 'gx', 'LineWidth', 2);

%% Comparison between the two CP distributions for MSER
figure(10), subplot(1,2,1); 
imshow(im_orig,rc)
hold on
plot(CPs_MSER_orig_ext_str.Location(:,1), CPs_MSER_orig_ext_str.Location(:,2), 'bx', 'LineWidth', 2);
title('Original CP set | MSER');
subplot(1,2,2);
imshow(im_rigid,Rri);
hold on, plot(CPs_MSER_t_ext_str.Location(:,1), CPs_MSER_t_ext_str.Location(:,2), 'gx', 'LineWidth', 2);
title('CP set extracted after transform | MSER');

%% 
% FAST: Original Image
CPs_FAST_orig_det = detectFASTFeatures(im_orig);
[CPs_FAST_orig_feat, CPs_FAST_orig_ext] = extractFeatures(im_orig, CPs_FAST_orig_det);
CPs_FAST_orig_ext_str = CPs_FAST_orig_ext.selectStrongest(target_n);

% Plotting for the original image
figure, imshow(im_orig, rc), title('Original image with CP extracted by FAST');
hold on;
plot(CPs_FAST_orig_ext_str.Location(:,1), CPs_FAST_orig_ext_str.Location(:,2), 'bx', 'LineWidth', 2);

%%
% FAST: Transformed Image
CPs_FAST_t_det = detectFASTFeatures(im_rigid);
[CPs_FAST_t_feat, CPs_FAST_t_ext] = extractFeatures(im_rigid, CPs_FAST_t_det);
CPs_FAST_t_ext_str = CPs_FAST_t_ext.selectStrongest(target_n);

% Plotting for the transformed image
figure, imshow(im_rigid, Rri), title('Transformed image with CP extracted by FAST');
hold on;
plot(CPs_FAST_t_ext_str.Location(:,1), CPs_FAST_t_ext_str.Location(:,2), 'gx', 'LineWidth', 2);

%% Comparison between the two CP distributions for FAST
figure(11), subplot(1,2,1); 
imshow(im_orig,rc)
hold on
plot(CPs_FAST_orig_ext_str.Location(:,1), CPs_FAST_orig_ext_str.Location(:,2), 'bx', 'LineWidth', 2);
title('Original CP set | FAST');
subplot(1,2,2);
imshow(im_rigid,Rri);
hold on, plot(CPs_FAST_t_ext_str.Location(:,1), CPs_FAST_t_ext_str.Location(:,2), 'gx', 'LineWidth', 2);
title('CP set extracted after transform | FAST');

%% 
% MinEigen: Original Image
CPs_MinEigen_orig_det = detectMinEigenFeatures(im_orig);
[CPs_MinEigen_orig_feat, CPs_MinEigen_orig_ext] = extractFeatures(im_orig, CPs_MinEigen_orig_det);
CPs_MinEigen_orig_ext_str = CPs_MinEigen_orig_ext.selectStrongest(target_n);

% Plotting for the original image
figure, imshow(im_orig, rc), title('Original image with CP extracted by MinEigen');
hold on;
plot(CPs_MinEigen_orig_ext_str.Location(:,1), CPs_MinEigen_orig_ext_str.Location(:,2), 'bx', 'LineWidth', 2);

%%
% MinEigen: Transformed Image
CPs_MinEigen_t_det = detectMinEigenFeatures(im_rigid);
[CPs_MinEigen_t_feat, CPs_MinEigen_t_ext] = extractFeatures(im_rigid, CPs_MinEigen_t_det);
CPs_MinEigen_t_ext_str = CPs_MinEigen_t_ext.selectStrongest(target_n);

% Plotting for the transformed image
figure, imshow(im_rigid, Rri), title('Transformed image with CP extracted by MinEigen');
hold on;
plot(CPs_MinEigen_t_ext_str.Location(:,1), CPs_MinEigen_t_ext_str.Location(:,2), 'gx', 'LineWidth', 2);

%% Comparison between the two CP distributions for MinEigen
figure(12), subplot(1,2,1); 
imshow(im_orig,rc)
hold on
plot(CPs_MinEigen_orig_ext_str.Location(:,1), CPs_MinEigen_orig_ext_str.Location(:,2), 'bx', 'LineWidth', 2);
title('Original CP set | MinEigen');
subplot(1,2,2);
imshow(im_rigid,Rri);
hold on, plot(CPs_MinEigen_t_ext_str.Location(:,1), CPs_MinEigen_t_ext_str.Location(:,2), 'gx', 'LineWidth', 2);
title('CP set extracted after transform | MinEigen');

%%
% Harris: Original Image
CPs_Harris_orig_det = detectHarrisFeatures(im_orig);
[CPs_Harris_orig_feat, CPs_Harris_orig_ext] = extractFeatures(im_orig, CPs_Harris_orig_det);
CPs_Harris_orig_ext_str = CPs_Harris_orig_ext.selectStrongest(target_n);

% Plotting for the original image
figure, imshow(im_orig, rc), title('Original image with CP extracted by Harris');
hold on;
plot(CPs_Harris_orig_ext_str.Location(:,1), CPs_Harris_orig_ext_str.Location(:,2), 'bx', 'LineWidth', 2);

%%
% Harris: Transformed Image
CPs_Harris_t_det = detectHarrisFeatures(im_rigid);
[CPs_Harris_t_feat, CPs_Harris_t_ext] = extractFeatures(im_rigid, CPs_Harris_t_det);
CPs_Harris_t_ext_str = CPs_Harris_t_ext.selectStrongest(target_n);

% Plotting for the transformed image
figure, imshow(im_rigid, Rri), title('Transformed image with CP extracted by Harris');
hold on;
plot(CPs_Harris_t_ext_str.Location(:,1), CPs_Harris_t_ext_str.Location(:,2), 'gx', 'LineWidth', 2);

%% Comparison between the two CP distributions for Harris
figure(13), subplot(1,2,1); 
imshow(im_orig,rc)
hold on
plot(CPs_Harris_orig_ext_str.Location(:,1), CPs_Harris_orig_ext_str.Location(:,2), 'bx', 'LineWidth', 2);
title('Original CP set | Harris');
subplot(1,2,2);
imshow(im_rigid,Rri);
hold on, plot(CPs_Harris_t_ext_str.Location(:,1), CPs_Harris_t_ext_str.Location(:,2), 'gx', 'LineWidth', 2);
title('CP set extracted after transform | Harris');

%%
% ORB-like Algorithm
% Detect FAST keypoints
CPs_ORB_orig_det = detectFASTFeatures(im_orig);

% Extract BRIEF (Binary Robust Independent Elementary Features) descriptors
[CPs_ORB_orig_feat, CPs_ORB_orig_ext] = extractFeatures(im_orig, CPs_ORB_orig_det, 'Method', 'Block', 'BlockSize', 31);
CPs_ORB_orig_ext_str = CPs_ORB_orig_ext.selectStrongest(target_n);

% Plotting for the original image
figure, imshow(im_orig, rc), title('Original image with ORB-like CP extracted');
hold on;
plot(CPs_ORB_orig_ext_str.Location(:,1), CPs_ORB_orig_ext_str.Location(:,2), 'bx', 'LineWidth', 2);

%%
% ORB-like: Transformed Image
CPs_ORB_t_det = detectFASTFeatures(im_rigid);
[CPs_ORB_t_feat, CPs_ORB_t_ext] = extractFeatures(im_rigid, CPs_ORB_t_det, 'Method', 'Block', 'BlockSize', 31);
CPs_ORB_t_ext_str = CPs_ORB_t_ext.selectStrongest(target_n);

% Plotting for the transformed image
figure, imshow(im_rigid, Rri), title('Transformed image with ORB-like CP extracted');
hold on;
plot(CPs_ORB_t_ext_str.Location(:,1), CPs_ORB_t_ext_str.Location(:,2), 'gx', 'LineWidth', 2);

%% Comparison between the two CP distributions for ORB-like
figure(14), subplot(1,2,1); 
imshow(im_orig,rc)
hold on
plot(CPs_ORB_orig_ext_str.Location(:,1), CPs_ORB_orig_ext_str.Location(:,2), 'bx', 'LineWidth', 2);
title('Original CP set | ORB-like');
subplot(1,2,2);
imshow(im_rigid,Rri);
hold on, plot(CPs_ORB_t_ext_str.Location(:,1), CPs_ORB_t_ext_str.Location(:,2), 'gx', 'LineWidth', 2);
title('CP set extracted after transform | ORB-like');
