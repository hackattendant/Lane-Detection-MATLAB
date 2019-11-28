clear;
clc;
% v = VideoReader('challenge_video.mp4');
v = VideoReader('Data/short_clip.mp4');
outvid = VideoWriter('Data/Output/output.mp4', 'MPEG-4');
open(outvid);
label = 0;
while hasFrame(v)
% while (label == 0)
    % increment label
    label = label + 1;
    
    % read in image
%     img = imread('test_images/straight_lines2.jpg');
    img = readFrame(v);
    [img, gauss, threshed, masked_anes, left_masked, right_masked] = pipeline(img);


    %----------Applying Hough Transform to White and Yellow Frames---------
    [H_Y,theta_Y,rho_Y] = hough(left_masked);

    [H_W,theta_W,rho_W] = hough(right_masked);

    %--------Extracting Hough Peaks from Hough Transform of frames---------
    P_Y = houghpeaks(H_Y,2,'threshold',2);
    P_W = houghpeaks(H_W,2,'threshold',2);
    %----------Plotting Hough Transform and detecting Hough Peaks----------
    % figure('Name','Hough Peaks for White Line')
    % imshow(imadjust(rescale(H_W)),[],'XData',theta_W,'YData',rho_W,'InitialMagnification', 'fit');
    % xlabel('\theta (degrees)')
    % ylabel('\rho')
    % axis on
    % axis normal
    % hold on
    % colormap(gca,hot)
    % x = theta_W(P_W(:,2));
    % y = rho_W(P_W(:,1));
    % plot(x,y,'s','color','blue');
    % hold off
    % % figure('Name','Hough Peaks for Yellow Line')
    % % imshow(imadjust(rescale(H_Y)),[],'XData',theta_Y,'YData',rho_Y,'InitialMagnification', 'fit');
    % xlabel('\theta (degrees)')
    % ylabel('\rho')
    % axis on
    % axis normal
    % hold on
    % colormap(gca,hot)
    % x = theta_W(P_Y(:,2));
    % y = rho_W(P_Y(:,1));
    % plot(x,y,'s','color','blue');
    % hold off
    %--------------Extracting Lines from Detected Hough Peaks--------------
    lines_Y = houghlines(left_masked,theta_Y,rho_Y,P_Y,'FillGap',3000,'MinLength',20);
    figure('Name','Hough Lines found in image', 'visible', 'off'), imshow(img), hold on;
    if isempty(lines_Y) == false
        for k = 1:1
           xy = [lines_Y(k).point1; lines_Y(k).point2];
           plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
           % Plot beginnings and ends of lines
           plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
           plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
        end
    end

    lines_W = houghlines(right_masked,theta_W,rho_W,P_W,'FillGap',3000,'MinLength',20);
    max_len = 0;
    if isempty(lines_W) == false
        for k = 1:1
           xy = [lines_W(k).point1; lines_W(k).point2];
           plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','red');
           % Plot beginnings and ends of lines
           plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','blue');
           plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
        end
    end
    hold off;
%     name = 'challenge_images/img' + string(label) + '.png';
%     name = 'Data/Output/img' + string(label) + '.png';
%     ethan = gcf;
%     saveas(gcf,name);
    % convert figure to image
    F = getframe(gcf);
    [X, Map] = frame2im(F);
    % write to new video file
    writeVideo(outvid, X);
end
% close outvid
close(outvid);
function [img, gauss, threshed, masked_lanes, left_masked, right_masked] = pipeline(img)
    % apply gauss filter
    gauss = imgaussfilt(img);
    % threshold image
    threshed = threshold(gauss);
    % mask image
    % region of interest points
    x_points = [740, 600, 180, 1200];
    y_points = [444, 444, 720, 720];
    % left side of image roi
    x1_points = [180, 510, 600, 510];
    y1_points = [720, 720, 444, 444];
    % right side of image roi
    x2_points = [590, 850, 1250, 590];
    y2_points = [444, 444, 720, 720];
    % get m, and n for poly2mask
    dimens = size(threshed);
    m = dimens(1);
    n = dimens(2);
    % create binary mask array
    mask = poly2mask(x_points, y_points, m, n);
    left_mask = poly2mask(x1_points, y1_points, m, n);
    right_mask = poly2mask(x2_points, y2_points, m, n);
    
    % create new image with only inside mask
    masked_lanes = and(mask, threshed);
    % left lane
    left_masked = and(left_mask, threshed);
    % right lane
    right_masked = and(right_mask, threshed);

    
    
%     figure()
%     imshow(img);
%     figure()
%     imshow(threshed);
%     figure();
%     imshow(masked_lanes);
%     figure()
%     imshow(left_masked);
%     figure()
%     imshow(right_masked);

  

    
%     done_img = masked;
end
