function [img, gauss, threshed, masked_lanes, left_masked, right_masked] = pipeline(img)
    %% apply gauss filter
    gauss = imgaussfilt(img);
    %% threshold image
    threshed = threshold(gauss);
    %% mask image
    % region of interest points
    x_points = [740, 600, 180, 1200];
    y_points = [444, 444, 720, 720];
    % left side of image roi
    x1_points = [180, 510, 600, 510];
    y1_points = [720, 720, 444, 444];
    % right side of image roi
    x2_points = [650, 720, 1200, 590];
    y2_points = [444, 444, 720, 720];
    % get m, and n for poly2mask
    dimens = size(threshed);
    m = dimens(1);
    n = dimens(2);
    %% create binary mask array
    mask = poly2mask(x_points, y_points, m, n);
    left_mask = poly2mask(x1_points, y1_points, m, n);
    right_mask = poly2mask(x2_points, y2_points, m, n);
    
    %% create new image with only inside mask
    masked_lanes = and(mask, threshed);
    % left lane
    left_masked = and(left_mask, threshed);
    % right lane
    right_masked = and(right_mask, threshed);
end