classdef Robot
    %ROBOT 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
        position
        velocity
        bound    % 机器人运动的边界
    end
    
    methods
        function obj = Robot(pos)
            %ROBOT 构造此类的实例
            obj.position = pos;
            obj.velocity = [0,0,0];
        end

        function obj = setVelocity(obj, v)
            % 设置机器人速度
            obj.velocity = v;
        end
        
        function obj = move(obj, timestep)
            % 机器人移动
            obj.position = obj.position + obj.velocity * timestep;
        end
        
    end
end

