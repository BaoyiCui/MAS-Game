clear;
clc;
close all;

timestep = 0.01; % 仿真时间步长
timeend = 10;
xbound = [-10,10];
ybound = [-10,10];
bbox = [xbound(1), ybound(1);xbound(2), ybound(1);xbound(2), ybound(2);xbound(1), ybound(2)];

xlim(xbound);
ylim(ybound);


n_p = 4; % number of pursuers
n_e = 8; % number of evaders

pursuers = cell(1, n_p);
evaders = cell(1, n_e);

% initialize the pursuers
for i=1:n_p
    pos = rand(1,2);
    pos(1,1) = pos(1,1) * (xbound(2) - xbound(1)) + xbound(1);
    pos(1,2) = pos(1,2) * (ybound(2) - ybound(1)) + ybound(1);
    pursuers{i} = Pursuer(pos);
end

% initialize the evaders
for i=1:n_e
    pos = rand(1,2);
    pos(1,1) = pos(1,1) * (xbound(2) - xbound(1)) + xbound(1);
    pos(1,2) = pos(1,2) * (ybound(2) - ybound(1)) + ybound(1);
    evaders{i} = Evader(pos);
end


pos_evaders = zeros(n_e,2);
pos_pursuers = zeros(n_p,2);
bound = Polyhedron(bbox);   % 边界

figure(1)
scatter1 = scatter(pos_evaders(:,1), pos_evaders(:,2), 'd', 'filled', "Color", 'r');
scatter2 = scatter(pos_pursuers(:,1), pos_pursuers(:,2), 'O', 'filled', "Color", "k");

% TODO: 主循环
for t=0:timestep:timeend
    % 1. calculate Voronoi tesselation with all agents
    for i = 1:length(evaders)
        pos_evaders(i,:) = evaders{i}.position;
    end

    for i = 1:length(pursuers)
        pos_pursuers(i,:) = pursuers{i}.position;
    end
    % get voronoi diagram by using function voronoi()
    pos_all = [[pos_evaders; pos_pursuers], [zeros(n_e,1); ones(n_p, 1)]]; % 第三列为1为pursuer，否则为evader
    [v,p] = mpt_voronoi(pos_all(:, 1:2)', 'bound', bound);  % 取出所有agents的位置用于计算voronoi图

    for i = 1:length(p)
        if i <= n_e
            evaders{i} = evaders{i}.setVoronoiCell(p(i));
        else
            pursuers{i-n_e} = pursuers{i-n_e}.setVoronoiCell(p(i));
        end
    end

    adjacencyMatrix = getVoronoiAdjacency(p);
    
    for i = 1:length(pursuers)
        % find the nearest evader
        dists = pdist2(pursuers{i}.position, pos_evaders);
        [~, nearestEvaderIdx] = min(dists);
        
        % 2. determine nearest evader from Voronoi neighbors
        pursuers{i}.target = evaders{nearestEvaderIdx};
        if adjacencyMatrix(i + n_e, nearestEvaderIdx)
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

    disp(t);

    % 绘图
    clf;
    hold on
    plot(p, "wire", true);
    scatter(pos_evaders(:,1), pos_evaders(:,2), 'd', 'filled', "Color", 'r');
    scatter(pos_pursuers(:,1), pos_pursuers(:,2), 'O', 'filled', "Color", "k");
    hold off;
    drawnow;
end
