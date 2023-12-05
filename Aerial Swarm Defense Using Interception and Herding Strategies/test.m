%% DBSCAN example
% clear;
% clc;
% close all;
% % 首先，生成一些随机数据
% rng default; % 用于可重复性
% n = 500;
% X = [randn(n, 2) * 1.0 + ones(n, 2); randn(n, 2) * 2.0 - ones(n, 2)] * 2;

% % 使用DBSCAN进行聚类
% eps = 0.5;
% MinPts = 3;
% idx = dbscan(X, eps, MinPts);

% % 可视化结果
% figure;
% gscatter(X(:, 1), X(:, 2), idx);
% title('DBSCAN Clustering');

%% 拦截点计算测试
% % 测试数据
% F1 = [1, 3];  % 第一个焦点
% F2 = [-2, -2];  % 第二个焦点
% k = 0.5;  % 距离比率

% % 计算圆心和半径
% [center, radius] = computeApolloniusCircle(F1, F2, k);

% % 绘制阿波罗尼斯圆
% theta = 0:0.01:2*pi;  % 角度从 0 到 2*pi
% x = center(1) + radius*cos(theta);
% y = center(2) + radius*sin(theta);

% % 绘制圆和焦点
% figure;
% plot(x, y, 'b-', 'LineWidth', 2);  % 绘制圆
% hold on;
% plot(F1(1), F1(2), 'g*');  % 第一个焦点
% plot(F2(1), F2(2), 'r*');  % 第二个焦点
% plot(center(1), center(2), 'bo');  % 圆心

% % 设定图形属性
% axis equal;
% grid on;
% xlabel('x');
% ylabel('y');
% title('Apollonius Circle');
% xlim([min(x)-1, max(x)+1]);  % 设置 x 轴的限制
% ylim([min(y)-1, max(y)+1]);  % 设置 y 轴的限制

% % 显示图例
% hold off;

% function [center, radius] = computeApolloniusCircle(pointA, pointB, k)
%     % 保证 k 不等于 1
%     if k == 1
%         error('k must not be equal to 1');
%     end
    
%     % 计算 A 和 B 之间的距离
%     d = norm(pointA - pointB);
    
%     % 计算中心点 C
%     center = (1/(1 - k)) * pointA - (k/(1 - k)) * pointB;
    
%     % 计算半径
%     if k < 1
%         radius = d / (1 - k^2);
%     else
%         radius = k * d / (k^2 - 1);
%     end
% end