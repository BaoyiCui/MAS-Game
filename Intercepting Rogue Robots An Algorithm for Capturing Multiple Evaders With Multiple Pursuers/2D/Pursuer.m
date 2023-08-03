classdef Pursuer < Robot
    %PURSUER 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
        target % 追踪的目标
        targetIsAdjacent    % 目标所在cell与pursuer所在cell是否邻接
    end
    
    methods
        function obj = Pursuer(pos)
            obj = obj@Robot(pos);
        end
        
        function obj = setTarget(evader)
            obj.target = evader;
        end
        
        function obj = calculateVelocity(obj)
            % 判断目标cell与pursuer所在cell是否邻接
            if obj.targetIsAdjacent
                % 计算边界
                sharedVertices = getSharedBound(obj.voronoi_cell, obj.target.voronoi_cell); % 计算voronoi boundary
                % compute u_p^j
                centroidOfBound = mean(sharedVertices, 1);
                v = (centroidOfBound - obj.position) / norm(centroidOfBound - obj. position);
            else
                % if no neighbor evader exists, move directly towards nearest evader
                v = (obj.target.position - obj.position) / norm(obj.target.position - obj.position);
            end        

            obj = obj.setVelocity(v);
        end

    end
end

