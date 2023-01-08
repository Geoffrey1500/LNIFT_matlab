% Demo code of the LNIFT algorithm. If it is helpful for you, please cite:
% Li, Jiayuan, et al. "LNIFT: Locally Normalized Image for Rotation Invariant Multimodal Feature Matching." IEEE Transactions on Geoscience and Remote Sensing 60 (2022): 1-14.
% Note that the results of this Matlab code is not the same as the C++ code and the running time is much slower.
% MATLAB2021a or higher is required for ORB detection.

clc;clear; warning('off'); close all;

addpath LNIFT\
str1='data\pair1_1.png';   % image pair
str2='data\pair1_2.png';   % image pair
patch_size=128;

im1 = im2uint8(imread(str1));
im2 = im2uint8(imread(str2));

if size(im1,3)==3
    im1 = rgb2gray(im1);
end
if size(im2,3)==3
    im2 = rgb2gray(im2);
end

% Keypoint detection. Please set the 'FastThreshold' of detectORBFeatures
% function from 31 to 1 to get more features.
kpts1 = detector(im1,5000,1);
kpts2 = detector(im2,5000,1);

% Keypoint description.
des1 = descriptor(im1,kpts1,patch_size,8,4);
des2 = descriptor(im2,kpts2,patch_size,8,4);

% Keypoint matching.
indexPairs = matchFeatures(des1',des2','MaxRatio',1,'MatchThreshold', 100);
kpts1 = kpts1'; kpts2 = kpts2';
matchedPoints1 = kpts1(indexPairs(:, 1), 1:2);
matchedPoints2 = kpts2(indexPairs(:, 2), 1:2);
%     [matchedPoints2,IA]=unique(matchedPoints2,'rows');
%     matchedPoints1=matchedPoints1(IA,:);

% Outlier removal
H=FSC(matchedPoints1,matchedPoints2,'similarity',3);
Y_=H*[matchedPoints1';ones(1,size(matchedPoints1,1))];
Y_(1,:)=Y_(1,:)./Y_(3,:);
Y_(2,:)=Y_(2,:)./Y_(3,:);
E=sqrt(sum((Y_(1:2,:)-matchedPoints2').^2));
inliersIndex=E<3;
cleanedPoints1 = matchedPoints1(inliersIndex, :);
cleanedPoints2 = matchedPoints2(inliersIndex, :);
[cleanedPoints2,IA] = unique(cleanedPoints2,'rows');
cleanedPoints1 = cleanedPoints1(IA,:);

% show results
figure; showMatchedFeatures(im1, im2, cleanedPoints1, cleanedPoints2, 'montage');
image_fusion(im2,im1,double(H))







