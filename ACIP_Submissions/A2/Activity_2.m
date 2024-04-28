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
 

%% Step 5. Repeat the process with the BRISK
% Repeating everything for the second transformation

% Original Image
CPs_Matlab_orig_det = detectBRISKFeatures(im_orig);

% Feature extraction
[CPs_Matlab_orig_feat, CPs_Matlab_orig_ext] = extractFeatures(im_orig, CPs_Matlab_orig_det);

% You might want to reduce the number of CPs to around 50, if you have more than this number
target_n = 100; 
CPs_Matlab_orig_ext_str_br = CPs_Matlab_orig_ext.selectStrongest(target_n);

% Plot extracted CPs along with the coin image
figure(6), imshow(im_orig,rc),title('Original image with CP extracted by BRISK')
hold on
plot(CPs_Matlab_orig_ext_str_br.Location(:,1),CPs_Matlab_orig_ext_str_br.Location(:,2),'bx','LineWidth',2); 

% Feature detection and extraction
CPs_Matlab_t_det2 = detectBRISKFeatures(im_rigid);
[CPs_Matlab_t_feat2,  CPs_Matlab_t_ext2] = extractFeatures(im_rigid,  CPs_Matlab_t_det2);

% Select the strongest CPs (within availability)
CPs_Matlab_t_ext_str2=CPs_Matlab_t_ext2.selectStrongest(target_n);

% Show the final selected set
figure(7), imshow(im_rigid,Rri),title('Transformed image with CP extracted by BRISK')
hold on
plot(CPs_Matlab_t_ext_str2.Location(:,1),CPs_Matlab_t_ext_str2.Location(:,2),'gx','LineWidth',2); 

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
