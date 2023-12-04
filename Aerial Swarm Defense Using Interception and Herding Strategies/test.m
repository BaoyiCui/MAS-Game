clear;
clc;
close all;
% 首先，生成一些随机数据
rng default;  % 用于可重复性
n = 500;
X = [randn(n,2)*1.0+ones(n,2); randn(n,2)*2.0-ones(n,2)]* 2;

% 使用DBSCAN进行聚类
eps = 0.5;
MinPts = 3;
idx = dbscan(X,eps,MinPts);

% 可视化结果
figure;
gscatter(X(:,1),X(:,2),idx);
title('DBSCAN Clustering');