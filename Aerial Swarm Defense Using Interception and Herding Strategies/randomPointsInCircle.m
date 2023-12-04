function points = randomPointsInCircle(radius, numPoints)
    % RANDOMPOINTSINCIRCLE
    %   在圆内随机取点
    % radius: 圆半径
    % numPoints: 取点个数
    % 随机生成在[0, 2*pi]范围内的角度
    theta = 2 * pi * rand(1, numPoints);

    % 随机生成在[0, radius^2]范围内的半径的平方
    rSquared = radius^2 * rand(1, numPoints);

    % 计算半径。因为我们是在半径的平方上均匀分布，所以需要开平方根来得到半径
    r = sqrt(rSquared);

    % 将极坐标转换为笛卡尔坐标
    x = r .* cos(theta);
    y = r .* sin(theta);

    % 将x和y合并为一个2*numPoints的矩阵，每一列是一个点的坐标
    points = [x; y];
end
