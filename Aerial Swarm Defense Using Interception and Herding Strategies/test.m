% Given values for circle and line
% circle_center = [0, 0];
circle_center = [-3990.48038466324
-2515.27887744041]';
radius = 3.213951616591904e+03;
line_point1 = [0,0];
line_point2 = [-2.044400468137731e+03;-1.214149932670039e+03]';

% Calculate intersection points
intersect_points = CircleLineIntersection(circle_center, radius, line_point1, line_point2);

% Start figure to plot
figure;

% Plot circle
viscircles(circle_center, radius, 'Color', 'b');

% Hold on to plot additional graphics on top
hold on;

% Plot line segment
line([line_point1(1), line_point2(1)], [line_point1(2), line_point2(2)], 'Color', 'r');

% Plot the intersection points if they exist
if ~isempty(intersect_points)
    plot(intersect_points(:, 1), intersect_points(:, 2), 'ko', 'MarkerFaceColor', 'g');
end

% Set the axes limits
xlim([min([line_point1(1), line_point2(1)])-radius, max([line_point1(1), line_point2(1)])+radius]);
ylim([min([line_point1(2), line_point2(2)])-radius, max([line_point1(2), line_point2(2)])+radius]);

% Add grid for better readability
grid on;

% Keep the axis equal to avoid distortion
axis equal;

% Add title and labels
title('Circle-Line Intersection');
xlabel('x-axis');
ylabel('y-axis');

% Release the hold on the current figure
hold off;


function points = CircleLineIntersection(circle_center, radius, line_point1, line_point2)
    % Extract circle information
    h = circle_center(1);
    k = circle_center(2);
    r = radius;

    % Extract line information
    x1 = line_point1(1);
    y1 = line_point1(2);
    x2 = line_point2(1);
    y2 = line_point2(2);

    % Line's slope (m) and y-intercept (b) calculation
    if x2 ~= x1
        m = (y2 - y1) / (x2 - x1);
        b = y1 - m * x1;

        % Quadratic equation coefficients
        A = 1 + m ^ 2;
        B = 2 * (m * b - m * k - h);
        C = h ^ 2 + k ^ 2 + b ^ 2 - 2 * b * k - r ^ 2;

        % Solve quadratic equation for x
        discriminant = B ^ 2 - 4 * A * C;

        if discriminant >= 0
            sqrt_discriminant = sqrt(discriminant);
            x_intersect1 = (-B + sqrt_discriminant) / (2 * A);
            x_intersect2 = (-B - sqrt_discriminant) / (2 * A);

            % Calculate corresponding y values
            y_intersect1 = m * x_intersect1 + b;
            y_intersect2 = m * x_intersect2 + b;
        else
            points = []; % No intersection, return empty array
            return;
        end

    else
        % If the line is vertical, use the circle equation directly
        x_intersect1 = x1; % or x2 (since x1 == x2 for a vertical line)
        x_intersect2 = x_intersect1;
        A = 1;
        B = -2 * k;
        C = k ^ 2 - r ^ 2 + (x1 - h) ^ 2;

        discriminant = B ^ 2 - 4 * A * C;

        if discriminant >= 0
            sqrt_discriminant = sqrt(discriminant);
            y_intersect1 = (-B + sqrt_discriminant) / (2 * A);
            y_intersect2 = (-B - sqrt_discriminant) / (2 * A);
        else
            points = []; % No intersection, return empty array
            return;
        end

    end

    % Check if intersection points are within the line segment
    points = [];

    if IsBetween(x1, y1, x2, y2, x_intersect1, y_intersect1)
        points = [points; x_intersect1, y_intersect1];
    end

    if IsBetween(x1, y1, x2, y2, x_intersect2, y_intersect2)
        points = [points; x_intersect2, y_intersect2];
    end

    %     points = points';

end

function isBetween = IsBetween(ax, ay, bx, by, cx, cy)
    % Check if point C is on line segment AB
    crossproduct = (cy - ay) * (bx - ax) - (cx - ax) * (by - ay);

    if abs(crossproduct) > 1 % (consider floating-point tolerance)
        isBetween = false;
        return;
    end

    % Check if the point is within the bounding rectangle
    isBetween = (cx <= max(ax, bx)) && (cx >= min(ax, bx)) && ...
        (cy <= max(ay, by)) && (cy >= min(ay, by));
end