close all;
clear;
clc;

%% initialize the parameters
ts = 0.1; % time step
t_end = 200; % ending time
u_a_bound = 9; % attacker's control acceleration bound
u_d_bound = 1.5; % defender's control acceleration bound
drag_coef = 1.5; % const drag coeffecient
rho_p = 45; % radius of the protected area
rho_d_int = 5; % intercepting radius, if the distance between attacker and defender <= this value, then they are seen as damaged
rho_d = 2500; % defenders' percepting region
rho_d_game = 2000; % defenders' playing region
rho_a_game = 2700; % attacker's initial position region
radius_a = 0.5; % attacker's geometric radius
radius_d = 0.5; % defender's geometric radius
radius_c = 1.5; % clustered group's radius
R_sb = 10; % string barrier's maximum length
N_a = 20; % attackers' number
N_d = 20; % defenders' number
num_c = 3;  % number of clusters
num_uc = 3; % number of unclustered attackers

%% initialize the agents
attackers = cell(1, N_a);
defenders = cell(1, N_d);
% initialize the attackers
group_tags_c = randi([1, num_c], 1, N_a - num_uc); % clustered attackers的组标签
group_tags_uc = (num_c + 1):(num_c + num_uc); % unclustered attackers的组标签
% 最后几个attacker为unclustered attacker
% unclustered attacker的group tag为-1
group_tags = [group_tags_c, group_tags_uc];

% 生成每个clustered 和unclustered group的中心坐标
pos_group_init_a = randomPointsInRing(rho_d, rho_a_game, num_c + num_uc);

for i = 1:N_a
    group_tag = group_tags(i);

    if i <= N_a - num_uc
        c_center = pos_group_init_a(:, group_tag);
        attackers{i}.position = randomPointsInCircle(radius_c, 1) + c_center;
    else
        attackers{i}.position = pos_group_init_a(:, group_tag);
    end

end

% pos_init_a = randomPointsInRing(rho_d, rho_a_game, N_a);

% for i = 1:N_a
%     attackers{i}.position = pos_init_a(:, i);
% end

% initialize the defenders
pos_init_d = randomPointsInCircle(rho_d_game, N_d);

for i = 1:N_d
    defenders{i}.position = pos_init_d(:, i);
end

%% main loop
pos_a = zeros(2, N_a);
pos_d = zeros(2, N_d);

for i = 1:N_a
    pos_a(:, i) = attackers{i}.position;
end

for i = 1:N_d
    pos_d(:, i) = defenders{i}.position;
end

idx = DBSCAN(attackers, R_sb, N_a, N_d, 3);

%% plot
color_array = strings(N_a);
color_array(:) = 'r';
visrings([0; 0], rho_d_game, rho_d, 'b', 0.5);
hold on
% visrings(pos_a, zeros(N_a), radius_a * ones(N_a), color_array, zeros(N_a));
scatter(pos_a(1, :), pos_a(2, :), 'filled');
gscatter(pos_a(1, :)', pos_a(2, :)', idx);
