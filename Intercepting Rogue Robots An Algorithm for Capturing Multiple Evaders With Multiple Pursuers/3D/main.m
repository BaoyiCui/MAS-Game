clear;
clc;
close all;

timestep = 0.1; % 仿真时间步长
timeend = 200;
ubound = [10, 10, 10];
lbound = [-10, -10, -10];

n_p = 4; % number of pursuers
n_e = 2; % number of evaders

pursuers = cell(1, n_p);
evaders = cell(1, n_e);

% initialize the pursuers
for i=1:n_p
    pos = rand(1,3) .* (ubound - lbound) + lbound;
    pursuers{i} = Pursuer(pos);
end

% initialize the evaders
for i=1:n_e
    pos = rand(1,3) .* (ubound - lbound) + lbound;
    evaders{i} = Evader(pos);
end

bound = Polyhedron('ub', ubound, 'lb', lbound);   % 边界

figure(1)
% TODO: 主循环
pos_pursuers = zeros(n_p, 3);
for t=0:timestep:timeend
    n_e_alive = 0;
    evaders_alive_index = [];
    pos_evaders = [];
    % 1. calculate Voronoi tesselation with all agents
    for i = 1:length(evaders)
        if evaders{i}.isDead
            continue;
        else
            n_e_alive = n_e_alive + 1;
            evaders_alive_index = [evaders_alive_index, i];
            pos_evaders = [pos_evaders; evaders{i}.position];
        end
    end

    for i = 1:length(pursuers)
        pos_pursuers(i,:) = pursuers{i}.position;
    end

    if n_e_alive ==0
        break;
    end
    

    % get voronoi diagram by using function voronoi()
%     pos_all = [[pos_evaders; pos_pursuers], [zeros(n_e,1); ones(n_p, 1)]]; % 第三列为1为pursuer，否则为evader
    pos_all = [pos_evaders; pos_pursuers];
    [v,p] = mpt_voronoi(pos_all', 'bound', bound);  % 取出所有agents的位置用于计算voronoi图

    count = 1;
    for i = 1:length(p)
        if i <= n_e_alive
            evaders{evaders_alive_index(i)} = evaders{evaders_alive_index(i)}.setVoronoiCell(p(i));
        else
            pursuers{i-n_e_alive} = pursuers{i-n_e_alive}.setVoronoiCell(p(i));
        end
    end

    adjacencyMatrix = getVoronoiAdjacency(p);
    
    for i = 1:length(pursuers)
        % find the nearest evader
        dists = pdist2(pursuers{i}.position, pos_evaders);
        [~, nearestEvaderIdx] = min(dists);
        
        % 2. determine nearest evader from Voronoi neighbors
        for j = 1:n_e_alive
            
        end

        pursuers{i}.target = evaders{evaders_alive_index(nearestEvaderIdx)};
        if adjacencyMatrix(i + n_e_alive, nearestEvaderIdx)
            pursuers{i}.targetIsAdjacent = true;
        else
            pursuers{i}.targetIsAdjacent = false;
        end
        
        % 更新pursuers{i}的速度
        pursuers{i} = pursuers{i}.calculateVelocity();
        
    end

    % 5. calculate u_e^\kappa
    for i = 1:length(evaders)
        evaders{i} = evaders{i}.calculateVelocity();
    end

    % 6. move the robots
    for i = 1:length(evaders)
        evaders{i} = evaders{i}.move(timestep);
    end
    for i = 1:length(pursuers)
        pursuers{i} = pursuers{i}.move(timestep);
    end

    % check if evader is dead
    for i = 1:length(evaders)
        if evaders{i}.isDead
            continue;
        else
            evaders{i} = evaders{i}.checkIfAlive(pursuers);
        end
    end

    disp(t);

    % 绘图
    clf;
    hold on
    plot(p, "wire", true);
    for i = 1:length(p)
        if i<= n_e_alive
            f1 = plot(p(i), "color", 'b', "wire", true);
            alpha(f1, 0.2);
        else
            figure2 = plot(p(i), "wire", false);
            alpha(figure2, 0);
        end
    end
    scatter3(pos_evaders(:,1), pos_evaders(:,2), pos_evaders(:,3), 'd', 'filled', "Color", 'r');
    scatter3(pos_pursuers(:,1), pos_pursuers(:,2), pos_pursuers(:,3), 'O', 'filled', "Color", "k");
    title(t);
    hold off;
    drawnow;
end
