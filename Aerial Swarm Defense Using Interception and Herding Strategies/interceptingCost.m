function [costMatCol, costMatTime, interceptPoints] = interceptingCost(attackers, defenders)
    N_a = length(attackers);
    N_d = length(defenders);

    costMatCol = zeros(N_d, N_d);
    costMatTime = zeros(N_a, N_d);
    v_d_avr = defenders{1}.vel_max; % 以agent的最大速度近似平均速度，因为attacker的时间最优轨迹一定不考虑避障，必然是加速到最大速度然后匀速
    v_a_avr = attackers{1}.vel_max; % 但是defender可能会考虑避障，因此此处只是近似
    interceptPoints = cell(N_a, N_d);

    for j = 1:N_a

        for i = 1:N_d
            % 近似计算拦截点
            % 近似拦截点位于以初始attacker位置和defender位置为定点的阿波罗尼斯圆上
            [center, radius] = computeApolloniusCircle(attackers{j}.position, defenders{i}.position, v_a_avr / v_d_avr);
            interceptPoint = CircleLineIntersection(center', radius, attackers{j}.position', [0, 0]);
            % hold on
            % viscircles(center', radius);
            % plot([attackers{j}.position(1), 0], [attackers{j}.position(2), 0], "LineWidth", 3);

            if isempty(interceptPoint)
                costMatTime(j, i) = 100000; % 如果没有交点说明无法在attacker到达protected area前进行拦截，设置足够大的代价
            else
                costMatTime(j, i) = norm(interceptPoint' - defenders{i}.position) / v_d_avr; % 有交点则用预估时间作为代价
            end

            interceptPoints{j, i} = interceptPoint';

        end

    end

end

%% 计算阿波罗尼斯圆
function [center, radius] = computeApolloniusCircle(pointA, pointB, k)
    % 保证 k 不等于 1
    if k == 1
        error('k must not be equal to 1');
    end

    % 计算 A 和 B 之间的距离
    d = norm(pointA - pointB);

    % 计算中心点 C
    center = (1 / (1 - k)) * pointA - (k / (1 - k)) * pointB;

    % 计算半径
    if k < 1
        radius = d / (1 - k ^ 2);
    else
        radius = k * d / (k ^ 2 - 1);
    end

end

%% 计算圆与直线段的交点
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
        x_intersect2 = x1;
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

    if abs(crossproduct) > 1.0 % (consider floating-point tolerance)
        isBetween = false;
        return;
    end

    % Check if the point is within the bounding rectangle
    isBetween = (cx <= max(ax, bx)) && (cx >= min(ax, bx)) && ...
        (cy <= max(ay, by)) && (cy >= min(ay, by));
end
