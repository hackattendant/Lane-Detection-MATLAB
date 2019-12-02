% Thresholds the s_channel of the hsl image.
function thresholded_img = threshold(img)
    % convert image to HSL color space
    hsl = rgb2hsl(img);
    
    % grab s_channel
    s_channel = hsl(:, :, 2);
    
    %take derivative using sobel operator
    sobel = imgradient(s_channel, 'sobel');
    
    %threshold derivative image
    thresholded_img = imbinarize(sobel);
%     l_channel = hsl(:,:,3);
%     thresholded_img = imbinarize(l_channel);
end