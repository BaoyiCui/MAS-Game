classdef Attacker < Agent
    %ATTACKER 此处显示有关此类的摘要
    %   此处显示详细说明

    properties
        isIntercepted;
        isClustered;
    end

    methods

        function obj = Attacker(pos_init, d_coef, control_bound)
            %ATTACKER
            %   d_coef: positive, known, constant drag coefficient
            %   control_bound: positive, acceleration bound
            %   pos: initial position, (2*1)
            obj = obj@Agent(pos_init, d_coef, control_bound);
            obj.isIntercepted = false;
            obj.isClustered = false;
        end

        function obj = updateMotionState(obj, ts)
            % update robot position
            %   ts: time step
            % update velocity
            if obj.isIntercepted
                obj.velocity = zeros(2, 1);
            else
                obj.velocity = obj.velocity + ts * (-obj.drag_coef * eye(2) * obj.velocity + eye(2) * obj.control_input);
                % update position
                obj.position = obj.position + ts * obj.velocity;
            end

        end

        function obj = updateControlInput(obj, u)
            % update robot control input (acceleration)
            %   u: control input, (2*1)
            if obj.isIntercepted
                obj.control_input = zeros(2, 1);
            else

                if norm(u, 2) >= obj.control_bound
                    obj.control_input = obj.control_bound * u / norm(u, 2);
                else
                    obj.control_input = u;
                end

            end

        end

    end

end
