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
title('Thresholded Image');
hold off;

figure();
imshow(img); hold on;
l = plot(740, 444, 'ro'); hold on; l.MarkerFaceColor = l.Color;
l = plot(600, 444, 'ro'); hold on; l.MarkerFaceColor = l.Color;
l = plot(1200, 720, 'bo'); hold on; l.MarkerFaceColor = l.Color;
l = plot(180, 720, 'bo'); hold on; l.MarkerFaceColor = l.Color;
title('points for perspective transform and masking');
