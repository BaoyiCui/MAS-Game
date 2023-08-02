classdef Pursuer < Robot
    %PURSUER 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
        target % 追踪的目标
    end
    
    methods
        function obj = Pursuer(pos)
            obj = obj@Robot(pos);
        end
        
        function obj = setTarget(evader)
            obj.target = evader;
        end
        
        function obj = calculateVel(obj)
            % TODO: 确定输入输出
        end
    end
end

