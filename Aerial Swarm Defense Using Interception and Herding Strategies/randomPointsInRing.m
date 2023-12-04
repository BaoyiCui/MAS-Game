function points = randomPointsInRing(innerRadius, outerRadius, numPoints)
    % RANDOMPOINTSINRING
    %   在圆环内随机取点
    % innerRadius: 圆环内半径
    % outerRadius: 圆环外半径
    % numPoints: 取点个数
    % 随机生成在[0, 2*pi]范围内的角度
    theta = 2 * pi * rand(1, numPoints);

    % 随机生成在[innerRadius^2, outerRadius^2]范围内的半径的平方
    rSquared = innerRadius^2 + (outerRadius^2 - innerRadius^2) * rand(1, numPoints);

    % 计算半径。因为我们是在半径的平方上均匀分布，所以需要开平方根来得到半径
    r = sqrt(rSquared);

    % 将极坐标转换为笛卡尔坐标
    x = r .* cos(theta);
    y = r .* sin(theta);

    % 将x和y合并为一个2*numPoints的矩阵，每一列是一个点的坐标
    points = [x; y];
end
