close all;
clear;
clc;

%% initialize the parameters
ts = 1; % time step
t_end = 2000; % ending time
u_a_bound = 9; % attacker's control acceleration bound
u_d_bound = 18.4; % defender's control acceleration bound
drag_coef = 1.5; % const drag coeffecient
rho_p = 45; % radius of the protected area
rho_d_int = 5; % intercepting radius, if the distance between attacker and defender <= this value, then they are seen as damaged
rho_d = 2500; % defenders' percepting region
rho_d_game = 2000; % defenders' playing region
rho_a_game = 2300; % attacker's initial position region
radius_a = 0.5; % attacker's geometric radius
radius_d = 0.5; % defender's geometric radius
radius_c = 1.5; % clustered group's radius
R_sb = 10; % string barrier's maximum length
N_a = 10; % attackers' number
N_d = 20; % defenders' number
num_c = 3; % number of clusters
num_uc = 3; % number of unclustered attackers
v_a_avr = u_a_bound / drag_coef;
v_d_avr = u_d_bound / drag_coef;

%% initialize the agents
attackers = cell(1, N_a);
defenders = cell(1, N_d);

for i = 1:N_a
    attackers{i} = Attacker(zeros(2, 1), drag_coef, u_a_bound);
end

for i = 1:N_d
    defenders{i} = Defender(zeros(2, 1), drag_coef, u_d_bound);
end

% initialize the attackers
group_tags_c = randi([1, num_c], 1, N_a - num_uc); % clustered attackers的组标签
group_tags_uc = (num_c + 1):(num_c + num_uc); % unclustered attackers的组标签
% 最后几个attacker为unclustered attacker
% unclustered attacker的group tag为-1
group_tags = [group_tags_c, group_tags_uc];

% 生成每个clustered 和unclustered group的中心坐标
pos_group_init_a = randomPointsInRing(rho_a_game, rho_d, num_c + num_uc);

for i = 1:N_a
    group_tag = group_tags(i);

    if i <= N_a - num_uc
        c_center = pos_group_init_a(:, group_tag);
        attackers{i}.position = randomPointsInCircle(radius_c, 1) + c_center;
        attackers{i}.isClustered = true;
    else
        attackers{i}.position = pos_group_init_a(:, group_tag);
    end

    attackers{i}.control_bound = u_a_bound;
end

% initialize the defenders
pos_init_d = randomPointsInCircle(500, N_d);

for i = 1:N_d
    defenders{i}.position = pos_init_d(:, i);
    defenders{i}.control_bound = u_d_bound;
end

%% main loop
pos_a = zeros(2, N_a);
pos_d = zeros(2, N_d);
t = 0.0;
idx = DBSCAN(attackers, R_sb, N_a, N_d, 3);

for i = 1:N_a
    pos_a(:, i) = attackers{i}.position;
end

for i = 1:N_d
    pos_d(:, i) = defenders{i}.position;
end

f1 = figure;

while (t <= t_end)
    %% check if attacker is intercepted
    int_flag = checkIntercepted(attackers, defenders, rho_d_int);

    for i = 1:N_a

        if int_flag(i)
            attackers{i}.isIntercepted = true;
        end

    end

    idx = DBSCAN(attackers, R_sb, N_a, N_d, 3);
    drawResult(f1, pos_a, pos_d, rho_d_game, rho_d, rho_p, idx);

    if t == 0
        %% TODO: 1. use CADAA to assign defenders to intercept the unclustered attackers
        a_uc = attackers(idx==-1);  % 取出被DBSCAN判断为unclustered的攻击者
                
        [costMatCol, costMatTime, interceptPoints] = interceptingCost(a_uc, defenders);
        [solutionMat, fval] = CADAA(costMatCol, costMatTime, 0);

        %% TODO: Gathering Formations for the defenders
        % CoMs = zeros(2, num_c);
        Gammas = zeros(1, num_c);
        P_ac = cell(num_c);
        Theta_ac = cell(num_c);
    
        for i = 1:num_c
            a_c_i = attackers(group_tags == i);
            % CoMs(:, i) = getCoM(a_c_i);
            CoM = getCoM(a_c_i);
            [Gammas(i), P_ac{i}, Theta_ac{i}] = timeOptimalTraj(CoM, 100);
            hold on
            plot(P_ac{i}(:, 1), P_ac{i}(:, 2));
            hold off
        end
    
        Sigma = 0;
        % gamma
    end



    % TODO: Defender-to-Attacker-Swarm Assignment (DASA)

    % update attackers' position and defenders' position
    for i = 1:N_a
        u = ([0; 0] - attackers{i}.position) / norm([0; 0] - attackers{i}.position) * u_a_bound;
        attackers{i} = attackers{i}.updateControlInput(u);
        attackers{i} = attackers{i}.updateMotionState(ts);
        pos_a(:, i) = attackers{i}.position;
    end

    for i = 1:N_d
        pos_d(:, i) = defenders{i}.position;
    end

    % axis equal;
    t = t + ts;
end
