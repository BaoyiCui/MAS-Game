function [Gamma, P, Theta] = timeOptimalTraj(startPoint, numPoints)
    % TIMEOPTIMALTRAJ 规划attacker cluster的时间最优轨迹
    % inputs:
    %   startPoint: 路径起点
    %   numPoints: 轨迹上的采样点数量
    % outputs:
    %   Gamma: 路径长度
    %   P: 轨迹的二维坐标
    %   Theta: 每个轨迹点的航向角，取值范围[0,2 * pi]闭区间
    target = [0; 0]; % 原点是目标点
    % waypoints = [startPoint, target];
    % 路径长度
    Gamma = pdist2(startPoint, target);
    % 直线段路径
    xi = linspace(startPoint(1), target(1), numPoints);
    yi = linspace(startPoint(2), target(2), numPoints);
    P = [xi(:), yi(:)]; % 插值结果
    % 每个Theta都是从startPoint到target连线与X轴正向的夹角
    dx = target(1) - startPoint(1);
    dy = target(2) - startPoint(2);
    Theta = atan2(dy, dx); % atan2的返回值在[-pi,pi]

    if Theta < 0
        Theta = Theta + 2 * pi; % 使 Theta 在 [0, 2*pi] 闭区间内
    end

    % 因为路径是直线，所以所有点的 Theta 值都相同
    Theta = repmat(Theta, 1, numPoints);
end
