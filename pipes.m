function [X, lines_left, lines_right] = pipes(frame, old_left, old_right, first_pass)
    close all;
    
    
    %initialize distfrom cent 0
    dist_from_center = 0;
    
    %% Convert from RGB to HSV
%     hsv = rgb2hsv(frame);
%     v_channel = hsv(:, :, 3);
%     %% Threshold Image
%     sobel = imgradient(v_channel, 'sobel');
%     a = imbinarize(sobel);
    %% Threshold with custom function
    a = threshold(frame);
    %% Mask Image
    dimens = size(a);
    m = dimens(1);
    n = dimens(2);
    x_points = [710, 600, 90, 1230];
    y_points = [444, 444, 720, 720];
    rl_x = [710, 680, 680, 1200];
%     rl_y = [200, 200, 650, 650];
    rl_y = [200, 200, 720, 720];
    ll_x = [700, 680, 500, 200];
%     ll_y = [650, 300, 300, 650];
    ll_y = [720, 300, 300, 720];
    mask = poly2mask(x_points, y_points, m, n);
    rl_mask = poly2mask(rl_x, rl_y, m, n);
    ln_mask = poly2mask(ll_x, ll_y, m, n);
    masked = and(a, mask);
    masked_left = and(masked, ln_mask);
    masked_right = and(masked, rl_mask);
    %% Hough Points
    [H_l, theta_l, rho_l] = hough(masked_left);
    P_l = houghpeaks(H_l, 2, 'threshold', 2);
    [H_r, theta_r, rho_r] = hough(masked_right);
    P_r = houghpeaks(H_r, 2, 'threshold', 2);
    %% Plot hough transforms
%     if show_hough == true
%         figure('Name', 'Hough Peaks for Left Line');
%         imshow(imadjust(rescale(H_l)), [], 'XData', theta_l, 'YData', rho_l, 'InitialMagnification', 'fit');
%         xlabel('\theta (degrees)');
%         ylabel('\rho');
%         axis on;
%         axis normal;
%         hold on;
%         colormap(gca,hot);
%         x = theta_l(P_l(:, 2));
%         y = rho_l(P_l(:, 1));
%         plot(x, y, 's', 'color', 'blue');
%         title('Hough Peaks for Left Line');
%         hold off;
% 
%         figure('Name', 'Hough Peaks for Right Line');
%         imshow(imadjust(rescale(H_r)), [], 'XData', theta_r, 'YData', rho_r, 'InitialMagnification', 'fit');
%         xlabel('\theta (degrees)');
%         ylabel('\rho');
%         axis on;
%         axis normal;
%         hold on;
%         colormap(gca, hot);
%         x = theta_r(P_r(:, 2));
%         y = rho_r(P_r(:, 1));
%         plot(x, y, 's', 'color', 'blue');
%         title('Hough Peaks for Right Line');
%         hold off;
%     end
%% Extracct lines from Hough Peaks
    xy1 = []; xy2 = [];
    lines_left = houghlines(masked_left, theta_l, rho_l, P_l, 'FillGap', 3000, 'MinLength', 250);
    if isempty(lines_left) == true
        % if none found use old line
        lines_left = old_left;
    end
    figure('Name','Hough Lines found in image', 'visible', 'off'), imshow(frame), hold on;
    if isempty(lines_left) == false
        xy1 = [lines_left(1).point1; lines_left(1).point2];
        if first_pass == false && isempty(old_left) == false
            if isempty(old_left) == false
                if (any(lines_left(1).point1) == 1 && any(lines_left(1).point2) == 1 && any(old_left(1).point1) && any(old_left(1).point2) == 1)
                    % if non zero average
                    a = (1/15);
                    b = (14/15);
                    xy1 = [a .* lines_left(1).point1 + b .* old_left(1).point1; a .* lines_left(1).point2 + b .* old_left(1).point2];
                end
            end
        end
        plot(xy1(:,1), xy1(:,2), 'LineWidth', 2, 'Color', 'green');
        plot(xy1(1,1), xy1(1,2), 'x', 'LineWidth', 2, 'Color', 'red');
        plot(xy1(2,1), xy1(2,2), 'x', 'LineWidth', 2, 'Color', 'red');
    end
    lines_right = houghlines(masked_right, theta_r, rho_r, P_r, 'FillGap', 3000, 'MinLength', 250);
    if isempty(lines_right) == true
        lines_right = old_right;
    end
    if isempty(lines_right) == false
        xy2 = [lines_right(1).point1; lines_right(1).point2];
        if first_pass == false && isempty(old_right) == false
            if (any(lines_right(1).point1) == 1 && any(lines_right(1).point2) == 1 && any(old_right(1).point1) && any(old_right(1).point2) == 1)
%             xy2 = [(lines_right(1).point1 + (3*old_right(1).point1))/4; (lines_right(1).point2 + (3*old_right(1).point2))/4];
            % average if non zero
                a = (1/15);
                b = (14/15);
                xy2 = [a .* lines_right(1).point1 + b .* old_right(1).point1; a .* lines_right(1).point2 + b .* old_right(1).point2];
            end
        end
        plot(xy2(:,1), xy2(:,2), 'LineWidth', 2, 'Color', 'red');
        plot(xy2(1,1), xy2(1,2), 'x', 'LineWidth', 2, 'Color', 'green');
        plot(xy2(2,1), xy2(2,2), 'x', 'LineWidth', 2, 'Color', 'green');        
    end
    %% draw polygon
    if isempty(lines_right) == false && isempty(lines_left) == 0
        x = []; x = [x; xy1(:,1)]; x = [x; xy2(:,1)];
        y = []; y = [y; xy1(:,2)]; y = [y; xy2(:,2)];
        patch(x, y, 'g', 'FaceAlpha', .3);
        
        
        % calculate pixels from center
        mid = 640;
        pix_from_center = (lines_left(1).point1(1) + lines_right(1).point2(1))/2 - mid;
        dist_from_center = pix_from_center*3.7/700;
        
    end
    hold off;
    

    % set xy1 and xy2 as old points
    if isempty(xy1) == false
        lines_left(1).point1 = xy1(1,:);
        lines_left(1).point2 = xy1(2,:);
    end
    if isempty(xy2) == false
        lines_right(1).point1 = xy2(1,:);
        lines_right(1).point2 = xy2(2,:);
    end

    
    %% Convert and return
    F = getframe(gcf);
    [X, ~] = frame2im(F);
    
    
    % add label
    correction = ' Centered';
    if dist_from_center > 0.3
        correction = ' Drifting Left';
    end
    if dist_from_center < -0.3
        correction = ' Drifting Right';
    end
    label_string = join(['Estimated Distance from Center of Lane: ', num2str(dist_from_center), ' Meters']);
    X = insertText(X, [100 50], label_string, 'AnchorPoint', 'LeftBottom');
%     X = insertText(X, [100 80], (join(['Status: ', correction])), 'AnchorPoint', 'LeftBottom');
    
    
end