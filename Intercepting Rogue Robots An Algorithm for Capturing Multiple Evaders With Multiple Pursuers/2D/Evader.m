classdef Evader < Robot
    %EVADER 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
        isDead = false;
        r_capture = 0.5;    % 抓捕距离，当该半径内存在pursuer则evader死亡
    end
    
    methods
        function obj = calculateVelocity(obj)
            % 计算所在cell的质心
            vertices = obj.voronoi_cell.V;
            centroidOfCell = mean(vertices, 1);
            if obj.isDead
                obj.velocity = [0,0];
            else
                obj.velocity = (centroidOfCell - obj.position)/norm(centroidOfCell - obj.position);
            end
            
        end

        function obj = checkIfAlive(obj, pursuers)
            pos_pursuers = zeros(length(pursuers), size(obj.position, 2));
            for i = 1:length(pursuers)
                pos_pursuers(i, :) = pursuers{i}.position;
            end
            dists = pdist2(obj.position, pos_pursuers);
            if min(dists) < obj.r_capture
                obj.isDead = true;
            end
        end
    end
end

