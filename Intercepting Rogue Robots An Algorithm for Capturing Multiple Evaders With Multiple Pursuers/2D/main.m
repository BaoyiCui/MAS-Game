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

% get all agents' position, both evaders and pursuers
pos_evaders = zeros(n_e,2);
pos_pursuers = zeros(n_p,2);

for i = 1:length(evaders)
    
    pos_evaders(i,:) = evaders{i}.position;
end

for i = 1:length(pursuers)
    pos_pursuers(i,:) = pursuers{i}.position;
end

figure;
scatter(pos_evaders(:,1),pos_evaders(:,2), "Color",'k', "Marker", "s");
hold on;
scatter(pos_pursuers(:,1), pos_pursuers(:,2), "Color", "r", "Marker", 'O');

% get voronoi diagram by using function voronoi()
pos_all = [pos_evaders; pos_pursuers];

bound = Polyhedron(bbox);
% mpt_voronoi的第一个参数要求点是按列排列的，即，[x1...xn;y1...yn]
[v,p] = mpt_voronoi(pos_all', 'bound', bound);
% 返回值中p的顺序与输入的pos_all是相同的
plot(v, "wire", true);  % "wire"选项默认为false，即有填充，此处需要展示各个evader和pursuer因此只需要看到框架即可
axis equal;
hold off

% TODO: 主循环
for t=0:timestep:timeend
    
    

end
