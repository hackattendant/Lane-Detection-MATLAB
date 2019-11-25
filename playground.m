% read in image
img = imread('test_images/test1.jpg');
% display
figure();
imshow(img);
title('Original Image');
hold off;

% threshold image
threshed = threshold(img);
figure();
imshow(threshed);
title('Threshold Image');
hold off;

% mask image
% region of interest points
x_points = [740, 600, 180, 1200];
y_points = [444, 444, 720, 720];

% get m, and n for poly2mask
dimens = size(threshed);
m = dimens(1);
n = dimens(2);

% create binary mask array
mask = poly2mask(x_points, y_points, m, n);
% display
figure()
imshow(mask);
title('Binary Mask for ROI');
hold off;

% Create new image where only pixels are inside of mask
masked =and(mask, threshed);
%display
figure()
imshow(masked);
title('Masked Image');
hold off;


