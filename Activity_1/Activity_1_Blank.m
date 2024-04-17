% Class Activity 1

%1. Loading and showing the reference image, without and with imref2d
%(image reference frame)

im_ref = imread('coin.png');
figure;
imshow(im_ref);
title('Spatial reference frame unknown');

%imref2d Accumulates information about the image limits and shows these limits with imshow
Rcb_ref = imref2d(size(im_ref));
figure;
imshow(im_ref,Rcb_ref);
title('Spatial reference frame known');

%% Create the Transformation of free parameters, using pre-defined functions in Matlab
%We create the TRANSFORMATION MATRIX (transposed version of the matrix in the
% lectures, YOU DECIDE THE PARAMETERS)

%A) COMPLETE CODE HERE TO CREATE YOUR TRANSFORM

% Scaling
T_sc = [1.5 0 0; 0 1.5 0; 0 0 1];
Tform_sc = affine2d(T_sc);
[im_sc, Rtr] = imwarp(im_ref, Tform_sc);
Rcb_sc = imref2d(size(im_sc));
figure;imshow(im_sc,Rcb_sc);

% Rotating
theta = 60;
T_rot = [cosd(theta) -sind(theta) 0; sind(theta) cosd(theta) 0; 0 0 1];
Tform_rot = affine2d(T_rot);
[im_rot, Rtr] = imwarp(im_ref, Tform_rot);
figure;imshow(im_rot);

% Translation
im_tr = imtranslate(im_ref,[15, 25]);
Rcb_tr = imref2d(size(im_tr));
figure;imshow(im_tr,Rcb_ref);

% Affine transforms
T = [1 0 0; 0.3 1 0; 0 0 1]; %only horizontal shear, example of an affine
%T = [1 -0.2 0;0 1 0; 0 0 1]; %vertical shear
% for affine if you want to add rotation, translation or scaling, after
% shear, do it with builtin func
Tform_aff = affine2d(T);
[im_aff, Rtr] = imwarp(im_ref, Tform_aff);
Rcb_aff = imref2d(size(im_aff));
figure;
imshow(im_aff,Rcb_aff);
title("Affine transformation, Horizontal shearing")

% Similarity transform -> translation, rotation, scaling
im = imtranslate(im_ref,[0, 3]);
theta = 20;
im = imrotate(im,theta);
scaleFactor = 1.5;
im_sim = imresize(im,scaleFactor);
Rcb = imref2d(size(im_sim));
figure;
imshow(im_sim,Rcb);
title("Similarity transformation")

%Rigid -> translation + rotation
im1 = imtranslate(im_ref,[1, 3]);
theta = 40;
im_rigid = imrotate(im1,theta);
Rcb_rig = imref2d(size(im_rigid));
figure;
imshow(im_sim,Rcb_rig);
title("Rigid transformation");

% FOR THE PROJECTIVE TRANSFORM:
%--------------------------------------------------------------------------
%Recent versions' procedure
%--------------------------------------------------------------------------

% 1. Set up the parameters for the projective transform: angle theta, and two scalars a and b
% 2. Create the projective 2d object

theta = 50; %COMPLETE HERE THE THETA VALUE, IN DEGREES;
tform_proj = projective2d([cosd(theta) -sind(theta) 0.001; sind(theta) cosd(theta) 0.002; 0 0 1]);

% tform_proj= projective2d([%COMPLETE HERE THE FIRST ROW OF THE MATRIX TRANSFORM; %COMPLETE HERE THE SECOND ROW OF THE MATRIX TRANSFORM; %COMPLETE HERE THE THIRD ROW OF THE MATRIX TRANSFORM]);

%% B) Apply YOUR TRANSFORM
[im_proj,Rtr] = imwarp(im_ref,tform_proj);
Rcb_rig = imref2d(size(im_proj));

% Show your results, with the appropriate reference frame
figure;
subplot(1,2,1);
imshow(im_ref,Rcb_ref);title('Original image');
subplot(1,2,2);
imshow(im_proj,Rcb_rig);title('Transformed image, projection');

% See how the axis limits have changed, showing the effect of the transformation in both axis
%Alternatively, you can show the images with the same reference frame,
%using the 'OutputView' parameter in the call to the imwarp function

[im_proj,Rtr] = imwarp(im_ref,tform_proj,'OutputView',Rcb_ref);
% 
figure;
subplot(1,2,1);
imshow(im_ref,Rcb_ref);title('Original image');
subplot(1,2,2);
imshow(im_proj,Rcb_ref);title('Transformed image, Affine transform');
% 
