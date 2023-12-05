classdef Agent
    %AGENT 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
        position;
        velocity;
        control_input;
        control_bound;
        drag_coef;
        vel_max;
    end
    
    methods
        function obj = Agent(pos_init, d_coef, control_bound)
            %AGENT 
            %   d_coef: positive, known, constant drag coefficient
            %   control_bound: positive, acceleration bound
            %   pos: initial position, (2*1)
            obj.position = pos_init;
            obj.velocity = zeros(2,1);
            obj.drag_coef = d_coef;
            obj.control_bound = control_bound;
            obj.control_input = zeros(2,1);
            obj.vel_max = control_bound / d_coef;
        end
        
        function obj = updateControlInput(obj, u)
            % update robot control input (acceleration)
            %   u: control input, (2*1)
            if norm(u, 2) >= obj.control_bound
                obj.control_input = obj.control_bound * u / norm(u,2);
            else
                obj.control_input = u;
            end
        end

        function obj = updateMotionState(obj, ts)
            % update robot position
            %   ts: time step
            % update velocity
            obj.velocity = obj.velocity + ts * (-obj.drag_coef * eye(2) * obj.velocity + eye(2) * obj.control_input);
            % update position
            obj.position = obj.position + ts * obj.velocity;
        end
    end
end

