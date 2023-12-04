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
radius_d = 0.5; % defender's
R_sb = 10; % string barrier's maximum length
N_a = 20; % attackers' number
N_d = 20; % defenders' number

%% initialize the agents
attackers = cell(1, N_a);
defenders = cell(1, N_d);
% initialize the attackers
pos_init_a = randomPointsInRing(rho_d, rho_a_game, N_a);

for i = 1:N_a
    attackers{i}.position = pos_init_a(:, i);
end

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
