clear;
clc;
close all;

%% 初始化仿真参数
l = 10;     % ATL长度
h = 15;     % 区域长度
ubound = [l, h];
lbound = [0, 0];

n_a = 1;    % 攻击者数量
n_d = 2;    % 防御者数量

alpha = 1;    % 攻击者速度与防御者速度的比值

attackers = cell(1, n_a);
defenders = cell(1, n_d);

% 初始化攻击者位置
for i = 1:n_a
    pos = rand(1,2) .* (ubound - lbound) + lbound;
    attackers{i} = Robot(pos);
end
% 初始化防御者位置
for i = 1:n_d
    pos = rand(1,2) .* (ubound - lbound) + lbound;
    defenders{i} = Robot(pos);
end

bound = Polyhedron('ub', ubound, 'lb', lbound);   % 边界

figure(1)
plot(bound, "wire", true);
axis equal
grid on
hold on


%% 速度比值等于1
if alpha == 1   %如果速度比值等于一
    % 计算AR和BAR
    pos_all = [];
    for i = 1:n_a
        pos_all = [pos_all; attackers{i}.position];
    end
    for i = 1:n_d
        pos_all = [pos_all; defenders{i}.position];
    end
    [v,p] = mpt_voronoi(pos_all', 'bound', bound);
    AR = p(1);
    plot(AR);
    plot(bound - AR);


%% 速度比值小于一
elseif alpha < 1
    % 计算AR和BAR

else
    disp("alpha数值有误，alpha取值范围在区间(0, 1]");

end