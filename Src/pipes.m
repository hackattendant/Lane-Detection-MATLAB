% Finds lines and markups up video frames with information found.
function [X, lines_left, lines_right] = pipes(frame, old_left, old_right, first_pass)
    close all;
    %initialize distfrom cent 0
    dist_from_center = 0;
    % initialize xy1 and xy2 to be empty
    xy1 = []; xy2 = [];
    %% Threshold with custom function
    a = threshold(frame);
    %% Mask Image
    dimens = size(a);
    m = dimens(1);
    n = dimens(2);
%     x_points = [710, 600, 90, 1230];
    x_points = [680, 550, 90, 1230];
    y_points = [444, 444, 720, 720];
    rl_x = [710, 680, 680, 1200];
%     rl_y = [200, 200, 720, 720];
    rl_y = [200, 200, 650, 650];
    ll_x = [700, 680, 500, 200];
%     ll_y = [720, 300, 300, 720];
    ll_y = [650, 300, 300, 650];
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
    %% Extracct lines from Hough Peaks
    size_l = size(P_l);
    q_l = size_l(2);
    if q_l == 2
        lines_left = houghlines(masked_left, theta_l, rho_l, P_l, 'FillGap', 3000, 'MinLength', 250);
    end
    if q_l ~= 2
        lines_left = old_left
    end
    if isempty(lines_left) == true
        % if none found use old line
        lines_left = old_left;
    end
    figure('Name','Hough Lines found in image', 'visible', 'off'), imshow(frame), hold on;
    if isempty(lines_left) == false
        xy1 = [lines_left(1).point1; lines_left(1).point2];
        if first_pass == false && isempty(old_left) == false
            if isempty(old_left) == false
                % if no zeros (we don't want to zero out an average)
                if (any(lines_left(1).point1) == 1 && any(lines_left(1).point2) == 1 && any(old_left(1).point1) && any(old_left(1).point2) == 1)
                    % average point values to add smoothing effect
                    a = (1/10);
                    b = (9/10);
                    xy1 = [a .* lines_left(1).point1 + b .* old_left(1).point1; a .* lines_left(1).point2 + b .* old_left(1).point2];
                end
            end
        end
        plot(xy1(:,1), xy1(:,2), 'LineWidth', 2, 'Color', 'green');
        plot(xy1(1,1), xy1(1,2), 'x', 'LineWidth', 2, 'Color', 'red');
        plot(xy1(2,1), xy1(2,2), 'x', 'LineWidth', 2, 'Color', 'red');
    end
    size_r = size(P_r);
    q_r = size_r(2);
    if q_r == 2
        lines_right = houghlines(masked_right, theta_r, rho_r, P_r, 'FillGap', 3000, 'MinLength', 250);
    end
    if q_r ~= 2
        lines_right = old_right
    end
    if isempty(lines_right) == true
        lines_right = old_right;
    end
    if isempty(lines_right) == false
        xy2 = [lines_right(1).point1; lines_right(1).point2];
        if first_pass == false && isempty(old_right) == false
            % if no zeros (we don't want to zero out an average)
            if (any(lines_right(1).point1) == 1 && any(lines_right(1).point2) == 1 && any(old_right(1).point1) && any(old_right(1).point2) == 1)
                % average point values to add smoothing effect
                a = (1/10);
                b = (9/10);
                xy2 = [a .* lines_right(1).point1 + b .* old_right(1).point1; a .* lines_right(1).point2 + b .* old_right(1).point2];
            end
        end
        plot(xy2(:,1), xy2(:,2), 'LineWidth', 2, 'Color', 'red');
        plot(xy2(1,1), xy2(1,2), 'x', 'LineWidth', 2, 'Color', 'green');
        plot(xy2(2,1), xy2(2,2), 'x', 'LineWidth', 2, 'Color', 'green');        
    end
    %% draw polygon and calculate estimated diff from center
    if isempty(lines_right) == false && isempty(lines_left) == 0
        x = []; x = [x; xy1(:,1)]; x = [x; xy2(:,1)];
        y = []; y = [y; xy1(:,2)]; y = [y; xy2(:,2)];
        % draw polygon
        patch(x, y, 'g', 'FaceAlpha', .3);
        % calculate pixels from center
        mid = 640;
        pix_from_center = (lines_left(1).point1(1) + lines_right(1).point2(1))/2 - mid;
        dist_from_center = pix_from_center*3.7/700;
        
    end
    hold off;
    %% Set previous points for next iteration
    % set xy1 and xy2 as old points
    if isempty(xy1) == false
        lines_left(1).point1 = xy1(1,:);
        lines_left(1).point2 = xy1(2,:);
    end
    if isempty(xy2) == false
        lines_right(1).point1 = xy2(1,:);
        lines_right(1).point2 = xy2(2,:);
    end
    %% Conver frame to image
    F = getframe(gcf);
    [X, ~] = frame2im(F);  % X is image object we will use to write to video
    
    %% Add estimated offset as an overlay
    label_string = join(['Estimated Distance from Center of Lane: ', num2str(dist_from_center), ' Meters']);
    X = insertText(X, [100 50], label_string, 'AnchorPoint', 'LeftBottom');
end