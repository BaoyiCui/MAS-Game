clear;
clc;
close all;

% 创建边界多面体，限制x, y, z在-10到10之间
B = Polyhedron('lb', [-10; -10; -10], 'ub', [10; 10; 10]);

% 创建随机三维点集
S = 20 * rand(3, 10) - 10;

% 计算带有边界的三维Voronoi图
[V, P] = mpt_voronoi(S, 'bound', B);

% 绘制Voronoi图
figure;
for i = 1:numel(P)
    plot(P(i)); % 在同一个图形窗口中绘制每个多面体
    alpha(0.1);
    hold on;
end

% 添加其他图形选项
title('有界的三维Voronoi图');
xlabel('X');
ylabel('Y');
zlabel('Z');
grid on;
axis equal; % 使轴尺度相等
axis([-10, 10, -10, 10, -10, 10]); % 设置轴范围
hold off;

