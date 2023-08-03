clear;
clc;
close all;

timestep = 0.1; % 仿真时间步长
timeend = 100;
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


bound = Polyhedron(bbox);   % 边界

figure(1)

% TODO: 主循环
for t=0:timestep:timeend
    pos_evaders = [];
    pos_pursuers = [];
    % 1. calculate Voronoi tesselation with all agents
    for i = 1:length(evaders)
        if evaders{i}.isDead
            continue;
        else
            pos_evaders(i,:) = evaders{i}.position;
        end
    end

    for i = 1:length(pursuers)
        pos_pursuers(i,:) = pursuers{i}.position;
    end
    

    % get voronoi diagram by using function voronoi()
%     pos_all = [[pos_evaders; pos_pursuers], [zeros(n_e,1); ones(n_p, 1)]]; % 第三列为1为pursuer，否则为evader
    pos_all = [pos_evaders; pos_pursuers];
    [v,p] = mpt_voronoi(pos_all', 'bound', bound);  % 取出所有agents的位置用于计算voronoi图

    count = 1;
    for i = 1:length(evaders)
        if evaders{i}.isDead
            continue;
        else
            evaders{i} = evaders{i}.setVoronoiCell(p(count));
            count  = count + 1;
        end
    end
    for i = 1:length(pursuers)
        pursuers{i} = pursuers{i}.setVoronoiCell(p(count));
        count = count + 1;
    end

    adjacencyMatrix = getVoronoiAdjacency(p);
    
    for i = 1:length(pursuers)
        % find the nearest evader
        dists = pdist2(pursuers{i}.position, pos_evaders);
        [~, nearestEvaderIdx] = min(dists);
        
        % 2. determine nearest evader from Voronoi neighbors
        count = 0;
        for j = 1:length(evaders)
            if evaders{j}.isDead
                continue;
            else
                count = count + 1;
                if count == nearestEvaderIdx
                    pursuers{i}.target = evaders{j};
                    break;
                end
            end
        end
%         pursuers{i}.target = evaders{nearestEvaderIdx};
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
    scatter(pos_evaders(:,1), pos_evaders(:,2), 'd', 'filled', "Color", 'r');
    scatter(pos_pursuers(:,1), pos_pursuers(:,2), 'O', 'filled', "Color", "k");
    hold off;
    drawnow;
end
